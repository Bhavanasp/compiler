%{
	#include <string>
	#include "y.tab.h"
%}

alpha	[a-zA-Z]
digit	[0-9]
digits	digit+

%%

"init"				{return INIT;}
"int"				{return INT;}
"float"				{return FLOAT;}
"void"				{return VOID;}
","				{return COMMA;}
";"				{return SCOL;}
"loop"				{return LOOP;}
"if"				{return IF;}
"else"				{return ELSE;}
"break"				{return BREAK;}
"return"			{return RETURN;}
"="				{return ASSGN;}
"+"				{return ADD;}
"-"				{return SUB;}
"*"				{return MUL;}
"/"				{return DIV;}
"<"				{return LES;}
"<="				{return LEQ;}
">"				{return GRE;}
">="				{return GEQ;}
"=="				{return EQL;}
"!="				{return NEQ;}
"["				{return LSBR;}
"]"				{return RSBR;}
"("				{return LPBR;}
")"				{return RPBR;}
"{"				{return LFBR;}
"}"				{return RFBR;}
("+"|"-")?{digits}		{yylval.ival = atoi(yytext); return INTCONST;}
("+"|"-")?{digits}.{digits}	{yylval.fval = atof(yytext); return FLOATCONST;}
{alpha}({alpha}|{digit})*	{strcpy(yylval.text,yytext); return ID;}
[ \t\n]				;
"$"				{return 0;}
.  				{return ERR;}

%%



