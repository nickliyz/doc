# llvm 使用

参考资料：参考资料：《LLVM编译器实战教程》 3.3节

## 工具简介
* **opt**: 优化工具, 输入输出必须都是 bitcode(bc 文件)
* **llc**: 转换bc文件到汇编文件或目标文件的工具
* **llvm-mc**: 转换汇编产生 ELF/MachO/PE 等目标的工具
* **lli**: LLVM JIT编译器, 可以支持执行 bc 文件
* **llvm-link**: bc 文件链接工具
* **llvm-as**: 将可读的 ll 文件编译成 bc 文件的工具
* **llvm-dis**: 转换 bc 回可读 ll 文件的工具

例如: `main.c`
```c
#include <stdio.h>
int sum(int x, int y);

int main() {
    int r = sum(3, 4);
    printf("r = %d\n", r);
    return 0;
}
```

第二个文件是 `sum.c`:
```c
int sum(int x, int y) {
    return x + y;
}
```

命令：
```
clang main.c sum.c -o sum
```

独立的clang工具:
```
clang -emit-llvm -c main.c -o main.bc
clang -emit-llvm -c sum.c -o sum.bc

llvm-link main.bc sum.bc -o sum.linkded.bc
llc -filetype=obj sum.linkded.bc -o sum.linkded.o
clang sum.linkded.o -o sum
```

或者也可以：
```
clang -emit-llvm -c main.c -S -o main.ll
clang -emit-llvm -c sum.c -S -o sum.ll

llc -filetype=obj main.ll -o main.o
llc -filetype=obj sum.ll -o sum.o

clang main.o sum.o -o sum
```

如果想输出可读的 LLVM IR:
```bash
clang -emit-llvm -c main.c -S -o main.ll
clang -emit-llvm -c sum.c -S -o sum.ll
```

## clang
clang打印语法树：
```
clang -Xclang -ast-dump hello.c
```
或者
```
clang -cc1 -ast-dump hello.c
```

使用 `-###- 可以显示有 clang 驱动程序调用的程序列表，例如：
```
clang hello.c -###
```

clang 打印代码的 Tokens：
```
clang -cc1 -dump-tokens hello.c
```