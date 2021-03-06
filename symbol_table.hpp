#include <iostream>
#include <unordered_map>
using namespace std;

class attr{

	public:

		string type;
		string val;
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
