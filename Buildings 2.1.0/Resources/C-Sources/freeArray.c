/*
 * Modelica external function that frees the memory
 * that is allocated by initArray.c or by
 * storeValue.c
 *
 * When called by the Modelica function "initArray",
 * this function creates a structure for an array whose
 * number of elements can be enlarged.
 *
 * Pierre Vigouroux, LBNL                  7/18/2011
 */

#include "externalObjectStructure.h"
#include <stdlib.h>

void freeArray(void* object)
{ /* Release table storage */
  if ( object != NULL ){
    ExternalObjectStructure* table = (ExternalObjectStructure*) object;
    free(table->x);
    free(table);
  }
}
