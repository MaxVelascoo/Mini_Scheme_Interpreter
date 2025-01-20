grammar scheme;

root: (function_definition | constant_definition | expression)* EOF;

expression
    : value                                       // Valor literal o una expressió
    | if_expression                               // Expressió condicional "if"
    | cond_expression                             // Expressió condicional "cond"
    | logic_expression                            // Operadors lògics
    | arithmetic_expression                       // Operadors aritmètics
    | display_expression                          // Mostra un valor a la pantalla
    | function_call                               // Crida a funcions
    | let_expression                              // Expressió "let"
    | read_expression                             // Llegeix un valor de la entrada
    | newline_expression                          // Genera una nova línia
    | ID                                          // Identificador
    ;

function_definition: LEFT 'define' LEFT ID ID* RIGHT expression+ RIGHT;

constant_definition: LEFT 'define' ID expression RIGHT;

read_expression: LEFT 'read' RIGHT;

newline_expression: LEFT 'newline' RIGHT;

function_call
    : LEFT ID expression* RIGHT                                         // Crida a funcions
    | list_operations;                                                  // Operacions amb llistes

list_operations
    : LEFT 'car' expression RIGHT                                       // car retorna el primer element de una llista
    | LEFT 'cdr' expression RIGHT                                       // cdr retorna la resta de la llista
    | LEFT 'cons' expression expression RIGHT                           // cons afegeix un element a una llista
    | LEFT 'null?' expression RIGHT;                                    // null? verifica si la llista està buida

if_expression : LEFT 'if' expression expression expression RIGHT;

cond_expression: LEFT 'cond' cond_clause+ RIGHT;

logic_expression
    : LEFT logicOp expression expression RIGHT                          // Operadors de comparació: >, <, =, <=, >=
    | LEFT booleanLogicOp expression+ RIGHT;                            // Operadors lògics booleans: and, or, not

arithmetic_expression: LEFT aritmeticOp expression expression RIGHT;    // Operadors aritmètics: +, -, *, /, mod

aritmeticOp: '+' | '-' | '*' | '/' | 'mod';                             // Operadors aritmètics

logicOp: '>' | '<' | '=' | '<=' | '>=' | '<>';                                // Operadors de comparació

booleanLogicOp: 'and' | 'or' | 'not';                                   // Operadors lògics booleans

cond_clause
    : LEFT expression expression+ RIGHT                                 // Clausula condicional
    | LEFT 'else' expression+ RIGHT;                                    // Clausula "else"
    
display_expression: LEFT 'display' expression RIGHT;
    
list_literal
    : '\'' LEFT (value)* RIGHT                                          // Llista literal no buida
    | '\'' LEFT RIGHT;                                                  // Llista literal buida

let_expression: LEFT 'let' let_bindings expression* RIGHT;

let_bindings: LEFT let_binding* RIGHT;                                  // Associació de bindings

let_binding: LEFT ID expression RIGHT;                                  // Assignació d'un binding

value: BOOLEAN | STRING | NUMBER | list_literal;                        // Valors literals (booleans, strings, números o llistes literals

//TOKENS
LEFT: '(';                                                              // Parèntesi esquerre
RIGHT: ')';                                                             // Parèntesi dret
STRING: '"' ( ~["\r\n] )* '"';                                          // String literal
NUMBER: [0-9]+ ('.' [0-9]+)? ;                                          // Nombre (enter o decimal)
BOOLEAN: '#t' | '#f';                                                   // Booleans (true/false)
ID: [a-zA-ZáéíóúÁÉÍÓÚñÑ][a-zA-ZáéíóúÁÉÍÓÚñÑ0-9_?-]*;                    // Identificador
WS: [ \t\r\n]+ -> skip;                                                 // Espais en blanc
COMMENT: ';' ~[\r\n]* -> skip;                                          // Comentaris
