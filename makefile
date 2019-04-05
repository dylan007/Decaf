build: 
	bison -d Decaf.y
	flex Decaf.l
	gcc lex.yy.c Decaf.tab.c -o parse


clean:
	rm *.tab.h *.tab.c lex.yy.c *.gch sym

run:
	./parse