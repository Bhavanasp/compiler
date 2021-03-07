#include <iostream>
#include <unordered_map>
#include <string>
using namespace std;

class attr{

	public:
		string type; //array or function or variable
		string data_type; //int or float
		string val; //value assigned if any
		string size; //in bytes
		string addr; //address (start address in case of array)

		string ret_type;	//only for functions
		string number_of_args;  //only for functions

		attr(string type, string data_type, string val, string size, string addr){
			this->type = type;
			this->data_type = data_type;
			this->val = val;
			this->size = size;
			this->addr = addr;
		}

		void print(){
			cout<<"( ";
			if(type!="") cout<<"type: "<<type;
			if(data_type!="") cout<<", data_type: "<<data_type;
			if(val!="") cout<<", value: "<<val;
			if(size!="") cout<<", size: "<<size;
			if(addr!="") cout<<", address: "<<addr;
			if(ret_type!="") cout<<", return_type: "<<ret_type;
			if(number_of_args!="") cout<<", number_of_args: "<<number_of_args;
			cout<<" )";
		}
};

class Scope {

	public:

		unordered_map<string, attr*> table;
		Scope *prev;

		Scope(Scope *p){
			prev = p;
		}
	
		void put(string s, attr *a){
			table.insert({s,a});
		}

		attr* get(string s){
			for( Scope *scp = this; scp!=NULL; scp = scp->prev){
				auto found = (scp->table).find(s);
				if(found!=table.end()) return found->second;
			}
			return NULL;
		}

};
