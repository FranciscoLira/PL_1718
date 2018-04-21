%x converter

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int q = 0;
char* stack [15];

void printer(int i,char* tag,char* str){
	int tmp=-2;
	while(tmp<i){
		printf("\t");
		tmp++;
	}printf("%s",tag);
}

%}

%%

#{6}\ ?[^\n]+			printer(q,"<h6>",stack[q]);
#{5}\ ?[^\n]+			printer(q,"<h5>",stack[q]);
#{4}\ ?[^\n]+			{	
				printf("\t<h4>\n\t\t%s\n\t</h4>\n ",&yytext[4]);}
###\ ?[^\n]+			{	
				printf("\t<h3>\n\t\t%s\n\t</h3>\n ",&yytext[3]);}
##\ ?[^\n]+				{	
				printf("\t<h2>\n\t\t%s\n\t</h2>\n ",&yytext[2]);}
#\ ?[^\n]+				{	
				printf("\t<h1>\n\t\t%s\n\t</h1>\n ",&yytext[1]);}
~~[^\n]+~~				{	
				yytext[yyleng-2]=0;
				printf("<s>%s</s>",&yytext[2]);}
__[^\n]+__				{	
				yytext[yyleng-2]=0;
				printf("<b>%s</b>",&yytext[2]);}
_[^\n]+_				{	
				yytext[yyleng-1]=0;
				printf("<i>%s</i>",&yytext[1]);}
\[[A-Za-z\ ]+\]\([(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4}]\)	{
				printf("HERE");
}	
(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4} {
				printf("<a href=\"%s\">lixo</a>",yytext);}


%%


int yywrap(){
	return 1;
}

int main(){
	int s;
	printf("<!DOCTYPE html>\n\t<html>\n\t\t<head>\n\t\t\t<title>HTML from MARKDOWN</title>\n\t\t</head>\n\t<body>\n");
	while(s=yylex()){
		printf("%d",s);
	}
	yylex();
	printf("</body>\n</html>");

	return 0;
}