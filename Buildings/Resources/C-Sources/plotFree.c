/*
 * Modelica external function that frees the memory for the plotters.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

#include "plotObjectStructure.h"
#include <stdlib.h>

void plotFree(void* object)
{ /* Release memory */
  if ( object != NULL ){
    PlotObjectStructure* plt = (PlotObjectStructure*) object;
    free(plt->str);
    free(plt);
  }
}
