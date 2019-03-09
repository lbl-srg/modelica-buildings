/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "FMUZoneInstantiate.h"
#include "FMUEnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifndef _MSC_VER
#include <dlfcn.h> /* Provides dlsym */
#endif

void* getAdr(FMU *fmu, const char* functionName){
  void* fp;
#ifdef _MSC_VER
  fp = GetProcAddress(fmu->dllHandle, functionName);
#else
  fp = dlsym(fmu->dllHandle, functionName);
#endif
  if (!fp) {
    ModelicaFormatError("Function %s, not found in the EnergyPlus functions library.",
    functionName);
  }
  return fp;
}

void loadLib(const char* libPath, FMU *fmu) {

#ifdef _MSC_VER
  HINSTANCE h;
#else
  void *h;
#endif

writeLog(0, "Opening EnergyPlus library.");
writeLog(0, libPath);

#ifdef _MSC_VER
  h = LoadLibrary(libPath);
  if (!h) {
    ModelicaFormatError("Unable to load the EnergyPlus functions library with path %s.",
    libPath);
  }
#else
  h = dlopen(libPath, RTLD_LAZY);
  if (!h) {
    ModelicaFormatError("Unable to load the EnergyPlus functions library with path %s.",
    libPath);
  }
#endif

  fmu->dllHandle = h;

  /* Set pointers to functions provided by dll */
  fmu->instantiate = (fmi2Instantiate)getAdr(fmu, "fmi2Instantiate");
  if (!(fmu->instantiate)) {
    ModelicaError("Can't find function fmi2SetupExperiment().");
  }

  fmu->setupExperiment = (fmi2SetupExperiment)getAdr(fmu, "fmi2SetupExperiment");
  if (!(fmu->setupExperiment)) {
    ModelicaError("Can't find function fmi2SetupExperiment().");
  }

  fmu->setTime = (fmi2SetTime)getAdr(fmu, "fmi2SetTime");
  if (!(fmu->setTime)) {
    ModelicaMessage("Can't find function fmi2SetTime().");
  }

  fmu->setVariables = (fmi2SetReal) getAdr(fmu, "fmi2SetReal");
  if (!(fmu->setVariables)) {
    ModelicaError("Can't find function fmi2SetReal().");
  }
  fmu->getVariables = (fmi2GetReal)getAdr(fmu, "fmi2GetReal");
  if (!(fmu->getVariables)) {
    ModelicaError("Can't find function fmi2GetReal().");
  }

  fmu->newDiscreteStates = (fmi2NewDiscreteStates)getAdr(fmu, "fmi2NewDiscreteStates");
  if (!(fmu->newDiscreteStates)) {
    ModelicaError("Can't find function fmi2NewDiscreteStates().");
  }

  fmu->terminateSim = (fmi2Terminate)getAdr(fmu, "terminateSim");
  if (!(fmu->terminateSim)) {
    ModelicaError("Can't find function fmi2Terminate().");
  }

  fmu->freeInstance = (fmi2FreeInstance)getAdr(fmu, "freeInstance");
  if (!(fmu->freeInstance)) {
    ModelicaError("Can't find function fmi2FreeInstance().");
  }

  return;
}

/* Returns the value references in selectedValueReferences
*/
void getValueReferences(
    char** requiredVars,
    const size_t nReqVar,
    char** variableNames,
    fmi2ValueReference* valueReferences,
    size_t nValRef,
    fmi2ValueReference* selectedValueReferences){
    int i;
    int j;
    for (i = 0; i < nReqVar; i++){
      for (j = 0; j < nValRef; j++){
         if ( strstr(requiredVars[i], variableNames[j]) != NULL ){
           /* Found the variable */
           selectedValueReferences[i] = valueReferences[j];
           break;
         }
      }
    }
  }

void getParametersFromEnergyPlus(
  FMU* fmu,
  FMUZone* zone,
  const char* parNames[], /* such as {"V", "AFlo", "mSenFac"} */
  double* parValues,
  size_t nPar)
  {
  int i;
  fmi2Status status;
  char** ptrVarNames = NULL;
  char** ptrFullNames = NULL;

  fmi2ValueReference* parameterValueReferences;
  writeLog(2, "Getting parameters from EnergyPlus.");

  parameterValueReferences = (fmi2ValueReference*)malloc(nPar * sizeof(fmi2ValueReference));
  if ( parameterValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for parameterValueReferences in FMUZoneInstantiate.c.");

  buildVariableNames(zone->name, parNames, nPar, &ptrVarNames, &ptrFullNames);

  getValueReferences(ptrFullNames, nPar,
    zone->parameterVariableNames, zone->parameterValueReferences, zone->nParameterValueReferences,
    parameterValueReferences);
  /* Get initial parameter variables */

  /* writeLog(1, "begin getVariables"); */
  status = fmu->getVariables(zone->ptrBui->fmuCom, parameterValueReferences, nPar, parValues);
  /* writeLog(1, "end getVariables"); */
  if (status != fmi2OK ){
    ModelicaFormatError("Failed to get parameters for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }

  for (i = 0; i < nPar; i++)
    free(ptrVarNames[i]);
  free(ptrVarNames);

  /* free(parameterValueReferences);  */

  return;
}

void FMUZoneSetValueReferences(
  FMUZone* *zone,
  size_t nVal,
  fmi2ValueReference* *valRef,
  fmi2ValueReference* cntr)
{
  int k;
  *valRef = (fmi2ValueReference*)malloc(nVal * sizeof(fmi2ValueReference));
  if (*valRef == NULL)
    ModelicaFormatError("Failed to allocate memory for valRef.");
  for(k=0; k < nVal; k++){
    (*valRef)[k]=*cntr;
    (*cntr)++;
  }
}

/*
 Appends a character array to another character array.

 The array size of buffer may be extended by this function
 to prevent a buffer overflow.

 Arguments:
  buffer The buffer to which the character array will be added.
  toAdd The character array that will be appended to \c buffer
  bufLen The length of the character array buffer. This parameter will
         be set to the new size of buffer if memory was reallocated.
*/
void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen){
  const size_t minInc = 1024;
  const size_t nNewCha = strlen(toAdd);
  const size_t nBufCha = strlen(*buffer);
  /* reallocate memory if needed */
  if ( *bufLen < nNewCha + nBufCha + 1){
    *bufLen = *bufLen + nNewCha + minInc + 1;
    *buffer = realloc(*buffer, *bufLen);
    if (*buffer == NULL) {
      ModelicaError("Realloc failed in saveAppend.");
    }
  }
  /* append toAdd to buffer */
  strcpy(*buffer + strlen(*buffer), toAdd);
  return;
}


void saveAppendJSONElements(
  char* *buffer,
  const char* names[],
  fmi2ValueReference* valueReferences,
  size_t nNames,
  size_t* bufLen){
    int i;
    /* Write all names and value references in the format
        { "name": "V", "valueReference": 0},
        { "name": "AFlo", "valueReference": 1}
    */
    char* strValRef;
    /* Compute the string length for the value reference */
    size_t len = 0;

    for(i = 0; i < nNames; i++)
      len = len > valueReferences[i] ? len : valueReferences[i];
    len = len / 10 + 1;

    strValRef = (char*)malloc((len+1) * sizeof(char));
    if (strValRef == NULL)
      ModelicaError("Failed to allocate memory for strValRef in saveAppendJSONElements.");

    for(i = 0; i < nNames; i++){
      /* Convert value reference to string */
      sprintf(strValRef, "%u", valueReferences[i]);
      /* Build JSON string */
      saveAppend(buffer, "      { \"name\": \"", bufLen);
      saveAppend(buffer, names[i], bufLen);
      saveAppend(buffer, "\", \"valueReference\": ", bufLen);
      saveAppend(buffer, strValRef, bufLen);
      saveAppend(buffer, " }", bufLen);
      if (i < nNames-1)
        saveAppend(buffer, ",\n", bufLen);
      else
        saveAppend(buffer, "\n", bufLen);
      }
      free(strValRef);
  }


void buildJSONModelStructureForEnergyPlus(const FMUBuilding* bui, char* *buffer, size_t* size){
  int iZon;
  FMUZone** zones = (FMUZone**)bui->zones;

  saveAppend(buffer, "\"zones\": [\n  {\n", size);
  for(iZon = 0; iZon < bui->nZon; iZon++){
    /* Write zone name */
    saveAppend(buffer, "    \"name\": \"", size);
    saveAppend(buffer, zones[iZon]->name, size);
    saveAppend(buffer, "\",\n", size);
    /* Write parameters */
    saveAppend(buffer, "    \"parameters\": [\n", size);
    saveAppendJSONElements(
      buffer,
      (const char **)(zones[iZon]->parameterNames),
      zones[iZon]->parameterValueReferences,
      zones[iZon]->nParameterValueReferences,
      size);
    saveAppend(buffer, "\n    ],\n", size);
    /* Write inputs */
    saveAppend(buffer, "    \"inputs\": [\n", size);
    saveAppendJSONElements(
      buffer,
      (const char **)(zones[iZon]->inputNames),
      zones[iZon]->inputValueReferences,
      zones[iZon]->nInputValueReferences,
      size);
    saveAppend(buffer, "\n    ],\n", size);
    /* Write outputs */
    saveAppend(buffer, "    \"outputs\": [\n", size);
    saveAppendJSONElements(
      buffer,
      (const char **)(zones[iZon]->outputNames),
      zones[iZon]->outputValueReferences,
      zones[iZon]->nOutputValueReferences,
      size);
    /* Close json array */
    saveAppend(buffer, "\n    ]\n", size);

    return;
  }
}


void writeModelStructureForEnergyPlus(const FMUBuilding* bui){
  char * buffer;
  size_t size;
  size_t lenNam;
  char * filNam;
  FILE* fp;

  /* Initial size which will grow as needed */
  size = 1024;

  buffer = (char*)malloc((size+1) * sizeof(char));
  if ( buffer == NULL)
    ModelicaFormatError("Failed to allocate memory for json buffer.");
  memset(buffer, '\0', size + 1);

  /* Build the json structure */
  buildJSONModelStructureForEnergyPlus(bui, &buffer, &size);

  /* Write to file */
  /* Build the file name */
  lenNam = strlen(bui->tmpDir) + strlen(MOD_BUI_JSON);
  filNam = malloc((lenNam+1) * sizeof(char));
  if (filNam == NULL)
    ModelicaFormatError("Failed to allocate memory for name of '%s' file.", MOD_BUI_JSON);
  memset(filNam, '\0', lenNam+1);
  strcpy(filNam, bui->tmpDir);
  strcat(filNam, MOD_BUI_JSON);

  /* Open and write file */
  fp = fopen(filNam, "w");
  if (fp == NULL)
    ModelicaFormatError("Failed to open '%s' with write mode.", filNam);
  fprintf(fp, "%s", buffer);
  fclose(fp);
  free(filNam);
}

void setValueReferences(const FMUBuilding* bui){
  fmi2ValueReference cntr=0;
  int result;
  int i;
  int j;

  FMUZone** zones = (FMUZone**)bui->zones;

/*  FMUBuilding* bui = zone->ptrBui; */
  const int nZon=bui->nZon;

  const size_t scaPar=(*zones)[0].nParameterValueReferences;
  const size_t scaInp=(*zones)[0].nInputValueReferences;
  const size_t scaOut=(*zones)[0].nOutputValueReferences;
  const size_t nPar = scaPar*nZon;
  const size_t nInp = scaInp*nZon;
  const size_t nOut = scaOut*nZon;
  size_t len;

  fmi2ValueReference* parameterValueReferences;
  fmi2Byte** parameterNames;
  fmi2ValueReference* inputValueReferences;
  fmi2Byte** inputNames;
  fmi2ValueReference* outputValueReferences;
  fmi2Byte** outputNames;

  writeLog(1, "Allocating data structure for all zones in the building.");

  /* Define value references */
  /* Save input value references at zone and building level */
  cntr=0;

  for(j=0; j<nZon; j++){
    FMUZoneSetValueReferences(&(zones[j]), zones[j]->nParameterValueReferences, &(zones[j]->parameterValueReferences), &cntr);
  }
  for(j=0; j<nZon; j++){
    FMUZoneSetValueReferences(&(zones[j]), zones[j]->nInputValueReferences, &(zones[j]->inputValueReferences), &cntr);
  }
  /* Save output value references at zone and building level */
  for(j=0; j<nZon; j++){
    FMUZoneSetValueReferences(&(zones[j]), zones[j]->nOutputValueReferences, &(zones[j]->outputValueReferences), &cntr);
  }

  /* Build data structure to be sent to EnergyPlus */
  /* Allocate memory */

  /* Get 1-D array of value references */
  parameterValueReferences = (fmi2ValueReference*)malloc(nPar * sizeof(fmi2ValueReference));
  if ( parameterValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for parameterValueReferences.");

  inputValueReferences = (fmi2ValueReference*)malloc(nInp * sizeof(fmi2ValueReference));
  if ( inputValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for inputValueReferences.");

  outputValueReferences = (fmi2ValueReference*)malloc(nOut * sizeof(fmi2ValueReference));
  if ( outputValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for outputValueReferences.");

  /* Get 1-D array of names */
  /* Parameters */
  parameterNames = (char**)malloc(nPar * sizeof(char*));
  if ( parameterNames == NULL)
    ModelicaFormatError("Failed to allocate memory for parameterNames.");

  len = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaPar; j++){
      len = max(len, strlen(zones[i]->parameterVariableNames[j]));
    }
  }

  for(i = 0; i < nPar; i++){
    /* strlen, used above, does not include the terminating null character */
    parameterNames[i] = (char*)malloc((len+1) * sizeof(char));
    if ( parameterNames[i] == NULL)
      ModelicaFormatError("Failed to allocate memory for parameterNames[i].");
    memset(parameterNames[i], '\0', len + 1);
  }

  cntr = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaPar; j++){
      parameterValueReferences[cntr] = zones[i]->parameterValueReferences[j];
      strncpy(parameterNames[cntr],
        zones[i]->parameterVariableNames[j],
        strlen(zones[i]->parameterVariableNames[j]));
      cntr++;
    }
  }

  /* Inputs */
  inputNames = (char**)malloc(nInp * sizeof(char*));
  if ( inputNames == NULL)
    ModelicaFormatError("Failed to allocate memory for inputNames.");

  len = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaInp; j++){
      len = max(len, strlen(zones[i]->inputVariableNames[j]));
    }
  }

  for(i = 0; i < nInp; i++){
    /* strlen, used above, does not include the terminating null character */
    inputNames[i] = (char*)malloc((len+1) * sizeof(char));
    if ( inputNames[i] == NULL)
      ModelicaFormatError("Failed to allocate memory for inputNames[i].");
    memset(inputNames[i], '\0', len + 1);
  }
  cntr = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaInp; j++){
      inputValueReferences[cntr] = zones[i]->inputValueReferences[j];
      strncpy(inputNames[cntr],
        zones[i]->inputVariableNames[j],
        strlen(zones[i]->inputVariableNames[j]));
      cntr++;
    }
  }

  /* Outputs */
  outputNames = (char**)malloc(nOut * sizeof(char*));
  if ( outputNames == NULL)
    ModelicaFormatError("Failed to allocate memory for outputNames.");
  len = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaOut; j++){
      len = max(len, strlen(zones[i]->outputVariableNames[j]));
    }
  }
  for(i = 0; i < nOut; i++){
    /* strlen, used above, does not include the terminating null character */
    outputNames[i] = (char*)malloc((len+1) * sizeof(char));
    if ( outputNames[i] == NULL)
      ModelicaFormatError("Failed to allocate memory for outputNames[i].");
    memset(outputNames[i], '\0', len + 1);
  }

  cntr = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaOut; j++){
      outputValueReferences[cntr] = zones[i]->outputValueReferences[j];
      strncpy(outputNames[cntr],
        zones[i]->outputVariableNames[j],
        strlen(zones[i]->outputVariableNames[j]));
      cntr++;
    }
  }

  logStringArray(3, "Parameter names", (const char**)parameterNames, nPar);
  logValueReferenceArray(3, "Parameter value references", parameterValueReferences, nPar);
  logStringArray(3, "Input names", (const char**)inputNames, nInp);
  logValueReferenceArray(3, "Input value references", inputValueReferences, nInp);
  logStringArray(3, "Output names", (const char**)outputNames, nOut);
  logValueReferenceArray(3, "Output value references", outputValueReferences, nOut);

  free(parameterValueReferences);
  for(i = 0; i < nPar; i++)
    free(parameterNames[i]);
  free(parameterNames);

  free(inputValueReferences);
  for(i = 0; i < nInp; i++)
    free(inputNames[i]);
  free(inputNames);

  free(outputValueReferences);
  for(i = 0; i < nOut; i++)
    free(outputNames[i]);
  free(outputNames);

  return;
}


void FMUZoneAllocateAndInstantiateBuilding(FMUBuilding* bui){

  fmi2Boolean visible = fmi2False;
  fmi2Boolean loggingOn = fmi2True; /* fixme: Make an argument from Modelica */
  fmi2String fmuGUID = bui->name; /* GUID (simply set to the idf name because this is unique already) */
  fmi2Type fmuType = fmi2ModelExchange;


  /* Set callback functions */
  fmi2CallbackAllocateMemory allocateMemory = calloc;
  fmi2CallbackFreeMemory freeMemory = free;
  fmi2StepFinished stepFinished = NULL;
  fmi2ComponentEnvironment componentEnvironment = NULL;
  fmi2Status loggerStatus = fmi2OK;
  fmi2CallbackLogger logger = {componentEnvironment, bui->name, loggerStatus, "category", "message"};

  const fmi2CallbackFunctions callBackFunctions = { logger, allocateMemory, freeMemory, stepFinished, componentEnvironment };

  /* Set the value references for all parameters, inputs and outputs */
  setValueReferences(bui);

  /* Write the model structure to the FMU Resources folder so that EnergyPlus can
     read it and set up the data structure.
  */
  writeModelStructureForEnergyPlus(bui);
  /* This is the first call for this idf file.
     Allocate memory and load the library.
  */
  bui->fmu = (FMU*)malloc(sizeof(FMU));
  if ( bui->fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for fmu.");

  loadLib(bui->epLib, bui->fmu);

  writeLog(0, "Instantiating fmu.");

  /* Instantiate EnergyPlus, and get an fmi2Component */
  bui->fmuCom = bui->fmu->instantiate(
                       bui->name, /* instanceName (set to the same as the building name) */
                       fmuType,
                       fmuGUID,
                       bui->tmpDir,  /* fmuResourceLocation, which is the temporary directory name */
                       &callBackFunctions, /* call back functions so that FMU can report to master */
                       visible, /* Set to fmi2False, e.g., no user interaction or pop up windows */
                       loggingOn); /* If fmi2True, debug logging is enabled, else it is disabled */

  writeLog(2, "Returned from instantiating fmu.");
  if( bui->fmuCom == NULL ){
    ModelicaFormatError("Failed to instantiate building FMU with name %s.",
    bui->name);
  }

  return;
}

/* This function is called for each zone in the 'initial equation section'
*/
void FMUZoneInstantiate(void* object, double startTime, double* AFlo, double* V, double* mSenFac){
  fmi2Status status;
  FMUZone* zone = (FMUZone*) object;

  double* outputs;

  if (zone->ptrBui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
    */
    FMUZoneAllocateAndInstantiateBuilding(zone->ptrBui);
    /* This function can only be called once per building FMU */
    writeLog(0, "Setting up experiment.");

    status = zone->ptrBui->fmu->setupExperiment(
        zone->ptrBui->fmuCom, /* fmi2Component */
        fmi2False,            /* toleranceDefined */
        0.0,                  /* tolerance */
        startTime,            /* startTime */
        fmi2False,            /* stopTimeDefined */
        0);                   /* stopTime */

    writeLog(0, "Returned from setting up experiment.");
    if( status =! fmi2OK ){
      ModelicaFormatError("Failed to setup experiment for building FMU with name %s.",  zone->ptrBui->name);
    }
  }

  /* Allocate memory */
  outputs = (double*)malloc(zone->nParameterValueReferences * sizeof(double));
  if (outputs == NULL)
    ModelicaError("Failed to allocated memory for outputs in FMUZoneInstantiate.c.");

  getParametersFromEnergyPlus(
    zone->ptrBui->fmu,
    zone,
    (const char **)(zone->parameterNames),
    outputs,
    zone->nParameterValueReferences);

    /* Obtain the floor area and the volume of the zone */
    *V = outputs[0];
    *AFlo = outputs[1];
    *mSenFac = outputs[2];

    /* free(outputs); */
}
