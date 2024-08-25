# clang获取诊断信息

测试代码`hello.c`:
```c
int main() {
    printf("Hello, world!\n")
}
```

cmake 配置文件 `CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(serverity VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_executable(serverity main.cpp)

set_target_properties(serverity PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)

target_link_libraries(serverity
    clang
    clang-cpp
)
```

示例代码：`main.cpp`
```c++
#include <stdio.h>

extern "C" {
    #include "clang-c/Index.h"
}
#include "llvm/Support/CommandLine.h"
#include <iostream>

using namespace llvm;

static cl::opt<std::string> FileName(
    cl::Positional, cl::desc("<input file>"), cl::Required);

int main(int argc, char**argv){
    cl::ParseCommandLineOptions(argc, argv, "clang-interpreter\n");
    CXIndex index = clang_createIndex(0, 0);

    const char *args[] = {
        "-I/usr/include",
        "-I."
    };

    CXTranslationUnit translationUnit = clang_parseTranslationUnit(
        index, FileName.c_str(), args, 2, NULL, 0, CXTranslationUnit_None);

    unsigned diagnosticCount = clang_getNumDiagnostics(translationUnit);
    for (unsigned i = 0; i < diagnosticCount; i++) {
        CXDiagnostic diagnostic = clang_getDiagnostic(translationUnit, i);
        CXString category = clang_getDiagnosticCategoryText(diagnostic);
        CXString message = clang_getDiagnosticSpelling(diagnostic);
        unsigned serverity = clang_getDiagnosticSeverity(diagnostic);
        CXSourceLocation location = clang_getDiagnosticLocation(diagnostic);
        CXString FName;
        unsigned line, column;
        clang_getPresumedLocation(location, &FName, &line, &column);

        std::cout << "Serverity: " << serverity << " File: "
            << clang_getCString(FName) << " Line: " << line
            << " Col: " << column << " Category: "
            << clang_getCString(category) << " Message: "
            << clang_getCString(message) << std::endl;
        clang_disposeString(FName);
        clang_disposeString(category);
        clang_disposeString(message);
        clang_disposeDiagnostic(diagnostic);
    }

    clang_disposeTranslationUnit(translationUnit);
    clang_disposeIndex(index);

    return 0;
}
```

编译与输出：
```bash
cmake -B build
cmake --build build
./build/serverity hello.c
```