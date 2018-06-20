open: 
	google-chrome test/out*.html

testall: t1 t2 t3 t4

ex: do
	./mdhtml <exemplo.md >exemplo.html

t4: do
	./mdhtml <test/in4.md >test/out4.html

t3: do
	./mdhtml <test/in3.md >test/out3.html

t2: do
	./mdhtml <test/in2.md >test/out2.html

t1: do
	./mdhtml <test/in1.md >test/out1.html

do:
	flex converter.l 
	gcc lex.yy.c -o mdhtml

clean:
	rm lex.yy.c mdhtml
	rm test/out*.html
