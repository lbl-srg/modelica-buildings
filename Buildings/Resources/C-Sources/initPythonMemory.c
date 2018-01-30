/*
 * Modelica external function that generates a
 * structure to store an increasing number of double
 * values.
 *
 * When called by the Modelica function "initArray",
 * this function creates a structure for an array whose
 * number of elements can be enlarged.
 *
 * Pierre Vigouroux, LBNL                  7/18/2011
 */

//#include "externalObjectStructure.h"
//#include <ModelicaUtilities.h>
//#include <stdlib.h>

/* Create the structure "table" and return pointer to "table". */
void* initPythonMemory()
{
  void* memory = 0;
  return (void*) memory;
};
