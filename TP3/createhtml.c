#include "createhtml.h"
#include "linked.h"



void mainhtml(FILE* out, OrgGeo og) {
    Distrito disttmp = og->dist;
    fprintf("<h1>Distritos de Portugal</h1>");
    fprintf("<ul>");
    while (disttmp) {
        fprintf("<li><a href=\" %s.html\" rel=\"noopener\">%s</a></li>", disttmp -> dis, disttmp -> dis);
        disttmp = disttmp -> next;
    }
    fprintf("</ul>\n");
}


void htmlDistrito(FILE* out, char* distrito, Concelho c) {
    Cidade cid;
    Freguesia freg;
    fprintf("<h1>Concelhos do %s</h1>", distrito);
    while (c) {
        fprintf("<h2>%s</h2>", c-> con);
        cid = c->cids
        while (cid) {
            fprintf("<h3>%s</h3>", cid-> cid);
            freg = cid -> fregs;
            while (freg) {
                fprintf("<p>%s (%f km2) - %d habitantes</p>", freg -> fre, freg->tam, freg->hab);
                freg = freg->next;
            }
            cid = cid->next;
        }
        fprintf("<a href=\"main.html\" rel=\"noopener\">Retroceder</a>");
        fprintf("<p>&nbsp;</p>");
    }
}

void htmlinit(FILE* out){
  fprintf(out, "<!DOCTYPE html>");
  fprintf(out, "<head>");
  fprintf(out, "<body>");
}


void htmlend(FILE* out){
  fprintf(out, "</body>");
  fprintf(out, "</head>");
}