open: 
	google-chrome test/out*.html

testall: t1 t2 t3 t4

t4: do
	./exec <test/in4.md >test/out4.html

t3: do
	./exec <test/in3.md >test/out3.html

t2: do
	./exec <test/in2.md >test/out2.html

t1: do
	./exec <test/in1.md >test/out1.html

do:
	flex converter.l 
	gcc lex.yy.c -o exec

clean:
	rm lex.yy.c exec
	rm test/out*.html
