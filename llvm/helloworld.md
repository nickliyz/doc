# LLVM helloword

参考资料：《LLVM编译器实战教程》 3.6节

## 测试文件
`test.c`
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

编译：
```bash
clang -c -emit-llvm test.c -o test.bc
```

## CMake配置
`CMakeLists.txt`
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(helloworld VERSION 0.1.0 LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)

find_package(LLVM REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})

link_directories(${LLVM_LIBRARY_DIRS})

add_executable(helloworld main.cpp)

set_target_properties(helloworld PROPERTIES
    COMPILE_FLAGS "-fno-rtti")

# get config from `llvm-config --libs bitreader core support`
target_link_libraries(helloworld 
    LLVMBitReader 
    LLVMCore 
    LLVMRemarks
    LLVMBinaryFormat
    LLVMTargetParser
    LLVMBitstreamReader
    LLVMSupport
    LLVMDemangle
    LLVMOption
)
```

## helloworld 代码
```c++
#include <iostream>
#include "llvm/Bitcode/BitcodeReader.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_os_ostream.h"

using namespace llvm;

static cl::opt<std::string> FileName(
    cl::Positional, cl::desc("<filename>.bc"), cl::Required);

int main(int argc, char** argv){
    cl::ParseCommandLineOptions(argc, argv, "LLVM hello world\n");

    LLVMContext context;
    std::string error;
    ErrorOr<std::unique_ptr<MemoryBuffer>> mbr = 
        MemoryBuffer::getFile(FileName);

    if (!mbr) {
        errs() << "Error reading bitcode file: " << error << "\n";
        return 1;
    }

    std::unique_ptr<MemoryBuffer> mb = std::move(*mbr);

    Expected<std::unique_ptr<Module>> mr = parseBitcodeFile(*mb, context);
    if (!mr) {
        errs() << "Error reading bitcode file: " << error << "\n";
        return 1;
    }

    std::unique_ptr<Module> m = std::move(mr.get());
    if (!m) {
        errs() << "Error reading bitcode file: " << error << "\n";
        return 1;
    }

    raw_os_ostream os(std::cout);
    for (auto i = m->getFunctionList().begin(); i != m->getFunctionList().end(); i++) {
        Function &f = *i;
        os << f.getName() << "\n";
    }
}
```