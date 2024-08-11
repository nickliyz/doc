# LLVM

## 获取代码并编译（18.x）
参考资料：https://llvm.org/docs/GettingStarted.html#getting-the-source-code-and-building-llvm
```bash
git clone -b release/18.x --depth=1 https://github.com/llvm/llvm-project.git

cd llvm-project
cmake -S llvm -B build -G Ninja -DLLVM_ENABLE_PROJECTS="clang;lld" -DCMAKE_INSTALL_PREFIX=llvm-install -DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_ASSERTIONS=ON -DLLVM_PARALLEL_COMPILE_JOBS=8
cmake --build build
```