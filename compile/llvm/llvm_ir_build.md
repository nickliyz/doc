# llvm ir build api

## 继承关系 (参考`llvm/include/llvm/IR/Instruction.def`中的定义)
`Value`:
  * `Argument`  // 表示函数的参数
  * `BasicBlock`  // 表示基本块
  * `InlineAsm`  // 表示内联汇编代码
  * `MetadataAsValue`  // 表示元数据值
  * `BlockArgument`  // 表示块参数
  * `OpResult`  // 表示操作结果
  * `User`  // 表示使用者
    * `Instruction`  // 表示指令(UserOp1/UserOp2)
      * `UnaryInstruction`  // 表示一元指令
        * `UnaryOperator`  // 表示一元操作符(FNeg)
        * `CastInst`  // 表示类型转换指令
          * `PossiblyNonNegInst`  // 可能非负指令
          * `TruncInst`  // 截断指令(Trunc)
          * `ZExtInst`  // 零扩展指令(ZExt)
          * `SExtInst`  // 符号扩展指令(SExt)
          * `FPTruncInst`  // 浮点截断指令(FPTrunc)
          * `FPExtInst`  // 浮点扩展指令(FPExt)
          * `UIToFPInst`  // 无符号整数到浮点数转换指令(UIToFP)
          * `SIToFPInst`  // 有符号整数到浮点数转换指令(SIToFP)
          * `FPToUIInst`  // 浮点数到无符号整数转换指令(FPToUI)
          * `FPToSIInst`  // 浮点数到有符号整数转换指令(FPToSI)
          * `IntToPtrInst`  // 整数到指针转换指令(IntToPtr)
          * `PtrToIntInst`  // 指针到整数转换指令(PtrToInt)
          * `BitCastInst`  // 位转换指令(BitCast)
          * `AddrSpaceCastInst`  // 地址空间转换指令(AddrSpaceCast)
        * `AllocaInst`  // 分配指令(Alloca)
        * `LoadInst`  // 加载指令(Load)
        * `VAArgInst`  // 可变参数指令(VAArg)
        * `ExtractValueInst`  // 提取值指令(ExtractValue)
        * `FreezeInst`  // 冻结指令(Freeze)
      * `BinaryOperator`  // 表示二元操作符: Add/FAdd/Sub/FSub/Mul/FMul/UDiv/SDiv/FDiv/URem/SRem/FRem/Shl/LShr/AShr/And/Or/Xor
        * `PossiblyDisjointInst`  // 可能不相交指令
      * `CmpInst`  // 表示比较指令
        * `ICmpInst`  // 整数比较指令(ICmp)
        * `FCmpInst`  // 浮点比较指令(FCmp)
      * `CallBase`  // 表示调用基类
        * `CallInst`  // 表示调用指令(Call)
          * `IntrinsicInst`  // 内建指令
            * `LifetimeIntrinsic`  // 生命周期内建指令
            * `DbgInfoIntrinsic`  // 调试信息内建指令
            * `VPIntrinsic`  // 向量处理内建指令
            * `ConstrainedFPIntrinsic`  // 受限浮点内建指令
            * `MinMaxIntrinsic`  // 最小最大内建指令
            * `BinaryOpIntrinsic`  // 二元操作内建指令
            * `MemIntrinsicBase`  // 内存内建指令基类
            * `VAStartInst`  // 可变参数开始指令
            * `VAEndInst`  // 可变参数结束指令
            * `VACopyInst`  // 可变参数复制指令
            * `InstrProfInstBase`  // 指令分析基类
            * `PseudoProbeInst`  // 伪探测指令
            * `NoAliasScopeDeclInst`  // 无别名范围声明指令
            * `GCProjectionInst`  // 垃圾回收投影指令
            * `AssumeInst`  // 假设指令
            * `ConvergenceControlInst`  // 收敛控制指令
        * `InvokeInst`  // 调用指令(Invoke)
        * `CallBrInst`  // 调用分支指令(CallBr)
        * `GCStatepointInst`  // 垃圾回收状态点指令
      * `FuncletPadInst`  // 函数块填充指令
        * `CleanupPadInst`  // 清理填充指令(CleanupPad)
        * `CatchPadInst`  // 捕获填充指令(CatchPad)
      * `StoreInst`  // 存储指令(Store)
      * `FenceInst`  // 栅栏指令(Fence)
      * `AtomicCmpXchgInst`  // 原子比较交换指令(AtomicCmpXchg)
      * `AtomicRMWInst`  // 原子读-修改-写指令(AtomicRMW)
      * `GetElementPtrInst`  // 获取元素指针指令(GetElementPtr)
      * `SelectInst`  // 选择指令(Select)
      * `ExtractElementInst`  // 提取元素指令(ExtractElement)
      * `InsertElementInst`  // 插入元素指令(InsertElement)
      * `ShuffleVectorInst`  // 向量混洗指令(ShuffleVector)
      * `InsertValueInst`  // 插入值指令(InsertValue)
      * `PHINode`  // PHI节点 (PHI)
      * `LandingPadInst`  // 着陆垫指令(LandingPad)
      * `ReturnInst`  // 返回指令(Ret)
      * `BranchInst`  // 分支指令(Br)
      * `SwitchInst`  // 开关指令(Switch)
      * `IndirectBrInst`  // 间接分支指令(IndirectBr)
      * `ResumeInst`  // 恢复指令(Resume)
      * `CatchSwitchInst`  // 捕获开关指令(CatchSwitch)
      * `CatchReturnInst`  // 捕获返回指令(CatchRet)
      * `CleanupReturnInst`  // 清理返回指令(CleanupRet)
      * `UnreachableInst`  // 不可达指令(Unreachable)
    * `Operator`  // 操作符
      * `OverflowingBinaryOperator`  // 溢出二元操作符
      * `PossiblyExactOperator`  // 可能精确操作符
      * `FPMathOperator`  // 浮点数学操作符
    * `Constant`  // 常量
      * `ConstantData`  // 常量数据
        * `ConstantFP`  // 浮点常量
        * `ConstantInt`  // 整数常量
        * `ConstantAggregateZero`  // 聚合零常量
        * `ConstantPointerNull`  // 空指针常量
        * `ConstantDataSequential`  // 顺序常量数据
        * `ConstantTokenNone`  // 无令牌常量
        * `ConstantTargetNone`  // 无目标常量
        * `UndefValue`  // 未定义值
      * `ConstantAggregate`  // 聚合常量
      * `BlockAddress`  // 块地址
      * `DSOLocalEquivalent`  // DSO本地等价物
      * `NoCFIValue`  // 无CFI值
      * `ConstantExpr`:  // 常量表达式
        * `CastConstantExpr`  // 类型转换常量表达式
        * `BinaryConstantExpr`  // 二元常量表达式
        * `ExtractElementConstantExpr`  // 提取元素常量表达式
        * `InsertElementConstantExpr`  // 插入元素常量表达式
        * `ShuffleVectorConstantExpr`  // 向量混洗常量表达式
        * `GetElementPtrConstantExpr`  // 获取元素指针常量表达式
        * `CompareConstantExpr`  // 比较常量表达式

## `llvm`
`raw_fd_ostream &outs();`
获取输出流

`raw_fd_ostream &errs();`
获取错误输出流

`bool verifyFunction(const Function &F, raw_ostream *OS = nullptr);`
验证创建的 Function是否有问题, 如果有问题, 返回false

## `LLVMContext`
`LLVMContext` 是LLVM上下文, 不保证线程锁定.

## `Module`
`Function *getFunction(StringRef Name) const;`
在模块符号表中查找指定函数。如果没有存在，返回null。

## `Type`
`static Type *Type::getDoubleTy(LLVMContext &C);`
获取一个Double对象方法, 需要传入LLVMContext

```
static FunctionType *get(Type *Result,
                           ArrayRef<Type*> Params, bool isVarArg)
```
该方法是构造 FunctionType的主要方式, FunctionType也是Type的一种.

## `BasicBlock`
```
  static BasicBlock *BasicBlock::Create(LLVMContext &Context, const Twine &Name = "",
                            Function *Parent = nullptr,
                            BasicBlock *InsertBefore = nullptr)
```
创建一个新的 BasicBlock , parent 如果设置，表示在函数中插入，一般第一个插入的块是函数主体，也就是最外层的块。


## `IRBuilder`
```
  IRBuilder::IRBuilder(BasicBlock *TheBB, BasicBlock::iterator IP,
            MDNode *FPMathTag = nullptr,
            ArrayRef<OperandBundleDef> OpBundles = std::nullopt)
```
使用 BasicBlock 和指令迭代器 BasicBlock::iterator 构造一个 IRBuilder，后续所有操作都在此 BasicBlock 中进行

```
  AllocaInst *IRBuilderBase::CreateAlloca(Type *Ty, Value *ArraySize = nullptr,
                           const Twine &Name = "")
```

`ReturnInst *IRBuilderBase::CreateRet(Value *V)`
创建一条 'ret <val>' 指令

`ReturnInst *CreateRetVoid()` 创建一条 'ret void'指令

```
  CallInst *CreateCall(FunctionCallee Callee,
                       ArrayRef<Value *> Args = std::nullopt,
                       const Twine &Name = "", MDNode *FPMathTag = nullptr)
```
创建一个调用, 注意, `FunctionCallee`允许从`Function`隐式转换. `CallInst`是一个条指令, 也是一个值

`LoadInst *IRBuilderBase::CreateLoad(Type *Ty, Value *Ptr, const Twine &Name = "")`
创建一个条加载指令, 加载指定地址加载制定的值到指定变量

## `IRBuilder`
`void SetInsertPoint(BasicBlock *TheBB)`
IRBuilder 指定后续创建指令附加到快的结尾

## `Function`
`Function`是一个值(`Value`)
```
  static Function *Create(FunctionType *Ty, LinkageTypes Linkage,
                          const Twine &N = "", Module *M = nullptr
```
创建 Function 的函数, 需要提供函数的类型(原型), link方式, 函数名字, 如果匿名可以写成: "__anon_expr", 还有所属的模块.

`BasicBlock &Function::getEntryBlock()`
获取函数入口处的块

`void GlobalValue::setLinkage(Linkage L)`
设置函数的link属性, 如果函数是external的, 参数L可以设置为 `GlobalValue::ExternalLinkage`, 注意: `Function`继承`GlobalObject`并继承`GlobalValue`

```
  void print(raw_ostream &OS, AssemblyAnnotationWriter *AAW = nullptr,
             bool ShouldPreserveUseListOrder = false,
             bool IsForDebug = false) const;
```
打印`Function`的内容到输出流, 参考 `raw_fd_ostream &outs();`

`void Function::eraseFromParent();`
此方法取消“this”与包含模块的链接, 并删除它

## `FunctionPassManager`
```
  PreservedAnalysesT run(IRUnitT &IR, AnalysisManagerT &AM,
                         ExtraArgTs... ExtraArgs)
```
使用 FunctionPassManager 在 Function 上运行 FunctionAnalysisManager 的优化程序

## `Instruction`
`Type *AllocaInst::getAllocatedType()`
获取分配指令所分配的对象类型, 注意`AllocaInst`是指令(`Instruction`)

