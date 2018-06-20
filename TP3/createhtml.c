#include "createhtml.h"
#include <string.h>

void mainhtml(FILE* out, OrgGeo og) {
    Distrito disttmp = og->dist;
    fprintf(out, "<h1>Distritos de Portugal</h1>");
    fprintf(out, "<ul>");
    while (disttmp) {
        fprintf(out, "<li><a href=\" dists/%s.html\" rel=\"noopener\">%s</a></li>", disttmp -> dis, disttmp -> dis);
        disttmp = disttmp -> next;
    }
    fprintf(out, "</ul>\n");
}

void htmlDistrito(FILE* out, char* distrito, Concelho c) {
    Cidade cid;
    Freguesia freg;
    fprintf(out, "<h1>Concelhos do %s</h1>", distrito);
    while (c) {
        fprintf(out, "<h2>%s</h2>", c-> con);
        cid = c->cids;
        while (cid) {
            fprintf(out, "<h3>%s</h3>", cid-> cid);
            freg = cid -> fregs;
            while (freg) {
                fprintf(out, "<p>%s (%f km2) - %d habitantes</p>", freg -> fre, freg->tam, freg->nhab);
                freg = freg->next;
            }
            cid = cid->next;
        }
        c = c->next;
    }
    fprintf(out, "<a href=\"../index.html\" rel=\"noopener\">Retroceder</a>");
    fprintf(out, "<p>&nbsp;</p>");
}

FILE* htmlinit(char* file) {
    FILE* out;
    out = fopen(file, "w+");
    if (out == NULL) printf("Impossível criar ficheiro\n");
    fprintf(out, "<!DOCTYPE html>\n");
    fprintf(out, "<head>\n");
    fprintf(out, "<body>\n");
    return out;
}

void htmlend(FILE* out) {
    fprintf(out, "</body>");
    fprintf(out, "</head>");
}

void createmain(char* file, OrgGeo og) {
    FILE* fp;
    fp = htmlinit(file);
    mainhtml(fp, og);
    htmlend(fp);
}

void createdists(char* location, OrgGeo og) {
    FILE* fp;
    Distrito dtmp = og->dist;
    char* filename = (char*)malloc(sizeof(char) * (strlen(location) + 40));
    while (dtmp) {
        strcpy(filename, location);
        strcat(filename, dtmp->dis);
        strcat(filename, ".html");
        printf("%s\n", filename);
        fp = htmlinit(filename);
        htmlDistrito(fp, dtmp->dis, dtmp->conc);
        htmlend(fp);
        dtmp = dtmp->next;
    }
}