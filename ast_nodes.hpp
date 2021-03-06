//stmts Seq
//expr Eval
//if IF
//while While
//assgn Assign
//rel Rel
//add sub mul div Op
//intcont floatconst Num - leaves??

//class if extends stmt

//Expr lval
//Expr rval


#include <iostream>
using namespace std;


class SymTabNode{
	public:
		int* a;
};

class Node{
	public:
		string ntype;
		string type;
		string size;
		string op;
		string val;

		void constNode(string ntype, string type, string size, string val){
			this->type = type;
			this->size = size;
			this->val = val;
		};
};
