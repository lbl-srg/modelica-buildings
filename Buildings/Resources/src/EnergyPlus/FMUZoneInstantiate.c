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

int loadLib(const char* libPath, FMU *fmu) {
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
  return 0;

}

char* getEnergyPlusTemporaryDirectory(const char* idfName){
  /* Return the name of the temporary directory to be used for EnergyPlus */
  /* Get file name without path */

  char * nam = strrchr(idfName, '/');
  if ( nam == NULL )
    ModelicaFormatError("Failed to parse idfName '%s'. Expected an absolute path with forward slash '/'?", idfName);
  /* Remove the first slash */
  nam++;
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
  const char* pre = "tmp-eplus-";
  size_t lenPre = strlen(pre);
  char * des;
  des = malloc((lenPre+lenNam+1) * sizeof(char));

  if ( des == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(des, pre, lenPre);
  strncat(des, namOnl, lenNam);

  return des;
}

void getParametersFromEnergyPlus(
  FMU* fmu,
  const char* buildingName,
  const char* zoneName,
  char** outputNames,
  const fmi2ValueReference outputValueReferences[],
  size_t nOut,
  double* AFlo,
  double* V,
  double* mSenFac){

  int i;
  int j;
  int result;
  size_t lenOut = 0;
  double* outputs;
  const char* parNames[] = {"V", "AFlo", "mSenFac"};
  double parValues[3];
  char* outNamEP;

  /* Allocate memory */
  outputs = (double*)malloc(nOut * sizeof(double));
  /* Get initial output variables */
  result = fmu->getVariables(outputValueReferences, outputs, nOut, NULL);
  if (result <0 ){
    ModelicaFormatError("Failed to get initial outputs for building %s, zone %s.",
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
    for (j=0; j<nOut; j++){
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
  int i, j, k;

  const int nZon=zone->ptrBui->nZon;
  /* fmi2ValueReference* inputValueReferences=(fmi2ValueReference* )valgrin(nInp*sizeof(fmi2ValueReference)); */
  /* fmi2ValueReference* outputValueReferences=(fmi2ValueReference* )malloc(nOut*sizeof(fmi2ValueReference)); */
  zone->nInputValueReferences = 1;
  zone->nOutputValueReferences = 4;
  const size_t scaInp=zone->nInputValueReferences;
  const size_t scaOut=zone->nOutputValueReferences;
  const size_t nInp = scaInp*nZon;
  const size_t nOut = scaOut*nZon;

  char** inputNames;
  char** outputNames;

  fmi2ValueReference* inputValueReferences;
  fmi2ValueReference* outputValueReferences;

  char* tmpDir;

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

  fmu = (FMU*)malloc(sizeof(FMU));
  if ( fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for fmu.");
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
  for (k=0; k<scaInp; k++){
    for (j=0; j<nZon; j++) {
      inputNames[cntr]=(char*)malloc((strlen(tmpZon[j]->name)+strlen(consInputNames[k]) + 2)*sizeof(char));
      if ( inputNames[cntr] == NULL )
        ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for inputNames.");
      sprintf(inputNames[cntr], "%s%s%s", tmpZon[j]->name, ",", consInputNames[k]);
      strcpy(tmpZon[j]->inputVariableNames[k], inputNames[cntr]);
      tmpZon[j]->inputValueReferences[k]=inputValueReferences[cntr];
      cntr++;
    }
  }

  /* Save output value references at zone and building level */
  cntr=0;
  for (k=0; k<scaOut; k++){
    for (j=0; j<nZon; j++){
      outputNames[cntr]=(char*)malloc((strlen(tmpZon[j]->name)+strlen(consOutputNames[k]) + 2)*sizeof(char));
      if ( outputNames[cntr] == NULL )
        ModelicaError("Not enough memory in FMUZoneInstantiate.c to allocate memory for outputNames.");
      sprintf(outputNames[cntr], "%s%s%s", tmpZon[j]->name, ",", consOutputNames[k]);
      strcpy(tmpZon[j]->outputVariableNames[k], outputNames[cntr]);
      tmpZon[j]->outputValueReferences[k]=outputValueReferences[cntr];
      cntr++;
    }
  }

  result = loadLib(zone->ptrBui->epLib, zone->ptrBui->fmu);

  /* Instantiate the building FMU*/
  tmpDir = getEnergyPlusTemporaryDirectory(zone->ptrBui->name);


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
  free(tmpDir);

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

  getParametersFromEnergyPlus(
    zone->ptrBui->fmu,
    zone->ptrBui->name,
    zone->name,
    outputNames,
    outputValueReferences,
    nOut,
    AFlo, V, mSenFac);

  return;
}
