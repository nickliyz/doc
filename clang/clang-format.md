# clang format

参考资料
* [ClangFormat](https://clang.llvm.org/docs/ClangFormat.html)
* [Clang-Format Style Options](https://clang.llvm.org/docs/ClangFormatStyleOptions.html)
* [](https://clang.llvm.org/docs/ClangFormattedStatus.html)

clang format 配置文件为 `.clang-format`, 以下解释来自 Copilot:
```
---
Language:        Cpp # 指定语言为 C++
# BasedOnStyle:  LLVM # 基于 LLVM 风格（已注释掉）
AccessModifierOffset: -2 # 访问修饰符的缩进偏移量
AlignAfterOpenBracket: Align # 在打开括号后对齐
AlignConsecutiveMacros: false # 不对齐连续的宏定义
AlignConsecutiveAssignments: false # 不对齐连续的赋值语句
AlignConsecutiveDeclarations: false # 不对齐连续的声明
AlignEscapedNewlines: Right # 转义换行符对齐到右边
AlignOperands:   true # 对齐操作数
AlignTrailingComments: true # 对齐尾随注释
AllowAllArgumentsOnNextLine: true # 允许所有参数在下一行
AllowAllConstructorInitializersOnNextLine: true # 允许所有构造函数初始化器在下一行
AllowAllParametersOfDeclarationOnNextLine: true # 允许所有声明的参数在下一行
AllowShortBlocksOnASingleLine: Never # 不允许短代码块在单行
AllowShortCaseLabelsOnASingleLine: false # 不允许短的 case 标签在单行
AllowShortFunctionsOnASingleLine: All # 允许所有短函数在单行
AllowShortLambdasOnASingleLine: All # 允许所有短 lambda 在单行
AllowShortIfStatementsOnASingleLine: Never # 不允许短的 if 语句在单行
AllowShortLoopsOnASingleLine: false # 不允许短的循环在单行
AlwaysBreakAfterDefinitionReturnType: None # 定义返回类型后不换行
AlwaysBreakAfterReturnType: None # 返回类型后不换行
AlwaysBreakBeforeMultilineStrings: false # 多行字符串前不换行
AlwaysBreakTemplateDeclarations: MultiLine # 模板声明总是换行
BinPackArguments: true # 将参数打包在一起
BinPackParameters: true # 将参数打包在一起
BraceWrapping:
  AfterCaseLabel:  false # case 标签后不换行
  AfterClass:      false # 类后不换行
  AfterControlStatement: false # 控制语句后不换行
  AfterEnum:       false # 枚举后不换行
  AfterFunction:   false # 函数后不换行
  AfterNamespace:  false # 命名空间后不换行
  AfterObjCDeclaration: false # Objective-C 声明后不换行
  AfterStruct:     false # 在 struct 关键字之后不插入空行
  AfterUnion:      false # 在 union 关键字之后不插入空行
  AfterExternBlock: false # 在 extern 块之后不插入空行
  BeforeCatch:     false # 在 catch 关键字之前不插入空行
  BeforeElse:      false # 在 else 关键字之前不插入空行
  IndentBraces:    false # 不缩进大括号 {}
  SplitEmptyFunction: true # 将空函数体分成多行
  SplitEmptyRecord: true # 将空的 struct 或 class 定义分成多行
  SplitEmptyNamespace: true # 将空的命名空间定义分成多行
BreakBeforeBinaryOperators: None # 在二元运算符之前不换行
BreakBeforeBraces: Attach # 在大括号之前不换行，附加在语句末尾
BreakBeforeInheritanceComma: false # 在继承列表的逗号之前不换行
BreakInheritanceList: BeforeColon # 在继承列表的冒号之前换行
BreakBeforeTernaryOperators: true # 在三元运算符之前换行
BreakConstructorInitializersBeforeComma: false # 在构造函数初始化器的逗号之前不换行
BreakConstructorInitializers: BeforeColon # 在构造函数初始化器的冒号之前换行
BreakAfterJavaFieldAnnotations: false # 在 Java 字段注释之后不换行
BreakStringLiterals: true # 在字符串字面量中换行
ColumnLimit: 80 # 每行的最大字符数限制为 80
CommentPragmas: '^ IWYU pragma:' # 匹配 IWYU pragma 注释的正则表达式
CompactNamespaces: false # 不使用紧凑的命名空间格式
ConstructorInitializerAllOnOneLineOrOnePerLine: false # 构造函数初始化器不全在一行或每个初始化器一行
ConstructorInitializerIndentWidth: 4 # 构造函数初始化器的缩进宽度为 4
ContinuationIndentWidth: 4 # 续行的缩进宽度为 4
Cpp11BracedListStyle: true # 使用 C++11 的大括号列表初始化风格
DeriveLineEnding: true # 自动检测行尾格式
DerivePointerAlignment: false # 不自动检测指针对齐方式
DisableFormat: false # 不禁用格式化
ExperimentalAutoDetectBinPacking: false # 不使用实验性的自动检测打包
FixNamespaceComments: true # 修复命名空间注释
ForEachMacros:
  - foreach
  - Q_FOREACH
  - BOOST_FOREACH
IncludeBlocks:   Preserve
IncludeCategories:
  - Regex:           '^"(llvm|llvm-c|clang|clang-c)/'
    Priority:        2
    SortPriority:    0
  - Regex:           '^(<|"(gtest|gmock|isl|json)/)'
    Priority:        3
    SortPriority:    0
  - Regex:           '.*'
    Priority:        1
    SortPriority:    0
IncludeIsMainRegex: '(Test)?$' # 用于识别主文件的正则表达式
IncludeIsMainSourceRegex: '' # 用于识别主源文件的正则表达式
IndentCaseLabels: false # 不缩进 case 标签
IndentGotoLabels: true # 缩进 goto 标签
IndentPPDirectives: None # 不缩进预处理指令
IndentWidth: 2 # 缩进宽度为 2 个空格
IndentWrappedFunctionNames: false # 不缩进换行的函数名
JavaScriptQuotes: Leave # 保持 JavaScript 引号的原样
JavaScriptWrapImports: true # 换行 JavaScript 导入语句
KeepEmptyLinesAtTheStartOfBlocks: true # 保留块开始处的空行
MacroBlockBegin: '' # 宏块开始的标记
MacroBlockEnd: '' # 宏块结束的标记
MaxEmptyLinesToKeep: 1 # 保留的最大空行数为 1
NamespaceIndentation: None # 不缩进命名空间
ObjCBinPackProtocolList: Auto # 自动处理 Objective-C 协议列表的打包
ObjCBlockIndentWidth: 2 # Objective-C 块的缩进宽度为 2
ObjCSpaceAfterProperty: false # 在 Objective-C 属性之后不加空格
ObjCSpaceBeforeProtocolList: true # 在 Objective-C 协议列表之前加空格
PenaltyBreakAssignment: 2 # 断行赋值的惩罚值
PenaltyBreakBeforeFirstCallParameter: 19 # 在第一个调用参数之前断行的惩罚值
PenaltyBreakComment: 300 # 断行注释的惩罚值
PenaltyBreakFirstLessLess: 120 # 在第一个 << 运算符之前断行的惩罚值
PenaltyBreakString: 1000 # 断行字符串的惩罚值
PenaltyBreakTemplateDeclaration: 10 # 断行模板声明的惩罚值
PenaltyExcessCharacter: 1000000 # 超过字符限制的惩罚值
PenaltyReturnTypeOnItsOwnLine: 60 # 返回类型单独一行的惩罚值
PointerAlignment: Right # 指针对齐方式为右对齐
ReflowComments: true # 重新格式化注释
SortIncludes: true # 排序包含的头文件
SortUsingDeclarations: true # 排序 using 声明
SpaceAfterCStyleCast: false # 在 C 风格的强制转换之后不加空格
SpaceAfterLogicalNot: false # 在逻辑非运算符之后不加空格
SpaceAfterTemplateKeyword: true # 在模板关键字之后加空格
SpaceBeforeAssignmentOperators: true # 在赋值运算符之前加空格
SpaceBeforeCpp11BracedList: false # 在 C++11 大括号列表之前不加空格
SpaceBeforeCtorInitializerColon: true # 在构造函数初始化器的冒号之前加空格
SpaceBeforeInheritanceColon: true # 在继承列表的冒号之前加空格
SpaceBeforeParens: ControlStatements # 在控制语句的括号之前加空格
SpaceBeforeRangeBasedForLoopColon: true # 在基于范围的 for 循环的冒号之前加空格
SpaceInEmptyBlock: false # 在空块中不加空格
SpaceInEmptyParentheses: false # 在空括号中不加空格
SpacesBeforeTrailingComments: 1 # 尾随注释之前加一个空格
SpacesInAngles: false # 在尖括号中不加空格
SpacesInConditionalStatement: false # 在条件语句中不加空格
SpacesInContainerLiterals: true # 在容器字面量中加空格
SpacesInCStyleCastParentheses: false # 在 C 风格的强制转换括号中不加空格
SpacesInParentheses: false # 在括号中不加空格
SpacesInSquareBrackets: false # 在方括号中不加空格
SpaceBeforeSquareBrackets: false # 在方括号之前不加空格
Standard: Latest # 使用最新的标准
StatementMacros:
  - Q_UNUSED
  - QT_REQUIRE_VERSION
TabWidth: 8 # 设置制表符宽度为 8 个空格
UseCRLF: false # 不使用 CRLF 作为行尾符，使用 LF
UseTab: Never # 从不使用制表符，使用空格进行缩进er
...
```