/*
 * Modelica external function that frees the memory for the plotters.
 *
 * Michael Wetter, LBNL                  3/23/2018
 */

#include "plotObjectStructure.h"
#include <ModelicaUtilities.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void plotFree(void* object)
{
  size_t i, iCol, iRow;
  double val;
/*  FILE *f1 = fopen("test.txt", "a");
  fprintf(f1, "Enter plotFree\n");
  fclose(f1);
  */
  if (object != NULL){
    PlotObjectStructure* plt = (PlotObjectStructure*) object;
    FILE *f = fopen(plt->fileName, "a");
    if (f == NULL){
      ModelicaError("Error opening file in plotPrint!\n");
    }
    /* Print the header */
    fprintf(f, "%s\n", plt->str);

    /* Print the data series */
    /* Plot x data */
    fprintf(f, "  const %s = [[", plt->instanceName);

    /* iRow is an unsigned integer. Hence, don't just subtract -2 */
    if (plt->iRow > 2){
      for(iRow = 0; iRow < plt->iRow-2; iRow++){
        fprintf(f, " %.6f,", plt->dbl[0][iRow]);
      }
    }
    if ((plt->iRow) > 1){
      val = plt->dbl[0][plt->iRow-1];
    }
    else{
      /* The plot has no data stored. Simply print 0 */
      val = 0.0;
    }
    fprintf(f, " %.6f],\n", val);
    /* Plot y data */
    for(iCol = 1; iCol < plt->nCol; iCol++){
      fprintf(f, "                              [");
      /* Loop over all data in this column, except the last */
      /* iRow is an unsigned integer. Hence, don't just subtract -2 */
      if (plt->iRow > 2){
        for(iRow = 0; iRow < plt->iRow-2; iRow++){
          fprintf(f, " %.6f,", plt->dbl[iCol][iRow]);
        }
      }
      /* Get the value for the last row */
      if ((plt->iRow) > 1){
        val = plt->dbl[iCol][plt->iRow-1];
      }
      else{
        /* The plot has no data stored. Simply print 0 */
        val = 0.0;
      }
      /* Print the value for the last row */
      if(iCol < plt->nCol-1){
        fprintf(f, " %.6f],\n", val);
      }
      else{
        fprintf(f, " %.6f]];\n", val);
      }
    }
    /* Print the terminal string */
    fprintf(f, "%s", plt->strTer);

    /* Decrement the counter of plots that need to be written to the file */
    for(i = 0; i < nPlotFileNames; i++){
      if (strcmp(plt->fileName, plotFileNames[i]) == 0){
        /* Found the file. Decrement the counter */
        nPlotsInFiles[i] = nPlotsInFiles[i]-1;
        if (nPlotsInFiles[i] == 0){
          /* This was the last plot in this file. */
         fprintf(f, "%s\n", "</body>");
         fprintf(f, "%s\n", "</html>");
         ModelicaFormatMessage("Wrote plot file \"%s\".\n", plt->fileName);
        }
      }
    } /* end of loop over nPlotFileNames */
    fclose(f);

    /* Release memory */
    free(plt->str);
    free(plt->strTer);
    free(plt->fileName);
    free(plt->instanceName);
    for(iCol = 0; iCol < plt->nCol; iCol++)
      free(plt->dbl[iCol]);
    free(plt->dbl);
    free(plt);
  } /* end of object != NULL */
}
