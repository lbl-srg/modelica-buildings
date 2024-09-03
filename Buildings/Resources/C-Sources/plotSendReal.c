/*
 * External function that stores the string data to be printed.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

 #include "plotObjectStructure.h"

 #include <string.h>
 #include <stdlib.h>

void plotSendReal(void* object, const double* dbl){
  int i;
  const size_t inc = 50; /* Increment with which to grow the column length */
  PlotObjectStructure* plt = (PlotObjectStructure*) object;

  if (plt->iRow + 1 > plt->nRow){
    /* Need to allocate more memory */
    for(i = 0; i < plt->nCol; i++){
      double* ptr = (double *)realloc(plt->dbl[i], (plt->iRow + inc) * sizeof(double));
      if (ptr == NULL){
        ModelicaError("Error: Not enough memory to reallocate double array in plotSendReal.c");
      }
      else{
        plt->dbl[i] = ptr;
      }
    }
    plt->nRow = plt->iRow + inc;
}
  /* Add the doubles */
  for(i = 0; i < plt->nCol; i++){
    plt->dbl[i][plt->iRow] = dbl[i];
  }
  /* Increment the counter for the number of rows that are stored */
  plt->iRow = plt->iRow + 1;
}
