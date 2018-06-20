make: do clean

do: linked createhtml flex yacc
	@gcc -s -Wall -o test y.tab.c lex.yy.c createhtml.c linked.c

yacc: 
	@yacc -d dicionario.y

flex: 
	@flex dicionario.l

createhtml: createhtml.c createhtml.h
	@gcc -c -g -Wall createhtml.c

linked: linked.c linked.h
	@gcc -c -g -Wall linked.c

cleanhtml:
	@rm files/dists/*.html files/*.html


clean:
	@rm -f lex.yy.c lex.texto.c y.tab.c y.tab.h 
	@rm -rf ../html
	@rm -f *.o
	@rm -f ../sttc