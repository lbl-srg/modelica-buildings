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

#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
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

  fmu->terminate = (fTerminate)getAdr(fmu, "terminate");
  if (!(fmu->terminate)) {
    ModelicaError("Can't find function terminate().");
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

  size_t lenExt = strlen(ext);
  /* Get the file name without extension */
  size_t lenNam = strlen(nam) - lenExt;
  char * namOnl;
  namOnl = malloc((lenNam+1) * sizeof(char));
  if ( namOnl == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(namOnl, nam, lenNam);

  /* Prefix for temporary directory */
  const char* pre = "tmp-eplus-\0";
  size_t lenPre = strlen(pre);

  *dirNam = (char*)malloc((lenPre+lenNam+1) * sizeof(char));
  if ( *dirNam == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(*dirNam, pre, lenPre);
  strcat(*dirNam, namOnl);

  return;
}

void buildVariableNames(
  const char* zoneName,
  const char** variableNames,
  const size_t nVar,
  char** fullNames){
  /* Map the output values to correct parameters */
  /* Compute longest output name */
  size_t i;
  size_t lenOut = 0;
  writeLog(0, "Building variable names");
  ModelicaFormatError("*** %zu", nVar);
  for (i=0; i<nVar; i++){
    lenOut = max(lenOut, strlen(zoneName) + 2 + strlen(variableNames[i]));
  }
  writeLog(0, "Building variable names 2");
  fullNames = (char**)malloc(nVar * sizeof(char*));
  if (fullNames == NULL)
    ModelicaError("Failed to allocate memory for fullNames in FMUZoneInstantiate.c.");
  for (i=0; i<nVar; i++){
    fullNames[i] = (char*)malloc((lenOut+2) * sizeof(char));
    ModelicaError("Failed to allocate memory for fullNames[i] in FMUZoneInstantiate.c.");
  }
  for (i=0; i<nVar; i++){
    sprintf(fullNames[i], "%s,%s", zoneName, variableNames[i]);
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
  double* outputs,
  size_t nOut)
  {
  int i;
  int result;
  writeLog(1, "Getting parameters from EnergyPlus.");
  char** fullNames = NULL;

  fmi2ValueReference* outputValueReferences;
  outputValueReferences = (fmi2ValueReference*)malloc(nOut * sizeof(fmi2ValueReference));
  if ( outputValueReferences == NULL)
    ModelicaFormatError("Failed to allocate memory for outputValueReferences in FMUZoneInstantiate.c.");

  buildVariableNames(zone->name, parNames, nOut, fullNames);
  getValueReferences(fullNames, nOut,
    zone->outputVariableNames, zone->outputValueReferences, zone->nOutputValueReferences,
    outputValueReferences);
  /* Get initial output variables */
  result = fmu->getVariables(outputValueReferences, outputs, nOut, NULL);
  if (result <0 ){
    ModelicaFormatError("Failed to get initial outputs for building %s, zone %s.",
    zone->ptrBui->name, zone->name);
  }
  for (i = 0; i < nOut; i++)
    free(fullNames[i]);
  free(fullNames);
  free(outputValueReferences);

  return;
}

void FMUZoneAllocateDataStructure(FMUZone* zone, double t0){
  int cntr=0;
  int result;
  int i, j, k;
  const int nZon=zone->ptrBui->nZon;
  /* fmi2ValueReference* inputValueReferences=(fmi2ValueReference* )valgrin(nInp*sizeof(fmi2ValueReference)); */
  /* fmi2ValueReference* outputValueReferences=(fmi2ValueReference* )malloc(nOut*sizeof(fmi2ValueReference)); */

  writeLog(1, "Allocating data structure for all zones in the building.");

  zone->nInputValueReferences = 1;
  zone->nOutputValueReferences = 4;
  const size_t scaInp=zone->nInputValueReferences;
  const size_t scaOut=zone->nOutputValueReferences;
  const size_t nInp = scaInp*nZon;
  const size_t nOut = scaOut*nZon;

  char** inputNames;
  char** outputNames;
  char** fullNames = NULL;

  fmi2ValueReference* inputValueReferences;
  fmi2ValueReference* outputValueReferences;

  char* tmpDir;
  tmpDir = NULL;

  inputValueReferences = malloc(nInp * sizeof(inputValueReferences));
  if (inputValueReferences == NULL)
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for inputValueReferences.");

  outputValueReferences = malloc(nOut * sizeof(outputValueReferences));
  if (outputValueReferences == NULL)
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for outputValueReferences.");

  /* const char* consInputNames[]={"T", "X", "mInlets_flow", "TInlet", "QGaiRad_flow"}; */
  /* const char* consOutputNames[]={"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"}; */

  const char* consInputNames[]={"T"};
  const char* consOutputNames[]={"QConSen_flow", "V", "AFlo", "mSenFac"};

  inputNames = (char**) malloc(nInp * sizeof(char*));
  if (inputNames == NULL)
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for inputNames.");

  outputNames = (char**) malloc(nOut * sizeof(char*));
  if (outputNames == NULL)
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for outputNames.");

  FMUZone** tmpZon;
  tmpZon=(FMUZone**)malloc(nZon*sizeof(FMUZone*));
  if ( tmpZon == NULL )
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for zone name array in fmu.");


  for(i=0; i<nZon; i++){
    tmpZon[i] = (FMUZone*)malloc(sizeof(FMUZone));
    if ( tmpZon[i] == NULL )
      ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for zone name in fmu.");
    char* name = ((FMUZone*)(zone->ptrBui->zones[i]))->name;
    tmpZon[i]->name=name;
    zone->ptrBui->zones[i] = tmpZon[i];
  }

  for (i=0; i<nInp; i++){
    inputValueReferences[i]=i;
  }

  for (i=0; i<nOut; i++){
    outputValueReferences[i]=i+nInp;
  }
  writeLog(0, "Allocating storage 1");

  /*  Save input value references at zone and building level */
  cntr=0;
  for(j=0; j<nZon; j++){
    writeLog(0, "aaaaaaaaa");
    buildVariableNames(tmpZon[j]->name, consInputNames, tmpZon[j]->nInputValueReferences, fullNames);
    for(k=0; k < tmpZon[j]->nInputValueReferences; k++){
      strcpy(tmpZon[j]->inputVariableNames[k], fullNames[k]);
      tmpZon[j]->inputValueReferences[k]=inputValueReferences[cntr];
      cntr++;
    }
  }
  for(j=0; j<nZon; j++){
    for(k=0; k < tmpZon[j]->nInputValueReferences; k++)
      free(fullNames[k]);
    free(fullNames);
  }
  writeLog(0, "Allocating storage 2");

  /* Save output value references at zone and building level */
  cntr=0;
  for(j=0; j<nZon; j++){
    buildVariableNames(tmpZon[j]->name, consOutputNames, tmpZon[j]->nOutputValueReferences, fullNames);
    for(k=0; k < tmpZon[j]->nOutputValueReferences; k++){
      strcpy(tmpZon[j]->outputVariableNames[k], fullNames[k]);
      tmpZon[j]->outputValueReferences[k]=outputValueReferences[cntr];
      cntr++;
    }
  }
  for(j=0; j<nZon; j++){
    for(k=0; k < tmpZon[j]->nOutputValueReferences; k++)
      free(fullNames[k]);
    free(fullNames);
  }


  /* Load library if this is the first call for this idf file */
  /* Boolean to check that setupExperiment is only called once. */
  if (zone->ptrBui->fmu == NULL){
    /* This is the first call for this idf file.
       Allocate memory and load the library.
    */
    zone->ptrBui->fmu = (FMU*)malloc(sizeof(FMU));
    if ( zone->ptrBui->fmu == NULL )
      ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for fmu.");

   loadLib(zone->ptrBui->epLib, zone->ptrBui->fmu);
   zone->ptrBui->_firstCall = 1;
  }
  else{
    zone->ptrBui->_firstCall=0;
  }

  /* Instantiate the building FMU*/
  getEnergyPlusTemporaryDirectory(zone->ptrBui->name, &tmpDir);

  result = zone->ptrBui->fmu->instantiate(zone->ptrBui->name, /* input */
                       zone->ptrBui->weather,  /* weather */
                       zone->ptrBui->idd,  /* idd */
                       tmpDir,  /* instanceName */
                       NULL,  /* parameterNames */
                       NULL, /* parameterValueReferences[] */
                       0, /* nPar */
                       (const char**)inputNames, /* inputNames */
                       inputValueReferences, /* inputValueReferences[] */
                       nInp, /* nInp */
                       (const char**)outputNames, /* outputNames */
                       outputValueReferences, /* outputValueReferences[] */
                       nOut, /* nOut */
                       NULL); /*log); */
  if(result<0){
    ModelicaFormatError("Failed to instantiate building FMU with name %s.",
    zone->ptrBui->name);
  }
  /* free(tmpDir); */

   /* Need to pass the start value at initialization */
  if (zone->ptrBui->_firstCall){
    /* This function can only be called once per building FMU */
    /* ModelicaMessage("*** Calling setupExperiment."); */
    result = zone->ptrBui->fmu->setupExperiment(t0, 1, NULL);
    /* ModelicaMessage("*** Returned from setupExperiment."); */
    if(result<0){
      ModelicaFormatError("Failed to setup experiment for building FMU with name %s.",
      zone->ptrBui->name);
    }
  }

  return;
}

/* This function is called for each zone in the 'initial equation section'
*/
void FMUZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac){
  FMUZone* zone = (FMUZone*) object;

  if (zone->nInputValueReferences == 0){
    /* This zone has not yet been initialized.
       This section is only executed once if the 'initial equation' section is called multiple times.
    */
    FMUZoneAllocateDataStructure(zone, t0);
  }
  /* Get outputs */
  /* Allocate memory */
  const size_t nOut = 3;
  const char* parNames[] = {"V", "AFlo", "mSenFac"};

  double* outputs;
  outputs = (double*)malloc(nOut * sizeof(double));
  if (outputs == NULL)
    ModelicaError("Failed to allocated memory for outputs in FMUZoneInstantiate.c.");

  writeLog(0, "aaaa");
  writeLog(0, parNames[0]);
writeLog(0, parNames[1]);
  writeLog(0, parNames[2]);

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

    free(outputs);
 }
