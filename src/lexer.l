%{
	// lexer.l - contains all lexemes and tokens definitions
	#include "y.tab.h"
%}

alpha	[a-zA-Z]
digit	[0-9]
digits	{digit}+

%%

"init"				{return INIT;} // entry point to the code
"int"				{strcpy(yylval.text,yytext); return INT;}
","				{strcpy(yylval.text,yytext); return COMMA;}
";"				{strcpy(yylval.text,yytext); return SCOL;}
"loop"				{return LOOP;} // analogous to while statement
"if"				{return IF;}
"else"				{return ELSE;}
"print"				{return PRINT;} // print keyword
"get"				{return GET;}   // get keyword
"="				{strcpy(yylval.text,yytext); return ASSGN;}
"+"				{strcpy(yylval.text,yytext); return PLUS;}
"-"				{strcpy(yylval.text,yytext); return MINUS;}
"*"				{strcpy(yylval.text,yytext); return MUL;}
"/"				{strcpy(yylval.text,yytext); return DIV;}
"<"				{strcpy(yylval.text,yytext); return LES;}
"<="				{strcpy(yylval.text,yytext); return LEQ;}
">"				{strcpy(yylval.text,yytext); return GRE;}
">="				{strcpy(yylval.text,yytext); return GEQ;}
"=="				{strcpy(yylval.text,yytext); return EQL;}
"!="				{strcpy(yylval.text,yytext); return NEQ;}
"&&"				{strcpy(yylval.text,yytext); return AND;}
"||"				{strcpy(yylval.text,yytext); return OR;}
"!"				{strcpy(yylval.text,yytext); return NOT;}
"["				{return LSBR;}
"]"				{return RSBR;}
"("				{return LPBR;}
")"				{return RPBR;}
"{"				{return LFBR;}
"}"				{return RFBR;}
"true"					{strcpy(yylval.text,yytext); return TRUE;}
"false"					{strcpy(yylval.text,yytext); return FALSE;}
{digits}				{yylval.ival = atoi(yytext); return INTCONST;} 
"\"".*"\""			        {strcpy(yylval.text,yytext); return STRCONST;}
{alpha}({alpha}|{digit})*		{strcpy(yylval.text,yytext); return ID;} // identifiers, alphabhet followed by any number of alphabets/digits
"#".*"#"				; // comments
[ \t\n]					;
"$"					{return 0;}
.  					{return ERR;}

%%



