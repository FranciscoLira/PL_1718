%x SOMA

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char* tmpstr;

%}

%%

#{6}\ ?[^\n]+			printf("\t<h6>\n\t\t%s\n\t</h6>\n ",&yytext[6]);
#{5}\ ?[^\n]+			printf("\t<h5>\n\t\t%s\n\t</h5>\n ",&yytext[5]);
#{4}\ ?[^\n]+			printf("\t<h4>\n\t\t%s\n\t</h4>\n ",&yytext[4]);
###\ ?[^\n]+			printf("\t<h3>\n\t\t%s\n\t</h3>\n ",&yytext[3]);
##\ ?[^\n]+				printf("\t<h2>\n\t\t%s\n\t</h2>\n ",&yytext[2]);
#\ ?[^\n]+				printf("\t<h1>\n\t\t%s\n\t</h1>\n ",&yytext[1]);
~~[^\n]+~~				{yytext[yyleng-2]=0 ; printf("<s>%s</s>",&yytext[2]);}
__[^\n]+__				{yytext[yyleng-2]=0 ; printf("<b>%s</b>",&yytext[2]);}
_[^\n]+_				{yytext[yyleng-1]=0 ; printf("<i>%s</i>",&yytext[1]);}


%%

int yywrap(){
	return 1;
}

int main(){
	int s;
	printf("<!DOCTYPE html\n<html>\n<head>\n<title>HTML from MARKDOWN</title>\n</head>\n<body>\n");
	while(s=yylex()){
		printf("%d",s);
	}
	yylex();
	printf("</body>\n</html>");

	return 0;
}