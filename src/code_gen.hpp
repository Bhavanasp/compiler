//code_gen.hpp
//functions - spcae, init, getReg, storeDtata, PrintDataSeg, printMipsCode

//import the symbol table module
#include "symbol_table.hpp"

extern string asmcode; //shared accross all files - a variable to store assembly code

//REGISTER DESCRIPTOR - code start

#define SIZE 17 //number of registers available

int reg_to_free = 8; //general purpose registers start from 8

vector<vector<attr*>> regdesc(SIZE); //register descriptor

//function to put spaces

string space(){
	return "       ";
}

//initialize the register descriptor

void init(){
	for(int i = 0;i<SIZE;i++){
		vector<attr*> locs;
		regdesc[i] = locs;
	}
}

//allocate a register for a variable or a temporary

int getReg(attr* a, bool load){

	if(a->reg!=-1) return a->reg;

	reg_to_free++;

	if(reg_to_free==9+SIZE){
		reg_to_free = 9;
	}

	for(int i = 0;i<SIZE;i++){
		if(regdesc[i].empty()){
			a->reg = i+9;
			regdesc[i].push_back(a);
			if(load) asmcode += space()+"lw $"+to_string(a->reg)+", "+to_string(a->offset)+"($8)"+"\n";
			return a->reg;
		};
	}

	for(auto iter = regdesc[reg_to_free-9].begin(); iter != regdesc[reg_to_free-9].end(); iter++){
		asmcode += space()+"sw $"+to_string(reg_to_free)+", "+to_string((*iter)->offset)+"($8)"+"\n";
		(*iter)->reg = -1;
	}

	regdesc[reg_to_free-9].clear();
	a->reg = reg_to_free;
	regdesc[reg_to_free-9].push_back(a);

	if(load) asmcode += space()+"lw $"+to_string(a->reg)+", "+to_string(a->offset)+"($8)"+"\n";

	return reg_to_free;
}

//datasegment generation for mips assembly code

void storeData(){
	for(int reg = 0; reg<SIZE; reg++){
		for(auto iter = regdesc[reg].begin(); iter != regdesc[reg].end(); iter++){
			asmcode += space()+"sw $"+to_string(reg+9)+", "+to_string((*iter)->offset)+"($8)"+"\n";
			(*iter)->reg = -1;
		}
	}
}

//printing the datasegmenet

string printDataSeg(){
	return top->printData();
}

//printing the mips code to the outfile

string printMipsCode(){
	asmcode  =  string(".data\n			.word	")
		+ printDataSeg() + string("\n")
		+ string(".text")+ string("\n")
		+ string(".globl main") + string("\n\n")
		+ asmcode;
 	return asmcode;
 }

//REGISTER DESCRIPTOR - code end
