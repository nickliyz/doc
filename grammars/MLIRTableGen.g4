grammar MLIRTableGen;

toplevel: (statement | include_directive | preprocessor_directive )* ;

statement : assert
    | class
    | def
    ;

assert : KwAssert value ',' value ';' ;
class : KwClass class_id (template_arg_list)? record_body ;
template_arg_list : '<' template_arg_decl (',' template_arg_decl)* '>' ;
template_arg_decl : type TokIdentifier ('=' value)? ;

record_body : parent_class_list body;
parent_class_list : (':' parent_class_list_NE)? ;
parent_class_list_NE : class_ref (',' class_ref)* ;
class_ref : (class_id | multi_class_id) ('<' arg_value_list '>')? ;
multi_class_id : TokIdentifier ;

body : ';'
    | '{' body_item* '}' ;

body_item : type TokIdentifier ('=' value)? ';'
    | KwLet TokIdentifier ('{' range_list '}')? '=' value ';'
    | KwDefVar TokIdentifier '=' value ';'
    | assert
    ;

preprocessor_directive : PreDefine TokIdentifier value?
    | (PreIfdef | PreIfndef) TokIdentifier
    | PreElse statement PreEndif
    | PreEndif
    ;

def : KwDef (named_value)? record_body ;

arg_value_list : postinal_arg_value_list ','? named_arg_value_list ;
postinal_arg_value_list : (value (',' value)*)? ;
named_arg_value_list : (named_value '=' value (',' named_value '=' value)*)? ;
named_value : value; 

include_directive : KwInclude TokString ;

value : simple_value value_suffix*
    | value '#' value? ;

value_suffix : '{' range_list '}'
    | '[' slice_elements ']' 
    | '.' TokIdentifier
    ;

range_list : range_piece (',' range_piece)* ;
range_piece : TokInteger
    | TokInteger '...' TokInteger
    | TokInteger '-' TokInteger
    | TokInteger TokInteger
    ;

slice_elements : (slice_element ',' )* slice_element (',')? ;
slice_element : value
    | value '...' value
    | value '-' value
    | value TokInteger
    ;

simple_value : 
    class_ref_value
    | bangop_value
    | bool_value
    | unkown_value
    | dict_value
    | list_value
    | dag_value
    | token_value
    | simple_value1
    ;
simple_value1 : TokInteger | TokString+ | tok_code ;
bool_value : KwTrue | KwFalse ;
unkown_value : '?';
dict_value : '{' value_list? '}' ;
value_list : value_list_NE;
value_list_NE : value (',' value)* ','? ;

list_value : '[' value_list? ']' ('<' type '>')?;
type: KwBit | KwInt | KwString | KwDag | KwCode
    | KwBits '<' TokInteger '>' 
    | KwList '<' type '>' 
    | class_id ;

dag_value : '(' dag_arg (dag_arg_list)? ')' ;
dag_arg_list : dag_arg (',' dag_arg)* ;
dag_arg : value (':' TokVarName)? | TokVarName ;

token_value : TokIdentifier;
class_ref_value : class_id '<' arg_value_list '>' ;

bangop_value : BangOp ('<' type '>')? '(' value_list_NE ')'
    | cond_operator '(' cond_clause (',' cond_clause)? ')';

cond_operator : '!cond' ;
cond_clause : value ':' value? ;

class_id : TokIdentifier ;

keywords : 
    KwAssert | KwBit | KwBits | KwClass | KwCode | KwDag | KwDef | KwDump | KwElse | KwFalse |
    KwForEach | KwDefm | KwDefSet | KwDefVar | KwFeld | KwIf | KwIn | KwInclude |
    KwInt | KwLet | KwList | KwMultiClass | KwString | KwThen | KwTrue ;
tok_code   :  TokCodeLeft ~(TokCodeRight)* TokCodeRight ;

BlockComments : '/*' .*? '*/' -> skip ;
Comment: '//' ~[\r\n]* -> skip;

PreDefine : '#define' ;
PreIfdef : '#ifdef' ;
PreIfndef : '#ifndef' ;
PreEndif : '#endif' ;
PreElse : '#else' ;

KwAssert : 'assert';
KwBit : 'bit' ;
KwBits : 'bits' ;
KwClass : 'class' ;
KwCode : 'code' ;
KwDag : 'dag' ;
KwDef : 'def' ;
KwDump : 'dump' ;
KwElse : 'else' ;
KwFalse : 'false' ;
KwForEach : 'foreach' ;
KwDefm : 'defm' ;
KwDefSet : 'defset' ;
KwDefVar : 'defvar' ;
KwFeld : 'field' ;
KwIf : 'if' ;
KwIn : 'in' ;
KwInclude : 'include' ;
KwInt : 'int' ;
KwLet : 'let' ;
KwList : 'list' ;
KwMultiClass : 'multiclass' ;
KwString : 'string' ;
KwThen : 'then' ;
KwTrue : 'true' ;

BangOp : 
    '!add' | '!and' | '!cast' | '!con' | '!dag' 
    | '!div' | '!empty' | '!eq' | '!exists' | '!filter' 
    | '!find' | '!foldl' | '!foreach' | '!ge' | '!getdagarg' 
    | '!getdagname' | '!getdagop' | '!gt' | '!head' | '!if' 
    | '!initialized' | '!instances' | '!interleave' | '!isa' | '!le' 
    | '!listconcat' | '!listflatten' | '!listremove' | '!listsplat' 
    | '!logtwo' | '!lt' | '!match' | '!mul' | '!ne' | '!not' 
    | '!or' | '!range' | '!repr' | '!setdagarg' | '!setdagname' 
    | '!setdagop' | '!shl' | '!size' | '!sra' | '!srl' 
    | '!strconcat' | '!sub' | '!subst' | '!substr' | '!tail' 
    | '!tolower' | '!toupper' | '!xor' ;

TokIdentifier : Digit* Ualpha (Ualpha | '0' .. '9')* ;
Ualpha : 'a'.. 'z' | 'A'..'Z' | '_' ;
TokVarName : '$' Ualpha (Ualpha | '0' .. '9')* ;

TokString: '"' ~'"'* '"';
TokCodeLeft : '[{' ;
TokCodeRight : '}]' ;

TokInteger     :  DecimalInteger | HexInteger | BinInteger ;
Digit : '0'..'9' ;
DecimalInteger :  [+|-]? Digit+ ;
HexInteger     :  '0x' (Digit | 'a'..'f' | 'A'..'F')+ ;
BinInteger     :  '0b' ('0' | '1')+ ;