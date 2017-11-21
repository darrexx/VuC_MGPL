grammar MGPL;

options { backtrack = false }

prog : 'game' idf '(' attrAssList ? ')' decl* stmtBlock block* ;
decl : varDecl ';' | objDecl ';' ;
varDecl : 'int' idf init ? | 'int' idf '[' number ']' ;
init : '=' expr ;
objDecl : objType idf '(' attrAssList ? ')' | objType idf '[' number ']';
objType : 'rectangle' | 'triangle' | 'circle' ;
attrAssList : attrAss , attrAssList | attrAss ;
attrAss : idf '=' expr ;
block : animBlock | eventBlock ;
animBlock : 'animation' idf '(' objType idf ')' stmtBlock ;
eventBlock : 'on' keyStroke stmtBlock ;
keyStroke : 'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow' ;
stmtBlock : '{' stmt* '}' ;
stmt : ifStmt | forStmt | assStmt ';' ;
ifStmt : 'if' '(' expr ')' stmtBlock ( 'else' stmtBlock )? ;
forStmt : 'for' '(' assStmt ';' expr ';' assStmt ')' stmtBlock ;
assStmt : var '=' expr ;
var : idf | idf '[' expr ']' | idf '.' idf | idf '[' expr ']' '.' idf ;
expr : number | var | var 'touches' var | '-' expr | '!' expr | '(' expr ')' | expr op expr ;
op : '||' | '&&' | '==' | '<' | '<=' | '+' | '-' | '*' | '/' ;
idf : ( 'a'..'z' | 'A'..'Z')
( 'a'..'z' | 'A'..'Z' | '_' | '0'..'9')*;
number	: ('0'..'9')+;
