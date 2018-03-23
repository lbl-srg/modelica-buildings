/*
 * Modelica external function that generates a
 * structure to store the plot text strings.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

#include "plotObjectStructure.h"
#include <ModelicaUtilities.h>
#include <stdlib.h>

/* Create the structure "table" and return pointer to "table". */
void* plotInit()
{
  int n = 100; /* Initial string size */
  PlotObjectStructure* plt = malloc(sizeof(PlotObjectStructure));
  if ( plt == NULL )
    ModelicaError("Not enough memory in plotInit.c.");
  plt->str = (char *)malloc(n * sizeof(char));
  if ( plt->str == NULL )
    ModelicaError("Not enough memory for allocating initial string in plotInit.c.");
  plt->str[0] = '\0';
  plt->n = n;
  plt->i = 1;
  return (void*) plt;
};
