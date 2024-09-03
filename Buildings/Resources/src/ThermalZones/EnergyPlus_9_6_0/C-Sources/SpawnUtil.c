/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "SpawnUtil.h"

#ifndef Buildings_SpawnUtil_c
#define Buildings_SpawnUtil_c

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#ifdef _WIN32 /* Win32 or Win64 */
#include <windows.h>
#else
#include <dirent.h>
#endif



void mallocString(const size_t nChar, const char *error_message, char** str, void (*SpawnFormatError)(const char *string, ...)){
  *str = (char *)malloc(nChar * sizeof(char));
  if ( *str == NULL )
    SpawnFormatError("%s", error_message);
}

void mallocSpawnReals(const size_t n, spawnReals** r, void (*SpawnFormatError)(const char *string, ...)){
  size_t i;
  *r = NULL;

  *r = (spawnReals*)malloc(sizeof(spawnReals));
  if ( *r == NULL)
    SpawnFormatError("%s", "Failed to allocate memory for spawnReals in SpawnUtil.c.");

  (*r)->valsEP = NULL;
  (*r)->valsSI = NULL;
  (*r)->units = NULL;
  (*r)->unitsModelica = NULL;
  (*r)->valRefs = NULL;
  (*r)->fmiNames = NULL;
  (*r)->n = n;

  if (n > 0){
    (*r)->valsEP = (fmi2Real*)malloc(n * sizeof(fmi2Real));

    if ((*r)->valsEP == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->valsEP in EnergyPlus.c");
    (*r)->valsSI = (fmi2Real*)malloc(n * sizeof(fmi2Real));

    if ((*r)->valsSI == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->valsSI in EnergyPlus.c");
    (*r)->units = (fmi2_import_unit_t**)malloc(n * sizeof(fmi2_import_unit_t*));

    if ((*r)->units == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->units in EnergyPlus.c");
    (*r)->unitsModelica = (char**)malloc(n * sizeof(char*));

    if ((*r)->unitsModelica == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->units in EnergyPlus.c");

    for(i = 0; i < n; i++){
      (*r)->unitsModelica[i] = NULL;
    }

    (*r)->valRefs = (fmi2ValueReference*)malloc(n * sizeof(fmi2ValueReference));
    if ((*r)->valRefs == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->valRefs in EnergyPlus.c");

    (*r)->fmiNames = (fmi2Byte**)malloc(n * sizeof(fmi2Byte*));
    if ((*r)->fmiNames == NULL)
        SpawnFormatError("%s", "Failed to allocate memory for (*r)->fmiNames in EnergyPlus.c");
  }
}

void mallocSpawnDerivatives(const size_t n, spawnDerivatives** r, void (*SpawnFormatError)(const char *string, ...)){

  size_t i;

  *r = NULL;
  *r = (spawnDerivatives*)malloc(sizeof(spawnDerivatives));
  if ( *r == NULL )
    SpawnFormatError("%s", "Failed to allocate memory for spawnDerivatives in SpawnUtil.c.");

  (*r)->structure = NULL;
  (*r)->delta = NULL;
  (*r)->vals = NULL;

  /* If there are no derivatives, then len = 0, but we still need derivatives->n = 0 to be set */
  (*r)->n = n;

  if (n > 0){

    (*r)->structure = (size_t **)malloc( n * sizeof(size_t*) );
    for(i = 0; i < n; i++){
      (*r)->structure[i] = NULL;
      (*r)->structure[i] = (size_t*)malloc( 2 * sizeof(size_t));
      if ((*r)->structure[i] == NULL)
        SpawnFormatError("Failed to allocate memory for (*r)->structure[%i] in EnergyPlus.c", i);
    }

    (*r)->delta = (fmi2Real*)malloc(n * sizeof(fmi2Real));
    if ((*r)->delta == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->delta in EnergyPlus.c");

    (*r)->vals = (fmi2Real*)malloc(n * sizeof(fmi2Real));
    if ((*r)->vals == NULL)
      SpawnFormatError("%s", "Failed to allocate memory for (*r)->vals in EnergyPlus.c");
  }
}

char* fmuModeToString(FMUMode mode){
  if (mode == instantiationMode)
    return "instantiation";
  if (mode == initializationMode)
    return "initialization";
  if (mode == eventMode)
    return "event";
  if (mode == continuousTimeMode)
    return "continuous";
  if (mode == terminatedMode)
    return "terminated";
  return "unknown mode for FMU";
}

void setVariables(
  FMUBuilding* bui,
  const char* modelicaInstanceName,
  const spawnReals* ptrReals)
  {
  size_t i;
  fmi2_status_t status;

  for(i = 0; i < ptrReals->n; i++){
    if (ptrReals->units[i]) /* Units are defined */
      ptrReals->valsEP[i] = fmi2_import_convert_from_SI_base_unit(ptrReals->valsSI[i], ptrReals->units[i]);
    else
      ptrReals->valsEP[i] = ptrReals->valsSI[i];
  }

  /* If debug mode, write exchanged values to log file */
  // - fixme if (bui->logLevel >= TIMESTEP){
    for(i = 0; i < ptrReals->n; i++){
      bui->SpawnFormatMessage("%.3f %s: Sending to EnergyPlus, %s = %.8g [%s].\n",
        bui->time, modelicaInstanceName, ptrReals->fmiNames[i], ptrReals->valsEP[i],
        fmi2_import_get_unit_name(ptrReals->units[i]));
//      if (ptrReals->units[i]){ /* Units are defined */
//        bui->SpawnFormatMessage("%.3f %s: Sending to EnergyPlus, %s = %.6g [%s].\n",
//          bui->time, modelicaInstanceName, ptrReals->fmiNames[i], ptrReals->valsEP[i],
//          fmi2_import_get_unit_name(ptrReals->units[i]));
      }
      else{
        bui->SpawnFormatMessage("%.3f %s: Sending to EnergyPlus, %s = %.6g (no units declared).\n",
          bui->time, modelicaInstanceName, ptrReals->fmiNames[i], ptrReals->valsEP[i]);
      }
    }
  // - fixme }

  status = fmi2_import_set_real(bui->fmu, ptrReals->valRefs, ptrReals->n, ptrReals->valsEP);
  if (status != (fmi2_status_t)fmi2OK) {
    bui->SpawnFormatError("Failed to set variables for %s in FMU.\n",  modelicaInstanceName);
  }
}

void stopIfResultsAreNaN(FMUBuilding* bui, const char* modelicaInstanceName, spawnReals* ptrReals){
  size_t i;
  fmi2_import_variable_t* fmiVar;
  const char* varNam;
  int i_nan = -1;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  for(i=0; i < ptrReals->n; i++){
    if (isnan(ptrReals->valsSI[i])){
      i_nan = (int)i;
      break;
    }
  }
  if (i_nan != -1){
    for(i=0; i < ptrReals->n; i++){
      fmiVar = fmi2_import_get_variable_by_vr(bui->fmu, fmi2_base_type_real, ptrReals->valRefs[i]);
      varNam = fmi2_import_get_variable_name(fmiVar);
      if (isnan(ptrReals->valsSI[i])){
        SpawnFormatMessage("%.3f %s: Received nan from EnergyPlus for %s at time = %.2f:\n", bui->time, modelicaInstanceName, bui->time);
      }
      SpawnFormatMessage("%.3f %s:   %s = %.2f\n", bui->time, modelicaInstanceName, varNam, ptrReals->valsSI[i]);
    }
    SpawnFormatError("%.3f %s: Terminating simulation because EnergyPlus returned nan for %s. See Modelica log file for details.",
       bui->time, modelicaInstanceName,
       fmi2_import_get_variable_name(fmi2_import_get_variable_by_vr(bui->fmu, fmi2_base_type_real, ptrReals->valRefs[i_nan])));
  }
}

void getVariables(FMUBuilding* bui, const char* modelicaInstanceName, spawnReals* ptrReals)
{
  size_t i;
  fmi2_status_t status;

  if (bui->logLevel >= TIMESTEP)
    bui->SpawnFormatMessage("%.3f %s: Getting real variables from EnergyPlus, mode = %s.\n",
      bui->time, modelicaInstanceName, fmuModeToString(bui->mode));

  status = fmi2_import_get_real(bui->fmu, ptrReals->valRefs, ptrReals->n, ptrReals->valsEP);
  if (status != (fmi2_status_t)fmi2OK) {
    if (bui->mode == initializationMode){
      bui->SpawnFormatError(
        "Failed to get parameter values for %s. This may be due to an error during the initialization or warm-up of EnergyPlus as the EnergyPlus FMU has been generated and loaded with no error.\n",
      modelicaInstanceName, fmuModeToString(bui->mode));
    }
    else{
      bui->SpawnFormatError("Failed to get variables for %s during mode = %s.\n",
      modelicaInstanceName, fmuModeToString(bui->mode));
    }
  }
  /* Set SI unit value */
  for(i = 0; i < ptrReals->n; i++){
    if (ptrReals->units[i]) /* Units are defined */
      ptrReals->valsSI[i] = fmi2_import_convert_to_SI_base_unit(ptrReals->valsEP[i], ptrReals->units[i]);
    else
      ptrReals->valsSI[i] = ptrReals->valsEP[i];
  }
  /* If debug mode, write exchanged values to log file */
  // - fixme if (bui->logLevel >= TIMESTEP){
    for(i = 0; i < ptrReals->n; i++){
      bui->SpawnFormatMessage("%.3f %s: Received from EnergyPlus, %s = %.8g [%s].\n",
        bui->time, modelicaInstanceName, ptrReals->fmiNames[i], ptrReals->valsEP[i],
        fmi2_import_get_unit_name(ptrReals->units[i]));
//      if (ptrReals->units[i]){ /* Units are defined */
//        bui->SpawnFormatMessage("%.3f %s: Received from EnergyPlus, %s = %.6g [%s].\n",
//          bui->time, modelicaInstanceName, ptrReals->fmiNames[i], ptrReals->valsEP[i],
//          fmi2_import_get_unit_name(ptrReals->units[i]));
      }
      else{
        bui->SpawnFormatMessage("%.3f %s: Received from EnergyPlus, %s = %.6g (no units declared).\n",
          bui->time, modelicaInstanceName, ptrReals->fmiNames[i], ptrReals->valsEP[i]);
      }
    }
  // - fixme }

  stopIfResultsAreNaN(bui, modelicaInstanceName, ptrReals);
}


/* Do the event iteration
   */
double do_event_iteration(FMUBuilding* bui, const char* modelicaInstanceName){
  fmi2_event_info_t eventInfo = {
    .newDiscreteStatesNeeded = fmi2_true,
    .terminateSimulation     = fmi2_false
  };
  size_t i = 0;
  const size_t nMax = 50;
  fmi2Status status = fmi2OK;
  double tNext;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Entered do_event_iteration, mode = %s\n", bui->time, modelicaInstanceName, fmuModeToString(bui->mode));
  /* Enter event mode if the FMU is in Continuous time mode
     because fmi2NewDiscreteStates can only be called in event mode */
  if (bui->mode == continuousTimeMode){
    SpawnFormatError("FMU is in unexpected mode in do_event_iteration at t=%.2f, modelicaInstance = %s, mode = %s. Contact support.",
      bui->time, modelicaInstanceName, fmuModeToString(bui->mode));
  }

  /* Make sure we are in event mode (this is for debugging) */
  if (bui->mode != eventMode){
    SpawnFormatError("%.3f %s: Expected to be in event mode, but was in %s, for FMU %s.", bui->time, modelicaInstanceName,
      fmuModeToString(bui->mode), bui->modelicaNameBuilding);
  }

  while (eventInfo.newDiscreteStatesNeeded && !eventInfo.terminateSimulation && i < nMax) {
    i++;
    if (bui->logLevel >= TIMESTEP)
      SpawnFormatMessage("%.3f %s: Calling fmi2_import_new_discrete_states with event iteration counter i = %lu\n", bui->time, modelicaInstanceName,
        i);
    status = fmi2_import_new_discrete_states(bui->fmu, &eventInfo);
  }
  if (eventInfo.terminateSimulation){
    SpawnFormatError("%.3f %s: FMU requested to terminate the simulation.", bui->time, modelicaInstanceName);
  }
  if (i == nMax){
    SpawnFormatError("%.3f %s: Did not converge during event iteration.", bui->time, modelicaInstanceName);
  }

  if (status != fmi2OK) {
    SpawnFormatError("%.3f %s: Failed during call to fmi2NewDiscreteStates for building %s with status %s.", bui->time, modelicaInstanceName,
    bui->modelicaNameBuilding, fmi2_status_to_string(status));
  }

  if(eventInfo.terminateSimulation == fmi2True){
    SpawnFormatError("%.3f %s: EnergyPlus requested to terminate the simulation for building = %s.", bui->time, modelicaInstanceName,
    bui->modelicaNameBuilding);
  }

  if(eventInfo.nextEventTimeDefined == fmi2False){
    SpawnFormatError("%.3f %s: Expected EnergyPlus to set nextEventTimeDefined = true for building = %s.", bui->time, modelicaInstanceName,
    bui->modelicaNameBuilding);
  }

  /* Assign tNext */
  tNext = eventInfo.nextEventTime;
  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Requested next event time: tNext = %.2f\n", bui->time, modelicaInstanceName, tNext);
  if (tNext <= bui->time + 1E-6){
    SpawnFormatError("EnergyPlus requested at time = %f a next event time of %f for modelicaInstance = %s. Zero time steps are not supported. Check with support.",
    bui->time, tNext, modelicaInstanceName);
  }


  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Exiting do_event_iteration, mode = %s\n", bui->time, modelicaInstanceName, fmuModeToString(bui->mode));
  return tNext;
}

/* Set the new time in the FMU, complete the integrator step and set the FMU into event mode.
*/
void advanceTime_completeIntegratorStep_enterEventMode(FMUBuilding* bui, const char* modelicaInstanceName, double time){
  fmi2Status status;
  fmi2Boolean enterEventMode;
  fmi2Boolean terminateSimulation;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: fmi2_import_enter_continuous_time_mode: Setting EnergyPlus to continuous time mode with time = %.2f\n", bui->time, modelicaInstanceName, time);
  status = fmi2_import_enter_continuous_time_mode(bui->fmu);
  if ( status != fmi2OK ) {
    SpawnFormatError("%.3f %s: Failed to set time in building FMU, returned status is %s.", bui->time, modelicaInstanceName,
      fmi2_status_to_string(status));
  }
  setFMUMode(bui, continuousTimeMode);

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: fmi2_import_set_time: Setting time in EnergyPlus to time = %.2f.\n", bui->time, modelicaInstanceName,
    time);

  bui->time = time;
  status = fmi2_import_set_time(bui->fmu, time);
  if ( status != fmi2OK ) {
    SpawnFormatError("%.3f %s: Failed to set time in building FMU, returned status is %s.", bui->time, modelicaInstanceName,
      fmi2_status_to_string(status));
  }

  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: fmi2_import_completed_integrator_step: Calling completed integrator step\n", bui->time, modelicaInstanceName);
  status = fmi2_import_completed_integrator_step(bui->fmu, fmi2_true, &enterEventMode, &terminateSimulation);
  if ( status != fmi2OK ) {
    SpawnFormatError("%.3f %s: Failed to complete integrator step in building FMU, returned status is %s.", bui->time, modelicaInstanceName,
    fmi2_status_to_string(status));
  }
  if (enterEventMode){
    SpawnFormatError(
      "Unexpected value for enterEventMode in SpawnUtil.c at t = %.2f for FMU for %s",
      time, modelicaInstanceName);
  }
  if (terminateSimulation){
    SpawnFormatError(
      "FMU requested to terminate simulation at t = %.2f for FMU for building %s and %s",
      time, bui->modelicaNameBuilding, modelicaInstanceName);
  }
  /* Enter the FMU into event mode */
  if (bui->logLevel >= TIMESTEP)
    SpawnFormatMessage("%.3f %s: Calling fmi2_import_enter_event_mode: Enter event mode for FMU %s.\n", bui->time, modelicaInstanceName,
      bui->modelicaNameBuilding);
  status = fmi2_import_enter_event_mode(bui->fmu);
  if (status != (fmi2Status)fmi2_status_ok){
    SpawnFormatError("%.3f %s: Failed to enter event mode in SpawnUtil.c, returned status is %s.", bui->time, modelicaInstanceName,
      fmi2_status_to_string(status));
  }
  setFMUMode(bui, eventMode);

  return;
}

/* Wrapper to set fmu mode indicator and log the mode change for debugging */
void setFMUMode(FMUBuilding* bui, FMUMode mode){
  if (bui->logLevel >= MEDIUM){
    if (bui->logLevel >= TIMESTEP || mode == instantiationMode || mode == initializationMode)
      bui->SpawnFormatMessage("%.3f %s: Switching to mode %s\n", bui->time, bui->modelicaNameBuilding, fmuModeToString(mode));
  }
  bui->mode = mode;
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
void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen, void (*SpawnFormatError)(const char *string, ...)){
  const size_t minInc = 1024;
  const size_t nNewCha = strlen(toAdd);
  const size_t nBufCha = strlen(*buffer);
  /* reallocate memory if needed */
  if ( *bufLen < nNewCha + nBufCha + 1){
    *bufLen = *bufLen + nNewCha + minInc + 1;
    *buffer = (char *)realloc(*buffer, *bufLen * sizeof(char));
    if (*buffer == NULL) {
      SpawnFormatError("Realloc failed in saveAppend with bufLen = %lu.", *bufLen);
    }
  }
  /* append toAdd to buffer */
  strcpy(*buffer + strlen(*buffer), toAdd);
  return;
}


void saveAppendJSONElements(
  char* *buffer,
  const char* values[],
  size_t n,
  size_t* bufLen,
  void (*SpawnFormatError)(const char *string, ...)){
    size_t i;
    /* Write all values and value references in the format
        { "name": "V"},
        { "name": "AFlo"}
    */
    for(i = 0; i < n; i++){
      /* Build JSON string */
      saveAppend(buffer, "        { \"", bufLen, SpawnFormatError);
      saveAppend(buffer, "name", bufLen, SpawnFormatError);
      saveAppend(buffer, "\": \"", bufLen, SpawnFormatError);
      saveAppend(buffer, values[i], bufLen, SpawnFormatError);
      saveAppend(buffer, "\" }", bufLen, SpawnFormatError);
      if (i < n-1)
        saveAppend(buffer, ",\n", bufLen, SpawnFormatError);
      }
  }

/* Replace all characters 'find' with 'replace' in string 'str' */
void replaceChar(char *str, char find, char replace){
  char *s;
  while ((s = strchr (str, find)) != NULL)
  {
    *s = replace;
  }
}

void checkAndSetVerbosity(FMUBuilding* bui, const int logLevel){

  if (getBuildings_nFMU() == 0){
    bui->logLevel = logLevel;
  }
  else{
    if (bui->logLevel != logLevel){
        bui->SpawnMessage(
          "Warning: Modelica objects declare different logLevel. Check parameter logLevel. Using highest declared value.\n");
    }
    if (logLevel > bui->logLevel){
      bui->logLevel = logLevel;
    }
  }
}


void setSimulationFMUName(FMUBuilding* bui, const char* modelicaNameBuilding){
  size_t iniLen = 100;
  const char* tmpDir = bui->tmpDir;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  mallocString(iniLen, "Failed to allocate memory for FMU name.", &(bui->fmuAbsPat), SpawnFormatError);
  memset(bui->fmuAbsPat, '\0', iniLen);

  saveAppend(&(bui->fmuAbsPat), tmpDir, &iniLen, SpawnFormatError);
  saveAppend(&(bui->fmuAbsPat), SEPARATOR, &iniLen, SpawnFormatError);
  /* modelicaNameBuilding can be very long. Hence we use EnergyPlus.fmu as the FMU name
     that contains the EnergyPlus model. This FMU will be in its own directory and hence
     there is no name clash
  saveAppend(&(bui->fmuAbsPat), modelicaNameBuilding, &iniLen, SpawnFormatError); */
  saveAppend(&(bui->fmuAbsPat), "EnergyPlus", &iniLen, SpawnFormatError);
  saveAppend(&(bui->fmuAbsPat), ".fmu", &iniLen, SpawnFormatError);
  /* Replace special characters that are introduced if arrays of models are used.
     Such array notation cause currently runtime errors when loading an FMU. */
  replaceChar(bui->fmuAbsPat, '[', '_');
  replaceChar(bui->fmuAbsPat, ']', '_');

  return;
}


char * getFileNameWithoutExtension(
  const char* idfName,
  void (*SpawnFormatError)(const char *string, ...))
  {
  char * namWitSla;
  char * nam;
  char * namOnl;
  char * ext;
  size_t lenNam;

  namWitSla = strrchr(idfName, '/');

  if ( namWitSla == NULL )
    SpawnFormatError("Failed to parse file name '%s'. Expected an absolute path with slash '%s'?", idfName, "/");

  /* Remove the first slash */
  nam = namWitSla + 1;
  /* Get the extension */
  ext = strrchr(nam, '.');
  if ( ext == NULL )
    SpawnFormatError("Failed to parse file name '%s'. Expected a file extension such as '.idf'?", idfName);

  /* Get the file name without extension */
  lenNam = strlen(nam) - strlen(ext);

  mallocString(
    lenNam+1,
    "Failed to allocate memory for temporary directory name in SpawnUtil.c",
    &namOnl,
    SpawnFormatError);

  memset(namOnl, '\0', lenNam+1);
  /* Copy nam to namOnl */
  strncpy(namOnl, nam, lenNam);

  return namOnl;
}

void getShortModelicaNameBuilding(
  const char* modelicaNameBuilding,
  char** shortName,
  void (*SpawnFormatError)(const char *string, ...)){
    const char buiSuf[] = ".building";
    size_t len;
    size_t i;
    const size_t lenBui = strlen(buiSuf);
    const char* rInd = strrchr(modelicaNameBuilding, '.');
    /* Make sure .building is found, and it is at the end of the string */
    if (rInd == NULL){
      SpawnFormatError("Did not find '.building', but expected modelicaNameBuilding to end with '.building', obtained '%s'. Did you rename the building instance?", modelicaNameBuilding);
    }
    if (*(rInd+lenBui) != '\0'){
      SpawnFormatError("String '.building' does not seem to be at the end of modelicaNameBuilding, obtained '%s'. Did you rename the building instance?", modelicaNameBuilding);
    }

    /* Allocate memory for new string */
    len = strlen(modelicaNameBuilding)-lenBui;
    mallocString(
      len+1,
      "Failed to allocate memory for temporary directory name in SpawnUtil.c.",
      shortName,
      SpawnFormatError);
    memset(*shortName, '\0', len+1);
    /* Copy string up to rInd, i.e., without .building */
    for (i = 0; &(modelicaNameBuilding[i]) != rInd; i++){
      (*shortName)[i] = modelicaNameBuilding[i];
    }
  }

void getSimulationTemporaryDirectory(
  const char* modelicaNameBuilding,
  char** dirNam,
  void (*SpawnFormatError)(const char *string, ...)){
  /* Return the absolute name of the temporary directory to be used for EnergyPlus
     in the form "/mnt/xxx/EnergyPlus-simulation-model.name.building"
  */
  size_t lenNam;
  size_t lenPre;
  size_t lenCur;
  size_t lenSep;
  char* curDir;
  size_t lenCurDir = 256;
  const size_t incLenCurDir = 256;
  const size_t maxLenCurDir = 100000;

  /* Prefix for temporary directory */
  const char* pre = "spawn-\0";
  /* Shortened name */
  char* shortBuildingName;

  /* Current directory */
  mallocString(
    lenCurDir,
    "Failed to allocate memory for current working directory in getSimulationTemporaryDirectory.",
    &curDir,
    SpawnFormatError);
  memset(curDir, '\0', lenCurDir);

#ifdef _WIN32 /* Win32 or Win64 */
  while ( _getcwd(curDir, (int)lenCurDir) == NULL ){
#else
  while ( getcwd(curDir, lenCurDir) == NULL ){
#endif
    if ( errno == ERANGE){
      lenCurDir += incLenCurDir;
      if (lenCurDir > maxLenCurDir){
        SpawnFormatError(
          "Temporary directories with names longer than %lu characters are not supported in SpawnFMU.c unless you change maxLenCurDir.",
          maxLenCurDir);
      }
      curDir = (char *)realloc(curDir, lenCurDir * sizeof(char));
      if (curDir == NULL)
        SpawnFormatError(
          "Failed to reallocate memory for current working directory in getSimulationTemporaryDirectory for %s.",
          modelicaNameBuilding);
      memset(curDir, '\0', lenCurDir);
    }
    else{ /* Other error than insufficient length */
      SpawnFormatError(
        "Unknown error when allocating memory for temporary directory in SpawnFMU.c. for %s",
        modelicaNameBuilding);
    }
  }
#ifdef _WIN32 /* Win32 or Win64 */
  replaceChar(curDir, '\\', '/');
#endif

  /* Reduced the name of modelicaNameBuilding because Windows has limits on the length
     of the file name.
  */
  /* Cut the trailing '.building' */
  getShortModelicaNameBuilding(modelicaNameBuilding, &shortBuildingName, SpawnFormatError);

  lenNam = strlen(shortBuildingName);
  lenCur = strlen(curDir);
  lenSep = 1;
  lenPre = strlen(pre);

  mallocString(
    lenCur+lenSep+lenPre+lenNam+1,
    "Failed to allocate memory for temporary directory name in SpawnUtil.c.",
    dirNam,
    SpawnFormatError);
  memset(*dirNam, '\0', (lenCur+lenSep+lenPre+lenNam+1));
  strncpy(*dirNam, curDir, lenCur);
  strcat(*dirNam, "/");
  strcat(*dirNam, pre);
  strcat(*dirNam, shortBuildingName);
  /* Replace special characters that are introduced if arrays of models are used.
     Such array notation cause currently runtime errors when loading an FMU. */
  replaceChar(*dirNam, '[', '_');
  replaceChar(*dirNam, ']', '_');
  free(curDir);
  return;
}


void buildVariableNames(
  const char* name,
  const char** variableNames,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFMINames,
  void (*SpawnFormatError)(const char *string, ...)){
    size_t i;
    size_t len;

    /* Set pointers to NULL and return if nVar == 0 */
    if (nVar == 0){
      *ptrVarNames = NULL;
      *ptrFMINames = NULL;
      return;
    }
    /* Compute longest name */
    len = 0;
    for (i=0; i<nVar; i++)
      len = max(len, strlen(variableNames[i]));

    *ptrVarNames = (char**)malloc(nVar * sizeof(char*));
    if (*ptrVarNames == NULL)
      SpawnFormatError("Failed to allocate memory for ptrVarNames in initialize_Spawn_EnergyPlus_9_6_0.c. for %s", name);

    for (i=0; i<nVar; i++){
      mallocString(
        len+1,
        "Failed to allocate memory for ptrVarNames[i] in initialize_Spawn_EnergyPlus_9_6_0.c.",
        &((*ptrVarNames)[i]),
        SpawnFormatError);
    }

    /* Copy the string */
    for (i=0; i<nVar; i++){
      memset((*ptrVarNames)[i], '\0', len+1);
      strcpy((*ptrVarNames)[i], variableNames[i]);
    }

    /* Compute longest name */
    len = 0;
    for (i=0; i<nVar; i++){
      /* Use +1 to account for the comma */
      len = max(len, strlen(name) + 1 + strlen(variableNames[i]));
    }

    *ptrFMINames = (char**)malloc(nVar * sizeof(char*));
    if (*ptrFMINames == NULL)
      SpawnFormatError("Failed to allocate memory for ptrFMINames in initialize_Spawn_EnergyPlus_9_6_0.c for %s.", name);

    for (i=0; i<nVar; i++){
      mallocString(
        len+1,
        "Failed to allocate memory for ptrFMINames[i] in initialize_Spawn_EnergyPlus_9_6_0.c.",
        &((*ptrFMINames)[i]),
        SpawnFormatError);
    }
    /* Copy the string */
    for (i=0; i<nVar; i++){
      memset((*ptrFMINames)[i], '\0', len+1);
      strcpy((*ptrFMINames)[i], name);
      strcat((*ptrFMINames)[i], "_");
      strcat((*ptrFMINames)[i], variableNames[i]);
    }

  return;
}

void createDirectory(const char* dirName, void (*SpawnFormatError)(const char *string, ...)){
  /* Create directory if it does not already exist */
#ifdef _WIN32 /* Win32 or Win64 */
  struct _stat64i32 st = {0};
  if (_stat64i32(dirName, &st) == -1) {
    if ( _mkdir(dirName) == -1)
      SpawnFormatError("Failed to create directory %s", dirName);
  }
#else
  struct stat st = {0};
  if (stat(dirName, &st) == -1) {
    if ( mkdir(dirName, 0700) == -1)
      SpawnFormatError("Failed to create directory %s", dirName);
  }
#endif
}

#ifndef _WIN32 /* Not Win32 or Win64 */
int isDirectory(const char *path){
   struct stat statbuf;
   if (stat(path, &statbuf) != 0)
       return 0;
   return S_ISDIR(statbuf.st_mode);
}

int isRegularFile(const char *path) {
   struct stat statbuf;
   if (stat(path, &statbuf) != 0)
       return 0;
   return S_ISREG(statbuf.st_mode);
}
#endif


void remove_files_or_directory(FMUBuilding* bui, const char* directory, const char* wildCard, bool recursive){
#ifdef _WIN32 /* Win32 or Win64 */
  WIN32_FIND_DATA fdFile;
  HANDLE hFind = NULL;
  size_t lenFilMas;
  char* filMas;
#else
  struct dirent **namelist;
  int nFil;
#endif

  size_t lenFil;
  char* filName;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Entered remove_files_or_directory, directory = '%s', wildCard = '%s'.\n",
      bui->time, bui->modelicaNameBuilding, directory, wildCard);

#ifdef _WIN32 /* Win32 or Win64 */
  /* Specify file mask */
  lenFilMas = strlen(directory) + strlen(wildCard) + 2;
  mallocString(lenFilMas, "Failed to allocate memory in remove_files_or_directory() for filMas.",
      &filMas, SpawnFormatError);
  memset(filMas, '\0', lenFilMas);
  strcpy(filMas, directory);
  strcat(filMas, "/");
  strcat(filMas, wildCard);

  if((hFind = FindFirstFile(filMas, &fdFile)) == INVALID_HANDLE_VALUE)
  {
     if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Did not find old files when searching for '%s'.\n", bui->time, bui->modelicaNameBuilding, filMas);
    free(filMas);
    return;
  }
  do
  {
      //Find first file will always return "."
      //    and ".." as the first two directories.
      if(strcmp(fdFile.cFileName, ".") != 0
              && strcmp(fdFile.cFileName, "..") != 0)
      {
          if(fdFile.dwFileAttributes &FILE_ATTRIBUTE_DIRECTORY){
            /* This is a directory. Call function recursively. */
            lenFil = lenFilMas + strlen("/") + strlen(fdFile.cFileName);

            mallocString(lenFil, "Failed to allocate memory in remove_files_or_directory() for filName.",
              &filName, SpawnFormatError);
            memset(filName, '\0', lenFil);
            strcpy(filName, directory);
            strcat(filName, "/");
            strcat(filName, fdFile.cFileName);
            remove_files_or_directory(bui, filName, "*", recursive);
            /* Now the directory is empty, delete it. */
            _rmdir(filName);
            free(filName);
          }
          else{
            /* Delete the file */
            lenFil = lenFilMas + strlen("/") + strlen(fdFile.cFileName);

            mallocString(lenFil, "Failed to allocate memory in remove_files_or_directory() for filName.",
              &filName, SpawnFormatError);
            memset(filName, '\0', lenFil);
            strcpy(filName, directory);
            strcat(filName, "/");
            strcat(filName, fdFile.cFileName);
            if (bui->logLevel >= MEDIUM)
              SpawnFormatMessage("%.3f %s: Deleting file '%s'.\n", bui->time, bui->modelicaNameBuilding, filName);
            deleteFile(filName);
            free(filName);
          }
      }
  }
  while(FindNextFile(hFind, &fdFile)); /* Find the next file. */
  FindClose(hFind); /* Close the file handle */
  free(filMas);

#else
  /* Scan the directory for files */
  nFil = scandir(directory, &namelist, NULL, alphasort);
  if (nFil == -1){
    /* scandir had an error, this may be if the directory does not exist. */
     if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Did not find files in '%s'.\n", bui->time, bui->modelicaNameBuilding, directory);
    return;
  }
  while (nFil--){
    if ( (strcmp(namelist[nFil]->d_name, "..") == 0) ||
         (strcmp(namelist[nFil]->d_name, ".")  == 0) ) {
      /* Skip for ".." and for "." */
      continue;
    }

    lenFil = strlen(directory) + strlen("/") + strlen(namelist[nFil]->d_name) + 1;
    mallocString(lenFil, "Failed to allocate memory in delete_extracted_fmu_files() for filName.",
      &filName, SpawnFormatError);

    memset(filName, '\0', lenFil);
    strcpy(filName, directory);
    strcat(filName, "/");
    strcat(filName, namelist[nFil]->d_name);

    if (isDirectory(filName) && recursive &&
       ((strcmp(wildCard, namelist[nFil]->d_name) == 0) || (strcmp(wildCard, "*") == 0))){
      /* Have directory, and its name matches wildCard, or wildCard is equal to "*" */
      /* Call method recursively */
      remove_files_or_directory(bui, filName, "*", recursive);
      /* Now the directory is empty. Delete it.*/
      rmdir(filName);
    }
    else if (isRegularFile(filName)){
      if ( (strcmp(wildCard, "*") == 0) ||
           (strcmp(wildCard, namelist[nFil]->d_name) == 0) ){
        if (bui->logLevel >= MEDIUM)
          SpawnFormatMessage("%.3f %s: Deleting file '%s'.\n", bui->time, bui->modelicaNameBuilding, filName);
        deleteFile(filName);
      }
    }
    else{
      if (bui->logLevel >= MEDIUM)
        SpawnFormatMessage("%.3f %s: Skipping removal of '%s', as it is does not match pattern.\n",
          bui->time, bui->modelicaNameBuilding, filName);
    }
    free(filName);
    free(namelist[nFil]);
  }
  free(namelist);
#endif
}

void delete_extracted_fmu_files(FMUBuilding* bui){
  /* Delete old ep* libraries generated by previous simulation, if present.
   */
  remove_files_or_directory(bui, bui->tmpDir, "binaries", true);
  remove_files_or_directory(bui, bui->tmpDir, "resources", true);
  remove_files_or_directory(bui, bui->tmpDir, "modelDescription.xml", false);
}

int deleteFile(const char* fileName){
  /* Remove file if it exists */
  if (access(fileName, F_OK) == 0) {
    /* File exists. Delete it. */
    return remove(fileName);
  }
  else
    return 0;
}


void loadFMU_setupExperiment_enterInitializationMode(FMUBuilding* bui, double startTime){
  fmi2_status_t status;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  const char* modelicaInstanceName = bui->modelicaNameBuilding;

  /* Instantiate the FMU for this building */
  generateAndInstantiateBuilding(bui);
  bui->time = startTime;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Instantiate building.\n", bui->time, modelicaInstanceName);

  /* This function can only be called once per building FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Calling fmi2_import_setup_experiment: Setting up experiment building at %p with startTime = %f.\n",
      bui->time,
      modelicaInstanceName, bui, startTime);

  /*SpawnFormatError("********* Calling setting up experiment... for building at %p", bui->fmu);*/

  status = fmi2_import_setup_experiment(
      bui->fmu,             /* fmu */
      fmi2False,            /* toleranceDefined */
      0.0,                  /* tolerance */
      startTime,            /* startTime */
      fmi2False,            /* stopTimeDefined */
      0);                   /* stopTime */

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Returned from setting up experiment with status %s.\n", bui->time, modelicaInstanceName, fmi2_status_to_string(status));

  if( status != fmi2_status_ok ){
    SpawnFormatError("%.3f %s: Failed to setup experiment for FMU with name %s.", bui->time, modelicaInstanceName,  bui->fmuAbsPat);
  }

  /* Enter initialization mode, because getting parameters is only
     allowed in the initialization mode, see FMU state diagram in standard */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: fmi2_import_enter_initialization_mode: Enter initialization mode of FMU with name %s.\n",
      bui->time,
      modelicaInstanceName,
      bui->fmuAbsPat);
  status = fmi2_import_enter_initialization_mode(bui->fmu);
  if( status != fmi2_status_ok ){
    SpawnFormatError("%.3f %s: Failed to enter initialization mode for FMU with name %s.", bui->time, modelicaInstanceName,
      bui->fmuAbsPat);
  }
  setFMUMode(bui, initializationMode);

  return;
}
#endif
