# TOY with antlr

参考资料：[My First Language Frontend with LLVM Tutorial](https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html)

`TOY.g4`语法：
```antlr
grammar TOY;

toplevel
    : DEF prototype expression                              # FunctionAST
    | EXTERN prototype                                      # ParenExpression
    | expression                                            # TopLevelExpression
    | SEMICOLON                                             # TopLevelSemicolon
    ;

expression
    : expression (SLASH | ASTERISK) expression              # MulDivAST
    | expression (PLUS | MINUS) expression                  # AddSubAST
    | ID LPAREN (expression (COMMA expression)*)? RPAREN    # CallExprAST
    | ID                                                    # VariableExprAST
    | NUMBER                                                # NumberExprAST
    | LPAREN expression RPAREN                              # ParenExprAST
    ;

prototype
    : ID LPAREN args RPAREN                                 # ProtoTypeAST
    ;

args
    : (ID)*
    ;

DEF: 'def';
EXTERN: 'extern';

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

SLASH: '/';
ASTERISK: '*';
PLUS: '+';
MINUS :'-';
LEFTANGLE: '<';

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
SEMICOLON: ';';
```

`conanfile.txt`依赖：
```text
[requires]
antlr4-cppruntime/4.13.1

[build_requires]
antlr4/4.13.1

[generators]
cmake
```

antlr4 生成Lexer:
```bash
source build/activate_run.sh
antlr4 antlr4 -Dlanguage=Cpp -visitor TOY.g4

conan install -if build -r conancenter --build=missing -g=virtualrunenv .
```

`CMakeLists.txt`配置：
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(antlr-toy VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()
set(THREADS_PREFER_PTHREAD_FLAG ON)
find_package(Threads REQUIRED)
include_directories(${CMAKE_CURRENT_SOURCE_DIR} /usr/lib/llvm-10/include)
file(GLOB SRCS ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
add_executable(antlr-toy ${SRCS})
target_link_directories(antlr-toy PUBLIC /usr/lib/llvm-10/lib)
target_link_libraries(antlr-toy ${CONAN_LIBS} Threads::Threads LLVM-10)
target_compile_options(antlr-toy PRIVATE "-fexceptions")
add_definitions(-D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS)
```

实现访问器：
```cpp
#include <iostream>
#include <string>

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

using namespace llvm;

static std::unique_ptr<LLVMContext> TheContext;
static std::unique_ptr<IRBuilder<>> Builder;
static std::unique_ptr<Module> TheModule;
static std::map<std::string, Value *> NamedValues;

static std::map<char, int> BinopPrecedence;

static void InitializeModule(){
    TheContext = std::make_unique<LLVMContext>();
    TheModule = std::make_unique<Module>("my cool jit", *TheContext);

    Builder = std::make_unique<IRBuilder<>>(*TheContext);
}

#include <antlr4-runtime/antlr4-runtime.h>
#include "TOYLexer.h"
#include "TOYParser.h"
#include "TOYVisitor.h"

class IRTOYVisitor : public TOYVisitor {
    std::any visitFunctionAST(TOYParser::FunctionASTContext *context) override {
        Function *TheFunction = any_cast<Function *>(visit(context->prototype()));

        BasicBlock *BB = BasicBlock::Create(*TheContext, "entry", TheFunction);
        Builder->SetInsertPoint(BB);
        NamedValues.clear();

        for (auto &Arg : TheFunction->args()){
            NamedValues[std::string(Arg.getName())] = &Arg;
        }

        if (Value *RetVal = any_cast<Value *>(visit(context->expression()))){
            Builder->CreateRet(RetVal);
            verifyFunction(*TheFunction);
            return TheFunction;
        }
        TheFunction->eraseFromParent();

        return nullptr;
    }

    std::any visitParenExpression(TOYParser::ParenExpressionContext *context) override {
        std::cout << "visitParenExpression" << std::endl;
        return nullptr;
    }

    std::any visitTopLevelExpression(TOYParser::TopLevelExpressionContext *context) override {

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

    std::any visitTopLevelSemicolon(TOYParser::TopLevelSemicolonContext *context) override {
        std::cout << "visitTopLevelSemicolon" << std::endl;
        return nullptr;
    }

    std::any visitCallExprAST(TOYParser::CallExprASTContext *context) override {
        auto args = context->expression();
        for (auto arg : args) {
            visit(arg);
        }
        return nullptr;
    }

    std::any visitVariableExprAST(TOYParser::VariableExprASTContext *context) override {
        Value *V = NamedValues[context->ID()->getText()];

        if (!V){
            std::cerr << "Unknown variable name";
            return nullptr;
        }
        return V;
    }

    std::any visitParenExprAST(TOYParser::ParenExprASTContext *context) override {
        std::cout << "visitParenExprAST" << std::endl;
        return nullptr;
    }

    std::any visitNumberExprAST(TOYParser::NumberExprASTContext *context) override {
        std::string number = context->NUMBER()->getText();
        double num = std::stod(number);
        // std::cout << "visitNumberExprAST, num: " << num << std::endl;
        Value *val = ConstantFP::get(*TheContext, APFloat(num));
        if (nullptr == val) {
            std::cerr << "Failed to create constant";
            return nullptr;
        }
        return val;
    }

    std::any visitAddSubAST(TOYParser::AddSubASTContext *context) override {
        Value *L = any_cast<Value *>(visit(context->expression(0)));
        Value *R = any_cast<Value *>(visit(context->expression(1)));

        if (!L || !R){
            return nullptr;
        }

        if (context->PLUS() != nullptr){
            return Builder->CreateFAdd(L, R, "addtmp");
        } else if (context->MINUS() != nullptr){
            return Builder->CreateFSub(L, R, "subtmp");
        } else {
            std::cerr << "Invalid operator";
            return nullptr;
        }
    }

    std::any visitMulDivAST(TOYParser::MulDivASTContext *context) override {
        Value *L = any_cast<Value *>(visit(context->expression(0)));
        Value *R = any_cast<Value *>(visit(context->expression(1)));

        if (!L || !R){
            return nullptr;
        }

        if (context->ASTERISK() != nullptr){
            return Builder->CreateFMul(L, R, "multmp");
        } else if (context->SLASH() != nullptr){
            return Builder->CreateFDiv(L, R, "divtmp");
        } else {
            std::cerr << "Invalid operator";
            return nullptr;
        }
    }

    std::any visitProtoTypeAST(TOYParser::ProtoTypeASTContext *context) override {
        int arg_size = context->args()->ID().size();
        std::vector<Type *> Doubles(arg_size, Type::getDoubleTy(*TheContext));
        FunctionType *FT = FunctionType::get(Type::getDoubleTy(*TheContext), Doubles, false);
        Function *F = Function::Create(FT, Function::ExternalLinkage, context->ID()->getText(), TheModule.get());

        unsigned Idx = 0;
        for (auto &Arg : F->args()){
            Arg.setName(context->args()->ID(Idx)->getText());
            Idx++;
        }

        return F;
    }

    std::any visitArgs(TOYParser::ArgsContext *context) override {
        std::cout << "visitArgs" << std::endl;
        return nullptr;
    }
};
```

定义 `main` 函数
```cpp
int main(int, char**){
    BinopPrecedence['<'] = 10;
    BinopPrecedence['+'] = 20;
    BinopPrecedence['-'] = 20;
    BinopPrecedence['*'] = 40; // highest

    InitializeModule();

    const char *src_path = "/home/lixiang/coding/llvm/antlr-toy/test.txt";
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
    TOYLexer lexer(&input);
    antlr4::CommonTokenStream tokens(&lexer);
    TOYParser parser(&tokens);
    antlr4::tree::ParseTree *tree = parser.toplevel();

    IRTOYVisitor visitor;
    visitor.visit(tree);

    // print out generated IR
    TheModule->print(errs(), nullptr);

    return 0;
}
```

`text.txt` 中的内容为测试；