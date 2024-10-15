# Nuttx on stm32

## install
### install deps
```
sudo apt install \
bison flex gettext texinfo libncurses5-dev libncursesw5-dev xxd \
git gperf automake libtool pkg-config build-essential gperf genromfs \
libgmp-dev libmpc-dev libmpfr-dev libisl-dev binutils-dev libelf-dev \
libexpat1-dev gcc-multilib g++-multilib picocom u-boot-tools util-linux
```

### install kconfig deps
```
sudo apt install kconfig-frontends
```

### install toolchain
```
sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi
```

### install minicom
```
sudo apt install minicom
```

### download code
```
cd ~
mkdir nuttxspace
cd nuttxspace
git clone https://github.com/apache/nuttx.git nuttx
git clone https://github.com/apache/nuttx-apps apps
```

### install openocd
```
cd ~
git clone -b v0.12.0 https://git.code.sf.net/p/openocd/code openocd-code
./bootstrap
./configure --enable-jimtcl-maintainer --enable-stlink --enable-jlink --enable-rlink --enable-vsllink --enable-ti-icdi --enable-remote-bitbang --disable-werror --disable-shared
make -j24
sudo make install
```

## Build Nuttx
### configure nuttx
```
cd ~/nuttxspace/nuttx/tools
./configure.sh stm32f4discovery:usbnsh
make menuconfig # check toolchain configuration
make -j24
ls -l nuttx.bin
```

## Run Nuttx on STM32f4discovery
### burn nuttx.bin to discovery board
```
cd ~/openocd-code/contrib
sudo cp 60-openocd.rules /etc/udev/rules.d/
sudo udevadm trigger

cd ~/nuttxspace/nuttx
openocd -f interface/stlink-v2.cfg -f board/stm32f4discovery.cfg -c init -c "reset halt" -c "flash write_image erase nuttx.bin 0x08000000"
```

### open minicom with /dev/ttyACM0
```
sudo minicom
```
PS: ACM uart device file is: **/dev/ttyACM0**


## Debug
### nuttx debug configs
`.config`:
```
DEBUG_NOOPT=y
DEBUG_SYMBOLS=y
```

build
```
make -j32
```

### install vscode extensions
link: https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug
command:
```
ext install marus25.cortex-debug
```

`launch.json` config:
```
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug Nuttx on STM32",
            "type": "cortex-debug",
            "request": "launch",
            "servertype": "openocd",
            "cwd": "${workspaceFolder}",
            "device": "stm32f4x",
            "configFiles": [
                "interface/stlink-v2.cfg",
                "board/stm32f4discovery.cfg"
            ],
            "executable": "${workspaceFolder}/nuttx",
            "gdbPath": "/usr/bin/gdb-multiarch",
            "preLaunchCommands": [
                "b nxtask_start",
                "monitor reset",
            ]
        }
    ]
}
```

### debug suggestion
type `hello` in nsh
break at `arch/arm/src/stm32/stm32_otgfsdev.c:stm32_txfifo_write()`
type `<Enter>` trigger break.