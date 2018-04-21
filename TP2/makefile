CFLAGS=-Wall -Wextra -ansi -pedantic -O2 -g
OBJS=$(patsubst %.c,%.o,$(wildcard *.c))
LIBS=

prot: $(OBJS)
	$(CC) $(CFLAGS) -o prot $(OBJS) $(LIBS) 


test4: test3
	./exec <in4.md >out4.html
#	diff out4.html fin4.html

test3: test3
	./exec <in3.md >out3.html
#	diff out3.html fin3.html

test2: test1
	./exec <in2.md >out2.html
#	diff out2.html fin2.html

test1: do
	./exec <in1.md >out1.html
#	diff out1.html fin1.html

do:
	flex converter.l 
	gcc lex.yy.c -o exec

clean:
	rm lex.yy.c exec
