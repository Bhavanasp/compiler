%{
	#include <iostream>
	#include <string>
	#include <stack>
	#include "symbol_table.hpp"
	#include "ast_nodes.hpp"

	using namespace std;

	extern FILE* yyin;

	int yylex();
	int yyerror(string s);
	
	stack <Env*> symref;
	Env* top = new Env(NULL);
	attr* a;

	struct ast_node{
		Node *node;
		struct ast_node* left;
		struct ast_node* right;
		ast_node(struct ast_node* vleft, struct ast_node* vright){
			left = vleft;
			right = vright;
		}
	};

	typedef struct ast_node node;
%}

%union {
	int ival;
	float fval; 
	char text[20];
	struct ast_node* snode;
}

%nonassoc NOELSE
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
%type <ival> FLOATCONST
%type <snode> INIT init stmts block bool loc factor funcdecl globaldecl globaldecls vardecl vardecls start program 

%%

start		:	program 
			
			{$$ = $1;};

program		:	globaldecls init
			
//			{$$ = new node($1,$2);}
;

globaldecls	:	globaldecls globaldecl
//			{$$ = new node($1,$2);}
			|//{$$ = NULL;}
;

globaldecl	:	vardecl
			{$$ = $1;}
			|funcdecl
			{$$ = $1;};

vardecls	:	vardecls vardecl
			{$$ = NULL;}
			|{$$ = NULL;};

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
			{$$ = $6;
			a = new attr();
			string s($1);
			a->type = s;
			top->put($2, a);};

block		:	LFBR
			{symref.push(top);
			top = new Env(top);
			cout<<"{";}
			vardecls
			stmts
			
//			{$$ = $3}
			
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
//			{$$ = new node($1, $2);}
			|//{$$ = NULL}
;

stmt		:	loc ASSGN bool SCOL
			
			|IF LPBR bool RPBR stmt %prec NOELSE
			|IF LPBR bool RPBR stmt ELSE stmt
			|LOOP LPBR bool RPBR stmt
			|ID LPBR args RPBR SCOL			
			{a = top->get($1);
			cout<<$1<<":"<<a->type<<endl;}
			|BREAK SCOL
			|block;

args		:	arglist
			{$$ = $1;}
			|{$$ = $1;};

arglist		:	arglist COMMA arg {$$ = new Node($1,$3);}
			|arg {$$ = $1;};

arg		:	factor {$$ = $1;};

type		:	INT|FLOAT;

loc		:	loc LSBR bool RSBR
			{$$ = new node(NULL,NULL);
			 $$->node->ntype = "location";}
			|ID
			{$$ = new node(NULL,NULL);
			 $$->node->ntype = "location";
			 $$->node->atr = top->get($1);
			 cout<<$1<<":"<<$$->node->attr->type<<endl;}
			;

bool		:	bool OR join
			{$$ = new node($1,$2);
			 $$->node->ntype = "bool";
			 $$->node->op = "||";}
			|join
			{$$ = $1;}
			;

join		:	join AND equality
			{$$ = new node($1,$2);
			 $$->node->ntype = "join";
			 $$->node->op = "&&";}
			|equality
			{$$ = $1;}
			;

equality	:	equality EQL rel
			{$$ = new node($1,$2);
			 $$->node->ntype = "equality";
			 $$->node->op = "==";}
			|equality NEQ rel
			{$$ = new node($1,$2);
			 $$->node->ntype = "equality";
			 $$->node->op = "!=";}
			|rel
			{$$ = $1;};

rel		:	expr LES expr
			{$$ = new node($1,$2);
			 $$->node->ntype = "rel";
			 $$->node->op = "<";}
			|expr LEQ expr
			{$$ = new node($1,$2);
			 $$->node->ntype = "rel";
			 $$->node->op = "<=";}
			|expr GEQ expr
			{$$ = new node($1,$2);
			 $$->node->ntype = "rel";
			 $$->node->op = ">=";}
			|expr GRE expr
			{$$ = new node($1,$2);
			 $$->node->ntype = "rel";
			 $$->node->op = ">";}
			|expr
			{$$ = $1;}
			;

expr		:	expr PLUS term
			{$$ = new node($1,$2);
			 $$->node->ntype = "add";
			 $$->node->op = "+";}
			|expr MINUS term
			{$$ = new node($1,$2);
			 $$->node->ntype = "subtract";
			 $$->node->op = "-";}
			|term
			{$$ = $1;}
			;

term		:	term MUL unary
			{$$ = new node($1,$2);
			 $$->node->op = "*";
			 $$->node->ntype = "multiply";}
			|term DIV unary
			{$$ = new node($1,$2);
			 $$->node->op = "/";
			 $$->node->ntype = "divide";}
			|unary
			{$$ = $1};

unary		:	NOT unary
			{$$ = $2;
			 $$->op = "!";}
			|MINUS unary
			{$$ = $2;
			 $$->op = "-";}
			|factor
			{$$ = $1;}
			;

factor		:	LPBR bool RPBR
			{$$ = $2;}
			|loc
			{$$ = $1;}
			|INTCONST
			{$$ = new node(NULL, NULL);
			 $$->node = new node();
			 $$->node->constNode("literal","intconst", "4", to_string($1));}
			|FLOATCONST
			{$$ = new node(NULL, NULL);
			$$->node->constNode("literal","floatconst", "4", to_string($1));}
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
