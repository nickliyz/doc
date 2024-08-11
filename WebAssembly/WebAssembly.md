# 参考资料
* WebAssembly 官网：https://webassembly.org/
* 安装emcc：https://emscripten.org/docs/getting_started/downloads.html
* 如何访问文件：https://emscripten.org/docs/getting_started/Tutorial.html#using-files
* 如何使用SDL：https://emscripten.org/docs/getting_started/Tutorial.html#generating-html

# 通过conan使用emcc
## 添加 conan profile
```text
[settings]
os=Emscripten
arch=wasm
compiler=clang
compiler.version=14
compiler.cppstd=11
compiler.libcxx=libc++
build_type=Release

[build_requires]
*: emsdk/3.1.50
```

## conan install 配置
```bash
conan install -if build -r conancenter --build=missing -pr:b=x64 -pr:h=emcc .
```

## cmake 命令
```bash
cmake -DCONAN_DISABLE_CHECK_COMPILER=ON -DCMAKE_TOOLCHAIN_FILE=/home/lixiang/.conan/data/emsdk/3.1.50/_/_/package/2880313eadc30db92089af7733fe8364772ee5c8/bin/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake -B build/
```

## CMake 如何传递参数给emcc
```cmake
set_target_properties(${PROJECT_NAME} PROPERTIES
    LINK_FLAGS "-s WASM=1 -s EXPORTED_RUNTIME_METHODS=wasmMemory -s SIDE_MODULE=1 --preload-file ${CMAKE_CURRENT_LIST_DIR}/test/hello_world_file.txt@test/hello_world_file.txt"
)
```

## cmake 修改 WebAssembly 编译产物格式
```cmake
# set(CMAKE_EXECUTABLE_SUFFIX ".html")
# set(CMAKE_EXECUTABLE_SUFFIX ".js")
set(CMAKE_EXECUTABLE_SUFFIX ".wasm")
```

# 不适用conan只使用emcc
```bash
cd ~

# Get the emsdk repo
git clone https://github.com/emscripten-core/emsdk.git

# Enter that directory
cd emsdk

# Fetch the latest version of the emsdk (not needed the first time you clone)
git pull

# Download and install the latest SDK tools.
./emsdk install latest

# Make the "latest" SDK "active" for the current user. (writes .emscripten file)
./emsdk activate latest

# Activate PATH and other environment variables in the current terminal
source ./emsdk_env.sh
```

如此可以使用 emcc 了