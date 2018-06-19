#include <string.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct freguesia{
	char* fre;
	int nhab;
	float tam;
	struct freguesia* next;
}*Freguesia;

typedef struct cidade{
	char* cid;
	int qFre;
	Freguesia fregs;
	struct cidade* next;
}*Cidade;

typedef struct concelho{
	char* con;
	int qCid;
	Cidade cids;
	struct concelho* next;
}*Concelho;

typedef struct distrito{
	char* dis;       //nome do distrito
	int qCon;        //quantos concelhos
	Concelho conc;  //lista ligada do concelho
	struct distrito* next;  //próximo distrito
}*Distrito;

typedef struct orggeo{
	int qDis;
	Distrito dist;
}*OrgGeo;

OrgGeo initOrgGeo();
void addDis(OrgGeo og, char* nomeDist);
void addConc(OrgGeo og, char* nomeDist, char* nomeConc);
void addCid(OrgGeo og, char* nomeDist, char* nomeConc, char* nomeCid);
void addFreg(OrgGeo og, char* nomeDist, char* nomeConc, char* nomeCid, char* nomeFreg, float tamFreg, int habFreg);
