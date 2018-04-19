CFLAGS=-Wall -Wextra -ansi -pedantic -O2 -g
OBJS=$(patsubst %.c,%.o,$(wildcard *.c))
LIBS=

prot: $(OBJS)
	$(CC) $(CFLAGS) -o prot $(OBJS) $(LIBS) 

do:
	flex converter.l 
	gcc lex.yy.c -o exec