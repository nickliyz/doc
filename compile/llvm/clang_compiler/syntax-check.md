# syntax-check 示例

参考资料：《Clang Compiler Frontend》 1.4节

准备源码 `mainbroken.cpp`
```c
extern void printf(const char *fmt, ...);

int main() {
    printf("Hello, World!\n");

    return 0
}
```

`CMakeLists.txt`配置:
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(syntax-check VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

if(APPLE)
set(LLVM_HOME "/opt/llvm-project/install/")
set(LLVM_DIR ${LLVM_HOME}/lib/cmake/llvm)
endif()

find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})
add_executable(syntax-check main.cpp)

set_target_properties(syntax-check PROPERTIES CXX_STANDARD 17)
set_target_properties(syntax-check PROPERTIES COMPILE_FLAGS "-fno-rtti")
target_link_libraries(syntax-check
    LLVMSupport
    clang
    clang-cpp
)
```

准备测试代码`main.cpp`
```c++
#include <stdio.h>
#include <clang/Frontend/FrontendActions.h>
#include <clang/Tooling/CommonOptionsParser.h>
#include <clang/Tooling/Tooling.h>
#include <llvm/Support/CommandLine.h>

namespace {
    llvm::cl::OptionCategory TestCategory("Test project");
    llvm::cl::extrahelp CommonHelp(clang::tooling::CommonOptionsParser::HelpMessage);
}

int main(int argc, const char** argv){
    llvm::Expected<clang::tooling::CommonOptionsParser> OptionsParser =
        clang::tooling::CommonOptionsParser::create(
            argc, argv, TestCategory);
    if (!OptionsParser) {
        llvm::errs() << OptionsParser.takeError();
        return 1;
    }

    clang::tooling::ClangTool Tool(OptionsParser->getCompilations(),
                                OptionsParser->getSourcePathList());

    return Tool.run(clang::tooling::newFrontendActionFactory<clang::SyntaxOnlyAction>().get());
}

```

编译执行：
```bash
cmake -B build
cmake --build build
```

运行程序：
```bash
./build/syntax-check mainbroken.cpp -- --std=c++17

# <<Output>>
/opt/coding/clang/syntax-check/mainbroken.cpp:6:13: error: expected ';' after return statement
    6 |     return 0
      |             ^
      |             ;
1 error generated.
Error while processing /opt/coding/clang/syntax-check/mainbroken.cpp.
```