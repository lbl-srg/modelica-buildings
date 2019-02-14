/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "FMUEnergyPlusStructure.h"
#include "ModelicaUtilities.h"

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
  writeLog(0, "Opening EnergyPlus library.");
  writeLog(0, libPath);

#ifdef _MSC_VER
  HINSTANCE h;
#else
  void *h;
#endif

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
  fmu->instantiate = (fInstantiate)getAdr(fmu, "instantiate");
  if (!(fmu->instantiate)) {
    ModelicaError("Can't find function instantiate().");
  }

  fmu->setupExperiment = (fSetupExperiment)getAdr(fmu, "setupExperiment");
  if (!(fmu->setupExperiment)) {
    ModelicaError("Can't find function setupExperiment().");
  }

  fmu->setTime = (fSetTime)getAdr(fmu, "setTime");
  if (!(fmu->setTime)) {
    ModelicaMessage("Can't find function setTime().");
  }

  fmu->setVariables = (fSetVariables) getAdr(fmu, "setVariables");
  if (!(fmu->setVariables)) {
    ModelicaError("Can't find function setVariables().");
  }
  fmu->getVariables = (fGetVariables)getAdr(fmu, "getVariables");
  if (!(fmu->getVariables)) {
    ModelicaError("Can't find function getVariables().");
  }

  fmu->getNextEventTime = (fGetNextEventTime)getAdr(fmu, "getNextEventTime");
  if (!(fmu->getNextEventTime)) {
    ModelicaError("Can't find function getNextEventTime().");
  }

  fmu->terminateSim = (fTerminateSim)getAdr(fmu, "terminateSim");
  if (!(fmu->terminateSim)) {
    ModelicaError("Can't find function terminateSim().");
  }
  return;
}

void getEnergyPlusTemporaryDirectory(const char* idfName, char** dirNam){
  /* Return the name of the temporary directory to be used for EnergyPlus */
  /* Get file name without path */
  /* return "tmp-eplus-ValidationRefBldgSmallOfficeNew2004_Chicago"; */
  char * namWitSla = strrchr(idfName, '/');

  if ( namWitSla == NULL )
    ModelicaFormatError("Failed to parse idfName '%s'. Expected an absolute path with forward slash '/'?", idfName);
  /* Remove the first slash */
  char * nam = namWitSla + 1;
  /* Get the extension */
  char * ext = strrchr(nam, '.');
  if ( ext == NULL )
    ModelicaFormatError("Failed to parse idfName '%s'. Expected a file extension such as '.idf'?", idfName);

  /* Get the file name without extension */
  size_t lenNam = strlen(nam) - strlen(ext);
  char * namOnl;
  namOnl = malloc((lenNam) * sizeof(char));
  if ( namOnl == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(namOnl, nam, lenNam);
  /* Add termination character */
  namOnl[lenNam] = '\0';

  /* Prefix for temporary directory */
  const char* pre = "tmp-eplus-\0";
  size_t lenPre = strlen(pre);

  *dirNam = malloc((lenPre+lenNam+1) * sizeof(char));
  if ( *dirNam == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(*dirNam, pre, lenPre);
  (*dirNam)[lenPre] = '\0';
  /* Add termination character */
  strcat(*dirNam, namOnl);
  free(namOnl);

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
  double* outputs,
  size_t nOut)
  {
  int i;
  int result;
  size_t len;
  writeLog(1, "Getting parameters from EnergyPlus.");
  char** fullNames = NULL;

  fmi2ValueReference* parameterValueReferences;
  parameterValueReferences = (fmi2ValueReference*)malloc(nOut * sizeof(fmi2ValueReference));
  if ( parameterValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for parameterValueReferences in FMUZoneInstantiate.c.");

  buildVariableNames(zone->name, parNames, nOut, &fullNames, &len);
  getValueReferences(fullNames, nOut,
    zone->parameterVariableNames, zone->parameterValueReferences, zone->nParameterValueReferences,
    parameterValueReferences);
  /* Get initial parameter variables */
  //result = fmu->getVariables(parameterValueReferences, outputs, nOut, NULL);

  //writeLog(1, "begin getVariables");
  result = fmu->getVariables(parameterValueReferences, outputs, nOut, NULL);
  //writeLog(1, "end getVariables");
  if (result <0 ){
    ModelicaFormatError("Failed to get initial outputs for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }
  //for (i = 0; i < nOut; i++)
  //  free(fullNames[i]);
  //free(fullNames);
  //free(parameterValueReferences);

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


void FMUZoneAllocateAndInstantiateBuilding(FMUBuilding* bui){
  fmi2ValueReference cntr=0;
  int result;
  int i;
  int j;
  FMUZone** zones = NULL;
  zones = (FMUZone**)bui->zones;

/*  FMUBuilding* bui = zone->ptrBui; */
  const int nZon=bui->nZon;

  const size_t scaPar=(*zones)[0].nParameterValueReferences;
  const size_t scaInp=(*zones)[0].nInputValueReferences;
  const size_t scaOut=(*zones)[0].nOutputValueReferences;
  const size_t nPar = scaPar*nZon;
  const size_t nInp = scaInp*nZon;
  const size_t nOut = scaOut*nZon;
  size_t len;
  writeLog(1, "Allocating data structure for all zones in the building.");

  char* tmpDir;
  tmpDir = NULL;

  fmi2ValueReference* parameterValueReferences;
  fmi2Byte** parameterNames;
  fmi2ValueReference* inputValueReferences;
  fmi2Byte** inputNames;
  fmi2ValueReference* outputValueReferences;
  fmi2Byte** outputNames;
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
    parameterNames[i] = (char*)malloc(len * sizeof(char));
    if ( parameterNames[i] == NULL)
      ModelicaFormatError("Failed to allocate memory for parameterNames[i].");
  }
  cntr = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaPar; j++){
      parameterValueReferences[cntr] = zones[i]->parameterValueReferences[j];
      strcpy(parameterNames[cntr], zones[i]->parameterVariableNames[j]);
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
    inputNames[i] = (char*)malloc(len * sizeof(char));
    if ( inputNames[i] == NULL)
      ModelicaFormatError("Failed to allocate memory for inputNames[i].");
  }
  cntr = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaInp; j++){
      inputValueReferences[cntr] = zones[i]->inputValueReferences[j];
      strcpy(inputNames[cntr], zones[i]->inputVariableNames[j]);
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
    outputNames[i] = (char*)malloc(len * sizeof(char));
    if ( outputNames[i] == NULL)
      ModelicaFormatError("Failed to allocate memory for outputNames[i].");
  }

  cntr = 0;
  for(i = 0; i < nZon; i++){
    for(j = 0; j < scaOut; j++){
      outputValueReferences[cntr] = zones[i]->outputValueReferences[j];
      strcpy(outputNames[cntr], zones[i]->outputVariableNames[j]);
      cntr++;
    }
  }

  /* This is the first call for this idf file.
     Allocate memory and load the library.
  */
  bui->fmu = (FMU*)malloc(sizeof(FMU));
  if ( bui->fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for fmu.");

  loadLib(bui->epLib, bui->fmu);

  /* Instantiate the building FMU*/
  getEnergyPlusTemporaryDirectory(bui->name, &tmpDir);


  writeLog(0, "Instantiating fmu.");
  logStringArray(3, "Parameter names", (const char**)parameterNames, nPar);
  logValueReferenceArray(3, "Parameter value references", parameterValueReferences, nPar);
  logStringArray(3, "Input names", (const char**)inputNames, nInp);
  logValueReferenceArray(3, "Input value references", inputValueReferences, nInp);
  logStringArray(3, "Output names", (const char**)outputNames, nOut);
  logValueReferenceArray(3, "Output value references", outputValueReferences, nOut);
  result = bui->fmu->instantiate(bui->name, /* input */
                       bui->weather,  /* weather */
                       bui->idd,  /* idd */
                       tmpDir,  /* instanceName */
                       (const char**)parameterNames,  /* parameterNames */
                       parameterValueReferences, /* parameterValueReferences[] */
                       nPar, /* nPar */
                       (const char**)inputNames, /* inputNames */
                       inputValueReferences, /* inputValueReferences[] */
                       nInp, /* nInp */
                       (const char**)outputNames, /* outputNames */
                       outputValueReferences, /* outputValueReferences[] */
                       nOut, /* nOut */
                       NULL); /*log); */
  writeLog(3, "Returned from instantiating fmu.");
  if(result<0){
    ModelicaFormatError("Failed to instantiate building FMU with name %s.",
    bui->name);
  }

  /* EnergyPlus relies on these memories
  free(tmpDir);

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
  */
  return;
}

/* This function is called for each zone in the 'initial equation section'
*/
void FMUZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac){
  int result = 0;
  FMUZone* zone = (FMUZone*) object;
  const size_t nOut = 3;
  const char* parNames[] = {"V", "AFlo", "mSenFac"};

  double* outputs;

  if (zone->ptrBui->fmu == NULL){
    /* EnergyPlus is not yet loaded.
       This section is only executed once if the 'initial equation' section is called multiple times.
    */
    FMUZoneAllocateAndInstantiateBuilding(zone->ptrBui);
    /* This function can only be called once per building FMU */
    writeLog(0, "Setting up experiment.");
    result = zone->ptrBui->fmu->setupExperiment(t0, 1, NULL);
    writeLog(0, "Returned from setting up experiment.");
    if(result<0){
      ModelicaFormatError("Failed to setup experiment for building FMU with name %s.",  zone->ptrBui->name);
  }

  }
  /* Allocate memory */
  outputs = (double*)malloc(nOut * sizeof(double));
  if (outputs == NULL)
    ModelicaError("Failed to allocated memory for outputs in FMUZoneInstantiate.c.");


  getParametersFromEnergyPlus(
    zone->ptrBui->fmu,
    zone,
    parNames,
    outputs,
    nOut);

    /* Obtain the floor area and the volume of the zone */
    *V = outputs[0];
    *AFlo = outputs[1];
    *mSenFac = outputs[2];

    //free(outputs);
 }
