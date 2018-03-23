/*
 * A structure to store an increasing number of double
 * values.
 */

#ifndef BUILDINGS_PLOTOBJECTSTRUCTURE_H /* Not needed since it is only a typedef; added for safety */
#define BUILDINGS_PLOTOBJECTSTRUCTURE_H

typedef struct PlotObjectStructure
{
  /* String array to be plotted */
  char* str;
  /* Number of element in the array */
  size_t n;
  /* Number of used elements */
  size_t i;
} PlotObjectStructure;

static size_t nPlt = 0; /* Number of plotters */

#endif
