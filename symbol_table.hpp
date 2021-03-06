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
			if(type!="") cout<<type<<" ";
			if(data_type!="") cout<<data_type<<" ";
			if(val!="") cout<<val<<" ";
			if(size!="") cout<<size<<" ";
			if(addr!="") cout<<addr<<" ";
			if(ret_type!="") cout<<ret_type<<" ";
			if(number_of_args!="") cout<<number_of_args<<" ";
		}
};

class Env {

	public:

		unordered_map<string, attr*> table;
		Env *prev;

		Env(Env *p){
			prev = p;
		}
	
		void put(string s, attr *a){
			table.insert({s,a});
		}

		attr* get(string s){
			for( Env *e = this; e!=NULL; e = e->prev){
				auto found = (e->table).find(s);
				if(found!=table.end()) return found->second;
			}
			return NULL;
		}

};