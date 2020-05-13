/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "EnergyPlusUtil.h"

#ifndef Buildings_EnergyPlusUtil_c
#define Buildings_EnergyPlusUtil_c

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

/* Use windows.h only for Windows */
#ifdef _WIN32
#include <windows.h>
#else
#define _GNU_SOURCE
#include <dlfcn.h>
#endif

void writeFormatLog(unsigned int level, const char *fmt, ...) {
  /*const char* prefix = "\033[1;33m*** Log\033[0m: ";*/
  const char* prefix = "*** Log: ";
  va_list args;

  if (level <= FMU_EP_VERBOSITY){
    fprintf(stdout, "%s", prefix);
    va_start(args, fmt);
    vprintf(fmt, args);
    va_end(args);
    fprintf(stdout, "%s", "\n");
    fflush(stdout);
    ModelicaFormatMessage(fmt, args);
  }
}

void writeLog(unsigned int level, const char* msg)
{
    if (level <= FMU_EP_VERBOSITY){
      const char* prefix = "*** Log: ";
      char* m;
      mallocString((strlen(msg)+strlen(prefix)+1), "Failed to allocate string array in writeLog.", &m);
      strcpy(m, prefix);
      strcat(m, msg);
      fprintf(stdout, "%s\n", m);
      fflush(stdout);
      ModelicaFormatMessage("%s", m);
    }
}

void logStringArray(unsigned int level,
                    const char* msg,
                    const char** array,
                    size_t n){
  int i;
  if (level <= FMU_EP_VERBOSITY){
    writeLog(level, msg);
    for(i = 0; i < n; i++)
      writeLog(level, array[i]);
    writeLog(level, "End of array.");
  }
}

void logValueReferenceArray(unsigned int level,
                            const char* msg,
                            const fmi2ValueReference* array,
                            size_t n){
  int i;
  if (level <= FMU_EP_VERBOSITY){
    char res[100];
    writeLog(level, msg);
    for(i = 0; i < n; i++){
      sprintf(res, "%d", array[i]);
      writeLog(level, res);
    }
    writeLog(level, "End of array.");
  }
}


void printBacktrace(){
  void* callstack[128];
  int i, frames = backtrace(callstack, 128);
  char** strs = backtrace_symbols(callstack, frames);
  for (i = 0; i < frames; ++i) {
    printf("%s\n", strs[i]);
  }
  free(strs);
}

void mallocString(const size_t nChar, const char *error_message, char** str){
  *str = malloc(nChar * sizeof(char));
  if ( *str == NULL )
    ModelicaError(error_message);
}

void mallocSpawnReals(const size_t n, spawnReals** r){
  size_t i;
  *r = (spawnReals*)malloc(n * sizeof(spawnReals));
  if ( *r == NULL)
    ModelicaFormatError("Failed to allocate memory for spawnReals in EnergyPlusUtil.c.");

  (*r)->valsEP = NULL;
  (*r)->valsSI = NULL;
  (*r)->units = NULL;
  (*r)->valRefs = NULL;
  (*r)->fmiNames = NULL;
  for(i = 0; i < n; i++){
    (*r)->valsEP = (fmi2Real*)malloc(n * sizeof(fmi2Real));
    if ((*r)->valsEP == NULL)
      ModelicaFormatError("Failed to allocate memory for (*r)->valsEP in EnergyPlus.c");

    (*r)->valsSI = (fmi2Real*)malloc(n * sizeof(fmi2Real));
    if ((*r)->valsSI == NULL)
      ModelicaFormatError("Failed to allocate memory for (*r)->valsSI in EnergyPlus.c");

    (*r)->units = (fmi2_import_unit_t**)malloc(n * sizeof(fmi2_import_unit_t*));
    if ((*r)->units == NULL)
      ModelicaFormatError("Failed to allocate memory for (*r)->units in EnergyPlus.c");

    (*r)->valRefs = (fmi2ValueReference*)malloc(n * sizeof(fmi2ValueReference));
    if ((*r)->valRefs == NULL)
      ModelicaFormatError("Failed to allocate memory for (*r)->valRefs in EnergyPlus.c");

    (*r)->fmiNames = (fmi2Byte**)malloc(n * sizeof(fmi2Byte*));
    if ((*r)->fmiNames == NULL)
      ModelicaFormatError("Failed to allocate memory for (*r)->fmiNames in EnergyPlus.c");
  }
  (*r)->n = n;
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
  ModelicaFormatError("Unknown fmu mode %d", mode);
  return "unknown error";
}

void setVariables(FMUBuilding* bui, const char* modelicaInstanceName, const spawnReals* ptrReals){
  size_t i;
  fmi2_status_t status;
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_set_real: Setting real variables in EnergyPlus for modelicaInstance %s, mode = %s.\n",
      modelicaInstanceName, fmuModeToString(bui->mode));

  for(i = 0; i < ptrReals->n; i++){
    if (ptrReals->units[i]) /* Units are defined */
      ptrReals->valsEP[i] = fmi2_import_convert_from_SI_base_unit(ptrReals->valsSI[i], ptrReals->units[i]);
    else
      ptrReals->valsEP[i] = ptrReals->valsSI[i];
  }
  status = fmi2_import_set_real(bui->fmu, ptrReals->valRefs, ptrReals->n, ptrReals->valsEP);
  if (status != fmi2OK) {
    ModelicaFormatError("Failed to set variables for %s in FMU.\n",  modelicaInstanceName);
  }
}

void stopIfResultsAreNaN(FMUBuilding* bui, const char* modelicaInstanceName, spawnReals* ptrReals){
  size_t i;
  fmi2_import_variable_t* fmiVar;
  const char* varNam;
  size_t i_nan = -1;
  for(i=0; i < ptrReals->n; i++){
    if (isnan(ptrReals->valsSI[i])){
      i_nan = i;
      break;
    }
  }
  if (i_nan != -1){
    for(i=0; i < ptrReals->n; i++){
      fmiVar = fmi2_import_get_variable_by_vr(bui->fmu, fmi2_base_type_real, ptrReals->valRefs[i]);
      varNam = fmi2_import_get_variable_name(fmiVar);
      if (isnan(ptrReals->valsSI[i])){
        ModelicaFormatMessage("Received nan from EnergyPlus for %s at time = %.2f:\n", modelicaInstanceName, bui->time);
      }
      ModelicaFormatMessage("  %s = %.2f\n", varNam, ptrReals->valsSI[i]);
    }
    ModelicaFormatError("Terminating simulation because EnergyPlus returned nan for %s. See Modelica log file for details.",
      fmi2_import_get_variable_name(fmi2_import_get_variable_by_vr(bui->fmu, fmi2_base_type_real, ptrReals->valRefs[i_nan])));
  }
}

void getVariables(FMUBuilding* bui, const char* modelicaInstanceName, spawnReals* ptrReals)
{
  size_t i;
  fmi2_status_t status;
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_get_real: Getting real variables from EnergyPlus for object %s, mode = %s.\n",
      modelicaInstanceName, fmuModeToString(bui->mode));
  status = fmi2_import_get_real(bui->fmu, ptrReals->valRefs, ptrReals->n, ptrReals->valsEP);
  if (status != fmi2OK) {
    ModelicaFormatError("Failed to get variables for %s\n",
    modelicaInstanceName);
  }
  /* Set SI unit value */
  for(i = 0; i < ptrReals->n; i++){
    if (ptrReals->units[i]) /* Units are defined */
      ptrReals->valsSI[i] = fmi2_import_convert_to_SI_base_unit(ptrReals->valsEP[i], ptrReals->units[i]);
    else
      ptrReals->valsSI[i] = ptrReals->valsEP[i];
  }
  stopIfResultsAreNaN(bui, modelicaInstanceName, ptrReals);
}


/* Do the event iteration
   */
double do_event_iteration(FMUBuilding* bui, const char* modelicaInstanceName){
  fmi2_event_info_t eventInfo;
  size_t i = 0;
  const size_t nMax = 50;
  fmi2Status status;
  double tNext;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Entered do_event_iteration for %s, mode = %s\n",
      modelicaInstanceName, fmuModeToString(bui->mode));
  /* Enter event mode if the FMU is in Continuous time mode
     because fmi2NewDiscreteStates can only be called in event mode */
  if (bui->mode == continuousTimeMode){
    ModelicaFormatError("FMU is in unexpected mode in do_event_iteration at t=%.2f, modelicaInstance = %s, mode = %s. Contact support.",
      bui->time, modelicaInstanceName, fmuModeToString(bui->mode));
    /*
      if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("fmi2_import_enter_event_mode: Enter event mode in do_event_iteration for FMU %s\n", bui->modelicaNameBuilding);
    status = fmi2_import_enter_event_mode(bui->fmu);
    if (status != fmi2_status_ok){
      ModelicaFormatError("Failed to enter event mode in do_event_iteration for FMU %s and modelicaInstance %s, returned status is %s.",
      bui->modelicaNameBuilding, modelicaInstanceName, fmi2_status_to_string(status));
    }
    setFMUMode(bui, eventMode);
    */
  }
/* *****************************************************************************
  if (bui->mode != initializationMode){
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("fmi2_import_enter_event_mode: Enter event mode in do_event_iteration for FMU %s\n", bui->modelicaNameBuilding);
    status = fmi2_import_enter_event_mode(bui->fmu);
    if (status != fmi2_status_ok){
      ModelicaFormatError("Failed to enter event mode in do_event_iteration for FMU %s and modelicaInstance %s, returned status is %s.",
      bui->modelicaNameBuilding, modelicaInstanceName, fmi2_status_to_string(status));
    }
    setFMUMode(bui, eventMode);
  }
  ***************************************************************************** */


  /* Make sure we are in event mode (this is for debugging) */
  if (bui->mode != eventMode){
    ModelicaFormatError("Expected to be in event mode, but was in %s, for FMU %s and modelicaInstance %s.",
      fmuModeToString(bui->mode), bui->modelicaNameBuilding, modelicaInstanceName);
  }
  eventInfo.newDiscreteStatesNeeded = fmi2_true;
  eventInfo.terminateSimulation     = fmi2_false;
  while (eventInfo.newDiscreteStatesNeeded && !eventInfo.terminateSimulation && i < nMax) {
    i++;
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage(
        "fmi2_import_new_discrete_states: Doing event iteration with i = %lu, modelicaInstance = %s\n",
        i,
        modelicaInstanceName);
    status = fmi2_import_new_discrete_states(bui->fmu, &eventInfo);
  }
  if (eventInfo.terminateSimulation){
    ModelicaFormatError("FMU requested to terminate the simulation.");
  }
  if (i == nMax){
    ModelicaFormatError("Did not converge during event iteration.");
  }

  if (status != fmi2OK) {
    ModelicaFormatError("Failed during call to fmi2NewDiscreteStates for building %s with status %s.",
    bui->modelicaNameBuilding, fmi2_status_to_string(status));
  }
  if(eventInfo.terminateSimulation == fmi2True){
    ModelicaFormatError("EnergyPlus requested to terminate the simulation for building = %s, modelicaInstance = %s, time = %f.",
    bui->modelicaNameBuilding, modelicaInstanceName, bui->time);
  }
  if(eventInfo.nextEventTimeDefined == fmi2False){
    ModelicaFormatError("Expected EnergyPlus to set nextEventTimeDefined = true for building = %s, modelicaInstance = %s, time = %f.",
    bui->modelicaNameBuilding, modelicaInstanceName, bui->time);
  }
  else{
    tNext = eventInfo.nextEventTime;
    if (FMU_EP_VERBOSITY >= TIMESTEP)
      ModelicaFormatMessage("Requested next event time at %.2f: %.2f;\t modelicaInstance = %s\n",
        bui->time, tNext, modelicaInstanceName);
    if (tNext <= bui->time + 1E-6){
      ModelicaFormatError("EnergyPlus requested at time = %f a next event time of %f for modelicaInstance = %s. Zero time steps are not supported. Check with support.",
      bui->time, tNext, modelicaInstanceName);
    }
  }

  /* THIS WAS WRONG: if newDiscreteStatesNeeded is false, the FMU is in continuous time mode
  setFMUMode(bui, continuousTimeMode); */
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("Exiting do_event_iteration for modelicaInstance %s, mode = %s with tNext = %.2f\n",
      modelicaInstanceName, fmuModeToString(bui->mode), tNext);
  return tNext;
}

/* Set the new time in the FMU, complete the integrator step and set the FMU into event mode.
*/
void advanceTime_completeIntegratorStep_enterEventMode(FMUBuilding* bui, const char* modelicaInstanceName, double time){
  fmi2Status status;
  fmi2Boolean enterEventMode;
  fmi2Boolean terminateSimulation;

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_enter_continuous_time_mode: ************ Setting EnergyPlus to continuous time mode at t = %.2f\n", time);
  status = fmi2_import_enter_continuous_time_mode(bui->fmu);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set time in building FMU for %s, returned status is %s.",
      modelicaInstanceName, fmi2_status_to_string(status));
  }
  setFMUMode(bui, continuousTimeMode);

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_set_time: Setting time in EnergyPlus to %.2f for %s.\n",
    time,
    modelicaInstanceName);

  bui->time = time;
  status = fmi2_import_set_time(bui->fmu, time);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to set time in building FMU for %s, returned status is %s.",
      modelicaInstanceName, fmi2_status_to_string(status));
  }

  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage("fmi2_import_completed_integrator_step: Calling completed integrator step at t = %.2f\n", time);
  status = fmi2_import_completed_integrator_step(bui->fmu, fmi2_true, &enterEventMode, &terminateSimulation);
  if ( status != fmi2OK ) {
    ModelicaFormatError("Failed to complete integrator step in building FMU for %s, returned status is %s.",
    modelicaInstanceName, fmi2_status_to_string(status));
  }
  if (enterEventMode){
    ModelicaFormatError(
      "Unexpected value for enterEventMode in EnergyPlusUtil.c at t = %.2f for FMU for %s",
      time, modelicaInstanceName);
  }
  if (terminateSimulation){
    ModelicaFormatError(
      "FMU requested to terminate simulation at t = %.2f for FMU for building %s and %s",
      time, bui->modelicaNameBuilding, modelicaInstanceName);
  }
  /* Enter the FMU into event mode */
  if (FMU_EP_VERBOSITY >= TIMESTEP)
    ModelicaFormatMessage(
      "fmi2_import_enter_event_mode: Enter event mode for FMU %s, model %s\n",
      bui->modelicaNameBuilding, modelicaInstanceName);
  status = fmi2_import_enter_event_mode(bui->fmu);
  if (status != fmi2_status_ok){
    ModelicaFormatError("Failed to enter event mode in EnergyPlusUtil.c for modelicaInstance %s, returned status is %s.",
    modelicaInstanceName, fmi2_status_to_string(status));
  }
  setFMUMode(bui, eventMode);

  return;
}

/* Wrapper to set fmu mode indicator and log the mode change for debugging */
void setFMUMode(FMUBuilding* bui, FMUMode mode){
  if (FMU_EP_VERBOSITY >= MEDIUM){
    if (FMU_EP_VERBOSITY >= TIMESTEP || mode == instantiationMode || mode == initializationMode)
    ModelicaFormatMessage("Switching %s to mode %s\n", bui->modelicaNameBuilding, fmuModeToString(mode));
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
  const char* values[],
  size_t n,
  size_t* bufLen){
    int i;
    /* Write all values and value references in the format
        { "name": "V"},
        { "name": "AFlo"}
    */
    for(i = 0; i < n; i++){
      /* Build JSON string */
      saveAppend(buffer, "        { \"", bufLen);
      saveAppend(buffer, "name", bufLen);
      saveAppend(buffer, "\": \"", bufLen);
      saveAppend(buffer, values[i], bufLen);
      saveAppend(buffer, "\" }", bufLen);
      if (i < n-1)
        saveAppend(buffer, ",\n", bufLen);
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

void checkAndSetVerbosity(const int verbosity){

  if (getBuildings_nFMU() == 0){
    FMU_EP_VERBOSITY = verbosity;
  }
  else{
    if (FMU_EP_VERBOSITY != verbosity){
        ModelicaFormatMessage("Warning: Modelica objects declare different verbosity. Check parameter verbosity. Using highest declared value.\n");
    }
    if (verbosity > FMU_EP_VERBOSITY){
      FMU_EP_VERBOSITY = verbosity;
    }
  }
}


void getSimulationFMUName(const char* modelicaNameBuilding, const char* tmpDir, char* *fmuAbsPat){
  size_t iniLen = 100;

  /*
  const size_t lenNam = strlen(modelicaNameBuilding);
  char* newModNam;

  newModNam = malloc(lenNam * sizeof(char));
  if (newModNam == NULL){
    ModelicaFormatError("Failed to allocate memory for new Modelica name.");
  }
  Replace special characters in FMU name
  strcpy(newModNam, modelicaNameBuilding);
  replaceChar(newModNam, '[', '_');
  replaceChar(newModNam, ']', '_');
  */
  mallocString(iniLen, "Failed to allocate memory for FMU name.", fmuAbsPat);
  memset(*fmuAbsPat, '\0', iniLen);

  saveAppend(fmuAbsPat, tmpDir, &iniLen);
  saveAppend(fmuAbsPat, SEPARATOR, &iniLen);
  saveAppend(fmuAbsPat, modelicaNameBuilding, &iniLen);
  saveAppend(fmuAbsPat, ".fmu", &iniLen);
  /* Replace special characters that are introduced if arrays of models are used.
     Such array notation cause currently runtime errors when loading an FMU. */
  replaceChar(*fmuAbsPat, '[', '_');
  replaceChar(*fmuAbsPat, ']', '_');

  return;
}


char * getFileNameWithoutExtension(const char* idfName){
  char * namWitSla;
  char * nam;
  char * namOnl;
  char * ext;
  size_t lenNam;

  namWitSla = strrchr(idfName, '/');

  if ( namWitSla == NULL )
    ModelicaFormatError("Failed to parse file name '%s'. Expected an absolute path with slash '%s'?", idfName, "/");

  /* Remove the first slash */
  nam = namWitSla + 1;
  /* Get the extension */
  ext = strrchr(nam, '.');
  if ( ext == NULL )
    ModelicaFormatError("Failed to parse file name '%s'. Expected a file extension such as '.idf'?", idfName);

  /* Get the file name without extension */
  lenNam = strlen(nam) - strlen(ext);

  mallocString(lenNam+1, "Failed to allocate memory for temporary directory name in EnergyPlusUtil.c", &namOnl);

  memset(namOnl, '\0', lenNam+1);
  /* Copy nam to namOnl */
  strncpy(namOnl, nam, lenNam);

  return namOnl;
}

void getSimulationTemporaryDirectory(const char* modelicaNameBuilding, char** dirNam){
  /* Return the absolute name of the temporary directory to be used for EnergyPlus
     in the form "/mnt/xxx/tmp-eplus-mod.nam.bui"
  */
  size_t lenNam;
  size_t lenPre;
  size_t lenCur;
  size_t lenSep;
  char* curDir;
  char* namOnl;
  size_t lenCurDir = 256;
  const size_t incLenCurDir = 256;
  const size_t maxLenCurDir = 100000;

  /* Prefix for temporary directory */
  const char* pre = "tmp-simulation-\0";

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Entered getSimulationTemporaryDirectory.\n");
  /* Current directory */
  mallocString(lenCurDir, "Failed to allocate memory for current working directory in getSimulationTemporaryDirectory.", &curDir);
  memset(curDir, '\0', lenCurDir);

  while ( getcwd(curDir, lenCurDir) == NULL ){
    if ( errno == ERANGE){
      lenCurDir += incLenCurDir;
      if (lenCurDir > maxLenCurDir){
        ModelicaFormatError("Temporary directories with names longer than %lu characters are not supported in EnergyPlusFMU.c unless you change maxLenCurDir.", maxLenCurDir);
      }
      curDir = realloc(curDir, lenCurDir * sizeof(char));
      if (curDir == NULL)
        ModelicaError("Failed to reallocate memory for current working directory in getSimulationTemporaryDirectory.");
      memset(curDir, '\0', lenCurDir);
    }
    else{ /* Other error than insufficient length */
      ModelicaFormatError("Unknown error when allocating memory for temporary directory in EnergyPlusFMU.c.");
    }
  }

  lenNam = strlen(modelicaNameBuilding);
  lenCur = strlen(curDir);
  lenSep = 1;
  lenPre = strlen(pre);

  mallocString((lenCur+lenSep+lenPre+lenNam+1), "Failed to allocate memory for temporary directory name in EnergyPlusUtil.c.", dirNam);
  memset(*dirNam, '\0', (lenCur+lenSep+lenPre+lenNam+1));
  strncpy(*dirNam, curDir, lenCur);
  strcat(*dirNam, "/");
  strcat(*dirNam, pre);
  strcat(*dirNam, modelicaNameBuilding);
  /* Replace special characters that are introduced if arrays of models are used.
     Such array notation cause currently runtime errors when loading an FMU. */
  replaceChar(*dirNam, '[', '_');
  replaceChar(*dirNam, ']', '_');
  free(curDir);
  return;
}

void fmilogger(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message){
  if (log_level == jm_log_level_error){
    ModelicaFormatError("Error in FMU: module = %s, log level = %d: %s", module, log_level, message);
  }
  else{
    ModelicaFormatMessage("Message from FMU: module = %s, log level = %d: %s", module, log_level, message);
  }
}

void buildVariableName(
  const char* firstPart,
  const char* secondPart,
  char* *ptrFullName){
  size_t i;
  size_t len;

  len = strlen(firstPart) + 1 + strlen(secondPart);

  mallocString(len+1, "Failed to allocate memory for ptrFullName in EnergyPlusUtil.c.", ptrFullName);
  /* Copy the string */
  memset(*ptrFullName, '\0', len+1);
  strcpy(*ptrFullName, firstPart);
  strcat(*ptrFullName, "_");
  strcat(*ptrFullName, secondPart);

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Built variable name '%s'.\n", *ptrFullName);

  return;
}


void buildVariableNames(
  const char* zoneName,
  const char** variableNames,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFullNames){
    size_t i;
    size_t len;
    /* Compute longest output plus zone name */
    len = 0;
    for (i=0; i<nVar; i++)
      len = max(len, strlen(variableNames[i]));

      *ptrVarNames = (char**)malloc(nVar * sizeof(char*));
      if (*ptrVarNames == NULL)
        ModelicaError("Failed to allocate memory for ptrVarNames in ZoneInstantiate.c.");

    for (i=0; i<nVar; i++){
      mallocString(len+1, "Failed to allocate memory for ptrVarNames[i] in ZoneInstantiate.c.", &((*ptrVarNames)[i]));
    }

    /* Copy the string */
    for (i=0; i<nVar; i++){
      memset((*ptrVarNames)[i], '\0', len+1);
      strcpy((*ptrVarNames)[i], variableNames[i]);
    }

    /* Compute longest output plus zone name */
    len = 0;
    for (i=0; i<nVar; i++){
      /* Use +1 to account for the comma */
      len = max(len, strlen(zoneName) + 1 + strlen(variableNames[i]));
    }

    *ptrFullNames = (char**)malloc(nVar * sizeof(char*));
    if (*ptrFullNames == NULL)
      ModelicaError("Failed to allocate memory for ptrFullNames in ZoneInstantiate.c.");

    for (i=0; i<nVar; i++){
      mallocString(len+1, "Failed to allocate memory for ptrFullNames[i] in ZoneInstantiate.c.", &((*ptrFullNames)[i]));
    }
    /* Copy the string */
    for (i=0; i<nVar; i++){
      memset((*ptrFullNames)[i], '\0', len+1);
      strcpy((*ptrFullNames)[i], zoneName);
      strcat((*ptrFullNames)[i], "_");
      strcat((*ptrFullNames)[i], variableNames[i]);
    }

  return;
}

void createDirectory(const char* dirName){
  struct stat st = {0};
  /* Create directory if it does not already exist */
  if (stat(dirName, &st) == -1) {
    if ( mkdir(dirName, 0700) == -1)
      ModelicaFormatError("Failed to create directory %s", dirName);
  }
}


void loadFMU_setupExperiment_enterInitializationMode(FMUBuilding* bui, double startTime){
  fmi2_status_t status;

  /* Instantiate the FMU for this building */
  generateAndInstantiateBuilding(bui);
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Instantiate building %s.\n", bui->modelicaNameBuilding);

  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_setup_experiment: Setting up experiment building %s at %p with startTime = %f.\n",
      bui->modelicaNameBuilding, bui, startTime);
  bui->time = startTime;
  setFMUMode(bui, instantiationMode);

  /* This function can only be called once per building FMU */
  /*ModelicaFormatError("********* Calling setting up experiment... for building at %p", bui->fmu);*/

  status = fmi2_import_setup_experiment(
      bui->fmu,             /* fmu */
      fmi2False,            /* toleranceDefined */
      0.0,                  /* tolerance */
      startTime,            /* startTime */
      fmi2False,            /* stopTimeDefined */
      0);                   /* stopTime */
/*  ModelicaFormatError("********* Returned from setting up experiment... for %s", bui->modelicaNameBuilding);*/

  if( status != fmi2_status_ok ){
    ModelicaFormatError("Failed to setup experiment for FMU with name %s.",  bui->fmuAbsPat);
  }

  /* Enter initialization mode, because getting parameters is only
     allowed in the initialization mode, see FMU state diagram in standard */
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("fmi2_import_enter_initialization_mode: Enter initialization mode of FMU with name %s.\n",
      bui->fmuAbsPat);
  status = fmi2_import_enter_initialization_mode(bui->fmu);
  if( status != fmi2_status_ok ){
    ModelicaFormatError("Failed to enter initialization mode for FMU with name %s.",
    bui->fmuAbsPat);
  }
  setFMUMode(bui, initializationMode);

  return;
}
#endif
