grammar MGPL_AST;

options {backtrack = false; output=AST;}

tokens {
GAME;
INIT;
ASSIGNMENTS;
ASSIGNMENT;
DECLARATIONS;
DECLARATION_VAR;
DECLARATION_OBJ;
OBJECT_TYPE;
PARAMETER;
ANIMATION;
EVENT;
CONDITION;
STATEMENTS;
IF_STATEMENT;
ELSE;
FOR_STATEMENT;
LOOP_CONDITION;
VARIABLE;
TOUCHES;
EXPRESSION;
POSITION;
}

prog : 'game' Idf '(' attrAssList ? ')' decl* stmtBlock block* -> ^(GAME Idf attrAssList ^(DECLARATIONS decl*) stmtBlock block*);
decl : varDecl ';'! | objDecl ';'!;
varDecl : 'int' Idf varDecl_2? -> ^(DECLARATION_VAR Idf varDecl_2?);
varDecl_2 : init | '[' Number ']';
init : '=' expr -> ^(INIT expr);
objDecl : (ObjType Idf '(' attrAssList ? ')' | ObjType Idf '[' Number ']' )-> ^(DECLARATION_OBJ ^(OBJECT_TYPE ObjType) Idf attrAssList? Number?);
ObjType : 'rectangle' | 'triangle' | 'circle' ;
attrAssList : attrAss (',' attrAss)* -> ^(ASSIGNMENTS attrAss+);
attrAss : Idf '=' expr -> ^(ASSIGNMENT Idf expr);
block : animBlock | eventBlock ;
animBlock : 'animation' Idf '(' ObjType Idf ')' stmtBlock -> ^(ANIMATION Idf ^(PARAMETER ObjType Idf) stmtBlock) ;
eventBlock : 'on' KeyStroke stmtBlock -> ^(EVENT ^(CONDITION KeyStroke) stmtBlock) ;
KeyStroke : 'space' | 'leftarrow' | 'rightarrow' | 'uparrow' | 'downarrow' ;
stmtBlock : '{' stmt* '}' -> ^(STATEMENTS stmt*);
stmt : (ifStmt | forStmt | assStmt ';'!);
ifStmt : 'if' '(' expr ')' stmtBlock ( 'else' stmtBlock )? -> ^(IF_STATEMENT ^(CONDITION expr) stmtBlock ^(ELSE stmtBlock)?);
forStmt : 'for' '(' assStmt ';' expr ';' assStmt ')' stmtBlock -> ^(FOR_STATEMENT ^(LOOP_CONDITION assStmt expr assStmt) stmtBlock);
assStmt : var '=' expr -> ^(ASSIGNMENT var expr);
var : Idf ('[' expr ']')? ('.' Idf)? -> ^(VARIABLE ^(Idf ^(POSITION expr)?) ^(Idf)?);

expr : orExpr; 
//Split expr
atomExpr: Number | var ('touches' var)? | '('! expr ')'!;
unExpr	: (('!'|'-')^)? atomExpr;
multExpr:unExpr (('*'|'/')^ unExpr)*;
addExpr	:multExpr (('-'|'+')^ multExpr)*;
andExpr	:relExpr ('&&'^ relExpr)*;
relExpr	:addExpr (('<'|'<='|'==')^ addExpr)*;
orExpr	:andExpr ('||'^ andExpr)*;

Idf : ( 'a'..'z' | 'A'..'Z')( 'a'..'z' | 'A'..'Z' | '_' | '0'..'9')*;
Number	: ('0'..'9')+;

Comment	:'//' ~('\r'|'\n')*{$channel=HIDDEN;};
WS	:('\n' | '\r' | ' ' | '\u000C' | '\t') {$channel=HIDDEN;};
