/*
 * Modelica external function that frees the memory
 * that is allocated by initPythonMemory.

 * Michael Wetter, LBNL                                1/31/2018
 */

#include "pythonObjectStructure.h"
#include <stdlib.h>

void freePythonMemory(void* object)
{
  if ( object != NULL ){
    pythonPtr* p = (pythonPtr*) object;
    free(p);
  }
}
