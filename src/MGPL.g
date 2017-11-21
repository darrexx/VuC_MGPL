parser grammar MGLP;

Prog ::= game Idf ( AttrAssList ? ) Decl* StmtBlock Block*
Decl ::= VarDecl ; | ObjDecl ;
VarDecl ::= int Idf Init ? | int Idf [ Number ]
Init ::= = Expr
ObjDecl ::= ObjType Idf ( AttrAssList ? ) | ObjType Idf [ Number ]
ObjType ::= rectangle | triangle | circle
AttrAssList ::= AttrAss , AttrAssList | AttrAss
AttrAss ::= Idf = Expr
Block ::= AnimBlock | EventBlock
AnimBlock ::= animation Idf ( ObjType Idf ) StmtBlock
EventBlock ::= on KeyStroke StmtBlock
KeyStroke ::= space | leftarrow | rightarrow | uparrow | downarrow
StmtBlock ::= { Stmt* }
Stmt ::= IfStmt | ForStmt | AssStmt ;
IfStmt ::= if ( Expr ) StmtBlock ( else StmtBlock )?
ForStmt ::= for ( AssStmt ; Expr ; AssStmt ) StmtBlock
AssStmt ::= Var = Expr
Var ::= Idf | Idf [ Expr ] | Idf . Idf | Idf [ Expr ] . Idf
Expr ::= Number | Var | Var touches Var | - Expr | ! Expr | ( Expr ) | Expr Op Expr |
Op ::= || | && | == | < | <= | + | - | * | /