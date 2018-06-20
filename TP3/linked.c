#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linked.h"

OrgGeo initOrgGeo() {
	OrgGeo og = (OrgGeo) malloc(sizeof(struct orggeo));
	og -> qDis = 0;
	og -> dist = NULL;
	return og;
}

void printog(OrgGeo og) {
	Distrito d = og->dist;
	Concelho c;
	Cidade ci;
	Freguesia f;
	printf("\nTREE-BEG----------------------------\n");
	while (d) {
		c = d->conc;
		printf("\t%s\n", d->dis);
		while (c) {
			ci = c->cids;
			printf("\t\t%s\n", c->con);
			while (ci) {
				f = ci->fregs;
				printf("\t\t\t%s\n", ci->cid);
				while (f) {
					printf("\t\t\t\t%s\n", f->fre);
					f = f->next;
				}
				ci = ci->next;
			}
			c = c->next;
		}
		d = d->next;
	}
	printf("TREE-END----------------------------\n\n");
}

void addDis(OrgGeo og, char* nomeDist) {
	Distrito tmp;
	if (og->qDis > 0) {
		tmp = og -> dist;

		while (tmp->next != NULL) {
			tmp = tmp -> next;
		}

		tmp -> next = (Distrito) malloc(sizeof(struct distrito));
		tmp = tmp -> next;
		og->qDis++;
	}
	else {
		og -> dist = (Distrito) malloc(sizeof(struct distrito));
		tmp = og -> dist;
		og->qDis++;
	}

	tmp -> dis = strdup(nomeDist);
	tmp -> qCon = 0;
	tmp -> conc = NULL;
	tmp -> next = NULL;
	//printog(og);
}

void addConc(OrgGeo og, char* nomeDist, char* nomeConc) {
	Distrito dtmp = og -> dist;
	Concelho ctmp;

	while (strcmp(dtmp->dis, nomeDist) != 0) {
		dtmp = dtmp->next;
	}

	if (dtmp -> qCon == 0) {
		dtmp -> conc = (Concelho) malloc(sizeof(struct concelho));
		ctmp = dtmp -> conc;
		dtmp -> qCon ++;
	}
	else {
		ctmp = dtmp -> conc;

		while (ctmp->next) ctmp = ctmp -> next;

		ctmp -> next = (Concelho) malloc(sizeof(struct concelho));
		ctmp = ctmp -> next;
	}
	ctmp -> con = strdup(nomeConc);
	ctmp -> qCid = 0;
	ctmp -> cids = NULL;
	ctmp -> next = NULL;
	//printog(og);
}

void addCid(OrgGeo og, char* nomeDist, char* nomeConc, char* nomeCid) {
	Distrito dtmp = og -> dist;
	Concelho ctmp;
	Cidade cidtmp;

	while (strcmp(dtmp->dis, nomeDist) != 0) {
		dtmp = dtmp->next;
	}
	ctmp = dtmp -> conc;
	while (strcmp(ctmp->con, nomeConc) != 0) {
		ctmp = ctmp->next;
	}

	if (ctmp -> qCid == 0) {
		ctmp -> cids = (Cidade) malloc(sizeof(struct cidade));
		cidtmp = ctmp-> cids;
		ctmp -> qCid ++;
	}
	else {
		ctmp -> qCid++;
		cidtmp = ctmp->cids;
		while (cidtmp->next) cidtmp = cidtmp -> next;
		cidtmp -> next = (Cidade) malloc(sizeof(struct cidade));
		cidtmp = cidtmp -> next;
	}

	cidtmp -> cid = strdup(nomeCid);
	cidtmp -> qFre = 0;
	cidtmp -> fregs = NULL;
	cidtmp -> next = NULL;
	//printog(og);
}

void addFreg(OrgGeo og, char* nomeDist, char* nomeConc, char* nomeCid, char* nomeFreg, float tamFreg, int habFreg) {
	Distrito dtmp = og -> dist;
	Concelho ctmp;
	Cidade cidtmp;
	Freguesia fregtmp;

	while (strcmp(dtmp->dis, nomeDist) != 0) {
		dtmp = dtmp->next;
	}
	ctmp = dtmp -> conc;

	while (strcmp(ctmp->con, nomeConc) != 0) {
		ctmp = ctmp->next;
	}
	cidtmp = ctmp -> cids;

	while (strcmp(cidtmp->cid, nomeCid) != 0) {
		cidtmp = cidtmp->next;
	}

	if (cidtmp -> qFre == 0) {
		cidtmp -> fregs = (Freguesia) malloc(sizeof(struct freguesia));
		fregtmp = cidtmp -> fregs;
		cidtmp -> qFre ++;
	}
	else {
		fregtmp = cidtmp -> fregs;
		while (fregtmp->next) fregtmp = fregtmp -> next;
		fregtmp	-> next = (Freguesia) malloc(sizeof(struct freguesia));
		fregtmp = fregtmp -> next;
	}

	fregtmp -> fre = strdup(nomeFreg);
	fregtmp -> tam = habFreg;
	fregtmp -> nhab = tamFreg;
	fregtmp -> next = NULL;
	//printog(og);
}

