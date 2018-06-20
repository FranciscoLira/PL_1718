%{
#include "createhtml.h"

extern FILE* yyin;
extern int yylex();
extern int yylineno;
extern char *yytext;
void yyerror(char*);

int i=0;
char* distrito=NULL;
char* concelho=NULL;
char* cidade=NULL;
char* freguesia=NULL;
OrgGeo og = NULL;

void deleteChar(char* s){
  int i,t=strlen(s);

  for(i=0;i<t;i++){
    s[i]=s[i+1];
  }
  s[strlen(s) - 1]=0;
}

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

OrgGeo: Distritos
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

IdD: NOME {if(!og) og = initOrgGeo(); distrito = $1; deleteChar(distrito);addDis(og, distrito);};
IdC: NOME {concelho = $1; deleteChar(concelho); addConc(og, distrito, concelho);};
IdCid: NOME {cidade = $1; deleteChar(cidade); addCid(og, distrito, concelho, cidade);}
IdFreg: NOME ',' HAB ',' TAM {freguesia = $1; deleteChar(freguesia); printf("%s - %s - %s - %s: %d, %f\n", distrito, concelho, cidade, freguesia, $3, $5); addFreg(og, distrito, concelho, cidade, freguesia, $3, $5);}


%%
void yyerror(char *erro){
  fprintf(stderr, "HELP! ERROR:%s \n", erro);
}

int main(){
  yyparse();
  createmain("files/index.html",og);
  createdists("files/dists/",og);
  return 0;
}
