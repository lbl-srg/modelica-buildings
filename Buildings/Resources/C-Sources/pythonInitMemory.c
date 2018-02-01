/*
 * Modelica external function that initializes
 * a pointer that is used to point to a Python memory structure.
 *
 * Michael Wetter, LBNL                                1/31/2018
 */

#include "pythonObjectStructure.h"
/* Create the structure and initialize its pointer to NULL. */
void* initPythonMemory()
{
  pythonPtr* ptr = malloc(sizeof(pythonPtr));
  /* Set ptr to null as pythonExchangeValuesNoModelica is checking for this */
  ptr->ptr = NULL;
  return (void*) ptr;
};
