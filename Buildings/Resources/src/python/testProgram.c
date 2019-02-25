#include "testProgram.h"

void ModelicaFormatError(const char* string, const char* fmt, const char* val){
  fprintf(stderr, string, fmt, val);
  fprintf(stderr, "\n");
  exit(1);
}

int main(int nArgs, char ** args){
  const char * moduleName = "testFunctions";
  const char * functionName = "r1_r1PassPythonObject";
  size_t nDblWri = 1;
  double dblValWri[] = {2.0};

  size_t nDblRea = 1;
  double dblValRea[1];

  int intValWri[] = {1};
  size_t nIntWri = 0;
  size_t nIntRea = 0;
  int intValRea[2];
  /*  char** strValWri = NULL;*/
  const char * strValWri[] = {"aaa"};
  size_t nStrWri = 0;

  int i;
  pythonPtr* ptr = malloc(sizeof(pythonPtr));
  /* Set ptr to null as pythonExchangeValuesNoModelica is checking for this */
  ptr->ptr = NULL;
  ptr->isInitialized = 0;

  for(i=0; i < 3  ; i++){
    printf("Calling with i = %d.\n", i);
    pythonExchangeValuesNoModelica(moduleName,
                         functionName,
                         dblValWri, nDblWri,
                         dblValRea, nDblRea,
                         intValWri, nIntWri,
                         intValRea, nIntRea,
                         strValWri, nStrWri,
	                       ModelicaFormatError,
                         ptr,
                         1);
  }
  return 0;
}
