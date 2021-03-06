parser: y.tab.c lex.yy.c y.tab.h ast_nodes.hpp.gcc symbol_table.hpp.gcc
	@ g++ -Wno-write-strings y.tab.c lex.yy.c -g -ll -ly -o parser
lex.yy.c: lexer.l
	@ lex lexer.l
y.tab.c: parser.y
	@ yacc -v -d -t -g parser.y
ast_nodes.hpp.gcc: ast_nodes.hpp
	@ g++ ast_nodes.hpp
symbol_table.hpp.gcc: symbol_table.hpp
	@ g++ symbol_table.hpp

clean:
	@ rm -f myparser y.tab.c lex.yy.c y.tab.h y.output
