# clang AST

源码`test.cc`:
```C++
int f(int x) {
    int result = (x / 42);
    return result;
}
```

`clang -Xclang -ast-dump -fsyntax-only test.cc` 输出:
```
TranslationUnitDecl 0x245f6e8 <<invalid sloc>> <invalid sloc>
|-TypedefDecl 0x245ffc0 <<invalid sloc>> <invalid sloc> implicit __int128_t '__int128'
| `-BuiltinType 0x245fc80 '__int128'
|-TypedefDecl 0x2460030 <<invalid sloc>> <invalid sloc> implicit __uint128_t 'unsigned __int128'
| `-BuiltinType 0x245fca0 'unsigned __int128'
|-TypedefDecl 0x24603a8 <<invalid sloc>> <invalid sloc> implicit __NSConstantString '__NSConstantString_tag'
| `-RecordType 0x2460120 '__NSConstantString_tag'
|   `-CXXRecord 0x2460088 '__NSConstantString_tag'
|-TypedefDecl 0x2460440 <<invalid sloc>> <invalid sloc> implicit __builtin_ms_va_list 'char *'
| `-PointerType 0x2460400 'char *'
|   `-BuiltinType 0x245f780 'char'
|-TypedefDecl 0x249d568 <<invalid sloc>> <invalid sloc> implicit __builtin_va_list '__va_list_tag [1]'
| `-ConstantArrayType 0x249d510 '__va_list_tag [1]' 1 
|   `-RecordType 0x2460530 '__va_list_tag'
|     `-CXXRecord 0x2460498 '__va_list_tag'
`-FunctionDecl 0x249d6a0 <test.cc:1:1, line:4:1> line:1:5 f 'int (int)'
  |-ParmVarDecl 0x249d5d8 <col:7, col:11> col:11 used x 'int'
  `-CompoundStmt 0x249d908 <col:14, line:4:1>
    |-DeclStmt 0x249d8a8 <line:2:5, col:26>
    | `-VarDecl 0x249d7a8 <col:5, col:25> col:9 used result 'int' cinit
    |   `-ParenExpr 0x249d888 <col:18, col:25> 'int'
    |     `-BinaryOperator 0x249d868 <col:19, col:23> 'int' '/'
    |       |-ImplicitCastExpr 0x249d850 <col:19> 'int' <LValueToRValue>
    |       | `-DeclRefExpr 0x249d810 <col:19> 'int' lvalue ParmVar 0x249d5d8 'x' 'int'
    |       `-IntegerLiteral 0x249d830 <col:23> 'int' 42
    `-ReturnStmt 0x249d8f8 <line:3:5, col:12>
      `-ImplicitCastExpr 0x249d8e0 <col:12> 'int' <LValueToRValue>
        `-DeclRefExpr 0x249d8c0 <col:12> 'int' lvalue Var 0x249d7a8 'result' 'int'
```