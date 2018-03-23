/*
 * External function that stores the data to be printed.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

 #include "plotObjectStructure.h"
 #include <ModelicaUtilities.h>
 #include <stdio.h>
 #include <string.h>

void plotPrint(void* object, const char* str, int finalCall){
  PlotObjectStructure* plt = (PlotObjectStructure*) object;
  const size_t strLen = strlen(str);

  if (plt->i + strLen > plt->n){
    /* Need to allocate more memory */
    char* ptr = (char *)realloc(plt->str, (plt->i + strLen + 100) * sizeof(char));
    if (ptr == NULL){
      free(plt->str);
      ModelicaError("Error: Not enough memory to reallocate string in plotPrint.c");
    }
    else{
      plt->str = ptr;
      plt->n = plt->i + strLen  + 100;
    }
  }
  /* Concatenate the strings */
  strcat(plt->str, str);
  plt->i = plt->i + strLen;

  if (finalCall){
    FILE *f = fopen("test.html", "w");
    if (f == NULL){
      ModelicaError("Error opening file in plotPrint!\n");
    }
    fprintf(f, "%s", plt->str);
    fclose(f);
  }
  return;
}
