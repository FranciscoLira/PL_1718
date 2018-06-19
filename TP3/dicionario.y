%{
#include"linked.h"

extern FILE* yyin;
extern int yylex();
extern int yylineno;
extern char *yytext;
void yyerror(char*);

int i=0;
char* distrito;
char* concelho;
char* cidade;
char* freguesia;
OrgGeo og;
%}
%union{
  char* t;
  int i;
  float f;
  }

%token<t> NOME
%token<i> HAB
%token<f> TAM
%%

OrgGeo: Distritos {og = initOrgGeo();}
      ;

Distritos: IdD '{' Concelhos '}' 
         | Distritos ';' IdD '{' Concelhos '}'
         | ;

Concelhos: IdC '{' Cidades '}' 
         | Concelhos ';' IdC '{' Cidades'}'
         | ;

Cidades: IdCid '{' Freguesias '}' 
       | Cidades ';' IdCid '{' Freguesias '}'
       | ;

Freguesias: IdFreg 
          | Freguesias ';' IdFreg 
          | ;

IdD: NOME {distrito = $1; addDis(og, distrito);};
IdC: NOME {concelho = $1; addConc(og, distrito, concelho);};
IdCid: NOME {cidade = $1; addCid(og, distrito, concelho, cidade);}
IdFreg: NOME ',' TAM ',' HAB {addFreg(og, distrito, concelho, cidade, $1, $3, $5);}


%%
#include "lex.yy.c"
void yyerror(char *erro){                                               
  fprintf(stderr, "HELP! ERROR:%s \n", erro);
}

int main(){
  yyparse();
  return 0;
}
