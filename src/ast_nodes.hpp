// ast_nodes.hpp
/* classes - Node, Expression, ConstExpr, UnaryExpr, BinaryExpr, Loc
   Stmts, Stmt, AssgnStmt, PrintLocStmt, PrintStringStmt, IfStmt
   BoolExpr, UnaryBool, BinaryBool, RelBool, ConstBool */
// functions - Gen

//import code generation module
#include "code_gen.hpp"

//string that stores the assembly code
string asmcode = "";

//labels
int labelvar = 0;

string label(){
	labelvar++;
	return "L" + to_string(labelvar);
}

//AST NODES - code starts

//Node

class Node{
public:
	string igcode;	//intermediate code
	string asmlycode; //assembly code - mips
};

//Expressions section

class Expression : public Node{
public:
	string exprtype;	//const
	string id;
	attr* a;
};

//Location (identifier)

class Loc : public Expression{
public:
	Loc(string id, attr* a){
		this->id = id;
		this->a = a;
		this->exprtype = "LocExpr";
	}
};

//Constant Expression

class ConstExpr : public Expression{
public:
	void igGen(){
		this->igcode = this->id + " = " + to_string(this->a->val); 
	}
	void asmGen(){
		getReg(this->a, true);
	}
	ConstExpr(string id, attr* a){
		this->id = id;
		this->a = a;
		this->exprtype = "ConstExpr";
		//this->igGen();
		this->asmGen();
	}
};

//Unary Expression

class UnaryExpr : public Expression{
public:
	string op;
	Expression* expr;

	void igGen(){
		this->igcode = this->id + " = " + op + " " + expr->id;
	}

	void asmGen(){
		int currReg1 = getReg(this->a, false);
		int currReg2 = getReg(expr->a, true);
		this->asmlycode += space()+"sub $"+to_string(currReg1)+", $0"+", $"+to_string(currReg2)+"\n";
		asmcode += this->asmlycode;
	}

	UnaryExpr(string id, attr* a, string op, Expression* expr){
		this->id = id;
		this->a = a;
		this->op = op;
		this->expr = expr;
		this->exprtype = "UnaryExpr";
		this->igGen();
		this->asmGen();
	}
};

//Binary Expression

class BinaryExpr : public Expression{
public:
	string op;
	Expression* expr1;
	Expression* expr2;

	void igGen(){
		this->igcode = this->id + " = " + expr1->id + " " + op + " " + expr2->id;
	}

	void asmGen(){
		int currReg1 = getReg(this->a, false);
		int currReg2 = getReg(expr1->a, true);
		int currReg3 = getReg(expr2->a, true);

		if(op=="+") op = "add";
		else if(op=="-") op = "sub";
		else if(op=="*") op = "mul";
		else if(op=="/") op = "div";

		this->asmlycode += space()+op+" $"+to_string(currReg1)+", $"+to_string(currReg2)+", $"+to_string(currReg3)+"\n";

		asmcode += this->asmlycode;
	}

	BinaryExpr(string id, attr* a, string op, Expression* expr1, Expression* expr2){
		this->id = id;
		this->a = a;
		this->op = op;
		this->expr1 = expr1;
		this->expr2 = expr2;
		this->exprtype = "BinaryExpr";	
		this->igGen();
		this->asmGen();
	}
};

//Statement

class Stmt : public Node{};

//Statements

class Stmts : public Node{
public:
	Stmt* stmt;
	Stmts* stmts;
	Stmts(Stmt* stmt, Stmts* stmts){
		this->stmt = stmt;
		this->stmts = stmts;
	}
};

//Assignment Statements

class AssgnStmt : public Stmt{
public:
	Loc* loc;
	Expression* expr;

	void igGen(){
		this->igcode = loc->id+" = "+expr->id;
	}

	void asmGen(){
		int currReg1 = getReg(loc->a, false);
		int currReg2 = getReg(expr->a, true);
		this->asmlycode += space()+"move $"+to_string(currReg1)+", $"+to_string(currReg2)+"\n";

		asmcode += this->asmlycode;
	}
	AssgnStmt(Loc* loc, Expression* expr){
		this->loc = loc;
		this->expr = expr;
		this->igGen();
		this->asmGen();
	}
};

//Print Statements

class PrintLocStmt : public Stmt{
public:
	Loc* loc;

	void igGen(){
		this->igcode = "print " + loc->id;
	}

	void asmGen(){
		this->asmlycode += space()+"li $v0, 1"+"\n";
		this->asmlycode += space()+"move $a0, $"+to_string(getReg(loc->a, true))+"\n";
		this->asmlycode += space()+"syscall"+"\n";

		asmcode += this->asmlycode;
	}

	PrintLocStmt(Loc* loc){
		this->loc = loc;
		this->igGen();
		this->asmGen();
	}
};

class PrintStringStmt : public Stmt{
public:
	string str;

	void igGen(){
		this->igcode = "print " + str;
	}

	void asmGen(){
		this->asmlycode += space()+"li $v0, 4"+"\n";
		this->asmlycode += space()+"la $a0, "+str+"\n";
		this->asmlycode += space()+"syscall"+"\n";

		asmcode += this->asmlycode;
	}

	PrintStringStmt(string str){
		this->str = str;
		this->igGen();
		this->asmGen();
	}
};

//Get values into a variable - Get statement

class GetStmt : public Stmt{
public:
	Loc* loc;

	void igGen(){
		this->igcode = "get " + loc->id;
	}

	void asmGen(){
		this->asmlycode += space()+"li $v0, 5"+"\n";
		this->asmlycode += space()+"syscall"+"\n";
		this->asmlycode += space()+"move $"+to_string(getReg(loc->a, true))+", $v0\n";
		
		asmcode += this->asmlycode;
	}

	GetStmt(Loc* loc){
		this->loc = loc;
		this->igGen();
		this->asmGen();
	}
};

//Booleans Section

class BoolExpr : public Node{
public:
	string id;
	attr* a;
	string Btrue;
	string Bfalse;
	string booltype;
};

void Gen(BoolExpr*);

//Unary Boolean

class UnaryBool : public BoolExpr{
public:
	string op;
	BoolExpr* bexpr;
	void gen(){
		bexpr->Btrue = this->Bfalse;
		bexpr->Bfalse = this->Btrue;
		Gen(bexpr);
	}
	UnaryBool(BoolExpr* bexpr){
		this->booltype = "UnaryBool";
		this->bexpr = bexpr;
	}
};

//Relational Boolean

class RelBool : public BoolExpr{
public:
	string op;
	Expression* expr1;
	Expression* expr2;

	void igGen(){
		this->igcode = "if " + expr1->id + " " + op + " " + expr2->id + " goto" + this->Btrue;
		this->igcode += "\ngoto "+this->Bfalse;
	}

	void asmGen(){
		int currReg1 = getReg(this->a, false);
		int currReg2 = getReg(expr1->a, true);
		int currReg3 = getReg(expr2->a, true);

		if(op=="<"){
			this->asmlycode += space() + "slt $" + to_string(currReg1) + ", $" + to_string(currReg2) + ", $" + to_string(currReg3) + "\n";
			this->asmlycode += space() + "bne $" + to_string(currReg1) + ", $0, " +  Btrue + "\n";
		}
		else if(op=="<="){
			this->asmlycode += space() + "slt $" + to_string(currReg1) + ", $" + to_string(currReg2) + ", $" + to_string(currReg3) + "\n";
			this->asmlycode += space() + "beq $" + to_string(currReg1) + ", $0, " +  Btrue + "\n";
		}
		else if(op==">"){
			this->asmlycode += space() + "slt $" + to_string(currReg1) + ", $" + to_string(currReg3) + ", $" + to_string(currReg2)+ "\n";
			this->asmlycode += space() + "bne $" + to_string(currReg1) + ", $0, " +  Btrue + "\n";
		}
		else if(op==">="){
			this->asmlycode += space() + "slt $" + to_string(currReg1) + ", $" + to_string(currReg3) + ", $" + to_string(currReg2)+ "\n";
			this->asmlycode += space() + "beq $" + to_string(currReg1) + ", $0, " +  Btrue + "\n";
		}
		else if(op=="=="){
			this->asmlycode += space() + "beq $" + to_string(currReg2) + ", $" + to_string(currReg3) + ", " + Btrue + "\n";
		}
		else if(op=="!="){
			this->asmlycode += space() + "bne $" + to_string(currReg2) + ", $" + to_string(currReg3) + ", " + Btrue + "\n";
		}
		this->asmlycode += space() + "j " + Bfalse + "\n";

		asmcode += this->asmlycode;
	}

	void gen(){
		this->igGen();
		this->asmGen();
	}

	RelBool(string id, attr* a, string op, Expression* expr1, Expression* expr2){
		this->booltype = "RelBool";
		this->id = id;
		this->a = a;
		this->op = op;
		this->expr1 = expr1;
		this->expr2 = expr2;
	}
};

//ConstBoolean

class ConstBool	: public BoolExpr{
public:
	string bval;
	void igGen(){
		if(bval=="false"){
			this->igcode += "goto "+ Bfalse;
		}
		else if(bval=="true"){
			this->igcode += "goto "+ Btrue;
		}
	}
	void asmGen(){
		if(bval=="false"){
			this->asmlycode += space()+"j "+ Bfalse+"\n";
		}
		else if(bval=="true"){
			this->asmlycode += space()+"j "+ Btrue+"\n";
		}
		asmcode += this->asmlycode;
	}
	void gen(){
		this->igGen();
		this->asmGen();
	}
	ConstBool(string bval){
		this->booltype = "ConstBool";
		this->bval = bval;
	}
};

//Binary Boolean

class BinaryBool : public BoolExpr{
public:
	string op;
	BoolExpr* bexpr1;
	BoolExpr* bexpr2;

	void igGen(){
		this->igcode = bexpr1->igcode + "\n" + bexpr1->Bfalse + bexpr2->igcode;
	}

	void asmGen(){
		if(op=="&&"){
			this->asmlycode += bexpr1->Btrue + ":\n";
		}
		else if(op=="||"){
			this->asmlycode += bexpr1->Bfalse + ":\n";	
		}
		asmcode += this->asmlycode;
	}

	void gen(){
		if(op=="&&"){
			bexpr1->Btrue = label();
			bexpr1->Bfalse = this->Bfalse;
			bexpr2->Btrue = this->Btrue;
			bexpr2->Bfalse = this->Bfalse;
		}
		else if(op=="||"){
			bexpr1->Btrue = this->Btrue;
			bexpr1->Bfalse = label();
			bexpr2->Btrue = this->Btrue;
			bexpr2->Bfalse = this->Bfalse;
		}

		Gen(bexpr1);
		this->asmGen();
		Gen(bexpr2);
		this->igGen();
	}

	BinaryBool(string op, BoolExpr* bexpr1, BoolExpr* bexpr2){
		this->booltype = "BinaryBool";
		this->op = op;
		this->bexpr1 = bexpr1;
		this->bexpr2 = bexpr2;
	}	
};

//If statement

class IfStmt : public Stmt{
public:
	BoolExpr* bexpr;
	void gen(){
		Gen(bexpr);
		asmcode += bexpr->Btrue + ":\n";
	}
	IfStmt(BoolExpr* bexpr){
		this->bexpr = bexpr;
		bexpr->Btrue = label();
		bexpr->Bfalse = label();
		this->gen();
	}
};

// code generation helper function for control flow statements

void Gen(BoolExpr* bexpr){
	if(bexpr->booltype=="BinaryBool"){
		((BinaryBool*)bexpr)->gen();
	}
	else if(bexpr->booltype=="UnaryBool"){
		((UnaryBool*)bexpr)->gen();
	}
	else if(bexpr->booltype=="RelBool"){
		((RelBool*)bexpr)->gen();
	}
	else if(bexpr->booltype=="ConstBool"){
		((ConstBool*)bexpr)->gen();
	}
}

//AST NODES - code end