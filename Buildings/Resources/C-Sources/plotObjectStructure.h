/*
 * A structure to store an increasing number of double
 * values.
 */

#ifndef BUILDINGS_PLOTOBJECTSTRUCTURE_H /* Not needed since it is only a typedef; added for safety */
#define BUILDINGS_PLOTOBJECTSTRUCTURE_H
#include <stdlib.h>

typedef struct PlotObjectStructure
{
  /* String array to be plotted */
  char* str;
  /* Number of chars in str */
  size_t nStr;
  /* Number of used chars in str */
  size_t iStr;
  /* double values to be plotted */
  double ** dbl;
  /* Number of double values in each time step */
  size_t nCol;
  /* Number of rows for which space has been allocated */
  size_t nRow;
  /* Number of rows that are currently used (1-based, e.g., nRow = 1 if data at one time stamp is stored) */
  size_t iRow;
  /* String array to be plotted at the end of the file */
  char* strTer;
  /* Number of chars in strTer */
  size_t nStrTer;
  /* Number of used chars in strTer */
  size_t iStrTer;
  /* Name of the file that will contain this plot */
  char* fileName;
  /* Instance name of the Modelica class that contains this plotter */
  char* instanceName;

} PlotObjectStructure;

static size_t nPlotFileNames = 0; /* Number of plotters */
static char ** plotFileNames;
static size_t * nPlotsInFiles;

#endif
