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
    ModelicaFormatError("Function %s,  not "
    "found in the EnergyPlus functions library.\n",
    functionName);
  }
  return fp;
}

int loadLib(const char* libPath, FMU *fmu) {
#ifdef _MSC_VER
  HINSTANCE h;
#else
  void *h;
#endif

#ifdef _MSC_VER
  h = LoadLibrary(libPath);
  if (!h) {
    ModelicaFormatError("Unable to load the EnergyPlus "
    "functions library with path %s.\n",
    libPath);
  }
#else
  h = dlopen(libPath, RTLD_LAZY);
  if (!h) {
    ModelicaFormatError("Unable to load the EnergyPlus "
    "functions library with path %s.\n",
    libPath);
  }
#endif

  fmu->dllHandle = h;

  fmu->instantiate = (fInstantiate)getAdr(fmu, "instantiate");
  if (!(fmu->instantiate)) {
    ModelicaError("Can't find function instantiate().\n");
  }

  fmu->setupExperiment = (fSetupExperiment)getAdr(fmu, "setupExperiment");
  if (!(fmu->setupExperiment)) {
    ModelicaError("Can't find function setupExperiment().\n");
  }

  fmu->setTime = (fSetTime)getAdr(fmu, "setTime");
  if (!(fmu->setTime)) {
    ModelicaMessage("Can't find function setTime().\n");
  }

  fmu->setVariables = (fSetVariables) getAdr(fmu, "setVariables");
  if (!(fmu->setVariables)) {
    ModelicaError("Can't find function setVariables().\n");
  }
  fmu->getVariables = (fGetVariables)getAdr(fmu, "getVariables");
  if (!(fmu->getVariables)) {
    ModelicaError("Can't find function getVariables().\n");
  }

  fmu->getNextEventTime = (fGetNextEventTime)getAdr(fmu, "getNextEventTime");
  if (!(fmu->getNextEventTime)) {
    ModelicaError("Can't find function getNextEventTime().\n");
  }

  fmu->terminate = (fTerminate)getAdr(fmu, "terminate");
  if (!(fmu->terminate)) {
    ModelicaError("Can't find function terminate().\n");
  }
  return 0;

}

void getParametersFromEnergyPlus(
  FMU* fmu,
  const char* buildingName,
  const char* zoneName,
  char** outputNames,
  const fmi2ValueReference outputValueReferences[],
  size_t totNumOut,
  double* AFlo,
  double* V,
  double* mSenFac){

  int i;
  int j;
  int result;
  size_t lenOut = 0;
  double* outputs;
  const char* parNames[] = {"V","AFlo","mSenFac"};
  double parValues[3];
  char* outNamEP;

  /* Allocate memory */
  outputs = (double*)malloc(totNumOut * sizeof(double));
  /* Get initial output variables */
  result = fmu->getVariables(outputValueReferences, outputs, totNumOut, NULL);
  if(result <0 ){
    ModelicaFormatError("Failed to get initial outputs for building %s, zone %s.\n",
    buildingName, zoneName);
  }

  /* Map the output values to correct parameters */
  /* Compute longest output name */
  for (i=0; i<3; i++){
    lenOut = max(lenOut, strlen(zoneName) + 1 + strlen(parNames[i]));
  }
  outNamEP = (char*) malloc((lenOut+1) * sizeof(char));
  if ( outNamEP == NULL )
    ModelicaFormatError("Failed to allocate memory for EnergyPlus output variable name in FMUZoneInstantiate.c.");
  for (i=0; i<3; i++){
    sprintf(outNamEP, "%s%s%s", zoneName, ",", parNames[i]);
    for (j=0; j<totNumOut; j++){
      if (strstr(outputNames[j], outNamEP)!=NULL){
        parValues[i] = outputs[j];
        break;
      }
    }
  }

  /* Obtain the floor area and the volume of the zone */
  *V = parValues[0];
  *AFlo = parValues[1];
  *mSenFac = parValues[2];
  return;
}

void FMUZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac){
  FMUZone* zone = (FMUZone*) object;
  /* Prevent this to be called multiple times */
  FMU* fmu;
  int cntr=0;
  int result;
  int i, j, k ;
  size_t totNumInp;
  size_t totNumOut;

  const int nZon=zone->ptrBui->nZon;
  /* fmi2ValueReference* inputValueReferences=(fmi2ValueReference* )valgrin(nInp*sizeof(fmi2ValueReference)); */
  /* fmi2ValueReference* outputValueReferences=(fmi2ValueReference* )malloc(nOut*sizeof(fmi2ValueReference)); */
  const int scaInp=1;
  const int scaOut=4;
  const int nInp = scaInp*nZon;
  const int nOut = scaOut*nZon;

  char** inputNames;
  char** outputNames;

  fmi2ValueReference* inputValueReferences;
  fmi2ValueReference* outputValueReferences;

  inputValueReferences = malloc(nInp * sizeof(inputValueReferences));
  if (inputValueReferences == NULL)
    ModelicaError("Not enough memory in FMUZoneIntialize.c. to allocate memory for inputValueReferences.");

  outputValueReferences = malloc(nOut * sizeof(outputValueReferences));
  if (outputValueReferences == NULL)
    ModelicaError("Not enough memory in FMUZoneIntialize.c. to allocate memory for outputValueReferences.");

  /* const char* consInputNames[]={"T", "X", "mInlets_flow", "TInlet", "QGaiRad_flow"}; */
  /* const char* consOutputNames[]={"TRad", "QConSen_flow", "QLat_flow", "QPeo_flow"}; */

  const char* consInputNames[]={"T"};
  const char* consOutputNames[]={"QConSen_flow", "V", "AFlo", "mSenFac"};

  inputNames = (char**) malloc(nInp * sizeof(char*));
  if (inputNames == NULL)
    ModelicaError("Not enough memory in FMUZoneIntialize.c. to allocate memory for inputNames.");

  outputNames = (char**) malloc(nOut * sizeof(char*));
  if (outputNames == NULL)
    ModelicaError("Not enough memory in FMUZoneIntialize.c. to allocate memory for outputNames.");

  fmu = (FMU*)malloc(sizeof(FMU));
  if ( fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneIntialize.c. to allocate memory for fmu.");
  FMUZone** tmpZon;
  tmpZon=(FMUZone**)malloc(nZon*sizeof(FMUZone*));
  if ( tmpZon == NULL )
    ModelicaError("Not enough memory in FMUZoneIntialize.c to allocate memory for zone name array in fmu.");


  for(i=0; i<nZon; i++){
    tmpZon[i] = (FMUZone*)malloc(sizeof(FMUZone));
    if ( tmpZon[i] == NULL )
      ModelicaError("Not enough memory in FMUZoneIntialize.c to allocate memory for zone name in fmu.");
    char* name = ((FMUZone*)(zone->ptrBui->zones[i]))->name;
    tmpZon[i]->name=name;
    zone->ptrBui->zones[i] = tmpZon[i];
  }

  /* Boolean to check that setupExperiment is only called once. */
  if (zone->ptrBui->fmu==NULL){
   zone->ptrBui->_firstCall = 1;
  }
  else{
    zone->ptrBui->_firstCall=0;
  }

  zone->ptrBui->fmu = fmu;
  for (i=0; i<nInp; i++){
    inputValueReferences[i]=i;
  }

  for (i=0; i<nOut; i++){
    outputValueReferences[i]=i+nInp;
  }

  /* Save input value references at zone and building level */
  while (cntr<nInp){
    for (k=0; k<scaInp; k++){
      for (j=0; j<nZon; j++) {
        inputNames[cntr]=(char*)malloc((strlen(tmpZon[j]->name)+strlen(consInputNames[k]) + 2)*sizeof(char));
        if ( inputNames[cntr] == NULL )
          ModelicaError("Not enough memory in FMUZoneIntialize.c to allocate memory for inputNames.");
        sprintf(inputNames[cntr], "%s%s%s", tmpZon[j]->name, ",", consInputNames[k]);
        strcpy(tmpZon[j]->inputVariableNames[k], inputNames[cntr]);
        tmpZon[j]->inputValueReferences[k]=inputValueReferences[cntr];
        cntr++;
      }
    }
  }

  /* Save output value references at zone and building level */
  cntr=0;
  while (cntr<nInp){
    for (k=0; k<scaOut; k++){
      for (j=0; j<nZon; j++){
        outputNames[cntr]=(char*)malloc((strlen(tmpZon[j]->name)+strlen(consOutputNames[k]) + 2)*sizeof(char));
        if ( outputNames[cntr] == NULL )
          ModelicaError("Not enough memory in FMUZoneIntialize.c to allocate memory for outputNames.");
        sprintf(outputNames[cntr], "%s%s%s", tmpZon[j]->name, ",", consOutputNames[k]);
        strcpy(tmpZon[j]->outputVariableNames[k], outputNames[cntr]);
        tmpZon[j]->outputValueReferences[k]=outputValueReferences[cntr];
        cntr++;
      }
    }
  }

  /* Compute the total number of input variables of the building model */
  totNumInp=sizeof(inputValueReferences)/sizeof(inputValueReferences[0]);
  /* Compute the total number of output variables of the building model */
  totNumOut=sizeof(outputValueReferences)/sizeof(outputValueReferences[0]);
  result = loadLib(zone->ptrBui->epLib, zone->ptrBui->fmu);

  /* Instantiate the building FMU*/
  result = zone->ptrBui->fmu->instantiate(zone->ptrBui->name, /* input */
                       zone->ptrBui->weather,  /* weather */
                       zone->ptrBui->idd,  /* idd */
                       "Alpha",  /* instanceName */
                       NULL,  /* parameterNames */
                       NULL, /* parameterValueReferences[] */
                       0, /* nPar */
                       (const char**)inputNames, /* inputNames */
                       inputValueReferences, /* inputValueReferences[] */
                       totNumInp, /* nInp */
                       (const char**)outputNames, /* outputNames */
                       outputValueReferences, /* outputValueReferences[] */
                       totNumOut, /* nOut */
                       NULL); /*log); */

  if(result<0){
    ModelicaFormatError("Couldn't instantiate building FMU with name %s.\n",
    zone->ptrBui->name);
  }

   /* Need to pass the start value at initialization */
  if (zone->ptrBui->_firstCall){
    /* This function can only be called once per building FMU */
    ModelicaMessage("*** Calling setupExperiment.\n");
    result = zone->ptrBui->fmu->setupExperiment(t0, 1, NULL);
    ModelicaMessage("*** Returned from setupExperiment.\n");    
    if(result<0){
      ModelicaFormatError("Failed to get setup experiment for building FMU with name %s.\n",
      zone->ptrBui->name);
    }
  }

  getParametersFromEnergyPlus(
    zone->ptrBui->fmu,
    zone->ptrBui->name,
    zone->name,
    outputNames,
    outputValueReferences,
    totNumOut,
    AFlo, V, mSenFac);

  return;
}
