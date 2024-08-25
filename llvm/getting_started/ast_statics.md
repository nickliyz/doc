# AST 统计

## 测试代码
`test.c`:
```c
int main() {
    char *msg = "Hello, World!";
    write(1, msg, 14);

    return 0;
}
```

## cmake 配置
`CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(ast_statics VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})
add_executable(ast_statics main.cpp)

set_target_properties(ast_statics PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)
target_link_libraries(ast_statics
    clang-cpp
)
```

## clang 代码
`main.cpp`:
```c++
#include "llvm/ADT/IntrusiveRefCntPtr.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/TargetParser/Host.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTConsumer.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/DiagnosticOptions.h"
#include "clang/Basic/FileManager.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/TargetOptions.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/Frontend/ASTConsumers.h"
#include "clang/Frontend/CompilerInstance.h"
#include "clang/Frontend/TextDiagnosticPrinter.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "clang/Parse/Parser.h"
#include "clang/Parse/ParseAST.h"
#include "llvm/Support/MemoryBuffer.h"

#include <iostream>

using namespace llvm;
using namespace clang;

static cl::opt<std::string> inputFilename(cl::Positional, cl::desc("<input file>"), cl::Required);

int main(int argc, char** argv){
    cl::ParseCommandLineOptions(argc, argv, "My simple front end\n");
    CompilerInstance CI;
    DiagnosticOptions diagnosticOptions;
    CI.createDiagnostics();

    std::shared_ptr<clang::TargetOptions> PTO = std::make_shared<clang::TargetOptions>();
    PTO->Triple = llvm::sys::getDefaultTargetTriple();

    TargetInfo* PTI = TargetInfo::CreateTargetInfo(CI.getDiagnostics(), PTO);
    CI.setTarget(PTI);
    CI.createFileManager();
    CI.createSourceManager(CI.getFileManager());
    CI.createPreprocessor(clang::TU_Complete);
    CI.getPreprocessorOpts().UsePredefines = false;
    std::unique_ptr<ASTConsumer> astConsumer = CreateASTPrinter(NULL, "");
    CI.setASTConsumer(std::move(astConsumer));

    CI.createASTContext();
    CI.createSema(clang::TU_Complete, NULL);

    Expected<FileEntryRef> fRef = CI.getFileManager().getFileRef(inputFilename);
    if (!fRef){
        std::cerr << "File not found: " << inputFilename << std::endl;
        return 1;
    } else {
        std::cerr << "File found: " << inputFilename << std::endl;
    }
    FileEntryRef ref = *fRef;

    auto &SM = CI.getSourceManager();
    FileID ID = SM.getOrCreateFileID(ref, SrcMgr::CharacteristicKind::C_User);
    const SourceLocation Start = SM.getLocForStartOfFile(ID);
    CI.getSourceManager().createFileID(ref, 
        Start, clang::SrcMgr::CharacteristicKind::C_User);

    CI.getDiagnosticClient().BeginSourceFile(CI.getLangOpts(), &CI.getPreprocessor());
    ParseAST(CI.getSema());
    CI.getASTContext().PrintStats();
    CI.getASTContext().Idents.PrintStats();

    return 0;
}
```

## 运行
```bash
cmake -B build
cmake --build build

./build/ast_statics test.c

# <<Output>>
File found: test.c
fatal error: error opening file '<invalid loc>': 

*** AST Context Stats:
  67 types total.
    1 ConstantArray types, 64 each (64 bytes)
    60 Builtin types, 32 each (1920 bytes)
    4 Pointer types, 48 each (192 bytes)
    2 Record types, 32 each (64 bytes)
Total bytes = 2240
0/0 implicit default constructors created
0/0 implicit copy constructors created
0/0 implicit copy assignment operators created
0/0 implicit destructors created

Number of memory regions: 1
Bytes used: 3968
Bytes allocated: 4096
Bytes wasted: 128 (includes alignment, etc)

*** Identifier Table Stats:
# Identifiers:   558
# Empty Buckets: 15826
Hash density (#identifiers per bucket): 0.034058
Ave identifier length: 14.973118
Max identifier length: 37

Number of memory regions: 9
Bytes used: 31233
Bytes allocated: 36864
Bytes wasted: 5631 (includes alignment, etc)File found: test.c
fatal error: error opening file '<invalid loc>': 

*** AST Context Stats:
  67 types total.
    1 ConstantArray types, 64 each (64 bytes)
    60 Builtin types, 32 each (1920 bytes)
    4 Pointer types, 48 each (192 bytes)
    2 Record types, 32 each (64 bytes)
Total bytes = 2240
0/0 implicit default constructors created
0/0 implicit copy constructors created
0/0 implicit copy assignment operators created
0/0 implicit destructors created

Number of memory regions: 1
Bytes used: 3968
Bytes allocated: 4096
Bytes wasted: 128 (includes alignment, etc)

*** Identifier Table Stats:
# Identifiers:   558
# Empty Buckets: 15826
Hash density (#identifiers per bucket): 0.034058
Ave identifier length: 14.973118
Max identifier length: 37

Number of memory regions: 9
Bytes used: 31233
Bytes allocated: 36864
Bytes wasted: 5631 (includes alignment, etc)
```