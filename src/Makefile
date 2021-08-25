parser: y.tab.c lex.yy.c y.tab.h symbol_table.hpp.gch ast_nodes.hpp.gch code_gen.hpp.gch
	@ g++ -Wno-write-strings y.tab.c lex.yy.c -g -ll -ly -o compiler && mv compiler test
lex.yy.c: lexer.l
	@ lex lexer.l
y.tab.c: parser.y
	@ yacc -v -d -t -g parser.y
symbol_table.hpp.gch: symbol_table.hpp
	@ g++ symbol_table.hpp
ast_nodes.hpp.gch: ast_nodes.hpp
	@ g++ ast_nodes.hpp
code_gen.hpp.gch: code_gen.hpp
	@ g++ code_gen.hpp

clean:
	@ rm -f myparser y.tab.c lex.yy.c y.tab.h y.dot y.output symbol_table.hpp.gch code_gen.hpp.gch ast_nodes.hpp.gch compiler
