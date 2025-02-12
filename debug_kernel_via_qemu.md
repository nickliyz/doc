# 调试步骤
* 下载 buildroot-2024.02.10 代码

```
cd buildroot-2024.02.10
make qemu_x86_defconfig
```

执行`make linux-menuconfig` 调整内核配置选项:
* **CONFIG_DEBUG_KERNEL=y**
* **CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT=y**
* **CONFIG_RANDOMIZE_BASE=no**
* **KALLSYMS_ALL=y**
* **KALLSYMS=y**
* **CONFIG_GDB_SCRIPTS=y**

然后执行`make -j12`编译.

不要用`output/images/start-qemu.sh`, 要用下面的命令:
```
output/build/host-qemu-8.1.1/build/qemu-system-i386 -M pc -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw -append "rootwait root=/dev/vda console=tty1 console=ttyS0"  -net nic,model=virtio -net user -nographic -s -S
```

vscode 配置(`output/build/linux-6.1.44/launch.json`):
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "type": "cppdbg",
            "request": "launch",
            "name": "Debug Kernel",
            "program": "${workspaceFolder}/vmlinux",
            "args": [],
            "cwd": "${workspaceFolder}",
            "externalConsole": false,
            "stopAtEntry": false,
            "miDebuggerServerAddress": "localhost:1234",
            "linux": {
                "MIMode": "gdb"
            },
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
        }
    ]
}
```

# NFS 配置
安装和启动nfs服务:
```
sudo apt install nfs-kernel-server
sudo systemctl start nfs-kernel-server.service
```

`sudo vim /etc/exports`, 然后添加:
```
/home/lixiang/github/buildroot-2024.02.10/output/target/ *(rw,async,no_subtree_check,no_root_squash,insecure)
```
PS: insecure 要加上

然后本地挂在测试:
```
mkdir mnt_test
ifconfig # 查看网卡地址
sudo mount -t nfs 10.248.24.143:/home/lixiang/github/buildroot-2024.02.10/output/target/ mnt_test/
ls mnt_test/ # 检查挂在是否正确
sudo umount mnt_test
```

修改内核配置(`make linux-menuconfig`):
* **CONFIG_IP_PNP=y**
* **CONFIG_KERNFS=y**
* **CONFIG_NFS_FS=y**
* **CONFIG_NFS_V2=y**
* **CONFIG_NFS_V3=y**
* **CONFIG_NFS_V4=y**
* **CONFIG_ROOT_NFS=y**
* **CONFIG_NFS_USE_KERNEL_DNS=y**
PS: 以上设置是为了能在启动时挂在nfs

修改buildroot系统设置:
* **BR2_TARGET_ENABLE_ROOT_LOGIN=n**
* **BR2_TARGET_GENERIC_GETTY=n**
PS: 这是为了免登陆

qemu启动命令改成:
```
output/build/host-qemu-8.1.1/build/qemu-system-i386 -M pc -kernel output/images/bzImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw -append "rootwait root=/dev/nfs rw nfsroot=10.248.24.143:/home/lixiang/github/buildroot-2024.02.10/output/target,vers=4,tcp ip=dhcp console=tty1 console=ttyS0" -net nic,model=virtio -net user -nographic -s -S
```

# 如何编写并测试内核模块
模块代码: `hello.c`:
```
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>

static int number = 10;

static int __init hello_init(void) {
    printk(KERN_WARNING "Hello, world! qemu kernel\n");
    number--;
    return 0;
}

static void __exit hello_exit(void) {
    printk(KERN_WARNING "Goodbye! qemu kernel\n");
}

module_init(hello_init);
module_exit(hello_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("JeffChong");
MODULE_DESCRIPTION("A simple Hello World driver");
MODULE_VERSION("1.0");
```

模块`Makefile`:
```
CROSS=/home/lixiang/github/buildroot-2024.02.10/output/host/bin/i686-buildroot-linux-gnu-
KERNEL_DIR=/home/lixiang/github/buildroot-2024.02.10/output/build/linux-6.1.44
CUR_DIR = $(shell pwd)

all:
	make -C $(KERNEL_DIR) M=$(CUR_DIR) ARCH=x86 CROSS_COMPILE=$(CROSS) modules
clean:
	make -C $(KERNEL_DIR) M=$(CUR_DIR) ARCH=x86 CROSS_COMPILE=$(CROSS) clean

obj-m = hello.o
```

# 如何在 buildroot 中直接增加一个内核模块
在 `hello/` 中增加 `Config.in`:
```
config BR2_PACKAGE_HELLO_MODULE
        bool "hello_module"
        depends on BR2_LINUX_KERNEL
        help
                Linux Kernel Module Cheat.
```

增加对应的扩展描述文件`external.desc`:
```
name: HELLO_MODULE
```

增加`external.mk`:
```
KERNEL_MODULE_VERSION = 1.0
KERNEL_MODULE_SITE = $(BR2_EXTERNAL_KERNEL_MODULE_PATH)
KERNEL_MODULE_SITE_METHOD = local
$(eval $(kernel-module))
$(eval $(generic-package))
```

修改`和来咯/Makefile`的内容为普通的Makefile:
```
obj-m = hello.o
ccflags-y := -DDEBUG -g -std=gnu99 -Wno-declaration-after-statement

.PHONY: all clean

all:
    $(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' modules

clean:
    $(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' clean
```

在顶层`Config.in`中增加:
```
source "hello/Config.in"
```

然后执行`make menuconfig`配置`BR2_PACKAGE_HELLO_MODULE=y`, 编译:
```
make -j
```

然后可以看到生成的ko在:`output/target/root/hello.ko`

# eBPF
准备bpf程序 `bpf.c`:
```
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_endian.h>

int counter = 0;

SEC("xdp")
int hello(void *ctx) {
    bpf_printk("Hello World %d", counter);
    counter++;
    return XDP_PASS;
}

char LICENSE[] SEC("license") = "Dual BSD/GPL";
```

编译bpf程序:
```
clear
/usr/bin/clang \
    -target bpf \
    -g \
    -O2 \
    -c bpf.c \
    -o bpf.o

cp bpf.o ../output/target/root/bpf.o
```

然后在设备端加载bpf程序:
```
/root # bpftool prog load bpf.o /sys/fs/bpf/hello
libbpf: prog 'hello': BPF program load failed: Invalid argument
libbpf: prog 'hello': -- BEGIN PROG LOAD LOG --
... ...
15: (85) call bpf_trace_printk#6
unknown func bpf_trace_printk#6
processed 14 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
-- END PROG LOAD LOG --
libbpf: prog 'hello': failed to load: -22
libbpf: failed to load object 'bpf.o'
Error: failed to load object file
```

则需要在内核中打开选项: 
* **FTRACE=y**
* **KPROBES=y**
* **KPROBE_EVENTS=y**
* **CONFIG_BPF_EVENTS=y**
* **CONFIG_DEBUG_FS=y**
* **CONFIG_DEBUG_FS_ALLOW_ALL=y**
然后重新编译内核. `CONFIG_DEBUG_FS`是为了能有 `/sys/kernel/debug/` 路径.

网络相关的:
* **NET_CLS_ACT=y**
* **CONFIG_NET_SCH_INGRESS=y**
* **CONFIG_NET_CLS_BPF=y**
* **CONFIG_NET_CLS_ACT=y**
* **CONFIG_LWTUNNEL_BPF=y**
* **CONFIG_CGROUP_BPF=y**

设备上执行:
```
mount -t debugfs none /sys/kernel/debug/
cat /sys/kernel/debug/tracing/trace_pipe &

cd /root
bpftool prog load bpf.o /sys/fs/bpf/hello
bpftool net attach xdp name hello dev eth0
```
不出意外的话可以看到:
```
virtio_net virtio0 eth0: XDP request 2 queues but max is 1. XDP_TX and XDP_REDIRECT will operate in a slower locked tx mode.
         bpftool-103     [000] d.s3.   339.812928: bpf_trace_printk: Hello World 0
     rcu_preempt-14      [000] d.s3.   339.817291: bpf_trace_printk: Hello World 1
          <idle>-0       [000] d.s3.   339.821815: bpf_trace_printk: Hello World 2
          <idle>-0       [000] d.s3.   339.822783: bpf_trace_printk: Hello World 3
          <idle>-0       [000] d.s3.   339.824729: bpf_trace_printk: Hello World 4
          <idle>-0       [000] d.s3.   339.826403: bpf_trace_printk: Hello World 5
          <idle>-0       [000] d.s3.   339.828355: bpf_trace_printk: Hello World 6
          <idle>-0       [000] d.s3.   339.830038: bpf_trace_printk: Hello World 7
/root #           <idle>-0       [000] d.s3.   339.832297: bpf_trace_printk: Hello World 8
```

detach:
```
bpftool net detach xdp dev eth0
```

# 关于clangd配置
生成内核的clangd信息`compile_commands.json`:
```
cd output/build/linux-6.1.44
./scripts/clang-tools/gen_compile_commands.py
```
即可生成`output/build/linux-6.1.44/compile_commands.json`, 然后在`output/build/linux-6.1.44/`下启动vscode就可以了.

* **注意:** 如果使用clangd, 需要禁用 cpp intelligence 索引, 并且需要clangd插件.