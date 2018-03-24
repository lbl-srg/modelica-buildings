/*
 * External function that stores the data to be printed.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

 #include "plotObjectStructure.h"
 #include <ModelicaUtilities.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>

void plotPrint(void* object, const char* str, int finalCall){
  int k=0;
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
    FILE *f = fopen(plt->fileName, "a");
    if (f == NULL){
      ModelicaError("Error opening file in plotPrint!\n");
    }
    fprintf(f, "%s", plt->str);
    /* Decrement the counter of plots that need to be written to the file */
    for(k = 0; k < nPlotFileNames; k++){
      if (strcmp(plt->fileName, plotFileNames[k]) == 0){
        /* Found the file. Decrement the counter */
        nPlotsInFiles[k] = nPlotsInFiles[k]-1;
        if (nPlotsInFiles[k] == 0){
          /* This was the last plot in this file. */
          fprintf(f, "%s\n", "</body>");
        }
      }
    }
    fclose(f);
  }
  return;
}
