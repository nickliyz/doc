# pybind11

## 参考资料
* [pybind11 — Seamless operability between C++11 and Python](https://pybind11.readthedocs.io/en/stable/index.html)
* [First steps](https://pybind11.readthedocs.io/en/stable/basics.html)

`CMakeLists.txt`:
```cmake
cmake_minimum_required(VERSION 3.4...3.18)

project(pybind1 VERSION 0.1.0 LANGUAGES C CXX)

find_package(pybind11 REQUIRED)

pybind11_add_module(pybind1 pybind1.cpp)
```

## 示例代码：
```c
#include <stdio.h>
#include <Python.h>
#include <pybind11/pybind11.h>

#define STRINGFY(x) #x
#define MACRO_STRINGFY(x) STRINGFY(x)

int add(int i, int j) {
    return i + j;
}

namespace py = pybind11;

PYBIND11_MODULE(pybind1, m) {
    m.doc() = "pybind11 example plugin"; // optional module docstring

    m.def("add", &add, "A function which adds two numbers");

    m.def("subtract", [](int i, int j) { 
        return i - j; 
        }, "A function which subtracts two numbers"
    );

    m.attr("__version__") = MACRO_STRINGFY(dev);
}
```