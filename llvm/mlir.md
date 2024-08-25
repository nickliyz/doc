# mlir 

参考资料
* [MLIR - Getting Started](https://mlir.llvm.org/getting_started/)

## build
```bash
mkdir ~/github/; cd ~/github/
git clone -b release/18.x --depth=1 https://github.com/llvm/llvm-project.git
mkdir llvm-project/build
cd llvm-project/build
cmake -G Ninja ../llvm \
   -DLLVM_ENABLE_PROJECTS="mlir;" \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
   -DCMAKE_BUILD_TYPE=Release \
   -DLLVM_ENABLE_ASSERTIONS=ON ..
# Using clang and lld speeds up the build, we recommend adding:
#  -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ -DLLVM_ENABLE_LLD=ON
# CCache can drastically speed up further rebuilds, try adding:
#  -DLLVM_CCACHE_BUILD=ON
# Optionally, using ASAN/UBSAN can find bugs early in development, enable with:
# -DLLVM_USE_SANITIZER="Address;Undefined"
# Optionally, enabling integration tests as well
# -DMLIR_INCLUDE_INTEGRATION_TESTS=ON
cmake --build . --target check-mlir
```

## USE
```bash
cd ~/github/llvm-project/mlir/examples/toy/Ch2/include/toy
mlir-tblgen -I /home/lixiang/github/llvm-project/mlir/include -gen-op-decls Ops.td -o Ops.h.inc
mlir-tblgen -I /home/lixiang/github/llvm-project/mlir/include -gen-op-defs Ops.td -o Ops.cpp.inc
mlir-tblgen -I /home/lixiang/github/llvm-project/mlir/include -gen-dialect-decls Ops.td -o Dialect.h.inc
mlir-tblgen -I /home/lixiang/github/llvm-project/mlir/include -gen-dialect-defs Ops.td -o Dialect.cpp.inc
```