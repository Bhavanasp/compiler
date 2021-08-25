%{  //parsery.y - contains the grammar and related actions integrated with abstract tree and code generations
    //and symbol table usage

	//import abstract syntax-tree node definitions (classes)
	#include "ast_nodes.hpp"

	using namespace std;

	//input file
	extern FILE* yyin;

	int yylex();
	int yyerror(string s);
	int size(string s);

	//allocates temporaries for intermediate code generation
	string temp(int val);

	int tempvar = 0;

	//a number to keep track of the strung constants(occur only in print statements)
	int strvar = 0;

	//vector to keep track of nested if, if-else and loop control flow structures
	vector <IfStmt*> ifstmt;

    //storage for labels generated in the assembly code
	vector <string> next_label;

%}

%union {

	//datatypes for the lexemes/tokens obtained from the lexer

	int ival;
	float fval; 
	char text[300];

	class Node* node;
	class Stmts* stmts;
	class Stmt* stmt;
	class AssgnStmt* assgn_stmt;
	class Expression* expr;
	class UnaryExpr* unary_expr;
	class BinaryExpr* binary_expr;
	class ConstExpr* const_expr;
	class Loc* loc;
	class PrintStmt* print_stmt;
	class BoolExpr* bool_expr;
	class ConstBool* const_bool;
	class RelBool* rel_bool;
	class UnaryBool* unary_bool;
	class BinaryBool* binary_bool;
	class IfStmt* if_stmt;
}

//tokens

%token INIT
%token INT
%token INTCONST STRCONST
%token TRUE FALSE
%token ID
%token COMMA SCOL
%token IF ELSE
%token LOOP
%token PRINT
%token GET
%token ASSGN
%token PLUS MINUS MUL DIV
%token LES LEQ GRE GEQ EQL NEQ
%token AND OR NOT
%token LSBR RSBR
%token LPBR RPBR
%token LFBR RFBR
%token ERR

//precedence and associativity of operators

%left ASSGN
%left OR
%left AND
%left EQL NEQ
%left LES LEQ
%left GEQ GRE
%left PLUS MINUS
%left MUL DIV
%right NOT
%right UMINUS
%left BRAC
%right NOELSE ELSE

//type specification for non terminals and terminals in the following grammar rules (cfg)

%type <stmt> stmt IF
%type <loc> loc
%type <text> ID TRUE FALSE STRCONST
%type <ival> INTCONST
%type <expr> expr
%type <bool_expr> bool
%type <text> ASSGN OR AND EQL NEQ LES LEQ GEQ GRE PLUS MINUS MUL DIV NOT
%type <stmts> stmts prog


%%

start		:	prog

			;

prog		:	INIT 

				{
					asmcode += "main:\n"; //main in the mips file
					asmcode +=  space()+string("lui $8, 0x1001")+"\n"; //initial address from which datasegment is allocated 
				}

				LFBR stmts RFBR

				{
					storeData();	//datasegment in the mips file
					asmcode += space()+"jr $ra\n";
				}

			;

stmts		:	stmt stmts

				{
					$$ = new Stmts($1, $2);
				}

			|	{	$$ = NULL; }

			;

stmt		:	INT ID SCOL

				{
					//declarations
					//create a new symbol table entry and insert into the symbol table
					int width = size("int");
					a = new attr(0, offset, "int", width);
					top->put($2, a);
					offset = offset+size("int");
					$$ = NULL;
				}

			|	loc ASSGN expr SCOL

				{
					//assignments
					$$ = new AssgnStmt($1, $3);
				}

			|	IF LPBR condition RPBR LFBR stmts RFBR

				%prec NOELSE

				{ 
					//if statments
					asmcode = asmcode + ifstmt[ifstmt.size()-1]->bexpr->Bfalse + ":\n";
					ifstmt.pop_back();
				} 

			|	IF LPBR condition RPBR 

				LFBR stmts RFBR

				ELSE

				{ 
					//if-else statements
					next_label.push_back(label());
					asmcode = asmcode + space() + "j " + next_label[next_label.size()-1] + "\n" + ifstmt[ifstmt.size()-1]->bexpr->Bfalse + ":\n";
				}

				LFBR stmts RFBR 

				{   
					asmcode = asmcode + next_label[next_label.size()-1] + ":\n";
					ifstmt.pop_back();
				  	next_label.pop_back();
				}


			|	LOOP LPBR

				{
					//loop statements
					next_label.push_back(label());
					asmcode = asmcode + next_label[next_label.size()-1] + ":\n";
				}

				condition RPBR

				LFBR stmts RFBR 

				{
					asmcode = asmcode + space() + "j " + next_label[next_label.size()-1] + "\n" + ifstmt[ifstmt.size()-1]->bexpr->Bfalse + ":\n";
					ifstmt.pop_back();
					next_label.pop_back();
				}

			|	PRINT LPBR STRCONST RPBR SCOL

				{
					//print a string statements
					string str = "";
					str += "str" + to_string(strvar);
					strvar++;
					$$ = new PrintStringStmt(str);
					str = "\n\t\t\t" + str + ": .asciiz	" + $3;
					strdata.push_back(str);
				}

			|	PRINT LPBR loc RPBR SCOL

				{   
				    //print a variable's value statements
					$$ = new PrintLocStmt($3);
				}

			|	GET LPBR loc RPBR SCOL

				{
					//read user input into a variable
					$$ = new GetStmt($3);
				}

			;

condition	:	bool

				{
					//conditions in the control flow statements
					ifstmt.push_back(new IfStmt($1));
				}

			;

bool 		:	bool OR bool

				{
					$$ = new BinaryBool($2, $1, $3);
				}

			|	bool AND bool

				{
					$$ = new BinaryBool($2, $1, $3);
				}

			|	NOT bool

				{
					$$ = new UnaryBool($2);
				}

			|	LPBR bool RPBR %prec BRAC

				{
					$$ = $2;
				}

			|	expr EQL expr

				{
					$$ = new RelBool(temp(0), a, $2, $1, $3);
				}

			|	expr NEQ expr

				{
					$$ = new RelBool(temp(0), a, $2, $1, $3);
				}

			|	expr GRE expr

				{
					$$ = new RelBool(temp(0), a, $2, $1, $3);
				}

			|	expr GEQ expr

				{
					$$ = new RelBool(temp(0), a, $2, $1, $3);
				}

			|	expr LES expr

				{
					$$ = new RelBool(temp(0), a, $2, $1, $3);
				}			

			|	expr LEQ expr

				{
					$$ = new RelBool(temp(0), a, $2, $1, $3);
				}

			|	TRUE

				{
					$$ = new ConstBool($1);
				}

			|	FALSE

				{
					$$ = new ConstBool($1);
				}

			;

expr		:	expr PLUS expr

				{
					$$ = new BinaryExpr(temp(0), a, $2, $1, $3);
				}

			|	expr MINUS expr

				{
					$$ = new BinaryExpr(temp(0), a, $2, $1, $3);
				}

			|	expr MUL expr

				{
					$$ = new BinaryExpr(temp(0), a, $2, $1, $3);
				}

			|	expr DIV expr

				{
					$$ = new BinaryExpr(temp(0), a, $2, $1, $3);
				}

			|	LPBR expr RPBR %prec BRAC

				{
					$$ = $2;
				}

			|	MINUS expr %prec UMINUS

				{
					$$ = new UnaryExpr(temp(0), a, $1, $2);
				}

			|	loc

				{
					$$ = $1;
				}

			|	INTCONST

				{	
					$$ = new ConstExpr(temp($1), a);
				}

			;

loc			:	ID

				{
					a = top->get($1);
					if(a==NULL){
						cout<<"Error: "<< $1 <<" has no declaration"<<endl;
						exit(0);
					}
					$$ = new Loc($1,a);
				}

			;

%%

int main(int argc, char *argv[]){
	if(argc != 3)
	{
		cout<<"Usage: ./<exefile> <inputfile> <outputfile>"<<endl;
       	exit(0);
	}
	yyin = fopen(argv[1], "r");
	FILE* outfile = fopen(argv[2], "w");
	init();
	yyparse();
	fprintf(outfile, "%s", printMipsCode().c_str());
	fclose(yyin);
	fclose(outfile);
	return 0;
}

int yyerror(string s){
	cout<<"Error: "<<s<<endl;;
	exit(0);
}

int size(string s){	if(s=="int"){
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

string temp(int val){
	tempvar++;
	string temperory = "#" + to_string(tempvar);
	int width = size("int");
	a = new attr(val, offset, "int", width);
	top->put(temperory, a);
	offset = offset+size("int");
	return temperory;
}