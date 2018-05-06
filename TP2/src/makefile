CFLAGS=-Wall -Wextra -ansi -pedantic -O2 -g
OBJS=$(patsubst %.c,%.o,$(wildcard *.c))
LIBS=

prot: $(OBJS)
	$(CC) $(CFLAGS) -o prot $(OBJS) $(LIBS) 

open: 
	google-chrome test/out*.html

test4: test3
	./exec <test/in4.md >test/out4.html
#	diff out4.html fin4.html

test3: test2
	./exec <test/in3.md >test/out3.html
#	diff out3.html fin3.html

test2: test1
	./exec <test/in2.md >test/out2.html
#	diff out2.html fin2.html

test1: do
	./exec <test/in1.md >test/out1.html
#	diff out1.html fin1.html

do:
	flex converter.l 
	gcc lex.yy.c -o exec

clean:
	rm lex.yy.c exec
	rm test/out*.html
