#include "testProgram.h"

void ModelicaFormatError(const char* string, const char* fmt, const char* val){
  printf(string, fmt, val);
  printf("\n");
  exit(1);
}


int main(int nArgs, char ** args){
  const char * moduleName = "testFunctions";
  const char * functionName = "i1_i2";
  size_t nDblWri = 0;
  double dblValWri[] = {2.0};

  size_t nDblRea = 0;
  double dblValRea[nDblRea];

  int intValWri[] = {1};
  size_t nIntWri = 1;
  size_t nIntRea = 2;
  int intValRea[nIntRea];
  //  char** strValWri = NULL;
  const char * strValWri[] = {"aaa"};
  size_t nStrWri = 0;

  int i;

  for(i=0; i < 10; i++){
    printf("Calling with i = %d.\n", i);
    pythonExchangeValuesNoModelica(moduleName,
                         functionName,
                         dblValWri, nDblWri,
                         dblValRea, nDblRea,
                         intValWri, nIntWri,
                         intValRea, nIntRea,
                         strValWri, nStrWri,
	                 ModelicaFormatError);
  }

  return 0;
}

