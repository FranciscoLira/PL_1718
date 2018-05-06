%x CONVERTER

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int q;
int st;	
char** stack;


/*This function makes print of inline a header in html
	t: # of tabs to indent
	tag: html tag that should be used
	sb: quantity of arguments to surpress in the begining
	se: quantity of arguments to surpress in the begining
	str: content of tag
*/

void printin(int t,char* tag, int sb, int se, char* str){
	int tmp = -2;
	while(tmp<t){
		printf("\t");
		tmp++;
	}
	str[se-1]=0;
	printf("<%s>",tag);
	printf("%s",&str[sb]);
	tmp = -2;
	printf("</%s>",tag);
}

%}

%%

#{6}\ ?[^\n]+			printin(q,"h6",6,0,yytext);
#{5}\ ?[^\n]+			printin(q,"h5",5,0,yytext);
#{4}\ ?[^\n]+			printin(q,"h4",4,0,yytext);
###\ ?[^\n]+			printin(q,"h3",3,0,yytext);
##\ ?[^\n]+				printin(q,"h2",2,0,yytext);
#\ ?[^\n]+				printin(q,"h1",1,0,yytext);
~~[^\n]+~~				printin(-2,"s",2,2,yytext);
__[^\n]+__				printin(-2,"b",2,2,yytext);
\*\*[^\n]+\*\*			printin(-2,"b",2,2,yytext);
_[^\n]+_				printin(-2,"i",1,1,yytext);
\*[^\n]+\*				printin(-2,"i",1,1,yytext);
\[[A-Za-z\ ]+\]\([(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4}]\)	printin(q,"HERE",0,0,"lixo");
(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4} 	printin(q,"a href=",0,0,"lixo");

%%

void stackDouble(){
	int t = 0;
	char** newstack = (char**)malloc(sizeof(char*)*st*2);
	while(t<st){
		newstack[t]=stack[t];
		t++;
	}
	st = st*2;
	free(stack);
	stack = newstack;
}

void stackAdd(char* tag){
	strcpy(stack[q],tag);
	q++;
	if(q>st){
		stackDouble();
	}
}

void stackRemove(){
	free(stack[q--]);
}

char* stackGet(){
	return stack[q];
}

int yywrap(){
	return 1;
}

int main(){
	int s;
	q = 0;
	st = 15;
	stack = (char**)malloc(sizeof(char*)*st);
	printf("<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>HTML from MARKDOWN</title>\n\t</head>\n\t<body>\n");
	while(s=yylex()){
		printf("%d",s);
	}
	yylex();
	printf("\n\t</body>\n</html>");

	return 0;
}