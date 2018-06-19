%{
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap
%%

[{},;]   		{return yytext[0];}
\"[^"]+\"   	{yylval.t = strdup(yytext);return NOME;}
[0-9]+       	{yylval.i = atoi(yytext);return HAB;}
[0-9]+\.[0-9]+ 	{yylval.f = atof(yytext);return TAM;}
.|\n            {;}
%%
