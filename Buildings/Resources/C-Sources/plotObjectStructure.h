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
  /* Number of chars in str */
  size_t n;
  /* Number of used chars in str */
  size_t i;
  /* Name of the file that will contain this plot */
  char* fileName;
  
} PlotObjectStructure;

static size_t nPlotFileNames = 0; /* Number of plotters */
static char ** plotFileNames;
static size_t * nPlotsInFiles;

#endif
