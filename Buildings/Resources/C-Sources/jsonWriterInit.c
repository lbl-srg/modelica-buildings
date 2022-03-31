/* Functions that ensures that each FileWriter writes to a unique file
 * and that stores variables in a struct for later use.
 *
 * Michael Wetter, LBNL                     2018-05-12
 * Filip Jorissen, KU Leuven
 */

#include "fileWriterStructure.c"
#include "ModelicaUtilities.h"

#include "jsonWriterInit.h"

void* jsonWriterInit(
  const char* instanceName,
  const char* fileName,
  const int dumpAtDestruction,
  const int numKeys,
  char** varKeys){

  int i;
  FileWriter* ID = (FileWriter*)allocateFileWriter(instanceName, fileName);

  if (dumpAtDestruction < 0 || dumpAtDestruction > 1)
    ModelicaFormatError("In jsonWriterInit.c: The initialisation flag 'dumpAtDestruction' of FileWriter %s must equal 0 or 1 but it equals %i.", instanceName, dumpAtDestruction);
  ID->dumpAtDestruction=dumpAtDestruction;

  ID->numKeys=numKeys;

  ID-> varKeys = malloc(numKeys * sizeof(char*));
  if ( ID->varKeys == NULL )
    ModelicaError("Not enough memory in jsonWriterInit.c for allocating varKeys[].");
  ID-> varVals = malloc(numKeys * sizeof(double));
  if ( ID->varVals == NULL )
    ModelicaError("Not enough memory in jsonWriterInit.c for allocating varVals[].");

  for (i = 0; i < numKeys; ++i)
  {
    ID-> varKeys[i] = malloc((strlen(varKeys[i])+1) * sizeof(char*));
    if ( ID->varKeys[i] == NULL )
      ModelicaError("Not enough memory in jsonWriterInit.c for allocating varKeys.");
      strcpy(ID->varKeys[i], varKeys[i]);
  }
  return (void*) ID;
}

void writeJsonLine(FILE * fOut, const char* line, const char* fileName){
  if (fputs(line, fOut) == EOF){
      ModelicaFormatError("In jsonWriterInit.c: Returned an error when writing to %s.", fileName);
  }
}

void cacheVals(void *ptrFileWriter, const double* varVals, const int numVals){
  int i;
  FileWriter *ID = (FileWriter*)ptrFileWriter;
  if (ID->numKeys != numVals){
    ModelicaFormatError("In jsonWriterInit.c: The supplied vector of names and values do not have equal lengths: %d and %d", ID->numKeys, numVals);
  }

  for (i = 0; i < numVals; ++i){
    ID->varVals[i]=varVals[i];
  }
}

void writeJson(void *ptrFileWriter,  const double* varVals, const int numVals){
  int i;
  FILE *fOut;
  FileWriter *ID = (FileWriter*)ptrFileWriter;
  if (ID->numKeys!=numVals){
    ModelicaFormatError("In writeJson.c: The supplied vector of names and values do not have equal lengths: %d and %d", ID->numKeys, numVals);
  }

  fOut = fopen(ID->fileWriterName, "a");
  if (fOut == NULL)
    ModelicaFormatError("In writeJson.c: Failed open file %s.", ID->fileWriterName);

  writeJsonLine(fOut, "{\n", ID->fileWriterName);

  for (i = 0; i < numVals; ++i){
    if (fprintf(fOut, "  \"%s\" : %.10e", ID->varKeys[i], varVals[i])<0){
      ModelicaFormatError("In writeJson.c: Returned an error when writing to %s.", ID->fileWriterName);
    }
    if (i == numVals-1){
      writeJsonLine(fOut,"\n", ID->fileWriterName);
    }else{
      writeJsonLine(fOut,",\n", ID->fileWriterName);
    }
  }
  writeJsonLine(fOut, "}\n", ID->fileWriterName);

  if (fclose(fOut) == EOF)
    ModelicaFormatError("In writeJson.c: Returned an error when closing %s.", ID->fileWriterName);
}
