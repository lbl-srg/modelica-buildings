/*
 * External function that stores the string data to be printed.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

#include <string.h>
#include <stdlib.h>

#include "ModelicaUtilities.h"

#include "plotObjectStructure.h"

void plotSendTerminalString(void* object, const char* str){
  PlotObjectStructure* plt = (PlotObjectStructure*) object;
  const size_t strLen = strlen(str);

  if (plt->iStrTer + strLen > plt->nStrTer){
    /* Need to allocate more memory */
    char* ptr = (char *)realloc(plt->strTer, (plt->iStrTer + strLen + 100) * sizeof(char));
    if (ptr == NULL){
      free(plt->strTer);
      ModelicaError("Error: Not enough memory to reallocate string in plotPrint.c");
    }
    else{
      plt->strTer = ptr;
      plt->nStrTer = plt->iStrTer + strLen  + 100;
    }
  }
  /* Concatenate the strings */
  strcat(plt->strTer, str);
  plt->iStrTer = plt->iStrTer + strLen;
}
