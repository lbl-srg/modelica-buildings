/*
 * pythonWrapper.h
 *
 * Header file for Modelica function call to Python
 */

#ifndef PYTHONWRAPPER_H_
#define PYTHONWRAPPER_H_

#include "ModelicaUtilities.h"

void pythonExchangeValues(const char * moduleName,
                          const char * functionName,
                          const char * pythonPath,
                          const double * dblValWri, size_t nDblWri,
                          double * dblValRea, size_t nDblRea,
                          const int * intValWri, size_t nIntWri,
                          int * intValRea, size_t nIntRea,
                          const char ** strValWri, size_t nStrWri,
                          void* object,
                          int passPythonObject);

extern void pythonExchangeValuesNoModelica(
    const char * moduleName,
	const char * functionName,
	const char * pythonPath,
	const double * dblValWri, size_t nDblWri,
	double * dblValRea, size_t nDblRea,
	const int * intValWri, size_t nIntWri,
	int * intValRea, size_t nIntRea,
	const char ** strValWri, size_t nStrWri,
	void(*ModelicaFormatError)(const char *string, ...),
	void* memory, int passPythonObject);

#endif /* PYTHONWRAPPER_H_ */
