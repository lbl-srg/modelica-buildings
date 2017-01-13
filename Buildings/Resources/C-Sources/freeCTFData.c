/*
 * Modelica external function that frees the memory
 * that is allocated by initCTFData.c
 *
 * When called by the Modelica function "initCTFData",
 * this function frees the memory used by ctfData.
 *
 * Michael Wetter, LBNL                  1/12/2017
 */

#include "externalObjectStructure.h"
#include <stdlib.h>

void freeCTFData(void* object)
{ /* Release table storage */
  if ( object != NULL ){
    ExternalCTFStructure* ctfData = (ExternalCTFStructure*) object;
    free(ctfData->x);
    free(ctfData);
  }
}
