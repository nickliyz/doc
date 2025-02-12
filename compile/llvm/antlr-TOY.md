# Kaleidoscope with antlr

参考资料：[Chapter 1: Toy Language and AST](https://mlir.llvm.org/docs/Tutorials/Toy/Ch-1/)

`TOY.g4`语法：
```antlr
grammar TOY;

module
    : function* EOF
    ;

function
    : DEF prototype block                                   # FunctionAST
    ;

block
    : LBRACE ((expression SEMICOLON) | SEMICOLON)* RBRACE   # BlockAST
    ;

expression
    : VAR ID (LEFTANGLE NUMBER (COMMA NUMBER)* RIGHTANGLE)? ASSIGN expression # VarExprAST
    | LBRACKET expression (COMMA expression)* RBRACKET      # ArrayExprAST
    | expression binop expression                           # BinaryExprAST
    | ID LPAREN (expression (COMMA expression)*)? RPAREN    # CallExprAST
    | ID                                                    # VariableExprAST
    | NUMBER                                                # NumberExprAST
    | RETURN (expression)?                                  # ReturnExprAST
    ;

prototype
    : ID LPAREN args RPAREN                                 # ProtoTypeAST
    ;

args
    : (ID)? (COMMA ID)*
    ;

binop
    : PLUS
    | MINUS
    | ASTERISK
    | SLASH
    ;

DEF: 'def';
EXTERN: 'extern';
IF: 'if';
THEN: 'then';
ELSE: 'else';
FOR: 'for';
IN: 'in';
UNARY: 'unary';
BINARY: 'binary';
VAR: 'var';
RETURN: 'return';

fragment DECDIGITS: [0-9];
fragment DIGITS: '0' | [1-9][0-9]*;
fragment EOL
    : ('\r' '\n')
    | ('\r' |'\n' | '\u2028' | '\u2029')
    | EOF
    ;

COMMENTS: '#' ~[\r\n]* EOL -> skip;
WS: [ \t\r\n]+ -> skip;


ID: [a-zA-Z][a-zA-Z0-9_]*;
NUMBER: DIGITS ('.' DECDIGITS+)?;

ASSIGN: '=';
SLASH: '/';
ASTERISK: '*';
PLUS: '+';
MINUS :'-';
LEFTANGLE: '<';
RIGHTANGLE: '>';
EXCLAMATION: '!';
VBAR: '|';
COLON: ':';
AMPERSAND: '&';

LBRACKET: '[';
RBRACKET: ']';

// '{' and '}' are reserved for block
LBRACE: '{';
RBRACE: '}';

LPAREN: '(';
RPAREN: ')';
COMMA: ',';
SEMICOLON: ';';
```

语法测试文件 `ast.toy`
```


# User defined generic function that operates on unknown shaped arguments.
def multiply_transpose(a, b) {
  return transpose(a) * transpose(b);
}

def main() {
  # Define a variable `a` with shape <2, 3>, initialized with the literal value.
  var a = [[1, 2, 3], [4, 5, 6]];
  var b<2, 3> = [1, 2, 3, 4, 5, 6];

  # This call will specialize `multiply_transpose` with <2, 3> for both
  # arguments and deduce a return type of <3, 2> in initialization of `c`.
  var c = multiply_transpose(a, b);

  # A second call to `multiply_transpose` with <2, 3> for both arguments will
  # reuse the previously specialized and inferred version and return <3, 2>.
  var d = multiply_transpose(b, a);

  # A new call with <3, 2> (instead of <2, 3>) for both dimensions will
  # trigger another specialization of `multiply_transpose`.
  var e = multiply_transpose(c, d);

  # Finally, calling into `multiply_transpose` with incompatible shapes
  # (<2, 3> and <3, 2>) will trigger a shape inference error.
  var f = multiply_transpose(a, c);
}
```

`antlr-debug`配置文件:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Debug ANTLR grammar",
            "type": "antlr-debug",
            "request": "launch",
            "input": "test.txt",
            "grammar": "TOY.g4",
            "startRule": "module",
            "printParseTree": true,
            "visualParseTree": true
        }
    ]
}
```

`ASTDump`实现：
```C++
#include <iostream>
#include <string>

#include <glog/logging.h>
#include <antlr4-runtime/antlr4-runtime.h>

#include "TOYLexer.h"
#include "TOYParser.h"
#include "TOYBaseVisitor.h"

class Dumper : public TOYBaseVisitor {
public:
    Dumper(const std::string &file_path) : file_path(file_path) {}

private:
    std::string file_path;
    int table_level = 0;
    void print_table(int level) {
        for (int i = 0; i < level; i++) {
            std::cout << "    ";
        }
    }

    std::any visitModule(TOYParser::ModuleContext *ctx) override {
        print_table(table_level);
        std::cout << "Module:" << std::endl;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        return ret;
    }

    std::any visitFunctionAST(TOYParser::FunctionASTContext *ctx) override {
        print_table(table_level);
        std::cout << "Function:" << std::endl;;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        return ret;
    }

    std::any visitProtoTypeAST(TOYParser::ProtoTypeASTContext *ctx) override {
        print_table(table_level);
        std::cout << "Proto: ";
        std::cout << "'" << ctx->ID()->getText() << "' ";
        std::cout << '@' << file_path << ':' << ctx->getStart()->getLine() << ':' << ctx->getStart()->getCharPositionInLine() + 1 << std::endl;
        print_table(table_level);
        std::cout << "Params: [";
        for (auto id : ctx->args()->ID()) {
            std::cout << id->getText();
            if (id != ctx->args()->ID(ctx->args()->ID().size() - 1)) {
                std::cout << ", ";
            }
        }
        std::cout << "]" << std::endl;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        return ret;
    }

    std::any visitBlockAST(TOYParser::BlockASTContext *ctx) override {
        print_table(table_level);
        std::cout << "Block: {" << std::endl;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        print_table(table_level);
        std::cout << "}" << std::endl;
        return ret;
    }

    std::any visitReturnExprAST(TOYParser::ReturnExprASTContext *ctx) override {
        print_table(table_level);
        std::cout << "Return " << std::endl;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        std::cout << std::endl;
        return ret;
    }

    std::any visitBinaryExprAST(TOYParser::BinaryExprASTContext *ctx) override {
        print_table(table_level);
        std::cout << "BinOp: " << ctx->binop()->getText() << " @" << ctx->getStart()->getLine() << ':' << ctx->getStart()->getCharPositionInLine() + 1 << std::endl;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        return ret;
    }

    std::any visitCallExprAST(TOYParser::CallExprASTContext *ctx) override {
        print_table(table_level);
        std::cout << "Call: " << ctx->ID()->getText() << " [ @" << file_path << ":" << ctx->getStart()->getLine() << ':' << ctx->getStart()->getCharPositionInLine() + 1 << std::endl;
        
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        print_table(table_level);
        std::cout << "]" << std::endl;
        return ret;
    }

    std::any visitVariableExprAST(TOYParser::VariableExprASTContext *ctx) override {
        print_table(table_level);
        std::cout << "var: " << ctx->ID()->getText() << " @" << file_path << ":" << ctx->getStart()->getLine() << ':' << ctx->getStart()->getCharPositionInLine() + 1 << std::endl;
        table_level++;
        std::any ret = visitChildren(ctx);
        table_level--;
        return ret;
    }

    std::any visitVarExprAST(TOYParser::VarExprASTContext *ctx) override {
        print_table(table_level);
        // clear dims
        std::vector<int> dims;
        std::cout << "VarDecl: " << ctx->ID()->getText();
        if (ctx->LEFTANGLE() != nullptr) {
            std::cout << "<";
            for (auto num : ctx->NUMBER()) {
                dims.push_back(std::stoi(num->getText()));
            }
            // print dims 1.000000e+00, 2.000000e+00, 3.000000e+00
            for (int i = 0; i < dims.size(); i++) {
                std::cout << dims[i];
                if (i != dims.size() - 1) {
                    std::cout << ", ";
                }
            }
            std::cout << "> " << " @" << file_path << ":" << ctx->getStart()->getLine() << ':' << ctx->getStart()->getCharPositionInLine() + 1 << std::endl;
        } else {
            std::cout << "<>" << " @" << file_path << ":" << ctx->getStart()->getLine() << ':' << ctx->getStart()->getCharPositionInLine() + 1 << std::endl;
        }

        table_level++;
        if (dynamic_cast<TOYParser::CallExprASTContext *>(ctx->expression()) == nullptr) {
            print_table(table_level);
        }
        std::any ret = visit(ctx->expression());
        std::cout << std::endl;
        table_level--;
        return ret;
    }

    std::any visitArrayExprAST(TOYParser::ArrayExprASTContext *ctx) override {
        std::vector<int> dims;
        dims.push_back(ctx->expression().size());

        TOYParser::ExpressionContext *first_expr = ctx->expression(0);
        TOYParser::ArrayExprASTContext *array_expr = dynamic_cast<TOYParser::ArrayExprASTContext *>(first_expr);
        if (array_expr != nullptr) {
            dims.push_back(array_expr->expression().size());
        }

        // print dims as <1, 2>
        std::cout << "<";
        for (int i = 0; i < dims.size(); i++) {
            std::cout << dims[i];
            if (i != dims.size() - 1) {
                std::cout << ", ";
            }
        }
        std::cout << "> [";

        for (auto expr : ctx->expression()) {
            visit(expr);
            if (expr != ctx->expression(ctx->expression().size() - 1)) {
                std::cout << ", ";
            }
        }
        std::cout << "]";
        return nullptr;
    }

    std::any visitNumberExprAST(TOYParser::NumberExprASTContext *ctx) override {
        double value = std::stod(ctx->NUMBER()->getText());
        // print double value as 1.000000e+00
        std::cout << std::scientific << value;

        return nullptr;
    }
};

int main(int argc, char** argv){
    google::InitGoogleLogging(argv[0]);

    // set log level to info
    FLAGS_logtostderr = 1;

    std::string src_path = "/home/lixiang/coding/llvm/antlr-toy/ast.toy";
    char *source = nullptr;
    FILE *fp = fopen(src_path.c_str(), "r");
    if (fp) {
        fseek(fp, 0, SEEK_END);
        long size = ftell(fp);
        fseek(fp, 0, SEEK_SET);
        source = (char *)malloc(size + 1);
        fread(source, 1, size, fp);
        source[size] = 0;
        fclose(fp);
    }
    antlr4::ANTLRInputStream input(source);
    TOYLexer lexer(&input);
    antlr4::CommonTokenStream tokens(&lexer);
    TOYParser parser(&tokens);
    antlr4::tree::ParseTree *tree = parser.module();

    Dumper dumper(src_path);
    dumper.visit(tree);
}
```