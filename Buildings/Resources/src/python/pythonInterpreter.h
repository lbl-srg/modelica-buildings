#ifndef _PYTHONINTERPRETER_H_
#define _PYTHONINTERPRETER_H_
/*////////////////////////////////////////////////////////////////////////////*/
/* Function that evaluates a Python function using*/
/* embedded Python.*/
/* The Python function must take as an argument one or more doubles, integers*/
/* and strings, in this order. If there is only one argument of each data type,*/
/* then it must be a scalar. Multiple arguments of the same data type*/
/* must be put in a list.*/
/**/
/* See the User's Guide of the Modelica package for instructions.*/
/**/
/* The PYTHONPATH must point to the directory that contains the function.*/
/* On Linux, run for example*/
/* export PYTHONPATH=xyz*/
/* where xyz is the directory that contains the file that implements the*/
/* function multiply.*/
/**/
/**/
/* First Implementation: Michael Wetter, LBNL, 1/31/2013*/
/* Modified: Thierry S. Nouidui, LBNL, 3/26/2013 to suport cross compilation*/
/* svn-id=$Id: exchangeValues.c 2877 2011-09-11 00:46:02Z mwetter $*/
/*////////////////////////////////////////////////////////////////////////////*/
#include <stddef.h>  /* stddef defines size_t */

#ifdef __APPLE__
#include <Python/Python.h>
#else
#include <Python.h>
#endif

#include "pythonObjectStructure.h"

#ifdef __cplusplus
extern "C" {
#endif
#ifdef _MSC_VER
#ifdef EXTERNAL_FUNCTION_EXPORT
# define LBNLPYTHONINTERPRETER_EXPORT __declspec( dllexport )
#else
# define LBNLPYTHONINTERPRETER_EXPORT __declspec( dllimport )
#endif
#elif __GNUC__ >= 4
/* In gnuc, all symbols are by default exported. It is still often useful,
to not export all symbols but only the needed ones */
# define LBNLPYTHONINTERPRETER_EXPORT __attribute__ ((visibility("default")))
#else
# define LBNLPYTHONINTERPRETER_EXPORT
#endif

/* Exchange values with Python.*/
/* Any argument that starts with 'n', such as nDblWri, may be zero.*/
/* If there is an error, then this function calls*/
/* ModelicaFormatError(...) which terminates the computation.*/
/**/
/* The arguments are as follows:*/
/*  moduleName            - Name of the Python module.*/
/*  functionName          - Name of the Python function.*/
/*  dblValWri             - Double values to write.*/
/*  nDblWri               - Number of doubles to write.*/
/*  dblValRea             - Double values to read.*/
/*  nDblRea               - Number of double values to read.*/
/*  intValWri             - Integer values to write.*/
/*  nIntWri               - Number of integers to write.*/
/*  intValRea             - Integer values to read.*/
/*  nIntRea               - Number of integers to read.*/
/*  strValWri             - String values to write.*/
/*  nStrWri               - Number of strings to write.*/
/*  nStrWri               - Number of strings to write.*/
/*  inModelicaFormatError - Pointer to ModelicaFormatError.*/
/*  memory                - Pointer to memory that contains the python object.*/
/*  have_memory           - Set to 0 for false, and 1 for true.*/
LBNLPYTHONINTERPRETER_EXPORT void pythonExchangeValuesNoModelica(const char * moduleName,
                          const char * functionName,
                          const double * dblValWri, size_t nDblWri,
                          double * dblValRea, size_t nDblRea,
                          const int * intValWri, size_t nIntWri,
                          int * intValRea, size_t nIntRea,
                          const char ** strValWri, size_t nStrWri,
                          void (*inModelicaFormatError)(const char *string,...),
                          void* object,
                          int have_memory);

LBNLPYTHONINTERPRETER_EXPORT void* initPythonMemory();

LBNLPYTHONINTERPRETER_EXPORT void freePythonMemory(void* object);

#ifdef __cplusplus
}
#endif

#endif /* _PYTHONINTERPRETER_H_ */
