%{

	#include <iostream>
	#include <string>
	using namespace std;

	extern FILE * yyin;

	int yylex();
	int yyerror(char *);

%}

%union {
	int ival;
	float fval; 
	char text[20];
}

%token INIT
%token ID
%token INT FLOAT VOID
%token INTCONST FLOATCONST
%token COMMA SCOL
%token IF ELSE
%token LOOP
%token BREAK
%token RETURN
%token ASSGN
%token ADD SUB MUL DIV
%token LES LEQ GRE GEQ EQL NEQ
%token LSBR RSBR
%token LPBR RPBR
%token LFBR RFBR
%token ERR

%%

program			:	declaration_list init_block
				{cout<<"input accepted"<<endl;}
			;

init_block		:	INIT compound_statement
			;

declaration_list	:	declaration_list declaration
			|
			;

declaration 		:	var_declaration
			| 	func_declaration
			;

var_declaration 	:	type_specifier ID SCOL
			|	type_specifier ID LSBR INTCONST RSBR SCOL
			;

type_specifier		:	INT | FLOAT | VOID
			;

func_declaration	:	type_specifier ID LPBR params RPBR compound_statement
			;

params			:	param_list
			|
			;

param_list		:	param_list COMMA param
			|	param
			;

param			:	type_specifier ID
			|	type_specifier ID LSBR RSBR
			;

compound_statement	:	LFBR local_declarations statement_list RFBR
			;

local_declarations	:	local_declarations var_declaration 
			|
			;

statement_list		:	statement_list statement
			|
			;

statement		:	expression_statement
			|	compound_statement
			|	selection_statement
			|	iteration_statement
			|	break_statement
			|	return_statement
			;

expression_statement	:	expression SCOL
			|	SCOL
			;

selection_statement	:	simple_selection
			|	simple_selection ELSE compound_statement
			;

simple_selection	:	IF LPBR expression RPBR compound_statement
			|	simple_selection ELSE IF LPBR expression RPBR compound_statement
			;

iteration_statement	:	LOOP LPBR expression RPBR statement
			;

break_statement		:	BREAK SCOL
			;

return_statement	:	RETURN SCOL
			|	RETURN expression SCOL
			;

expression		:	var ASSGN expression
			|	simple_expression
			;

var			:	ID
			|	ID LSBR expression RSBR
			;

simple_expression	:	additive_expression relop additive_expression
			|	additive_expression
			;

relop			:	LES | LEQ | GRE | GEQ | EQL | NEQ
			;

additive_expression	:	additive_expression addop term
			|	term
			;

addop			:	ADD
			|	SUB
			;

term			:	term mulop factor
			|	factor
			;

mulop			:	MUL
			|	DIV
			;

factor			:	LPBR expression RPBR
			|	var
			|	func_call
			|	INTCONST
			|	FLOATCONST
			;

func_call		:	ID LPBR args RPBR
			;

args			:	arg_list
			|
			;

arg_list		:	arg_list COMMA expression
			|	expression
			;

%%

int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		cout<<"Usage: <exefile> <inputfile>"<<endl;
       		exit(0);
	}
	yyin = fopen(argv[1], "r");
	yyparse();
	return 0;
}

int yyerror(char *s){
	cout<<"Error: "<<s<<endl;
	return 0;
}
