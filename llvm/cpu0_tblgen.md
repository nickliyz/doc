# Cpu0 Backend TableGen note

## 基础概念
`Register`的 Record:
```
class Register<string Register:n = ?, list<string> Register:altNames = []> {
  string Namespace = "";
  string AsmName = Register:n;
  list<string> AltNames = Register:altNames;
  list<Register> Aliases = [];
  list<Register> SubRegs = [];
  list<SubRegIndex> SubRegIndices = [];
  list<RegAltNameIndex> RegAltNameIndices = [];
  list<int> DwarfNumbers = [];
  list<int> CostPerUse = [0];
  bit CoveredBySubRegs = 0;
  bits<16> HWEncoding = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  bit isArtificial = 0;
  bit isConstant = 0;
  int PositionOrder = 0;
}
```

## Cpu0RegisterInfo.td
```
class Cpu0Reg<bits<16> Enc, string n> : Register<n> {
  // 该寄存器的目标特定硬件编码。
  let HWEncoding = Enc;
  // 寄存器的命名空间
  let Namespace = "Cpu0";
}

class Cpu0GPRReg<bits<16> Enc, string n> : Cpu0Reg<Enc, n>;
```
寄存器的宽度是16bits, 对于寄存器的发射.

```
let Namespace = "Cpu0" in {
  def ZERO : Cpu0GPRReg<0,  "zero">, DwarfRegNum<[0]>;
  def AT   : Cpu0GPRReg<1,  "1">,    DwarfRegNum<[1]>;
  ...
}
```

因此`ZERO`的Record:
```
def ZERO {	// Register Cpu0Reg Cpu0GPRReg DwarfRegNum
  string Namespace = "Cpu0";
  string AsmName = "zero";
  list<string> AltNames = [];
  list<Register> Aliases = [];
  list<Register> SubRegs = [];
  list<SubRegIndex> SubRegIndices = [];
  list<RegAltNameIndex> RegAltNameIndices = [];
  list<int> DwarfNumbers = [0];
  list<int> CostPerUse = [0];
  bit CoveredBySubRegs = 0;
  bits<16> HWEncoding = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  bit isArtificial = 0;
  bit isConstant = 0;
  int PositionOrder = 0;
}
```

接下来让看看`CpuRegs`的定义:
```
def CPURegs : RegisterClass<"Cpu0", [i32], 32, (add
  ZERO, AT, ...
  )>;
```
对应的Record:
```
def CPURegs {	// DAGOperand RegisterClass
  string OperandNamespace = "MCOI";
  string DecoderMethod = "";
  // 这里设置了名称空间是 "Cpu0"
  string Namespace = "Cpu0";
  RegInfoByHwMode RegInfos = ?;
  // 这里设置了寄存器的类型: i32
  list<ValueType> RegTypes = [i32];
  int Size = 0;
  // 这里设置了对齐, 参数是32
  int Alignment = 32;
  int CopyCost = 1;
  // 这里是个DAG, 在RegisterClass中, 对应的参数是: regList
  dag MemberList = (add ZERO, AT, ...);
  RegAltNameIndex altNameIndex = NoRegAltName;
  bit isAllocatable = 1;
  list<dag> AltOrders = [];
  code AltOrderSelect = [{}];
  int AllocationPriority = 0;
  bit GlobalPriority = 0;
  bit GeneratePressureSet = 1;
  int Weight = ?;
  string DiagnosticType = "";
  string DiagnosticString = "";
  bits<8> TSFlags = { 0, 0, 0, 0, 0, 0, 0, 0 };
  int BaseClassOrder = ?;
}
```

重点看一下`add`, 其定义:
```
def add        : SDNode<"ISD::ADD"       , SDTIntBinOp   ,
                        [SDNPCommutative, SDNPAssociative]>;
```
而`SDNode`(选择 DAG 节点定义)的定义:
```
class SDNode<string opcode, SDTypeProfile typeprof,
             list<SDNodeProperty> props = [], string sdclass = "SDNode">
             : SDPatternOperator {
  string Opcode  = opcode;
  string SDClass = sdclass;
  let Properties = props;
  SDTypeProfile TypeProfile = typeprof;
}
```
可以看到:
* opcode - "ISD::ADD"
  操作的名称是加法
* typeprof - SDTIntBinOp
  ```
  def SDTIntBinOp : SDTypeProfile<1, 2, [     // add, and, or, xor, udiv, etc.
    SDTCisSameAs<0, 1>, SDTCisSameAs<0, 2>, SDTCisInt<0>
  ]>;
  ```
  可以看出, 操作的类型是整形二元操作符, 表示操作类型中输入有两个操作数, 输出有一个操作数, 并且要求操作数 0和1, 0和2的类型必须相同, 还有操作数 0 的类型必须是整数
* props - [SDNPCommutative, SDNPAssociative]
  ```
  def SDNPCommutative : SDNodeProperty;   // X op Y == Y op X
  def SDNPAssociative : SDNodeProperty;   // (X op Y) op Z == X op (Y op Z)
  ```
  可以看出操作的类型满足**交换率**和**结合率**
* sdclass - "SDNode"

综上, `(add ZERO, AT...)` 这个DAG表示, 在加法操作时, 可以选择: ZERO, AT等寄存器