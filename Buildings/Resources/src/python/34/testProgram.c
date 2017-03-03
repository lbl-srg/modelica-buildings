#include "testProgram.h"

void ModelicaFormatError(const char* string, const char* fmt, const char* val){
  fprintf(stderr, string, fmt, val);
  fprintf(stderr, "\n");
  exit(1);
}

int main(int nArgs, char ** args){
	
   /* Parameters for testing exchange interface*/
  const char * moduleName = "testFunctions";
  const char * functionName = "i1_i2";
    
  size_t nDblWri = 0;
  double dblValWri[] = {2.0};
  
  size_t nDblRea = 0;
  double dblValRea[1];

  int intValWri[] = {1};
  size_t nIntWri = 1;
  size_t nIntRea = 2;
  int intValRea[2];
  /*  char** strValWri = NULL;*/
  const char * strValWri[] = {"aaa"};
  size_t nStrWri = 0;
  
  /* Parameters for testing cymdist interface*/
  const char * moduleName2 = "testCymdist";
  const char * functionName2 = "r1_r1";
  const char * inputFileName = "cymdist.inp";
  
  size_t nDblWri2 = 1;
  double dblValWri2[] = {15.0};
  const char *strWri2[] = {"u"};
  
  size_t nDblRea2 = 1;
  double dblValRea2[1];
  const char *strRea2[] = {"y"};
  const char *strDevRea[] = {"dev"};
  
  size_t nDblParWri = 0;
  const char * strParWri[] = {""};
  int dblValParWri[] = {0};
  int resWri = 0;

  int i;

  for(i=0; i < 10; i++){
    printf("Calling with i for exchange = %d.\n", i);
    pythonExchangeValuesNoModelica(moduleName,
                         functionName,
                         dblValWri, nDblWri,
                         dblValRea, nDblRea,
                         intValWri, nIntWri,
                         intValRea, nIntRea,
                         strValWri, nStrWri,
	                 ModelicaFormatError);
  }
  
    for(i=0; i < 10; i++){
    printf("Calling with i for cymdist = %d.\n", i);
    pythonExchangeValuesCymdistNoModelica(moduleName2,
                          functionName2, inputFileName,
						  nDblWri2, strWri2, dblValWri2, 
						  nDblRea2, strRea2, strDevRea, 
						  dblValRea2, nDblParWri, strParWri, 
						  dblValParWri, resWri,
	                 ModelicaFormatError);
	}

  return 0;
}

