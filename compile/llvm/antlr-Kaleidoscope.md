# Kaleidoscope with antlr

参考资料：[My First Language Frontend with LLVM Tutorial](https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html)

`Kaleidoscope.g4`语法：
```antlr
grammar Kaleidoscope;

src
    : toplevel* EOF
    ;

toplevel
    : DEF prototype expression SEMICOLON                    # FunctionAST
    | EXTERN prototype SEMICOLON                            # ExternExpression
    | expression                                            # TopLevelExpression
    | SEMICOLON                                             # TopLevelSemicolon
    ;

expression
    : LPAREN expression RPAREN                              # ParenExprAST
    | ID LPAREN (expression (COMMA expression)*)? RPAREN    # CallExprAST
    | expression (SLASH | ASTERISK) expression              # MulDivAST
    | expression (PLUS | MINUS) expression                  # AddSubAST
    | expression ASSIGN expression                          # AssignAST
    | expression LEFTANGLE expression                       # CmpExprAST
    | expression userdefinedop expression                   # UserDefExprAST
    | VAR initializer (COMMA initializer)* IN expression    # VarExprAST
    | IF expression THEN expression ELSE expression         # IfExprAST
    | FOR initializer COMMA expression 
        (COMMA expression)? IN expression                   # ForExprAST
    | userdefinedop expression                              # UserDefUnaryExprAST
    | unaryop expression                                    # UnaryOpAST
    | ID                                                    # VariableExprAST
    | NUMBER                                                # NumberExprAST
    ;

unaryop
    : EXCLAMATION
    | MINUS
    ;

userdefinedop
    : PLUS
    | MINUS
    | SLASH
    | ASTERISK
    | VBAR
    | ASSIGN
    | COLON
    | AMPERSAND
    | LEFTANGLE
    | RIGHTANGLE
    ;

initializer
    : ID (ASSIGN expression)?
    ;

prototype
    : ID LPAREN args RPAREN                                 # ProtoTypeAST
    | UNARY unaryop NUMBER? LPAREN ID RPAREN                # UnaryOpProtoTypeAST
    | BINARY userdefinedop NUMBER? LPAREN ID ID RPAREN      # BinaryOpProtoTypeAST
    ;

args
    : (ID)*
    ;

DEF: 'def';
EXTERN: 'extern';
IF: 'if';
THEN: 'then';
ELSE: 'else';
FOR: 'for';
IN: 'in';
UNARY: 'unary';
BINARY: 'binary';
VAR: 'var';

fragment DECDIGITS: [0-9];
fragment DIGITS: '0' | [1-9][0-9]*;
fragment EOL
    : ('\r' '\n')
    | ('\r' |'\n' | '\u2028' | '\u2029')
    | EOF
    ;

COMMENTS: '#' ~[\r\n]* EOL -> skip;
WS: [ \t\r\n]+ -> skip;


ID: [a-zA-Z][a-zA-Z0-9]*;
NUMBER: DIGITS ('.' DECDIGITS+)?;

ASSIGN: '=';
SLASH: '/';
ASTERISK: '*';
PLUS: '+';
MINUS :'-';
LEFTANGLE: '<';
RIGHTANGLE: '>';
EXCLAMATION: '!';
VBAR: '|';
COLON: ':';
AMPERSAND: '&';

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
SEMICOLON: ';';
```

`conanfile.txt`依赖：
```text
[requires]
antlr4-cppruntime/4.13.1
glog/0.7.1

[build_requires]
antlr4/4.13.1

[generators]
cmake
```

antlr4 生成Lexer:
```bash
source build/activate_run.sh
antlr4 antlr4 -Dlanguage=Cpp -visitor Kaleidoscope.g4

conan install -if build -r conancenter --build=missing -g=virtualrunenv .
```

`CMakeLists.txt`配置：
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(antlr-Kaleidoscope VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(LLVM_DIR "$(llvm-config --cmakedir)")
message(STATUS "LLVM_DIR: ${LLVM_DIR}")

set(CMAKE_BUILD_TYPE Debug)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
find_package(LLVM 18.1.8 REQUIRED CONFIG)

# file(GLOB SRCS ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
add_executable(antlr-Kaleidoscope main.cpp KaleidoscopeLexer.cpp KaleidoscopeParser.cpp KaleidoscopeBaseVisitor.cpp KaleidoscopeVisitor.cpp)
target_link_libraries(antlr-Kaleidoscope ${CONAN_LIBS} Threads::Threads ${LLVM_AVAILABLE_LIBS})
target_compile_options(antlr-Kaleidoscope PRIVATE "-fexceptions")
```

实现访问器：
```cpp
#include <iostream>
#include <string>

#include <glog/logging.h>

#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/StandardInstrumentations.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetOptions.h"
#include "llvm/TargetParser/Host.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Scalar/GVN.h"
#include "llvm/Transforms/Scalar/Reassociate.h"
#include "llvm/Transforms/Scalar/SimplifyCFG.h"

using namespace llvm;
using namespace llvm::sys;

static std::unique_ptr<LLVMContext> TheContext;
static std::unique_ptr<IRBuilder<>> Builder;
static std::unique_ptr<Module> TheModule;
static std::map<std::string, AllocaInst *> NamedValues;
static std::unique_ptr<FunctionPassManager> TheFPM;
static std::unique_ptr<LoopAnalysisManager> TheLAM;
static std::unique_ptr<FunctionAnalysisManager> TheFAM;
static std::unique_ptr<CGSCCAnalysisManager> TheCGAM;
static std::unique_ptr<ModuleAnalysisManager> TheMAM;
static std::unique_ptr<PassInstrumentationCallbacks> ThePIC;
static std::unique_ptr<StandardInstrumentations> TheSI;
static ExitOnError ExitOnErr;

static std::map<char, int> BinopPrecedence;

static void InitializeModuleAndManagers(){
    TheContext = std::make_unique<LLVMContext>();
    TheModule = std::make_unique<Module>("KaleidoscopeJIT", *TheContext);

    Builder = std::make_unique<IRBuilder<>>(*TheContext);

    TheFPM = std::make_unique<FunctionPassManager>();
    TheLAM = std::make_unique<LoopAnalysisManager>();
    TheFAM = std::make_unique<FunctionAnalysisManager>();
    TheCGAM = std::make_unique<CGSCCAnalysisManager>();
    TheMAM = std::make_unique<ModuleAnalysisManager>();
    ThePIC = std::make_unique<PassInstrumentationCallbacks>();
    TheSI = std::make_unique<StandardInstrumentations>(*TheContext, true);

    TheSI->registerCallbacks(*ThePIC);

    TheFPM->addPass(InstCombinePass());
    TheFPM->addPass(ReassociatePass());
    TheFPM->addPass(GVNPass());
    TheFPM->addPass(SimplifyCFGPass());

    PassBuilder PB;
    PB.registerModuleAnalyses(*TheMAM);
    PB.registerFunctionAnalyses(*TheFAM);
    PB.crossRegisterProxies(*TheLAM, *TheFAM, *TheCGAM, *TheMAM);
}

#include <antlr4-runtime/antlr4-runtime.h>
#include "KaleidoscopeLexer.h"
#include "KaleidoscopeParser.h"
#include "KaleidoscopeVisitor.h"

class IRKaleidoscopeVisitor : public KaleidoscopeVisitor {

    AllocaInst *CreateEntryBlockAlloca(Function *TheFunction,
                                                StringRef VarName) {
        IRBuilder<> TmpB(&TheFunction->getEntryBlock(),
                        TheFunction->getEntryBlock().begin());
        return TmpB.CreateAlloca(Type::getDoubleTy(*TheContext), nullptr, VarName);
    }


    std::any visitFunctionAST(KaleidoscopeParser::FunctionASTContext *context) override {
        Function *TheFunction = any_cast<Function *>(visit(context->prototype()));

        BasicBlock *BB = BasicBlock::Create(*TheContext, "entry", TheFunction);
        Builder->SetInsertPoint(BB);
        NamedValues.clear();

        for (auto &Arg : TheFunction->args()){
            AllocaInst *Alloca = CreateEntryBlockAlloca(TheFunction, Arg.getName());
            Builder->CreateStore(&Arg, Alloca);
            NamedValues[std::string(Arg.getName())] = Alloca;
        }

        std::any body = visit(context->expression());
        if (Value *RetVal = any_cast<Value *>(body)){
            Builder->CreateRet(RetVal);
            verifyFunction(*TheFunction);
            TheFPM->run(*TheFunction, *TheFAM);

            TheFunction->print(errs());

            return TheFunction;
        }
        TheFunction->eraseFromParent();

        return nullptr;
    }

    std::any visitParenExprAST(KaleidoscopeParser::ParenExprASTContext *context) override {
        LOG(INFO) << "(" << std::endl;
        std::any ret = visit(context->expression());
        LOG(INFO) << ")" << std::endl;

        return ret;
    }

    std::any visitExternExpression(KaleidoscopeParser::ExternExpressionContext *context) override {
        LOG(INFO) << "extern" << std::endl;
        Function *TheFunction = any_cast<Function *>(visit(context->prototype()));
        TheFunction->setLinkage(GlobalValue::ExternalLinkage);
        return TheFunction;
    }

    std::any visitTopLevelExpression(KaleidoscopeParser::TopLevelExpressionContext *context) override {

        std::vector<Type *> Doubles(0, Type::getDoubleTy(*TheContext));
        FunctionType *FT = FunctionType::get(Type::getDoubleTy(*TheContext), Doubles, false);
        Function *TheFunction = Function::Create(FT, Function::ExternalLinkage, "__anon_expr", TheModule.get());

        BasicBlock *BB = BasicBlock::Create(*TheContext, "entry", TheFunction);
        Builder->SetInsertPoint(BB);
        Value *RetVal = any_cast<Value *>(visit(context->expression()));
        Builder->CreateRet(RetVal);
        verifyFunction(*TheFunction);

        return TheFunction;
    }

    std::any visitTopLevelSemicolon(KaleidoscopeParser::TopLevelSemicolonContext *context) override {
        LOG(INFO) << ";" << std::endl;
        return nullptr;
    }

    std::any visitCallExprAST(KaleidoscopeParser::CallExprASTContext *context) override {
        std::string Callee = context->ID()->getText();
        if (auto *CalleeF = TheModule->getFunction(Callee)) {
            LOG(INFO) << Callee << "(" << std::endl;
            std::vector<Value *> ArgsV;
            for (auto &Arg : context->expression()){
                ArgsV.push_back(any_cast<Value *>(visit(Arg)));
            }

            LOG(INFO) << ")" << std::endl;

            Value *ret = Builder->CreateCall(CalleeF, ArgsV, "calltmp");
            if (nullptr == ret) {
                LOG(ERROR) << "Failed to create call instruction";
                return nullptr;
            }
            return ret;
        }
        LOG(ERROR) << "Unknown function referenced";
        return nullptr;
    }

    std::any visitVariableExprAST(KaleidoscopeParser::VariableExprASTContext *context) override {
        std::string var_name = context->ID()->getText();
        LOG(INFO) << var_name << std::endl;
        AllocaInst *A = NamedValues[var_name];

        if (!A){
            LOG(ERROR) << "Unknown variable name: " << var_name << " in visitVariableExprAST" << std::endl;
            return nullptr;
        }
        Value *ret = Builder->CreateLoad(A->getAllocatedType(), A, var_name);

        return ret;
    }

    std::any visitNumberExprAST(KaleidoscopeParser::NumberExprASTContext *context) override {
        std::string number = context->NUMBER()->getText();
        double num = std::stod(number);
        LOG(INFO) << num << std::endl;
        Value *val = ConstantFP::get(*TheContext, APFloat(num));
        if (nullptr == val) {
            LOG(ERROR) << "Failed to create constant";
            return nullptr;
        }
        return val;
    }

    std::any visitAddSubAST(KaleidoscopeParser::AddSubASTContext *context) override {
        Value *L = any_cast<Value *>(visit(context->expression(0)));
        LOG(INFO) << "+" << std::endl;
        Value *R = any_cast<Value *>(visit(context->expression(1)));

        if (!L || !R){
            return nullptr;
        }

        if (context->PLUS() != nullptr){
            return Builder->CreateFAdd(L, R, "addtmp");
        } else if (context->MINUS() != nullptr){
            return Builder->CreateFSub(L, R, "subtmp");
        } else {
            LOG(ERROR) << "Invalid operator";
            return nullptr;
        }
    }

    std::any visitMulDivAST(KaleidoscopeParser::MulDivASTContext *context) override {
        Value *L = any_cast<Value *>(visit(context->expression(0)));
        LOG(INFO) << "*" << std::endl;
        Value *R = any_cast<Value *>(visit(context->expression(1)));

        if (!L || !R){
            return nullptr;
        }

        if (context->ASTERISK() != nullptr){
            return Builder->CreateFMul(L, R, "multmp");
        } else if (context->SLASH() != nullptr){
            return Builder->CreateFDiv(L, R, "divtmp");
        } else {
            LOG(ERROR) << "Invalid operator";
            return nullptr;
        }
    }

    std::any visitProtoTypeAST(KaleidoscopeParser::ProtoTypeASTContext *context) override {
        int arg_size = context->args()->ID().size();
        std::vector<Type *> Doubles(arg_size, Type::getDoubleTy(*TheContext));
        FunctionType *FT = FunctionType::get(Type::getDoubleTy(*TheContext), Doubles, false);
        std::string function_name = context->ID()->getText();
        Function *F = Function::Create(FT, Function::ExternalLinkage, function_name, TheModule.get());

        unsigned Idx = 0;
        for (auto &Arg : F->args()){
            Arg.setName(context->args()->ID(Idx++)->getText());
        }

        LOG(INFO) << function_name << "(";
        for (auto &Arg : F->args()){
            LOG(INFO) << Arg.getName().str();
        }
        LOG(INFO) << ")" << std::endl;

        return F;
    }

    std::any visitArgs(KaleidoscopeParser::ArgsContext *context) override {
        LOG(INFO) << "visitArgs" << std::endl;
        return nullptr;
    }
    
    std::any visitCmpExprAST(KaleidoscopeParser::CmpExprASTContext *context) override {
        Value *L = any_cast<Value *>(visit(context->expression(0)));
        LOG(INFO) << "<" << std::endl;
        Value *R = any_cast<Value *>(visit(context->expression(1)));

        if (!L || !R){
            return nullptr;
        }

        if (context->LEFTANGLE() != nullptr) {
            L = Builder->CreateFCmpULT(L, R, "cmptmp");
        } else {
            LOG(ERROR) << "Invalid operator";
            return nullptr;
        }

        return Builder->CreateUIToFP(L, Type::getDoubleTy(*TheContext), "booltmp");
    }

    std::any visitIfExprAST(KaleidoscopeParser::IfExprASTContext *context) override {
        LOG(INFO) << "if" << std::endl;
        Value *CondV = any_cast<Value *>(visit(context->expression(0)));
        if (!CondV){
            return nullptr;
        }

        CondV = Builder->CreateFCmpONE(
            CondV, ConstantFP::get(*TheContext, APFloat(0.0)), "ifcond");

        Function *TheFunction = Builder->GetInsertBlock()->getParent();

        BasicBlock *ThenBB = BasicBlock::Create(*TheContext, "then", TheFunction);
        BasicBlock *ElseBB = BasicBlock::Create(*TheContext, "else");
        BasicBlock *MergeBB = BasicBlock::Create(*TheContext, "ifcont");

        Builder->CreateCondBr(CondV, ThenBB, ElseBB);

        Builder->SetInsertPoint(ThenBB);

        LOG(INFO) << "then" << std::endl;
        Value *ThenV = any_cast<Value *>(visit(context->expression(1)));
        if (!ThenV){
            return nullptr;
        }

        Builder->CreateBr(MergeBB);
        ThenBB = Builder->GetInsertBlock();

        TheFunction->insert(TheFunction->end(), ElseBB);
        Builder->SetInsertPoint(ElseBB);

        LOG(INFO) << "else" << std::endl;
        Value *ElseV = any_cast<Value *>(visit(context->expression(2)));
        if (!ElseV){
            return nullptr;
        }

        Builder->CreateBr(MergeBB);
        ElseBB = Builder->GetInsertBlock();

        TheFunction->insert(TheFunction->end(), MergeBB);
        Builder->SetInsertPoint(MergeBB);
        PHINode *PN = Builder->CreatePHI(Type::getDoubleTy(*TheContext), 2, "iftmp");
        
        PN->addIncoming(ThenV, ThenBB);
        PN->addIncoming(ElseV, ElseBB);

        Value *ret = PN;
        return ret;
    }

    std::any visitInitializer(KaleidoscopeParser::InitializerContext *context) override {
        std::string var_name = context->ID()->getText();
        LOG(INFO) << var_name << " = " << std::endl;

        Value *Val = any_cast<Value *>(visit(context->expression()));
        if (!Val){
            LOG(ERROR) << "Failed to get value" << std::endl;
            return nullptr;
        }

        AllocaInst *Alloca = nullptr;
        if (NamedValues.find(var_name) == NamedValues.end()){
            Alloca = Builder->CreateAlloca(Type::getDoubleTy(*TheContext), 0, var_name);
            NamedValues[var_name] = Alloca;
        } else {
            Alloca = NamedValues[var_name];
        }

        return Val;
    }

    std::any visitSrc(KaleidoscopeParser::SrcContext *context) override {
        LOG(INFO) << "visitSrc" << std::endl;
        return visitChildren(context);
    }

    std::any visitVarExprAST(KaleidoscopeParser::VarExprASTContext *context) override {
        std::vector<AllocaInst *> OldBindings;

        Function *TheFunction = Builder->GetInsertBlock()->getParent();

        for (unsigned i = 0, e = context->initializer().size(); i != e; ++i) {
            const std::string &var_name = context->initializer(i)->ID()->getText();
            
            LOG(INFO) << var_name << " = " << std::endl;
            Value *InitVal;
            if (context->initializer(i)->expression() != nullptr){
                InitVal = any_cast<Value *>(visit(context->initializer(i)->expression()));
                if (!InitVal){
                    return nullptr;
                }
            } else {
                InitVal = ConstantFP::get(*TheContext, APFloat(0.0));
            }

            AllocaInst *Alloca = Builder->CreateAlloca(Type::getDoubleTy(*TheContext), 0, var_name);
            Builder->CreateStore(InitVal, Alloca);
            OldBindings.push_back(NamedValues[var_name]);

            NamedValues[var_name] = Alloca;
        }

        Value *BodyVal = any_cast<Value *>(visit(context->expression()));
        if (!BodyVal){
            LOG(ERROR) << "Failed to get value" << std::endl;
            return nullptr;
        }

        for (unsigned i = 0, e = context->initializer().size(); i != e; ++i) {
            const std::string &var_name = context->initializer(i)->ID()->getText();
            NamedValues[var_name] = OldBindings[i];
        }

        return BodyVal;
    }

    std::any visitForExprAST(KaleidoscopeParser::ForExprASTContext *context) override {
        LOG(INFO) << "for" << std::endl;

        Value *Start = any_cast<Value *>(visit(context->initializer()));
        if (!Start){
            return nullptr;
        }

        Function *TheFunction = Builder->GetInsertBlock()->getParent();

        std::string var_name = context->initializer()->ID()->getText();
        AllocaInst *Alloca = CreateEntryBlockAlloca(TheFunction, var_name);

        BasicBlock *PreheaderBB = Builder->GetInsertBlock();
        BasicBlock *LoopBB = BasicBlock::Create(*TheContext, "loop", TheFunction);

        Builder->CreateBr(LoopBB);

        Builder->SetInsertPoint(LoopBB);

        AllocaInst *OldVal = NamedValues[var_name];
        NamedValues[var_name] = Alloca;

        PHINode *Variable = 
            Builder->CreatePHI(Type::getDoubleTy(*TheContext), 2, var_name);
        Variable->addIncoming(Start, PreheaderBB);

        LOG(INFO) << "for expression size: " << context->expression().size() << std::endl;
 
        if (context->expression(2) != nullptr) {
            visit(context->expression(2));
        } else {
            visit(context->expression(1));
        }
        
        Value *StepVal = nullptr;
        if (context->expression(2) != nullptr){
            StepVal = any_cast<Value *>(visit(context->expression(1)));
            if (!StepVal){
                return nullptr;
            }
        } else {
            StepVal = ConstantFP::get(*TheContext, APFloat(1.0));
        }
        Value *EndCond = any_cast<Value *>(visit(context->expression(0)));

        Value *CurVar = Builder->CreateLoad(Alloca->getAllocatedType(), Alloca, var_name);
        Value *NextVar = Builder->CreateFAdd(CurVar, StepVal, "nextvar");
        Builder->CreateStore(NextVar, Alloca);

        EndCond = Builder->CreateFCmpONE(
            EndCond, ConstantFP::get(*TheContext, APFloat(0.0)), "loopcond");

        BasicBlock *LoopEndBB = Builder->GetInsertBlock();
        BasicBlock *AfterBB = BasicBlock::Create(*TheContext, "afterloop", TheFunction);

        Builder->CreateCondBr(EndCond, LoopBB, AfterBB);
        Builder->SetInsertPoint(AfterBB);

        Variable->addIncoming(NextVar, LoopEndBB);

        if (OldVal){
            NamedValues[var_name] = OldVal;
        } else {
            NamedValues.erase(var_name);
        }

        Value *retVal = Constant::getNullValue(Type::getDoubleTy(*TheContext));
        return retVal;
    }

    std::any visitUnaryOpProtoTypeAST(KaleidoscopeParser::UnaryOpProtoTypeASTContext *context) override {
        std::string func_name = "unary";
        func_name += context->unaryop()->getText();

        Function *F = TheModule->getFunction(func_name);
        if (!F){
            std::vector<Type *> Doubles(1, Type::getDoubleTy(*TheContext));
            FunctionType *FT = FunctionType::get(Type::getDoubleTy(*TheContext), Doubles, false);
            F = Function::Create(FT, Function::ExternalLinkage, func_name, TheModule.get());

            F->arg_begin()->setName(context->ID()->getText());
            std::cout << func_name << "(" << context->ID()->getText() << ")" << std::endl;

            return F;
        }
        LOG(INFO) << "visitUnaryOpProtoTypeAST" << std::endl;
        return nullptr;
    }

    std::any visitAssignAST(KaleidoscopeParser::AssignASTContext *context) override {
        KaleidoscopeParser::VariableExprASTContext *LHSE = 
            static_cast<KaleidoscopeParser::VariableExprASTContext *>(context->expression(0));
        std::string var_name = LHSE->ID()->getText();
        LOG(INFO) << var_name << " = " << std::endl;

        Value *Val = any_cast<Value *>(visit(context->expression(1)));
        if (!Val){
            LOG(ERROR) << "Failed to get value" << std::endl;
            return nullptr;
        }

        Value *Variable = NamedValues[var_name];
        if (!Variable){
            LOG(ERROR) << "Unknown variable name: " << var_name << " in visitAssignAST" << std::endl;
            return nullptr;
        }

        Value *ret = Builder->CreateStore(Val, Variable);
        return ret;
    }

    std::any visitBinaryOpProtoTypeAST(KaleidoscopeParser::BinaryOpProtoTypeASTContext *context) override {
        std::string func_name = "binary";
        func_name += context->userdefinedop()->getText();
        
        Function *F = TheModule->getFunction(func_name);
        if (!F){
            std::vector<Type *> Doubles(2, Type::getDoubleTy(*TheContext));
            FunctionType *FT = FunctionType::get(Type::getDoubleTy(*TheContext), Doubles, false);
            F = Function::Create(FT, Function::ExternalLinkage, func_name, TheModule.get());

            F->arg_begin()[0].setName(context->ID(0)->getText());
            F->arg_begin()[1].setName(context->ID(1)->getText());

            LOG(INFO) << func_name << "(" << context->ID(0)->getText() << ", " << context->ID(1)->getText() << ")" << std::endl;

            return F;
        }

        return nullptr;
    }

    std::any visitUserDefUnaryExprAST(KaleidoscopeParser::UserDefUnaryExprASTContext *context) override {
        std::string func_name = "unary";
        func_name += context->userdefinedop()->getText();

        LOG(INFO) << func_name << std::endl;

        Function *F = TheModule->getFunction(func_name);
        if (!F){
            LOG(ERROR) << "Unknown unary operator";
            return nullptr;
        }

        Value *OperandV = any_cast<Value *>(visit(context->expression()));
        if (!OperandV){
            return nullptr;
        }

        return Builder->CreateCall(F, OperandV, "unop");
    }

    std::any visitUserDefExprAST(KaleidoscopeParser::UserDefExprASTContext *context) override {
        std::string func_name = "binary";
        func_name += context->userdefinedop()->getText();

        Function *F = TheModule->getFunction(func_name);
        if (!F){
            LOG(ERROR) << "Unknown binary operator";
            return nullptr;
        }

        Value *L = any_cast<Value *>(visit(context->expression(0)));
        LOG(INFO) << func_name << std::endl;
        Value *R = any_cast<Value *>(visit(context->expression(1)));

        if (!L || !R){
            return nullptr;
        }

        Value *ret = Builder->CreateCall(F, {L, R}, "binop");
        return ret;
    }

    std::any visitUnaryop(KaleidoscopeParser::UnaryopContext *context) override {
        return nullptr;
    }

    std::any visitUserdefinedop(KaleidoscopeParser::UserdefinedopContext *context) override {
        return nullptr;
    }

    std::any visitUnaryOpAST(KaleidoscopeParser::UnaryOpASTContext *context) override {
        std::string func_name = "unary";
        func_name += context->unaryop()->getText();
        
        Function *F = TheModule->getFunction(func_name);
        if (!F){
            LOG(ERROR) << "Unknown unary operator";
            return nullptr;
        }
        Value *OperandV = any_cast<Value *>(visit(context->expression()));
        if (!OperandV){
            return nullptr;
        }
        
        Value *ret = Builder->CreateCall(F, OperandV, "unop");
        return ret;
    }
};
```

实现 `main` 函数
```cpp
int main(int argc, char** argv){
    google::InitGoogleLogging(argv[0]);

    // set log level to info
    FLAGS_logtostderr = 1;

    BinopPrecedence['<'] = 10;
    BinopPrecedence['+'] = 20;
    BinopPrecedence['-'] = 20;
    BinopPrecedence['*'] = 40; // highest

    InitializeModuleAndManagers();

    const char *src_path = "/home/lixiang/coding/llvm/antlr-Kaleidoscope/test.txt";
    char *source = nullptr;
    FILE *fp = fopen(src_path, "r");
    if (fp) {
        fseek(fp, 0, SEEK_END);
        long size = ftell(fp);
        fseek(fp, 0, SEEK_SET);
        source = (char *)malloc(size + 1);
        fread(source, 1, size, fp);
        source[size] = 0;
        fclose(fp);
    }
    antlr4::ANTLRInputStream input(source);
    KaleidoscopeLexer lexer(&input);
    antlr4::CommonTokenStream tokens(&lexer);
    KaleidoscopeParser parser(&tokens);
    antlr4::tree::ParseTree *tree = parser.src();

    IRKaleidoscopeVisitor visitor;
    visitor.visit(tree);

    // print out generated IR
    // TheModule->print(errs(), nullptr);

    InitializeAllTargetInfos();
    InitializeAllTargets();
    InitializeAllTargetMCs();
    InitializeAllAsmParsers();
    InitializeAllAsmPrinters();

    auto TargetTriple = sys::getDefaultTargetTriple();
    TheModule->setTargetTriple(TargetTriple);

    std::string Error;
    auto Target = TargetRegistry::lookupTarget(TargetTriple, Error);

    if (!Target){
        LOG(ERROR) << Error << std::endl;
        return 1;
    }

    auto CPU = "generic";
    auto Features = "";

    TargetOptions opt;
    auto TheTargetMachine = Target->createTargetMachine(
        TargetTriple, CPU, Features, opt, Reloc::PIC_);

    TheModule->setDataLayout(TheTargetMachine->createDataLayout());

    auto Filename = "output.o";
    std::error_code EC;
    raw_fd_ostream dest(Filename, EC, sys::fs::OF_None);

    if (EC){
        LOG(ERROR) << "Could not open file: " << EC.message() << std::endl;
        return 1;
    }

    legacy::PassManager pass;
    auto FileType = CodeGenFileType::ObjectFile;

    if (TheTargetMachine->addPassesToEmitFile(pass, dest, nullptr, FileType)){
        LOG(ERROR) << "TheTargetMachine can't emit a file of this type" << std::endl;
        return 1;
    }

    pass.run(*TheModule);
    dest.flush();

    outs() << "Wrote " << Filename << "\n";

    return 0;
}
```

`text.txt` 中的内容为测试；

# 第8章实验
`test.txt`:
```txt
def average(x y) (x + y) * 0.5;
```

`antlr-debug`配置文件:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug ANTLR grammar",
            "type": "antlr-debug",
            "request": "launch",
            "input": "test.txt",
            "grammar": "TOY.g4",
            "startRule": "module",
            "printParseTree": true,
            "visualParseTree": true
        }
    ]
}
```

需要执行：
```bash
cd antlr-toy/
cmake --build build/

./build/bin/antlr-toy
clang test.cpp output.o -lstdc++ -o main
./main 
average of 3.0 and 4.0: 3.5
```