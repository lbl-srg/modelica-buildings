/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "EnergyPlusStructure.h"

#include "EnergyPlusUtil.c"

#include <stdlib.h>
#include <string.h>

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

static unsigned int Buildings_nFMU = 0;     /* Number of FMUs */
static struct FMUBuilding** Buildings_FMUS; /* Array with pointers to all FMUs */

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

/* Wrapper to set fmu mode indicator and log the mode change for debugging */
void setFMUMode(FMUBuilding* bui, FMUMode mode){
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("Switching %s to mode %s\n", bui->modelicaNameBuilding, fmuModeToString(mode));
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

  mallocString(lenNam+1, "Failed to allocate memory for temporary directory name in ZoneInstantiate.c", &namOnl);

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
        ModelicaFormatError("Temporary directories with names longer than %lu characters are not supported in EnergyPlusStructure.c unless you change maxLenCurDir.", maxLenCurDir);
      }
      curDir = realloc(curDir, lenCurDir * sizeof(char));
      if (curDir == NULL)
        ModelicaError("Failed to reallocate memory for current working directory in getSimulationTemporaryDirectory.");
      memset(curDir, '\0', lenCurDir);
    }
    else{ /* Other error than insufficient length */
      ModelicaFormatError("Unknown error when allocating memory for temporary directory in EnergyPlusStructure.c.");
    }
  }

  lenNam = strlen(modelicaNameBuilding);
  lenCur = strlen(curDir);
  lenSep = 1;
  lenPre = strlen(pre);

  mallocString((lenCur+lenSep+lenPre+lenNam+1), "Failed to allocate memory for temporary directory name in ZoneInstantiate.c.", dirNam);
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


void buildVariableNames(
  const char* firstPart,
  const char** secondParts,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFullNames){
    size_t i;
    size_t len;
    /* Compute longest output plus zone name */
    len = 0;
    for (i=0; i<nVar; i++)
      len = max(len, strlen(secondParts[i]));

    *ptrVarNames = (char**)malloc(nVar * sizeof(char*));
      if (*ptrVarNames == NULL)
        ModelicaError("Failed to allocate memory for ptrVarNames in ZoneInstantiate.c.");

    for (i=0; i<nVar; i++){
      mallocString(len+1, "Failed to allocate memory for ptrVarNames[i] in ZoneInstantiate.c.", &((*ptrVarNames)[i]));
    }
    /* Copy the string */
    for (i=0; i<nVar; i++){
      memset((*ptrVarNames)[i], '\0', len+1);
      strcpy((*ptrVarNames)[i], secondParts[i]);
    }

    /* Compute longest output plus zone name */
    len = 0;
    for (i=0; i<nVar; i++){
      /* Use +1 to account for the comma */
      len = max(len, strlen(firstPart) + 1 + strlen(secondParts[i]));
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
      strcpy((*ptrFullNames)[i], firstPart);
      strcat((*ptrFullNames)[i], "_");
      strcat((*ptrFullNames)[i], secondParts[i]);
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


size_t AllocateBuildingDataStructure(
  const char* modelicaNameBuilding,
  const char* idfName,
  const char* weaName,
  const char* iddName,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot){

  int i;
  /* Allocate memory */

  const size_t nFMU = getBuildings_nFMU();
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaFormatMessage("ZoneAllocateBuildingDataStructure: Allocating data structure for building %s", modelicaNameBuilding);

  if (nFMU == 0)
    Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
  else
    Buildings_FMUS = realloc(Buildings_FMUS, (nFMU+1) * sizeof(struct FMUBuilding*));
  if ( Buildings_FMUS == NULL )
    ModelicaError("Not enough memory in ZoneAllocate.c. to allocate array for Buildings_FMU.");

  Buildings_FMUS[nFMU] = malloc(sizeof(FMUBuilding));
  if ( Buildings_FMUS[nFMU] == NULL )
    ModelicaError("Not enough memory in ZoneAllocate.c. to allocate array for Buildings_FMU[0].");

  Buildings_FMUS[nFMU]->fmu = NULL;
  Buildings_FMUS[nFMU]->context = NULL;
  Buildings_FMUS[nFMU]->GUID = NULL;
  /* Set flag that dll fmu functions are not yet created */
  Buildings_FMUS[nFMU]->dllfmu_created = fmi2_false;

  /* Assign the modelica name for this building */
  mallocString((strlen(modelicaNameBuilding)+1), "Not enough memory in ZoneAllocate.c. to allocate modelicaNameBuilding.", &(Buildings_FMUS[nFMU]->modelicaNameBuilding));
  strcpy(Buildings_FMUS[nFMU]->modelicaNameBuilding, modelicaNameBuilding);

  /* Assign the Buildings library root */
  mallocString((strlen(buildingsLibraryRoot)+1), "Not enough memory in ZoneAllocate.c. to allocate buildingsLibraryRoot.", &(Buildings_FMUS[nFMU]->buildingsLibraryRoot));
  strcpy(Buildings_FMUS[nFMU]->buildingsLibraryRoot, buildingsLibraryRoot);

  /* Assign the idfName name */
  if (usePrecompiledFMU){
    mallocString((strlen(fmuName)+1), "Not enough memory in ZoneAllocate.c. to allocate idfName.", &(Buildings_FMUS[nFMU]->idfName));
    strcpy(Buildings_FMUS[nFMU]->idfName, fmuName);
  }
  else{
    mallocString((strlen(idfName)+1), "Not enough memory in ZoneAllocate.c. to allocate idfName.", &(Buildings_FMUS[nFMU]->idfName));
    strcpy(Buildings_FMUS[nFMU]->idfName, idfName);
  }

  /* Assign the weather name */
  mallocString((strlen(weaName)+1), "Not enough memory in ZoneAllocate.c. to allocate weather.", &(Buildings_FMUS[nFMU]->weather));
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);

  /* Assign the idd name */
  mallocString((strlen(iddName)+1), "Not enough memory in ZoneAllocate.c. to allocate idd.", &(Buildings_FMUS[nFMU]->idd));
  strcpy(Buildings_FMUS[nFMU]->idd, iddName);

  /* Set the model hash to null */
  Buildings_FMUS[nFMU]->modelHash = NULL;
  /* Set the number of this FMU */
  Buildings_FMUS[nFMU]->iFMU = nFMU;

  getSimulationTemporaryDirectory(modelicaNameBuilding, &(Buildings_FMUS[nFMU]->tmpDir));
  getSimulationFMUName(modelicaNameBuilding, Buildings_FMUS[nFMU]->tmpDir, &(Buildings_FMUS[nFMU]->fmuAbsPat));
  if (usePrecompiledFMU){
    Buildings_FMUS[nFMU]->usePrecompiledFMU = usePrecompiledFMU;
    /* Copy name of precompiled FMU */
    mallocString(strlen(fmuName)+1, "Not enough memory to allocate memory for FMU name.", &(Buildings_FMUS[nFMU]->precompiledFMUAbsPat));
    memset(Buildings_FMUS[nFMU]->precompiledFMUAbsPat, '\0', strlen(fmuName)+1);
    strcpy(Buildings_FMUS[nFMU]->precompiledFMUAbsPat, fmuName);
  }
  else{
    /* Use actual EnergyPlus */
    Buildings_FMUS[nFMU]->usePrecompiledFMU = usePrecompiledFMU;
    Buildings_FMUS[nFMU]->precompiledFMUAbsPat = NULL;
  }

  /* Initialize thermal zone data */
  Buildings_FMUS[nFMU]->nZon = 0;
  Buildings_FMUS[nFMU]->zones = NULL;

  /* Initialize output variable data */
  Buildings_FMUS[nFMU]->nOutputVariables = 0;
  Buildings_FMUS[nFMU]->outputVariables = NULL;

  /* Create the temporary directory */
  createDirectory(Buildings_FMUS[nFMU]->tmpDir);

  incrementBuildings_nFMU();

  return getBuildings_nFMU();
}

void AddZoneToBuilding(FMUZone* ptrZone){
  FMUBuilding* fmu = ptrZone->ptrBui;
  const size_t nZon = fmu->nZon;

  if (nZon == 0){
    fmu->zones=malloc(sizeof(FMUZone *));
    if ( fmu->zones== NULL )
      ModelicaError("Not enough memory in EnergyPlusDataStructure.c. to allocate zones.");
  }
  else{
    /* We already have nZon > 0 zones */

    /* Increment size of vector that contains the zones. */
    fmu->zones = realloc(fmu->zones, (nZon + 1) * sizeof(FMUZone*));
    if (fmu->zones == NULL){
      ModelicaError("Not enough memory in EnergyPlusDataStructure.c. to allocate memory for bld->zones.");
    }
  }
  /* Assign the zone */
  fmu->zones[nZon] = ptrZone;
  /* Increment the count of zones to this building. */
  fmu->nZon++;
}

void AddOutputVariableToBuilding(FMUOutputVariable* ptrOutVar){
  FMUBuilding* fmu = ptrOutVar->ptrBui;
  const size_t nOutputVariables = fmu->nOutputVariables;

  if (nOutputVariables == 0){
    fmu->outputVariables=malloc(sizeof(FMUOutputVariable *));
    if ( fmu->outputVariables== NULL )
      ModelicaError("Not enough memory in EnergyPlusDataStructure.c. to allocate output variables.");
  }
  else{
    /* We already have nOutputVariables > 0 output variables. */

    /* Increment size of vector that contains the output variables. */
    fmu->outputVariables = realloc(fmu->outputVariables, (nOutputVariables + 1) * sizeof(FMUOutputVariable*));
    if (fmu->outputVariables == NULL){
      ModelicaError("Not enough memory in EnergyPlusStructure.c. to allocate memory for fmu->outputVariables.");
    }
  }
  /* Assign the output variable */
  fmu->outputVariables[nOutputVariables] = ptrOutVar;
  /* Increment the count of output variables of this building. */
  fmu->nOutputVariables++;
}

FMUBuilding* getBuildingsFMU(size_t iFMU){
  return Buildings_FMUS[iFMU];
}

void incrementBuildings_nFMU(){
  Buildings_nFMU++;
  /* ModelicaFormatMessage("*** Increased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

void decrementBuildings_nFMU(){
  Buildings_nFMU--;
  /* ModelicaFormatMessage("*** Decreased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

unsigned int getBuildings_nFMU(){
  return Buildings_nFMU;
}

void FMUBuildingFree(FMUBuilding* ptrBui){
  fmi2Status status;
  const char * log = NULL;
  if (FMU_EP_VERBOSITY >= MEDIUM)
    ModelicaMessage("Entered FMUBuildingFree.");

  if ( ptrBui != NULL ){
    /* Make sure no thermal zone or output variable uses this building */
    if (ptrBui->nZon > 0 || ptrBui->nOutputVariables > 0){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("Exiting FMUBuildingFree without changes as zones or outputs uses this building.");
      return;
    }

    /* The call to fmi2_import_terminate causes a seg fault if
       fmi2_import_create_dllfmu was not successful */
    if (ptrBui->dllfmu_created){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaMessage("fmi2_import_terminate: terminating EnergyPlus.\n");
      status = fmi2_import_terminate(ptrBui->fmu);
      if (status != fmi2OK){
        ModelicaFormatMessage(
          "fmi2Terminate returned with non-OK status for building %s.",
          ptrBui->modelicaNameBuilding);
      }
    }
    if (ptrBui->fmu != NULL){
      if (FMU_EP_VERBOSITY >= MEDIUM)
        ModelicaFormatMessage(
          "fmi2_import_destroy_dllfmu: destroying dll fmu. for %s",
          ptrBui->modelicaNameBuilding);
      fmi2_import_destroy_dllfmu(ptrBui->fmu);
      fmi2_import_free(ptrBui->fmu);
    }
    if (ptrBui->context != NULL){
      fmi_import_free_context(ptrBui->context);
    }

    if (ptrBui->buildingsLibraryRoot != NULL)
      free(ptrBui->buildingsLibraryRoot);
    if (ptrBui->modelicaNameBuilding != NULL)
      free(ptrBui->modelicaNameBuilding);
    if (ptrBui->idfName != NULL)
      free(ptrBui->idfName);
    if (ptrBui->weather != NULL)
      free(ptrBui->weather);
    if (ptrBui->idd != NULL)
      free(ptrBui->idd);
    if (ptrBui->zones != NULL)
      free(ptrBui->zones);
    if (ptrBui->outputVariables != NULL)
      free(ptrBui->outputVariables);
    if (ptrBui->tmpDir != NULL)
      free(ptrBui->tmpDir);
    if (ptrBui->modelHash != NULL)
      free(ptrBui->modelHash);
    free(ptrBui);
  }
  decrementBuildings_nFMU();
  if (getBuildings_nFMU() == 0){
    free(Buildings_FMUS);
  }
}