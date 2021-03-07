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
#include <string>
#include "symbol_table.hpp"
using namespace std;

class Node{
	public:
		string ntype = "";
		string type = "";
		string size = "";
		string op = "";
		string val = "";
		string offset = "";
		attr* atr = NULL;

		void constNode(string ntype, string type, string size, string val){
			this->ntype = ntype;
			this->type = type;
			this->size = size;
			this->val = val;
		};

		void print(){
			cout<<"\n----------------------------------"<<endl;
			if(ntype!="") cout<<"node_type: "<<ntype<<endl;
			if(type!="") cout<<"type: "<<type<<endl;
			if(size!="") cout<<"size: "<<size<<endl;
			if(op!="") cout<<"operator: "<<op<<endl;
			if(val!="") cout<<"value: "<<val<<endl;
			if(offset!="") cout<<"offset: "<<offset;
			cout<<"----------------------------------"<<endl;
		}
};
