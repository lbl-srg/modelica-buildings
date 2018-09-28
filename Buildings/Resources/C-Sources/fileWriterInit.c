/* Functions that ensures that each FileWriter writes to a unique file
 * and that stores variables in a struct for later use.
 *
 * Michael Wetter, LBNL                     2018-05-12
 * Filip Jorissen, KU Leuven
 */
#include "fileWriterStructure.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int fileWriterIsUnique(const char* fileName){
  int i;
  int isUnique = 1;
  for(i = 0; i < FileWriterNames_n; i++){
    if (!strcmp(fileName, FileWriterNames[i])){
      isUnique = 0;
      break;
    }
  }
  return isUnique;
}

void* fileWriterInit(
  const char* instanceName,
  const char* fileName,
  const int numColumns,
  const int isCombiTimeTable){

  if ( FileWriterNames_n == 0 ){
    /* Allocate memory for array of file names */
    FileWriterNames = malloc(sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in fileWriterInit.c for allocating FileWriterNames.");
  }
  else{
    /* Check if the file name is unique */
    if (! fileWriterIsUnique(fileName)){
      ModelicaFormatError("FileWriter %s writes to file %s which is already used by another FileWriter.\nEach FileWriter must use a unique file name.",
      FileWriterNames[0], fileName);
    }
    /* Reallocate memory for array of file names */
    FileWriterNames = realloc(FileWriterNames, (FileWriterNames_n+1) * sizeof(char*));
    if ( FileWriterNames == NULL )
      ModelicaError("Not enough memory in fileWriterInit.c for reallocating FileWriterNames.");
  }
  /* Allocate memory for this file name */
  FileWriterNames[FileWriterNames_n] = malloc((strlen(fileName)+1) * sizeof(char));
  if ( FileWriterNames[FileWriterNames_n] == NULL )
    ModelicaError("Not enough memory in fileWriterInit.c for allocating FileWriterNames[].");
  /* Copy the file name */
  strcpy(FileWriterNames[FileWriterNames_n], fileName);
  FileWriterNames_n++;

  FileWriter* ID;
  ID = (FileWriter*)malloc(sizeof(*ID));
  if ( ID == NULL )
    ModelicaFormatError("Not enough memory in fileWriterInit.c for allocating ID of FileWriter %s.", instanceName);

  ID->fileWriterName = malloc((strlen(fileName)+1) * sizeof(char));
  if ( ID->fileWriterName == NULL )
    ModelicaFormatError("Not enough memory in fileWriterInit.c for allocating ID->fileWriterName in FileWriter %s.", instanceName);
  strcpy(ID->fileWriterName, fileName);

  ID->instanceName = malloc((strlen(instanceName)+1) * sizeof(char));
  if ( ID->instanceName == NULL )
    ModelicaFormatError("Not enough memory in fileWriterInit.c for allocating ID->instanceName in FileWriter %s.", instanceName);
  strcpy(ID->instanceName, instanceName);

  if (numColumns<0)
    ModelicaFormatError("In fileWriterInit.c: The number of columns that are written by the FileWriter %s cannot be negative", instanceName);
  ID->numColumns=numColumns;
  ID->numRows=0;

  if (isCombiTimeTable<0 || isCombiTimeTable >1)
    ModelicaFormatError("In fileWriterInit.c: The initialisation flag 'isCombiTimeTable' of FileWriter %s must equal 0 or 1 but it equals %i.", instanceName, isCombiTimeTable);
  ID->isCombiTimeTable=isCombiTimeTable;

  FILE *fp = fopen(fileName, "w");
  if (fp == NULL)
    ModelicaFormatError("In fileWriterInit.c: Failed to create empty .csv file %s during initialisation.", fileName);
  fclose(fp);
  return (void*) ID;
}

/* This function writes a line to the FileWriter object file
and counts the total number of lines that are written
by incrementing the counter numRows if isMetaData==0. */
void writeLine(void *ptrFileWriter, const char* line, const int isMetaData){
  FileWriter *ID = (FileWriter*)ptrFileWriter;
  FILE *fOut = fopen(ID->fileWriterName, "a");
  if (fputs(line, fOut)==EOF){
    ModelicaFormatError("In fileWriterInit.c: Returned an error when writing to %s.", ID->fileWriterName);
  }
  if (isMetaData==0)
    ID->numRows=ID->numRows+1;
  fclose(fOut);
}
