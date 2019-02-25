/*
 * Modelica external function that generates a
 * structure to store the plot text strings.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

#include "plotObjectStructure.h"
#include <ModelicaUtilities.h>
#include <stdlib.h>
#include <stdio.h>

void plotWriteHeader(const char* fileName){
  FILE *f = fopen(fileName, "w");
  if (f == NULL){
    ModelicaError("Error opening file in plotWriteHeader!\n");
  }
  fprintf(f, "%s\n", "<!DOCTYPE html>");
  fprintf(f, "%s\n", "<html>");
  fprintf(f, "%s\n", "<head>");
  fprintf(f, "%s\n", "<meta content=\"text/html;charset=utf-8\" http-equiv=\"Content-Type\">");
  fprintf(f, "%s\n", "<meta content=\"utf-8\" http-equiv=\"encoding\">");
  fprintf(f, "%s\n", "<script src=\"https://cdn.plot.ly/plotly-latest.min.js\"></script>");
  fprintf(f, "%s\n", "</head>");
  fprintf(f, "%s\n", "<body>");
  fclose(f);
}

void plotRegister(const char* fileName){
  int i;
  for(i = 0; i < nPlotFileNames; i++){
    if (strcmp(fileName, plotFileNames[i]) == 0){
      /* This plot file name already exists */
      nPlotsInFiles[i]++;
      return;
    }
  }
  /* This is a new plot file */
  /* Reallocate memory for the new array */
  if (nPlotFileNames == 0){
    plotFileNames = malloc(sizeof(char*));
    plotFileNames[0] = malloc((strlen(fileName)+1) * sizeof(char));
    strcpy(plotFileNames[0], fileName);
    nPlotsInFiles = malloc(sizeof(size_t));
    nPlotsInFiles[0] = 1;
  }
  else{
    /* Have already at least one plot file name, but this fileName is new */
    plotFileNames = (char **) realloc(plotFileNames, (nPlotFileNames+1) * sizeof(char*));
    if (plotFileNames == NULL){
      ModelicaError("Failed to allocate memory for plotFileNames.");
    }
    plotFileNames[nPlotFileNames] = malloc((strlen(fileName)+1) * sizeof(char));
    if (plotFileNames[nPlotFileNames] == NULL){
      ModelicaError("Failed to allocate memory for plotFileNames.");
    }
    strcpy(plotFileNames[nPlotFileNames], fileName);
    /* Reallocate memory for nPlotsInFile */
    nPlotsInFiles = (size_t*) realloc(nPlotsInFiles, (nPlotFileNames+1) * sizeof(size_t));
    if (nPlotsInFiles == NULL){
      ModelicaError("Failed to allocate memory for nPlotsInFile.");
    }
    nPlotsInFiles[nPlotFileNames] = 1;
  }
  /* Write the header for this plot */
  plotWriteHeader(fileName);
  nPlotFileNames++;
  return;
}

/* Create the structure "table" and return pointer to "table". */
void* plotInit(const char* fileName,
               const char* instanceName,
               int nCol)
{
  int i;
  const size_t nStr = 100; /* Initial string size */
  const size_t nRow = 50; /* Initial double size */
  PlotObjectStructure* plt = malloc(sizeof(PlotObjectStructure));
  if ( plt == NULL )
    ModelicaError("Not enough memory in plotInit.c.");

  /* Allocate strings */
  plt->str = (char *)malloc(nStr * sizeof(char));
  if ( plt->str == NULL )
    ModelicaError("Not enough memory for allocating initial string in plotInit.c.");
  plt->str[0] = '\0';
  plt->nStr = nStr;
  plt->iStr = 1;
  plt->strTer = (char *)malloc(nStr * sizeof(char));
  if ( plt->strTer == NULL )
    ModelicaError("Not enough memory for allocating terminal string in plotInit.c.");
  plt->strTer[0] = '\0';
  plt->nStrTer = nStr;
  plt->iStrTer = 1;

  /* Allocate file name */
  plt->fileName = malloc((strlen(fileName)+1) * sizeof(char));
  if (plt->fileName == NULL){
    ModelicaError("Failed to allocate memory for plt->fileName in plotInit.c");
  }
  strcpy(plt->fileName, fileName);
  /* Allocate instance name */
  plt->instanceName = malloc((strlen(instanceName)+1) * sizeof(char));
  if (plt->instanceName == NULL){
    ModelicaError("Failed to allocate memory for plt->instanceName in plotInit.c");
  }
  strcpy(plt->instanceName, instanceName);

  /* Allocate double array */
  plt->dbl = (double **)malloc(nCol * sizeof(double *));
  if (plt->dbl == NULL){
    ModelicaError("Failed to allocate memory for plt->dbl in plotInit.c");
  }
  plt->nCol = nCol;
  for(i = 0; i < nCol; i++){
    plt->dbl[i] = (double *)malloc(nRow * sizeof(double));
    if (plt->dbl[i] == NULL){
      ModelicaError("Failed to allocate memory for plt->dbl[i] in plotInit.c");
    }
  }
  plt->iRow = 0;
  plt->nRow = nRow;

  /* Register this plot in the list of plots */
  plotRegister(fileName);
  return (void*) plt;
};
