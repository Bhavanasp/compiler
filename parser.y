%{
	#include <iostream>
	#include <string>
	#include <stack>
	#include "ast_nodes.hpp"

	using namespace std;

	extern FILE* yyin;

	int yylex();
	int yyerror(string s);
	int size(string s);

	//stack to keep track of the hierarchical symbol table	
	stack <Scope*> symref;
	
	//global symbol table
	Scope* top = new Scope(NULL);

	//attributes
	attr* a;

	//abstract syntax tree node definition
	struct ast_node{
		Node *node;
		struct ast_node* left;
		struct ast_node* right;
		ast_node(Node *vnode, struct ast_node* vleft, struct ast_node* vright){
			node = vnode;
			left = vleft;
			right = vright;
		}
	};

	typedef struct ast_node node;

	void preorder(node*);

	int npar;
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
%token INT FLOAT CHAR VOID
%token INTCONST FLOATCONST CHARCONST
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

%type <text> type
%type <text> ID INT FLOAT CHAR
%type <ival> INTCONST
%type <fval> FLOATCONST
%type <text> CHARCONST
%type <snode> start program globaldecls globaldecl vardecls vardecl 
%type <snode> funcdecl block init params paramlist param stmts stmt
%type <snode> args arglist arg loc bool join equality rel expr
%type <snode> term unary factor

%%

start		:	program 
			
			{$$ = $1; 
		       	 cout<<"\n\n----------------------------------"<<endl;
			 cout<<" SYNTAX-TREE TRAVERSAL (PREORDER) "<<endl;
			 cout<<"----------------------------------"<<endl;
			 preorder($$);};

program		:	globaldecls init
			
			{$$ = new node(NULL, $1, $2);};

globaldecls	:	globaldecls globaldecl

			{$$ = new node(NULL, $1,$2);}

			|

			{$$ = NULL;};

globaldecl	:	vardecl

			{$$ = $1;}

			|

			funcdecl
	
			{$$ = $1;};

vardecls	:	vardecls vardecl

			{$$ = NULL;}

			|
	
			{$$ = NULL;};

vardecl		:	type ID SCOL

			{$$ = NULL;
			 a = new attr("var",$1,"",to_string(size($1)),"");
			 top->put($2, a);
			 cout<<"\tinstalled "<<$2<<" : ";a->print();cout<<endl;}

			|

			type ID LSBR INTCONST RSBR SCOL

			{$$ = NULL;
			 a = new attr("array",$1,"",to_string(size($1)*$4),"");
			 top->put($2, a);
			 cout<<"\tinstalled "<<$2<<" : ";a->print();cout<<endl;};

funcdecl	:	type ID LPBR {npar = 0;cout<<"{\n";} params RPBR block

			{$$ = $7;
			 a = new attr("func","","","","");
			 a->ret_type = $1;
			 a->number_of_args = to_string(npar);			
			 top->put($2, a);
			 cout<<"\tinstalled "<<$2<<" : ";a->print();cout<<endl;};

block		:	LFBR

			{symref.push(top);
			 top = new Scope(top);}

			vardecls
			stmts
			
			RFBR

			{$$ = $4;
			 top = symref.top();
			 symref.pop();
			 cout<<"}\n";};

init		:	{cout<<"{\n";} INIT block

			{$$ = $3;};

params		:	paramlist

			{$$ = $1;}

			|

			{$$ = NULL;};

paramlist	:	paramlist COMMA param

			{$$ = new node(NULL,$1,$3);}

			|

			param

			{$$ = $1;};

param		:	type ID

			{$$ = new node(new Node(),NULL,NULL);
			 a = new attr("var",$1,"",to_string(size($1)),"");
			 top->put($2, a);
			 $$->node->atr = a;
			 cout<<"\tinstalled "<<$2<<" : ";a->print();cout<<endl;
			 npar++;}

			|

			type ID LSBR RSBR

			{$$ = new node(new Node(),NULL,NULL);
			 a = new attr("array",$1,"","","");
			 top->put($2, a);
			 $$->node->atr = a;
			 cout<<"\tinstalled "<<$2<<" : ";a->print();cout<<endl;
			 npar++;};

stmts		:	stmts stmt

			{$$ = new node(NULL, $1, $2);}

			|

			{$$ = NULL;};

stmt		:	loc ASSGN bool SCOL

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "assgn";
			 $$->node->op = "=";}

			|IF LPBR bool RPBR stmt %prec NOELSE

			{$$ = new node(new Node(),$3,$5);
			 $$->node->ntype = "if";}

			|IF LPBR bool RPBR stmt ELSE stmt

			{$$ = NULL;}

			|LOOP LPBR bool RPBR stmt

			{$$ = new node(new Node(),$3,$5);
			 $$->node->ntype = "loop";}

			|BREAK SCOL

			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->ntype = "funcall";}

			|RETURN factor SCOL

			{$$ = new node(new Node(),$2,NULL);
			 $$->node->ntype = "return";}

			|{cout<<"{\n";} block

			{$$ = $2;};

args		:	arglist

			{$$ = $1;}

			|

			{$$ = NULL;};

arglist		:	arglist COMMA arg 

			{$$ = new node(NULL,$1,$3);}

			|arg 

			{$$ = $1;};

arg		:	factor 

			{$$ = $1;};

type		:	INT | FLOAT | CHAR;

loc		:	loc LSBR bool RSBR

			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->ntype = "location";}

			|ID

			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->ntype = "location";
			 $$->node->atr = top->get($1);
			  cout<<"\taccessed "<<$1<<" : ";$$->node->atr->print();cout<<endl;}

			|ID LPBR args RPBR
			
			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->ntype = "funcall";
			 $$->node->atr = top->get($1);
			 cout<<"\taccessed "<<$1<<" : ";$$->node->atr->print();cout<<endl;}

			;

bool		:	bool OR join

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "bool";
			 $$->node->op = "||";}

			|join

			{$$ = $1;};

join		:	join AND equality

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "join";
			 $$->node->op = "&&";}

			|equality

			{$$ = $1;};

equality	:	equality EQL rel

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "equality";
			 $$->node->op = "==";}

			|equality NEQ rel

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "equality";
			 $$->node->op = "!=";}

			|rel

			{$$ = $1;};

rel		:	expr LES expr

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "rel";
			 $$->node->op = "<";}

			|expr LEQ expr

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "rel";
			 $$->node->op = "<=";}

			|expr GEQ expr

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "rel";
			 $$->node->op = ">=";}

			|expr GRE expr

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "rel";
			 $$->node->op = ">";}

			|expr

			{$$ = $1;};

expr		:	expr PLUS term

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "add";
			 $$->node->op = "+";}

			|expr MINUS term

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "subtract";
			 $$->node->op = "-";}

			|term

			{$$ = $1;};

term		:	term MUL unary

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "multiply";
			 $$->node->op = "*";}

			|term DIV unary

			{$$ = new node(new Node(),$1,$3);
			 $$->node->ntype = "divide";
			 $$->node->op = "/";}

			|unary

			{$$ = $1;};

unary		:	NOT unary

			{$$ = $2;
			 $$->node->op = "!";}

			|MINUS unary

			{$$ = $2;
			 $$->node->op = "-";}

			|factor
			{$$ = $1;}

			;

factor		:	LPBR bool RPBR

			{$$ = $2;}

			|loc

			{$$ = $1;}

			|INTCONST

			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->constNode("literal","intconst", "4", to_string($1));
			 a = new attr("const",to_string($1),"","4","");
			 top->put(to_string($1), a);
			 $$->node->atr = a;
			 cout<<"\tinstalled "<<$1<<" : ";a->print();cout<<endl;}

			|FLOATCONST

			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->constNode("literal","floatconst", "4", to_string($1));
			 a = new attr("const",to_string($1),"","4","");
			 top->put(to_string($1), a);
			 $$->node->atr = a;
			 cout<<"\tinstalled "<<$1<<" : ";a->print();cout<<endl;}

			|CHARCONST

			{$$ = new node(new Node(),NULL,NULL);
			 $$->node->constNode("literal","charconst", "1", $1);
			 a = new attr("const",$1,"","1","");
			 top->put($1, a);
			 $$->node->atr = a;
			 cout<<"\tinstalled "<<$1<<" : ";a->print();cout<<endl;};
			

%%

int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		cout<<"Usage: <exefile> <inputfile>"<<endl;
       		exit(0);
	}
	yyin = fopen(argv[1], "r");
	cout<<"\n\n-----------------------------------------------------------------"<<endl;
	cout<<"    		WORKING OF THE SYMBOL-TABLE   			"<<endl;
	cout<<"-----------------------------------------------------------------\n\n"<<endl;
	yyparse();
	return 0;
}

int yyerror(string s){
	cout<<"Error: "<<s<<endl;
	return 0;
}

int size(string s){
	if(s=="int"){
		return 4;
	}
	else if(s=="float"){
		return 4;
	}
	else if(s=="char"){
		return 1;
	}
	else {
		return 0;
	}
}

void preorder(node* ptr){
	if(ptr!=NULL){
		if(ptr->node!=NULL){
		  ptr->node->print();		
		}
		preorder(ptr->left);
		preorder(ptr->right);
	}
}
