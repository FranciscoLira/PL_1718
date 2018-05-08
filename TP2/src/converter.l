%x LINK CHECKER

%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int q;
int st;	
char** stack;
char** tmplink;

void printstack(){
	int z=0;
	while(z<q){
		printf("%s;",stack[z]);
		z++;
	}
}

void puttab(int t){
	int i=0;
	while(i<t){
		printf("\t");
		i++;
	}
}

int getLevel(char* tag){
	if (strcmp(tag,"h1")==0) return 1;
	if (strcmp(tag,"h2")==0) return 1;
	if (strcmp(tag,"h3")==0) return 1;
	if (strcmp(tag,"h4")==0) return 1;
	if (strcmp(tag,"h5")==0) return 1;
	if (strcmp(tag,"h6")==0) return 1;
	if (strcmp(tag,"code")==0) return 2;
	if (strcmp(tag,"ol")==0) return 3;
	if (strcmp(tag,"ul")==0) return 3;
	if (strcmp(tag,"li")==0) return 4;
	if (strcmp(tag,"i")==0) return 5;
	if (strcmp(tag,"b")==0) return 5;
	if (strcmp(tag,"s")==0) return 5;
	return 0;
}

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
	int tmp = strlen(tag);
	stack[q] = (char*)malloc(sizeof(char)*(tmp+1));
	strcpy(stack[q],tag);
	q++;
	if(q>st-1){
		stackDouble();
	}
}

void stackRemove(){
	q--;
	free(stack[q]);

}

char* stackGet(){
	return stack[q-1];
}

char* stackGetList(){
	return stack[q-2];
}

void starttag(char* tag){
	if(q>0){
		if(strcmp(tag,stackGet())==0){
			printf("</%s>",tag);
			stackRemove();
		}
		else{
			int lvl = getLevel(tag);
			while(q>0 && ((getLevel(stackGet()))<lvl)){
				printf("</%s>",stackGet());
				stackRemove();
			}
			if(getLevel(stackGet())==1){
				puttab(q+1);
			}
			printf("<%s>",tag);
			stackAdd(tag);
		}
	}
	else{
		if(getLevel(tag)<2) puttab(q+1);
		printf("<%s>",tag);
		stackAdd(tag);
	}
}

void startlist(char* tag){
	if(q>0){
		if(strcmp(stackGet(),"li") == 0){
			if(strcmp(stackGetList(),tag) == 0){
				printf("</li>\n");
				puttab(q-1);
				printf("<li>");
			}
			else{
				printf("</li>\n");
				stackRemove();
				puttab(q-1);
				printf("</%s>\n",stackGet());
				stackRemove();
				puttab(q);
				printf("<%s>\n",tag);
				stackAdd(tag);
				puttab(q);
				printf("<li>");
				stackAdd("li");
			}
		}

	}
	else{
		puttab(q);
		printf("<%s>\n",tag);
		stackAdd(tag);
		puttab(q);
		printf("<li>");
		stackAdd("li");
	}
}

void checkheader(){
	if(q>0){
		if(((strcmp(stackGet(),"h6")) == 0)
		||((strcmp(stackGet(),"h5")) == 0)
		||((strcmp(stackGet(),"h4")) == 0)
		||((strcmp(stackGet(),"h3")) == 0)
		||((strcmp(stackGet(),"h2")) == 0)
		||((strcmp(stackGet(),"h1")) == 0)
		||((strcmp(stackGet(),"li")) == 0)){
			printf("</%s>\n",stackGet());
			stackRemove();
		}
		else if(((strcmp(stackGet(),"ol")) == 0)
		||((strcmp(stackGet(),"ul")) == 0)){
			puttab(q-1);
			printf("</%s>\n",stackGet());
			stackRemove();
		}
	}
	else printf("\n");
}

void closetags(){
	while(q>0){
		printf("</%s>\n",stackGet());
		stackRemove();
	}
}

void createLink(){
	printf("<a href=\"https://www.%s\">%s</a>",tmplink[1],tmplink[0]);
}

%}

%%

\n 						checkheader();
\[					 	BEGIN LINK;
#{6}					starttag("h6");
#{5}					starttag("h5");
#{4}					starttag("h4");
###						starttag("h3");
##						starttag("h2");
#						starttag("h1");
```						starttag("code");
~~						starttag("s");
__						starttag("b");
\*\*					starttag("b");
_						starttag("i");
\*						starttag("i");
\n[1-9]+.\ 				startlist("ol");
\n0.\ 					startlist("ul");
.						printf("%s",yytext);

<LINK>{
	[^\n]+\] 									{tmplink[0]=strdup(yytext);tmplink[0][yyleng-1] = 0;}
	\((https:\/\/)?(www.)?
	[A-Za-z]+\.com\)						{tmplink[1]=strdup(yytext);tmplink[1][yyleng-1] = 0;createLink(); BEGIN INITIAL;}
}

%%


int yywrap(){
	return 1;
}

int main(){
	int s;
	q = 0;
	st = 15;
	stack = (char**)malloc(sizeof(char*)*st);
	tmplink = (char**)malloc(sizeof(char*)*2);
	/*
	costum css 
	    padding: 16px;
		background-color: #f6f8fa;
		font-family: "SFMono-Regular",Consolas,"Liberation Mono",Menlo,Courier,monospace;
	*/
	printf("<!DOCTYPE html>\n<html>\n\t<head>\n\t\t<style>\n\tcode\t{padding: 16px;\n\t\t\tbackground-color: #f6f8fa;\n\t\t\tfont-family: \"SFMono-Regular\",Consolas,\"Liberation Mono\",Menlo,Courier,monospace;}\n\t\t</style>\n\t\t<title>HTML from MARKDOWN</title>\n\t</head>\n\t<body>\n");
	while(s=yylex()){
		printf("%d",s);
	}
	yylex();
	closetags();
	printf("\n\t</body>\n</html>");

	return 0;
}

/*
\[[A-Za-z\ ]+\]\([(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4}]\)	printin(q,"HERE",0,0,"lixo");
(https?:\/\/)?(www.)?[a-z]+\.[a-z]{2,4} 	printin(q,"a href=",0,0,"lixo");
*/