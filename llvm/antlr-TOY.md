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
    : LBRACE ((expression SEMICOLON) | SEMICOLON)* RBRACE                             # BlockAST
    ;

expression
    : VAR ID (LEFTANGLE NUMBER (COMMA NUMBER)* RIGHTANGLE)? ASSIGN expression # VarExprAST
    | LBRACKET expression (COMMA expression)* RBRACKET      # ArrayExprAST
    | expression binop expression                           # BinaryExprAST
    | ID LPAREN (expression (COMMA expression)*)? RPAREN    # CallExprAST
    | ID                                                    # VariableExprAST
    | NUMBER                                                # NumberExprAST
    | RETURN (expression)? SEMICOLON                        # ReturnExprAST
    ;

prototype
    : ID LPAREN args RPAREN                                 # ProtoTypeAST
    ;

args
    : (ID)*
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


ID: [a-zA-Z][a-zA-Z0-9]*;
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

语法测试文件 `test.txt`
```
def main() {
  # Define a variable `a` with shape <2, 3>, initialized with the literal value.
  # The shape is inferred from the supplied literal.
  var a = [[1, 2, 3], [4, 5, 6]];

  # b is identical to a, the literal tensor is implicitly reshaped: defining new
  # variables is the way to reshape tensors (element count must match).
  var b<2, 3> = [1, 2, 3, 4, 5, 6];

  # transpose() and print() are the only builtin, the following will transpose
  # a and b and perform an element-wise multiplication before printing the result.
  print(transpose(a) * transpose(b));
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