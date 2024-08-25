# clang visit childs

## 测试用源码
`hello.c`:
```c
#include <stdio.h>

int main(){
    printf("Hello, world!\n");
    return 0;
}
```

## cmake 配置文件
`CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(visit VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

add_executable(visit main.cpp)

set_target_properties(visit PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)

target_link_libraries(visit
    clang
    clang-cpp
)
```

## clang 程序
`main.cpp`:
```c++
#include <stdio.h>
#include <iostream>
extern "C" {
    #include "clang-c/Index.h"
}
#include "llvm/Support/CommandLine.h"

using namespace llvm;

static cl::opt<std::string> FileName(cl::Positional, cl::desc("Input file"), cl::Required);

enum CXChildVisitResult visit(CXCursor cursor, CXCursor parent, CXClientData client_data){
    if (clang_getCursorKind(cursor) == CXCursor_CXXMethod ||
        clang_getCursorKind(cursor) == CXCursor_FunctionDecl){
            CXString name = clang_getCursorSpelling(cursor);
            CXSourceLocation loc = clang_getCursorLocation(cursor);
            CXString fName;
            unsigned line = 0, col = 0;
            clang_getPresumedLocation(loc, &fName, &line, &col);

            std::cout << clang_getCString(fName) << ":"
                        << line << ":" << col << " declares "
                        << clang_getCString(name) << std::endl;
            return CXChildVisit_Continue;
        }
    return CXChildVisit_Recurse;
}

int main(int argc, char** argv){
    cl::ParseCommandLineOptions(argc, argv, "c1");
    CXIndex index = clang_createIndex(0, 0);

    const char *args[] = {"-I/usr/include", "-I."};
    CXTranslationUnit tu = clang_parseTranslationUnit(index, FileName.c_str(), args, 2, NULL, 0, CXTranslationUnit_None);

    CXCursor cursor = clang_getTranslationUnitCursor(tu);
    clang_visitChildren(cursor, visit, NULL);

    clang_disposeTranslationUnit(tu);
    clang_disposeIndex(index);

    return 0;
}
```

## 运行程序
```bash
cmake -B build
cmake --build build
./build/visit hello.c

# <<Ouput>>
...
hello.c:3:5 declares main
```