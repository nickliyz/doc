# LLVM

## 获取代码并编译（18.x）
参考资料：https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm
```bash
git clone -b release/18.x --depth=1 https://github.com/llvm/llvm-project.git

cd llvm-project
cmake -S llvm -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DLLVM_ENABLE_PROJECTS="clang;mlir;lldb" \
    -DLLVM_ENABLE_RUNTIMES="libc;libcxx;libcxxabi;libunwind" \
    -DLLVM_TARGETS_TO_BUILD="Native;ARM;Mips" \
    -DLLVM_PARALLEL_LINK_JOBS=1 \
    -DLLVM_PARALLEL_COMPILE_JOBS=16 \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLDB_TEST_COMPILER=/usr/local/bin/clang
cmake --build build
cmake --install build
```

## only build lldb
```
cmake -S llvm -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_PROJECTS="clang;lldb" \
    -DLLVM_ENABLE_RUNTIMES="libc;libcxx;libcxxabi;libunwind" \
    -DLLVM_TARGETS_TO_BUILD="Native" \
    -DLLVM_PARALLEL_LINK_JOBS=2 \
    -DLLVM_PARALLEL_COMPILE_JOBS=24 \
    -DLLVM_PARALLEL_TABLEGEN_JOBS=8 \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DLLDB_TEST_COMPILER=/usr/local/bin/clang
```

## for macOS
```bash
git clone -b release/18.x --depth=1 https://github.com/llvm/llvm-project.git

cd llvm-project
cmake -S llvm -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;mlir;" \
    -DDLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_ENABLE_RUNTIMES="libc;libcxx;libcxxabi;libunwind" \
    -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
    -DLLVM_ENABLE_ASSERTIONS=ON \
    -DCMAKE_INSTALL_PREFIX=install/
cmake --build build
cmake --install build
```

`CMakeLists.txt` in macOS:
```cmake
if(APPLE)
set(LLVM_HOME "/opt/llvm-project/install/")
set(LLVM_DIR ${LLVM_HOME}/lib/cmake/llvm)
endif()
```

## llvm-config
使用如下命令获取 llvm 的链接信息
```bash
llvm-config --cxxflags --ldflags --system-libs --libs core orcjit native
```
