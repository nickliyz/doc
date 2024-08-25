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

可以精简输出：
```
clang -fsyntax-only -Xclang -ast-dump min.c

# <<Output>>

TranslationUnitDecl 0x5576be5a6218 <<invalid sloc>> <invalid sloc>
|-TypedefDecl 0x5576be5a6a48 <<invalid sloc>> <invalid sloc> implicit __int128_t '__int128'
| `-BuiltinType 0x5576be5a67e0 '__int128'
|-TypedefDecl 0x5576be5a6ab8 <<invalid sloc>> <invalid sloc> implicit __uint128_t 'unsigned __int128'
| `-BuiltinType 0x5576be5a6800 'unsigned __int128'
|-TypedefDecl 0x5576be5a6dc0 <<invalid sloc>> <invalid sloc> implicit __NSConstantString 'struct __NSConstantString_tag'
| `-RecordType 0x5576be5a6b90 'struct __NSConstantString_tag'
|   `-Record 0x5576be5a6b10 '__NSConstantString_tag'
|-TypedefDecl 0x5576be5a6e68 <<invalid sloc>> <invalid sloc> implicit __builtin_ms_va_list 'char *'
| `-PointerType 0x5576be5a6e20 'char *'
|   `-BuiltinType 0x5576be5a62c0 'char'
|-TypedefDecl 0x5576be5a7160 <<invalid sloc>> <invalid sloc> implicit __builtin_va_list 'struct __va_list_tag[1]'
| `-ConstantArrayType 0x5576be5a7100 'struct __va_list_tag[1]' 1 
|   `-RecordType 0x5576be5a6f40 'struct __va_list_tag'
|     `-Record 0x5576be5a6ec0 '__va_list_tag'
`-FunctionDecl 0x5576be606d68 <min.c:1:1, line:3:1> line:1:5 min 'int (int, int)'
  |-ParmVarDecl 0x5576be606c00 <col:9, col:13> col:13 used a 'int'
  |-ParmVarDecl 0x5576be606c80 <col:16, col:20> col:20 used b 'int'
  `-CompoundStmt 0x5576be606fa8 <col:23, line:3:1>
    `-ReturnStmt 0x5576be606f98 <line:2:5, col:24>
      `-ConditionalOperator 0x5576be606f68 <col:12, col:24> 'int'
        |-BinaryOperator 0x5576be606ed8 <col:12, col:16> 'int' '<'
        | |-ImplicitCastExpr 0x5576be606ea8 <col:12> 'int' <LValueToRValue>
        | | `-DeclRefExpr 0x5576be606e68 <col:12> 'int' lvalue ParmVar 0x5576be606c00 'a' 'int'
        | `-ImplicitCastExpr 0x5576be606ec0 <col:16> 'int' <LValueToRValue>
        |   `-DeclRefExpr 0x5576be606e88 <col:16> 'int' lvalue ParmVar 0x5576be606c80 'b' 'int'
        |-ImplicitCastExpr 0x5576be606f38 <col:20> 'int' <LValueToRValue>
        | `-DeclRefExpr 0x5576be606ef8 <col:20> 'int' lvalue ParmVar 0x5576be606c00 'a' 'int'
        `-ImplicitCastExpr 0x5576be606f50 <col:24> 'int' <LValueToRValue>
          `-DeclRefExpr 0x5576be606f18 <col:24> 'int' lvalue ParmVar 0x5576be606c80 'b' 'int'
```

使用 `-###- 可以显示有 clang 驱动程序调用的程序列表，例如：
```
clang hello.c -###
```

clang 打印代码的 Tokens：
```
clang -cc1 -dump-tokens hello.c
```

clang 处理预编译，测试文件`pp.c`
```c
#define EXIT_SUCCESS 0
int main() {
    return EXIT_SUCCESS;
}
```

命令：
```
clang -E pp.c -o pp2.c && cat pp2.c

# <<Output>>

# 1 "pp.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 389 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "pp.c" 2

int main() {
    return 0;
}
```

`pp-trace`可以查看宏的处理：
```
pp-trace pp.c

# <<Output>>
...
- Callback: FileChanged
  Loc: "/home/lixiang/coding/llvm/serverity/pp.c:1:1"
  Reason: ExitFile
  FileType: C_User
  PrevFID: (getFileEntryForID failed)
- Callback: MacroDefined
  MacroNameTok: EXIT_SUCCESS
  MacroDirective: MD_Define
- Callback: MacroExpands
  MacroNameTok: EXIT_SUCCESS
  MacroDefinition: [(local)]
  Range: ["/home/lixiang/coding/llvm/serverity/pp.c:3:12", "/home/lixiang/coding/llvm/serverity/pp.c:3:12"]
  Args: (null)
- Callback: EndOfMainFile
...
```