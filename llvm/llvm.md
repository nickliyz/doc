# LLVM

## 获取代码并编译（18.x）
参考资料：https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm
```bash
git clone -b release/18.x --depth=1 https://github.com/llvm/llvm-project.git

cd llvm-project
cmake -S llvm -B build -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;mlir;" \
    -DDLLVM_BUILD_EXAMPLES=ON \
    -DLLVM_ENABLE_RUNTIMES="libc;libcxx;libcxxabi;libunwind" \
    -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_ENABLE_ASSERTIONS=ON
cmake --build build
```

使用如下命令获取 llvm 的链接信息
```bash
llvm-config --cxxflags --ldflags --system-libs --libs core orcjit native
```