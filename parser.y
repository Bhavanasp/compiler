%{

	#include <iostream>
	#include <string>
	#include <stack>
	#include "symbol_table.hpp"

	using namespace std;

	extern FILE * yyin;

	int yylex();
	int yyerror(string s);
	
	stack <Env *> symref;
	Env *top = new Env(NULL);
	attr *a;
%}

%union {
	int ival;
	float fval; 
	char text[20];
}

%nonassoc NO_ELSE
%nonassoc ELSE

%token INIT
%token INT FLOAT VOID
%token INTCONST FLOATCONST
%token ID
%token COMMA SCOL
%token IF ELSE
%token LOOP
%token BREAK
%token RETURN
%token ASSGN
%token PLUS MINUS MUL DIV
%token LES LEQ GRE GEQ EQL NEQ
%token AND OR NOT
%token LSBR RSBR
%token LPBR RPBR
%token LFBR RFBR
%token ERR

%type <text> ID
%type <text> type
%type <text> INT
%type <text> FLOAT
%type <ival> INTCONST

%%

start		:	program	{cout<<endl;};

program		:	globaldecls init;

globaldecls	:	globaldecls globaldecl
			|;

globaldecl	:	vardecl
			|funcdecl;

vardecls	:	vardecls vardecl
			|;

vardecl		:	type ID SCOL
			{a = new attr();
			string s($1);
			a->type = s;
			top->put($2, a);}

			|

			type ID LPBR INTCONST RPBR SCOL
			{a = new attr();
			string s($1);
			a->type = s;
			top->put($2, a);};

funcdecl	:	type ID LPBR params RPBR block
			{a = new attr();
			string s($1);
			a->type = s;
			top->put($2, a);};

block		:	LFBR
			{symref.push(top);
			top = new Env(top);
			cout<<"{";}
			vardecls
			stmts
			RFBR
			{top = symref.top();
			symref.pop();
			cout<<"}";};

init		:	INIT block;

params		:	paramlist
			|;

paramlist	:	paramlist COMMA param
			|param;

param		:	type ID
			{a = new attr();
			string s($1);
			a->type = s;
			top->put($2, a);}
			|type ID LSBR RSBR;

stmts		:	stmts stmt
			|;

stmt		:	loc ASSGN bool SCOL
			|IF LPBR bool RPBR stmt %prec NO_ELSE
			|IF LPBR bool RPBR stmt ELSE stmt
			|LOOP LPBR bool RPBR stmt
			|ID LPBR args RPBR SCOL			
			{a = top->get($1);
			cout<<$1<<":"<<a->type<<endl;}
			|BREAK SCOL
			|block;

args		:	arglist
			|;

arglist		:	arglist COMMA arg
			|arg;

arg		:	factor;

type		:	INT|FLOAT;

loc		:	loc LSBR bool RSBR
			|ID
			{a = top->get($1);
			cout<<$1<<":"<<a->type<<endl;}
;

bool		:	bool OR join
			|join;

join		:	join AND equality
			|equality;

equality	:	equality EQL rel
			|equality NEQ rel
			|rel;

rel		:	expr LES expr
			|expr LEQ expr
			|expr GEQ expr
			|expr GRE expr
			|expr;

expr		:	expr PLUS term
			|expr MINUS term
			|term;

term		:	term MUL unary
			|term DIV unary
			|unary;

unary		:	NOT unary
			|MINUS unary|factor;

factor		:	LPBR bool RPBR
			|loc
			|INTCONST
			|FLOATCONST
			;

// block

// declarations

// if-else

// while

// expressions

// statements

// functions


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

int yyerror(string s){
	cout<<"Error: "<<s<<endl;
	return 0;
}
