%x converter

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int q = 0;
char* stack [15];

void printin(int i,char* tag,char* str){
	int tmp = -2;
	while(tmp<i){
		printf("\t");
		tmp++;
	}
	printf("<%s>",tag);
	printf("%s",str);
	tmp = -2;
	printf("</%s>",tag);
}

%}

%%

#{6}\ ?[^\n]+			printin(q,"h6",yytext);
#{5}\ ?[^\n]+			printin(q,"h5","lixo");
#{4}\ ?[^\n]+			printin(q,"h4","lixo");
###\ ?[^\n]+			printin(q,"h3","lixo");
##\ ?[^\n]+				printin(q,"h2","lixo");
#\ ?[^\n]+				printin(q,"h1",yytext);
~~[^\n]+~~				printin(q,"s","lixo");
__[^\n]+__				printin(q,"b","lixo");
_[^\n]+_				printin(q,"i","lixo");
\[[A-Za-z\ ]+\]\([(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4}]\)	printin(q,"HERE","lixo");
(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4} 	printin(q,"a href=","lixo");

<HEADER6>{
	~~[^\n]+~~				printin(q,"s","lixo");
	__[^\n]+__				printin(q,"b","lixo");
	_[^\n]+_				printin(q,"i","lixo");
	\[[A-Za-z\ ]+\]\([(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4}]\)	printin(q,"HERE","lixo");
	(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4} 	printin(q,"a href=","lixo");

}

%%


int yywrap(){
	return 1;
}

int main(){
	int s;
	printf("<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<title>HTML from MARKDOWN</title>\n\t</head>\n\t<body>\n");
	while(s=yylex()){
		printf("%d",s);
	}
	yylex();
	printf("\n\t</body>\n</html>");

	return 0;
}