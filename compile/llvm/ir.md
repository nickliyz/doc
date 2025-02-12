# llvm ir base

## 基础
LLVM 是一种静态单地址(SSA: Static Single Assignment) 为基础的表示, 提供类型安全, 滴级别操作, 灵活性, 可实现高层表示的能力.

LLVM标识符有两种类型: 全局和本地.

全局变量以'@'开头, 本地标识符以字符'%'开头. 
1. 标识符的正则表达式是: `[%@][-a-zA-Z$._][-a-zA-Z$._0-9]*`
2. 未命名值表示为带有其前缀的无符号数值, 例如 %12, @2, %44
3. 常量
   * 简单常量
     * 布尔常量, `true` 或者 `false`
     * 证书常量, 可以是这儿证书, 十六进制必须有前缀, 有符号(s开头), 无符号(u开头)的, 例如 `s0x8000`
     * 浮点常量, 浮点数可以使用正常小数或者指数计数, 例如 `1.23421e+2`
     * 控指针常量: 必须是 `null`
     * 标记常量: 必须是 `none`
   * 复杂常量
     * 结构常数, 用`{}`括起来, 以逗号分割, 例如: `{ i32 4, float 17.0, ptr @G }` 当 `G`声明为`@G = external global i32`
     * 数组常量, 用`[]`括起来, 以逗号分割, 例如: `[ i32 42, i32 11, i32 74 ]`
     * 矢量常量, 用`<>`括起来, 以逗号分割, 例如: `< i32 42, i32 11, i32 74, i32 100 >`
     * 零初始化, `zeroinitializer` 可用于将任何类型的值初始化为零
     * 元数据节点, 元数据节点是没有类型的常量元组, 例如`!{!0, !{!2, !0}, !"test"}`
   * 字符串常量, 以`"`包裹, 内部支持转译, 也就是说 `"\\"`是有一个字符的字符串, `"\0x31"`, 是有一个数字'1'的字符串

简单的例子: `%result = mul i32 %X, 8`
复杂一点的:
```llvm
%0 = add i32 %X, %X           ; yields i32:%0
%1 = add i32 %0, %0           ; yields i32:%1
%result = add i32 %1, %1
```
上述代码:
* `;`开始的是注释, 直到行尾
* 计算结构未分配名称时, 自动分配一个未命名值
* 默认情况下, 未命名值是按照顺序编号的, 从0开始.

## Global Variables
```
@<GlobalVarName> = [Linkage] [PreemptionSpecifier] [Visibility]
                   [DLLStorageClass] [ThreadLocal]
                   [(unnamed_addr|local_unnamed_addr)] [AddrSpace]
                   [ExternallyInitialized]
                   <global | constant> <Type> [<InitializerConstant>]
                   [, section "name"] [, partition "name"]
                   [, comdat [($name)]] [, align <Alignment>]
                   [, code_model "model"]
                   [, no_sanitize_address] [, no_sanitize_hwaddress]
                   [, sanitize_address_dyninit] [, sanitize_memtag]
                   (, !name !N)*
```

* Global Attributes
  * no_sanitize_address
  * no_sanitize_hwaddress
  * sanitize_memtag
  * sanitize_address_dyninit
* DLLStorageClass
  * dllimport
  * dllexport
* PreemptionSpecifier
  * dso_preemptable
  * dso_local
* Thread Local Storage Models
  * localdynamic
  * initialexec
  * localexec

## Functions
### Define
```
define [linkage] [PreemptionSpecifier] [visibility] [DLLStorageClass]
       [cconv] [ret attrs]
       <ResultType> @<FunctionName> ([argument list])
       [(unnamed_addr|local_unnamed_addr)] [AddrSpace] [fn Attrs]
       [section "name"] [partition "name"] [comdat [($name)]] [align N]
       [gc] [prefix Constant] [prologue Constant] [personality Constant]
       (!name !N)* { ... }
```

* Linkage
  * private
  * internal
  * available_externally
  * linkonce
  * weak
  * common
  * appending
  * extern_weak
  * linkonce_odr, weak_odr
  * external
* PreemptionSpecifier
  * dso_preemptable
  * dso_local
* Visibility
  * 0 - default
  * 1 - hidden
  * 2 - protected
* DLLStorageClass
  * dllimport
  * dllexport
* ThreadLocal
  * 0 - not thread local
  * 1 - thread local
  * 2 - localdynamic
  * 3 - initialexec
  * 4 - localexec
* AddrSpace
* InitializerConstant

### Declear
```
define [linkage] [PreemptionSpecifier] [visibility] [DLLStorageClass]
       [cconv] [ret attrs]
       <ResultType> @<FunctionName> ([argument list])
       [(unnamed_addr|local_unnamed_addr)] [AddrSpace] [fn Attrs]
       [section "name"] [partition "name"] [comdat [($name)]] [align N]
       [gc] [prefix Constant] [prologue Constant] [personality Constant]
       (!name !N)* { ... }
```

## Alias
```
@<Name> = [Linkage] [PreemptionSpecifier] [Visibility] [DLLStorageClass] [ThreadLocal] [(unnamed_addr|local_unnamed_addr)] alias <AliaseeTy>, <AliaseeTy>* @<Aliasee>
          [, partition "name"]
```

## IFuncs
```
@<Name> = [Linkage] [PreemptionSpecifier] [Visibility] ifunc <IFuncTy>, <ResolverTy>* @<Resolver>
          [, partition "name"]
```

## Comdat
```
$<Name> = comdat SelectionKind

```