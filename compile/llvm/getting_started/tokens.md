# clang 获取 tokens

## 测试代码
`hello.c`
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

## cmake 文件
`CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(tokens VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})

link_directories(${LLVM_LIBRARY_DIRS})

add_executable(tokens main.cpp)

set_target_properties(tokens PROPERTIES
    COMPILE_FLAGS "-fno-rtti"
)

target_link_libraries(tokens
    clang
    clang-cpp
)
```

## clang 程序
`main.cpp`:
```c++
#include <stdio.h>

extern "C" {
    #include "clang-c/Index.h"
}

#include "llvm/Support/CommandLine.h"
#include <iostream>

using namespace llvm;

static cl::opt<std::string> input(cl::Positional, cl::desc("<input file>"), cl::Required);

int main(int argc, char** argv){
    cl::ParseCommandLineOptions(argc, argv, "clang-c-index-test\n");
    
    CXIndex index = clang_createIndex(0, 0);
    const char *args[] = {
        "-I/usr/include",
        "-I."
    };

    CXTranslationUnit tu = clang_parseTranslationUnit(
        index, input.c_str(), args, 2, NULL, 0, CXTranslationUnit_None
    );

    CXFile file = clang_getFile(tu, input.c_str());
    CXSourceLocation loc_start = clang_getLocationForOffset(tu, file, 0);
    CXSourceLocation loc_end = clang_getLocationForOffset(tu, file, 60);

    unsigned numTokens = 0;
    CXToken *tokens = NULL;
    clang_tokenize(tu, clang_getRange(loc_start, loc_end), &tokens, &numTokens);

    for (unsigned i = 0; i < numTokens; i++) {
        enum CXTokenKind kind = clang_getTokenKind(tokens[i]);
        CXString name = clang_getTokenSpelling(tu, tokens[i]);
        switch(kind) {
            case CXToken_Punctuation:
            std::cout << "PUNCTUATION: " << clang_getCString(name) << ")";
                break;
            case CXToken_Keyword:
                std::cout << "KEYWORD: " << clang_getCString(name) << ")";
                break;
            case CXToken_Identifier:
                std::cout << "IDENTIFIER: " << clang_getCString(name) << ")";
                break;
            case CXToken_Literal:
                std::cout << "COMMENT: " << clang_getCString(name) << ")";
                break;
            case CXToken_Comment:
                std::cout << "Comment: " << clang_getCString(name) << ")";
                break;
            default:
                std::cout << "UNKOWN: " << clang_getCString(name) << ")";
                break;
        }
        clang_disposeString(name);
    }
    std::cout << std::endl;
    clang_disposeIndex(index);
    clang_disposeTokens(tu, tokens, numTokens);
    clang_disposeTranslationUnit(tu);

    return 0;
}
```

## 运行
```bash
cmake -B build
cmake --build build

./build/tokens hello.c

# <<Output>>

PUNCTUATION: #)IDENTIFIER: include)PUNCTUATION: <)IDENTIFIER: stdio)PUNCTUATION: .)IDENTIFIER: h)PUNCTUATION: >)KEYWORD: int)IDENTIFIER: main)PUNCTUATION: ()PUNCTUATION: ))PUNCTUATION: {)IDENTIFIER: printf)PUNCTUATION: ()COMMENT: "Hello, World!\n")
```