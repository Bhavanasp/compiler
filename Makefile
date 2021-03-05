parser: y.tab.c lex.yy.c y.tab.h
	@ g++ -Wno-write-strings y.tab.c lex.yy.c -g -ll -ly -o parser
lex.yy.c: lexer.l
	@ lex lexer.l
y.tab.c: parser.y
	@ yacc -v -d -t -g parser.y
clean:
	@ rm -f myparser y.tab.c lex.yy.c y.tab.h y.output
