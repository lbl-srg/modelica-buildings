/*
 * Modelica external function that generates a
 * structure to store the CTF Data.
 *
 * When called by the Modelica function "initCTFData",
 * this function creates a structure for that holds the CTF data.
 *
 * Pierre Vigouroux, LBNL                  7/18/2011
 */

#include "externalCTFStructure.h"
#include <ModelicaUtilities.h>
#include <stdlib.h>

/* Create the structure "table" and return pointer to "table". */
void* initCTFData()
{
  ExternalCTFStructure* ctfData = malloc(sizeof(ExternalCTFStructure));
  if ( ctfData == NULL )
    ModelicaError("Not enough memory in initCTFData.c.");
  /* Number of elements in the array */
  ctfData->n=0;   /* initialise nEle to 0 */
  ctfData->x=NULL;   /* set the pointer to null */

  return (void*) ctfData;
};
