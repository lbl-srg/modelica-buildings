/*
 * External function that stores the string data to be printed.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

 #include "plotObjectStructure.h"

 #include <string.h>
 #include <stdlib.h>

void plotSendString(void* object, const char* str){
  PlotObjectStructure* plt = (PlotObjectStructure*) object;
  const size_t strLen = strlen(str);

  if (plt->iStr + strLen > plt->nStr){
    /* Need to allocate more memory */
    char* ptr = (char *)realloc(plt->str, (plt->iStr + strLen + 100) * sizeof(char));
    if (ptr == NULL){
      free(plt->str);
      ModelicaError("Error: Not enough memory to reallocate string in plotPrint.c");
    }
    else{
      plt->str = ptr;
      plt->nStr = plt->iStr + strLen  + 100;
    }
  }
  /* Concatenate the strings */
  strcat(plt->str, str);
  plt->iStr = plt->iStr + strLen;
}
