#include "linked.h"

void mainhtml(FILE* out, OrgGeo og);
void htmlDistrito(FILE* out, char* distrito, Concelho c);
FILE* htmlinit(char* file);
void htmlend(FILE* out);
void createmain(char* file,OrgGeo og);
void createdists(char* location,OrgGeo og);