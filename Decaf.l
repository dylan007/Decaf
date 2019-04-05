%{
	#include"Decaf.tab.h"
	#include "hashtable.h"
	#include <stdio.h>
	#include <stdlib.h>
	node *table[100] = {NULL};
	FILE *out = NULL;
%}
%option yylineno
%x C_COMMENT

%%
"/*"            { BEGIN(C_COMMENT); }
<C_COMMENT>"*/" { BEGIN(INITIAL); }
<C_COMMENT>\n   { }
<C_COMMENT>.    { }
"//".*                                   
\n {printf("%s",yytext);}
(" "|\t) {printf("%s",yytext);}
(";") {printf("%s",yytext);return END;}
(",") {printf("%s",yytext);return COMMA;}
"." {printf("%s",yytext);return FS;}
"[" {printf("%s",yytext);return SQBO;}
"]" {printf("%s",yytext);return SQBC;}
("(") {printf("%s",yytext);return OB;}
(")") {printf("%s",yytext);return CB;}
("{") {printf("%s",yytext);return OCB;}
("}") {printf("%s",yytext);return CCB;}
("0x"|"0X")[0-9|A-F|a-f]+ {printf("%s",yytext);return HEXCONST;}
[+|-]?[0-9]+[\.][0-9]*([E][+|-]?[0-9]+)? {printf("%s",yytext);return FLOAT;}
[+|-]?[0-9]+ {printf("%s",yytext);return DECCONST;}
"null" {printf("%s",yytext);return NULLCONST;}
"true"|"false" {printf("%s",yytext);return BOOLCONST;}
"void" {printf("%s",yytext);return VOID;}
"class" {printf("%s",yytext);return CLASS;}
"extends" {printf("%s",yytext);return EXTENDS;}
"implements" {printf("%s",yytext);return IMPLEMENTS;}
"interface" {printf("%s",yytext);return INTERFACE;}
"int"|"double"|"bool"|"string" {printf("%s",yytext);return DT;}
"if" {printf("%s",yytext);return IF;}
"else" {printf("%s",yytext);return ELSE;}
"for" {printf("%s",yytext);return FOR;}
"while" {printf("%s",yytext);return WHILE;}
"return" {printf("%s",yytext);return RETURN;}
"break" {printf("%s",yytext);return BREAK;}
"Print" {printf("%s",yytext);return PRINT;}
"this" {printf("%s",yytext);return THIS;}
"ReadInteger"|"ReadLine" {printf("%s",yytext);return READ;}
"New" {printf("%s",yytext);return NEW;}
"NewArray" {printf("%s",yytext);return NEWARR;}
[A-Za-z_][0-9|A-Za-z_]* {
	printf("%s\n",yytext);
	if(out==NULL)
		out = fopen("sym","a+");
	int h = hash(yytext);
	printf("Hashval:%d\n",h);
	if(!search(table[h],yytext)){
		fprintf(out,"ID inserted : %s\n",yytext);
		table[h] = insert(table[h],yytext);
	}
	fclose(out);
	out = NULL;
	return ID;
}
("-") {printf("%s",yytext);return MINUS;}
("+") {printf("%s",yytext);return PLUS;}
("*") {printf("%s",yytext);return MULT;}
("/") {printf("%s",yytext);return DIVIDE;}
("%") {printf("%s",yytext);return MOD;}
("!") {printf("%s",yytext);return NOT;}
("&&") {printf("%s",yytext);return AND;}
("||") {printf("%s",yytext);return OR;}
("<") {printf("%s",yytext);return GT;}
(">") {printf("%s",yytext);return LT;}
("!=") {printf("%s",yytext);return NE;}
("==") {printf("%s",yytext);return EQQ;}
("<=") {printf("%s",yytext);return LTE;}
(">=") {printf("%s",yytext);return GTE;}
("=") {printf("%s",yytext);return EQ;}
(\"(\\.|[^"\\])*\") {printf("%s",yytext);return STRCONST;}
%%
int yywrap()
{
	return 1;
}
