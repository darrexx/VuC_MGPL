grammar MGPL;

options {backtrack = false;}

prog : 'game' Idf '(' attrAssList ? ')' decl* stmtBlock block* ;
decl : varDecl ';' | objDecl ';' ;
varDecl : 'int' Idf init ? | 'int' Idf '[' Number ']' ;
init : '=' expr ;
objDecl : ObjType Idf '(' attrAssList ? ')' | ObjType Idf '[' Number ']';
ObjType : 'rectangle' | 'triangle' | 'circle' ;
attrAssList : attrAss (',' attrAssList)?;
attrAss : Idf '=' expr ;
block : animBlock | eventBlock ;
animBlock : 'animation' Idf '(' ObjType Idf ')' stmtBlock ;
eventBlock : 'on' KeyStroke stmtBlock ;
KeyStroke : 'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow' ;
stmtBlock : '{' stmt* '}' ;
stmt : ifStmt | forStmt | assStmt ';' ;
ifStmt : 'if' '(' expr ')' stmtBlock ( 'else' stmtBlock )? ;
forStmt : 'for' '(' assStmt ';' expr ';' assStmt ')' stmtBlock ;
assStmt : var '=' expr ;
var : Idf ('[' expr ']')? ('.' Idf)? ;

expr : orExpr; // (Number | var | var 'touches' var | '-' expr | '!' expr | '(' expr ')') (Op expr)* ;
atomExpr: Number | var ('touches' var)? | '(' expr ')';
unExpr	: ('!'|'-') atomExpr; //'-' expr | '!' expr | '(' expr ')';
multExpr:unExpr (('*'|'/') unExpr)*;
addExpr	:multExpr (('-'|'+') multExpr)*;
andExpr	:relExpr ('&&' relExpr)*;
relExpr	:addExpr (('<'|'<='|'==') addExpr)*;
orExpr	:andExpr ('||' andExpr)*;
//Op : '||' | '&&' | '==' | '<' | '<=' | '+' | '-' | '*' | '/' ;
Idf : ( 'a'..'z' | 'A'..'Z')( 'a'..'z' | 'A'..'Z' | '_' | '0'..'9')*;
Number	: ('0'..'9')+;
