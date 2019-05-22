/* Functions that ensures that each FileWriter writes to a unique file
 * and that stores variables in a struct for later use.
 *
 * Michael Wetter, LBNL                     2018-05-12
 * Filip Jorissen, KU Leuven
 */

#ifndef IBPSA_JSONRITERSInit_h
#define IBPSA_JSONRITERSInit_h

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "fileWriterStructure.h"

void* jsonWriterInit(
  const char* instanceName,
  const char* fileName,
  const int dumpAtDestruction,
  const int numKeys,
  char** varKeys);

void writeJson(void *ptrFileWriter,  const double* varVals, const int numVals);
void cacheVals(void *ptrFileWriter, const double* varVals, const int numVals);

#endif
