/*
 * A structure to store a pointer that is used
 * to point to a Python object between the function
 * invocations.
 *
 * Michael Wetter, LBNL                                1/31/2018
 */

#ifndef BUILDINGS_PYTHONOBJECTSTRUCTURE_H /* Not needed since it is only a typedef; added for safety */
#define BUILDINGS_PYTHONOBJECTSTRUCTURE_H

#ifdef __APPLE__
#include <Python/Python.h>
#else
#include <Python.h>
#endif

typedef struct pythonPtr
{
  void* ptr;
  int isInitialized;
  PyObject* pModule;
  PyObject* pFunc;
} pythonPtr;

#endif
