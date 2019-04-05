%{
	#include<stdio.h>
	#include<stdlib.h>
	#include "symboltable.h"
	int yylex();
	int yyerror();
	extern FILE* yyin;
	extern int yylineno;
%}
%token COMM TS NL HEXCONST FLOAT DECCONST BOOLCONST KEY ID STRCONST OP END DT BRACK COMMA FS NULLCONST SQBO SQBC OB CB VOID CLASS OCB CCB EXTENDS IMPLEMENTS INTERFACE FOR WHILE IF ELSE RETURN BREAK EQ THIS MINUS NOT READ NEW NEWARR PRINT SP PLUS MULT DIVIDE MOD AND OR NE EQQ LT GT LTE GTE U_MINUS
%locations
%left     EQ
%left     OR
%left     AND 
%nonassoc  EQQ NE
%nonassoc  LT GT LTE GTE
%left      PLUS MINUS
%left      MULT DIVIDE MOD  
%nonassoc  T_UnaryMinus NOT 
%nonassoc  FS SQBO
%nonassoc  T_Lower_Than_Else
%nonassoc  ELSE

%%
start : declList{printf("Success \n"); exit(0);}
       ;
declList : declList decl
			| decl
			;
decl : classDecl
	  | fnDecl
	  | varDecl
	  | intDecl
	  ;
varDecl : var END
		;
var : type ID
	  ;
type : DT
	  | ID
	  | type SQBO SQBC
	  ;
intDecl : INTERFACE ID OCB intfList CCB
		;
intfList : intfList fnHeader END
			|
			;
classDecl : CLASS ID optExt optImpl OCB fieldList CCB
			;
optExt : EXTENDS ID 
		|
		;
optImpl : IMPLEMENTS impList
		|
		;
impList : impList COMMA ID
		| ID
		;
fieldList : fieldList field
			| 
			;
field : varDecl
		| fnDecl
		;
fnHeader : type ID OB formals CB
		| VOID ID OB formals CB
		;
formals : formalList
		|
		;
formalList : formalList COMMA var
			| var
			;
fnDecl : fnHeader stmtBlock
		;
stmtBlock : OCB varDecls stmtList CCB
			;
varDecls : varDecls varDecl
			|
			;
stmtList : stmt stmtList
			|
			;
stmt : optExpr END
	  | stmtBlock
	  | IF OB expr CB stmt optElse
	  | WHILE OB expr CB stmt
	  | FOR OB optExpr END expr END optExpr CB stmt
	  | RETURN expr END
	  | RETURN END
	  | PRINT OB exprList CB END
	  | BREAK END
	  ;
lvalue : ID 
		| expr FS ID
		| expr SQBO expr SQBC
		;
call : ID OB actuals CB
		| expr FS ID OB actuals CB
		;
optExpr : expr
		|
		;
expr : lvalue
		| call
		| constant
		| lvalue EQ expr
		| expr PLUS expr
		| expr MINUS expr
		| expr DIVIDE expr
		| expr MULT expr
		| expr MOD expr
		| expr EQQ expr
		| expr NE expr
		| expr LT expr
		| expr GT expr
		| expr LTE expr
		| expr GTE expr
		| expr AND expr
		| expr OR expr
		| OB expr CB
		| '-' expr %prec T_UnaryMinus 
		| NOT expr
		| READ OB CB
		| NEW OB ID CB
		| NEWARR OB expr COMMA type CB
		| THIS
		;
constant : DECCONST
	   | FLOAT
	   | BOOLCONST
	   | STRCONST
	   | NULLCONST
	   | HEXCONST
	   ;
actuals : exprList 
		|
		;
exprList : exprList COMMA expr
			| expr
			;
optElse : ELSE stmt
		| %prec T_Lower_Than_Else 
		;


%%
int yyerror(char *msg)
{
	printf("Invalid expression at line number: %d %s\n",yylineno,msg);
	return 1;
}
void main(int argc,char *argv)
{
	char filename[] = "fibonacci.decaf";
	yyin=fopen(filename,"r");
	do{
	if(yyparse()){
	printf("Error\n");exit(0);
	}
	}while(feof(yyin)!=0);
	printf("Success\n");
}
