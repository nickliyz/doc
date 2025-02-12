# TableGen Note

## 寄存器
```
class Register<string n, list<string> altNames = []> {
  string Namespace = "";
  string AsmName = n;
  list<string> AltNames = altNames;
  list<Register> Aliases = [];
  list<Register> SubRegs = [];
  list<SubRegIndex> SubRegIndices = [];
  list<RegAltNameIndex> RegAltNameIndices = [];
  list<int> DwarfNumbers = [];
  int CostPerUse = 0;
  bit CoveredBySubRegs = 0;
  bits<16> HWEncoding = 0;  // 该寄存器的目标特定硬件编码。
  bit isArtificial = 0;
}

class DwarfRegNum<list<int> Numbers> {
  list<int> DwarfNumbers = Numbers;
}
```
`Register`表示一个寄存器, `DwarfRegNum`用于设置寄存器的值, 例如:
```
class Cpu0Reg<bits<16> Enc, string n> : Register<n> {
  let HWEncoding = Enc;
  let Namespace = "Cpu0";
}

class Cpu0GPRReg<bits<16> Enc, string n> : Cpu0Reg<Enc, n>;

let Namespace = "Cpu0" in {
  def ZERO : Cpu0GPRReg<0,   "zero">, DwarfRegNum<[0]>; // 寄存器的 DwarfNumbers 会被设置为: [0]
  ...
}
```

## DAG
### 立即数转换
```
class SDNodeXForm<SDNode opc, code xformFunction> {
  SDNode Opcode = opc;
  code XFormFunction = xformFunction;
}
```
是DAG转换函数, 通常用于立即数的提取, `code xformFunction`是获取立即数的代码, 例如:
```
// 获取寄存器的高16bits
def HI16 : SDNodeXForm<imm, [{
  return getImm(N, (N->getZExtValue() >> 16) & 0xffff);
}]>;

// 获取寄存器的低16bits
def LO16 : SDNodeXForm<imm, [{
  return getImm(N, N->getZExtValue() & 0xffff);
}]>;
```

### 操作数约束
```
class SDTypeConstraint<int opnum> {
  int OperandNum = opnum;
}
```
例如:
```
class SDTCisVT<int OpNum, ValueType vt> : SDTypeConstraint<OpNum> {
  ValueType VT = vt;    // 指定的操作数恰好具有此 VT
}
```
比如: `SDTCisVT<0, iPTR>`表示要求操作数0的类型应当是 `iPTR`, 也就是指针.

### DAG 类型配置
```
// 此配置文件描述了选择的DAG节点的类型要求
class SDTypeProfile<int numresults,       // 结果操作数
      int numoperands,                    // 操作数
      list<SDTypeConstraint> constraints  // 操作数约束
      > {
  int NumResults = numresults;
  int NumOperands = numoperands;
  list<SDTypeConstraint> Constraints = constraints;
}
```

例如:
```
def SDT_Cpu0JmpLink : SDTypeProfile<0, 1, [SDTCisVT<0, iPTR>]>;
```
要求具有 `SDT_Cpu0JmpLink`配置的节点, 应接受一个操作数, 返回0个操作数, 且第一个操作数0的类型必须是指针.

### DAG 属性
```
class SDNodeProperty;
```
例如:
```
def SDNPHasChain    : SDNodeProperty;   // R/W 链操作数和结果
def SDNPOutGlue     : SDNodeProperty;   // 写入标志结果
def SDNPOptInGlue   : SDNodeProperty;   // 可选地读取标志操作数
def SDNPVariadic    : SDNodeProperty;   // 节点有可变参数
...
```

### DAG 匹配操作
```
// 选择 DAG 模式操作
class SDPatternOperator {
  list<SDNodeProperty> Properties = [];
}
```

### DAG 节点定义
```
class SDNode<string opcode,                   // DAG 节点的操作名
            SDTypeProfile typeprof,           // DAG 节点配置
            list<SDNodeProperty> props = [],  // DAG 节点属性列表
            string sdclass = "SDNode"         // DAG 节点类别
            > : SDPatternOperator {
  string Opcode  = opcode;
  string SDClass = sdclass;
  let Properties = props;
  SDTypeProfile TypeProfile = typeprof;
}
```
由于 `SDNode` 继承了 `SDPatternOperator`, 所以它拥有 `SDTypeProfile TypeProfile` 的配置

例如:
```
def Cpu0JmpLink : SDNode<"Cpu0ISD::JmpLink", SDT_Cpu0JmpLink,
                         [SDNPHasChain, SDNPOutGlue, SDNPOptInGlue,
                          SDNPVariadic]>;
```
定义了跳转类 DAG 节点:
* 操作名为 `"Cpu0ISD::JmpLink"`
* 配置为 `SDT_Cpu0JmpLink`: 0输出, 1输入, 输入参数必须是指针
* 节点属性:
  * SDNPHasChain    // R/W 链操作数和结果
  * SDNPOutGlue     // 写入标志结果
  * SDNPOptInGlue   // 可选地读取标志操作数
  * SDNPVariadic    // 节点有可变参数
* 节点类别: `"SDNode"`

### DAG 模式转换
```
class Pattern<dag patternToMatch, list<dag> resultInstrs> {
  dag             PatternToMatch  = patternToMatch;
  list<dag>       ResultInstrs    = resultInstrs;
  list<Predicate> Predicates      = [];  // See class Instruction in Target.td.
  int             AddedComplexity = 0;   // See class Instruction in Target.td.
}

class Pat<dag pattern, dag result> : Pattern<pattern, [result]>;
```
转换 `pattern` 形式到 `result` 形式.
例如:
```
def : Pat<(Cpu0JmpLink (i32 tglobaladdr:$dst)),
          (JSUB tglobaladdr:$dst)>;
```
将伪指令操作`(Cpu0JmpLink (i32 tglobaladdr:$dst))`转换为低级操作:`(JSUB tglobaladdr:$dst)`, `JSUB`是一个条指令. 其中 `tglobaladdr` 表示选择是, 要求操作数必须是一个 32 位的全局地址.

在看 `JSUB`的定义:
```
let isCall = 1, hasDelaySlot = 1 in {
  class JumpLink<bits<8> op, string instrAsm>
      : FJ<op, (outs), (ins calltarget:$target, variable_ops),
         !strconcat(instrAsm, "\t$target"), [(Cpu0JmpLink imm:$target)],
         IIBranch> {
    let DecoderMethod = "DecodeJumpTarget";
  }
  ...
}
def JSUB     : JumpLink<0x3b, "jsub">;
```
可以看到 `JSUB` 的Patten是`[(Cpu0JmpLink imm:$target)]`, 也就是说, 前后是呼应的.

## 指令
```
class Instruction {
  string Namespace = "";    // 指令的 Namespace
  dag OutOperandList;       // 包含 MI def 操作数列表的 dag
  dag InOperandList;        // 包含 MI 使用操作数列表的 dag
  string AsmString = "";    // 用于打印指令的 .s 格式
  list<dag> Pattern;        // 设置为此指令的 DAG 模式(如果我们知道其中一个), 否则, 为未初始化
  int Size = 0;             // 编码指令的大小，如果无法确定大小则为零
  string DecoderNamespace = "";     // 该指令所在的“命名空间”诸如 ARM 之类的目标存在多个 ISA 命名空间
  InstrItinClass Itinerary = NoItinerary;
  bits<64> TSFlags = 0;
  ...
}
```

### 指令行程
```
class InstrItinClass;
```
例如:
```
def IIAlu              : InstrItinClass;
```

## Processor
### 功能单元
```
class FuncUnit;
```

例如:
```
def ALU     : FuncUnit;
def IMULDIV : FuncUnit;
```

### 指令阶段
```
class InstrStage<int cycles,            // 机器周期中的阶段长度
                 list<FuncUnit> units,  // 功能单元的选择
                 int timeinc = -1,      // 循环直到下一阶段开始
                 ReservationKind kind = Required> { // 保留类型
  int Cycles          = cycles;       // length of stage in machine cycles
  list<FuncUnit> Units = units;       // choice of functional units
  int TimeInc         = timeinc;      // cycles till start of next stage
  int Kind            = kind.Value;   // kind of FU reservation
}
```

例如:
```
InstrStage<1,   [ALU]>>
```
表示这是一个 ALU 功能单元的阶段, 指令周期是 1

### 指令形成数据
```
class InstrItinData<InstrItinClass Class, list<InstrStage> stages,
                    list<int> operandcycles = [],
                    list<Bypass> bypasses = [], int uops = 1> {
  InstrItinClass TheClass = Class;
  int NumMicroOps = uops;
  list<InstrStage> Stages = stages;
  list<int> OperandCycles = operandcycles;
  list<Bypass> Bypasses = bypasses;
}
```
比如:
```
InstrItinData<IIAlu               ,  [InstrStage<1,   [ALU]>]>,
```
表示 `IIAlu` 类指令的执行有一个阶段, 该阶段在 ALU 上执行, 指令周期是: 1

### 处理器形成
```
// 处理器行程 -这些值代表所有行程的集合
class ProcessorItineraries<list<FuncUnit> fu, list<Bypass> bp,
                           list<InstrItinData> iid> {
  list<FuncUnit> FU = fu;
  list<Bypass> BP = bp;
  list<InstrItinData> IID = iid;
}
```

例如:
```
def Cpu0GenericItineraries : ProcessorItineraries<[ALU, IMULDIV], [], [
  InstrItinData<IIAlu               ,  [InstrStage<1,   [ALU]>]>,
  InstrItinData<IICLO               ,  [InstrStage<1,   [ALU]>]>,
  ...
  InstrItinData<IIHiLo              ,  [InstrStage<1,   [IMULDIV]>]>,
  InstrItinData<IIImul              ,  [InstrStage<17,  [IMULDIV]>]>,
  InstrItinData<IIIdiv              ,  [InstrStage<38,  [IMULDIV]>]>
]>;
```
表示处理器 `ALU` 和 `IMULDIV` 所有相关的指令行程数据.

### 芯片组特征
```
class SubtargetFeature<
    string n, 
    string a, 
    string v, 
    string d,
    list<SubtargetFeature> i = []> {
  string Name = n;                    // 功能名称
  string Attribute = a;               // 由功能设置的属性
  string Value = v;                   // 功能要设置的属性值
  string Desc = d;                    // 功能描述
  list<SubtargetFeature> Implies = i; // 该功能暗示的功能存在
}
```

例如:
```
def FeatureCmp            : SubtargetFeature<"cmp", "HasCmp", "true",
                                             "Enable 'cmp' instructions.">;
def FeatureSlt            : SubtargetFeature<"slt", "HasSlt", "true",
                                             "Enable 'slt' instructions.">;
def FeatureCpu032I        : SubtargetFeature<"cpu032I", "Cpu0ArchVersion",
                                             "Cpu032I", "Cpu032I ISA Support",
                                             [FeatureCmp]>;
def FeatureCpu032II       : SubtargetFeature<"cpu032II", "Cpu0ArchVersion",
                                             "Cpu032II", "Cpu032II ISA Support",
                                             [FeatureCmp, FeatureSlt]>;
```

### 芯片组定义
```
class Processor<
    string n,                 // 芯片组名称
    ProcessorItineraries pi,  // 目标处理器的调度信息
    list<SubtargetFeature> f  // 功能特性
    > {
  ...
}
```

例如:
```
class Proc<string Name, list<SubtargetFeature> Features>
  : Processor<Name, Cpu0GenericItineraries, Features>;

def : Proc<"cpu032I", [FeatureCpu032I]>;
def : Proc<"cpu032II", [FeatureCpu032II]>;
```

### 指令集信息
```
class InstrInfo {
  ...
}
```
例如:
```
def Cpu0InstrInfo : InstrInfo;
```

### AsmPrinter
```
class AsmParser {
  bit ShouldEmitMatchRegisterName = 1;
  ...
}
```
例如:
```
def Cpu0AsmParser : AsmParser {
  let ShouldEmitMatchRegisterName = 0;
}
```

### ASM 解析器
```
class AsmParserVariant {
  int Variant = 0;
  string RegisterPrefix = "";
  ...
}
```
例如:
```
def Cpu0AsmParserVariant : AsmParserVariant {
  int Variant = 0;
  string RegisterPrefix = "$";
}
```

### Target
```
class Target {
  // 该目标的指令集描述
  InstrInfo InstructionSet;
  // 可用于此目标的 AsmParser 实例
  list<AsmParser> AssemblyParsers = [DefaultAsmParser];
  // // 可用于此目标的 AsmWriter 实例
  list<AsmParserVariant> AssemblyParserVariants = [DefaultAsmParserVariant];
  ...
```

例如:
```
def Cpu0 : Target {
  let InstructionSet = Cpu0InstrInfo;
  let AssemblyParsers = [Cpu0AsmParser];
  let AssemblyParserVariants = [Cpu0AsmParserVariant];
}
```