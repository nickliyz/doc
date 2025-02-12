# clang tool

## 参考资料
* [How to write RecursiveASTVisitor based ASTFrontendActions.](https://clang.llvm.org/docs/RAVFrontendAction.html)

## `CMakeLists.txt`配置
```cmake
cmake_minimum_required(VERSION 3.15.0)
project(clang-parse1 VERSION 0.1.0 LANGUAGES C CXX)

include_directories(/usr/lib/llvm-10/include)
set(CMAKE_CXX_STANDARD 14)

add_executable(clang-parse1 main.cpp)

find_package(Clang REQUIRED)

target_link_libraries(clang-parse1 clang-10)

link_directories(/usr/lib/llvm-10/lib)

add_definitions(
    "-D__STDC_CONSTANT_MACROS"
    "-D__STDC_LIMIT_MACROS"
    "-DCMAKE_EXPORT_COMPILE_COMMANDS"
)

add_executable(tool tool.cpp)
target_link_libraries(tool clang-cpp LLVM-10)
```

## 代码

`template <typename T> class IntrusiveRefCntPtr`是一个智能指针, 带有引用计数.

`clang::FileManager` 是一个文件系统管理类, 提供一些文件系统相关的功能.

`clang::FileSystemOptions()` 是文件管理器的配置类, 内部的 `WorkingDir`是工作路径.

创建一个文件管理器对象:
`llvm::IntrusiveRefCntPtr<clang::FileManager> fm(new clang::FileManager(clang::FileSystemOptions()));`


```C++
bool runToolOnCode(std::unique_ptr<FrontendAction> ToolAction, const Twine &Code,
                   const Twine &FileName = "input.cc",
                   std::shared_ptr<PCHContainerOperations> PCHContainerOps =
                       std::make_shared<PCHContainerOperations>());
```
是一个在源码上运行`FrontendAction`的函数, 例如: `clang::tooling::runToolOnCode(std::make_unique<IndexerAction>(), file_source)`, 其中 `file_source` 是C++源码, 而`IndexerAction`是要运行的`FrontendAction`.

`ASTFrontendAction`是`FrontendAction`接口的抽象类, 其重载了 `ExecuteAction`方法, 改抽象类可以被实现成用户自定义的`FrontendAction`. `FrontendAction`中的方法:
```C++
virtual std::unique_ptr<ASTConsumer> CreateASTConsumer(
        CompilerInstance &CI,
        StringRef InFile) = 0;
```

重写该方法, 用于返回一个 `ASTConsumer` 对象, 以进一步处理AST, 例如:
```C++
class IndexerAction : public clang::ASTFrontendAction {
    virtual std::unique_ptr<clang::ASTConsumer> CreateASTConsumer(
        clang::CompilerInstance &CI, llvm::StringRef InFile) {
        std::cout << "CreateASTConsumer" << std::endl;
        return std::make_unique<IndexerASTConsumer>();
    }
};
```

`ASTConsumer`是一个接口, 提供给底层回调, 该接口提供了丰富的功能, 这里我们只关注:`virtual void HandleTranslationUnit(ASTContext &Ctx) {}`, 改方法处理已经解析的 `ASTContext`上下文.

`ASTContext`可通过`TranslationUnitDecl *getTranslationUnitDecl() const { return TUDecl; }`
接口返回可供`RecursiveASTVisitor`编译的`TranslationUnitDecl`对象.

`clang::RecursiveASTVisitor`通过
```
template <typename Derived>
bool RecursiveASTVisitor<Derived>::TraverseDecl(Decl *D);
```
方法遍历 `TranslationUnitDecl`对象, `clang::RecursiveASTVisitor`是模板类, 模板的类型是其子类实现, 例如:
```
class ASTIndexer : public clang::RecursiveASTVisitor<ASTIndexer> {
public:
    virtual bool VisitFunctionDecl(clang::FunctionDecl *FD) {
        // print function name
        std::cout << "VisitFunctionDecl" << std::endl;
        llvm::outs() << FD->getNameInfo().getAsString() << "\n";
        return true;
    }
};
```
`clang::RecursiveASTVisitor`提供了很多遍历方法, 对于函数, 重载了 `virtual bool VisitFunctionDecl(clang::FunctionDecl *FD)`方法.