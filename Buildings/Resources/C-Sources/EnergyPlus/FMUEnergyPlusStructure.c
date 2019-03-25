/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"

#include <stdlib.h>
#include <string.h>

/* Use windows.h only for Windows */
#ifdef _WIN32
#include <windows.h>
#else
#define _GNU_SOURCE
#include <dlfcn.h>
#endif

void writeLog(unsigned int level, const char* msg)
{
    if (level <= FMU_EP_VERBOSITY){
      const char* prefix = "*** Log: ";
      char* m;
      m = (char*)malloc( (strlen(msg)+strlen(prefix)+1) * sizeof(char));
      if (m == NULL)
        ModelicaError("Failed to allocate string array in writeLog.\n");
      strcpy(m, prefix);
      strcat(m, msg);
      fprintf(stdout, "%s\n", m);
      fflush(stdout);
      ModelicaFormatMessage("%s\n", m);
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


void getEnergyPlusFMUName(const char* idfName, const char* tmpDir, char* *fmuAbsPat){
  size_t lenIDF = strlen(idfName);
  size_t lenTMP = strlen(tmpDir);
  size_t iniLen = 100;
  char * idfNamNoExt = getIDFNameWithoutExtension(idfName);


  *fmuAbsPat = malloc(iniLen * sizeof(char));
  if (*fmuAbsPat == NULL){
    ModelicaFormatError("Failed to allocate memory for FMU name for %s.", idfName);
  }
  memset(*fmuAbsPat, '\0', iniLen);

  saveAppend(fmuAbsPat, tmpDir, &iniLen);
  saveAppend(fmuAbsPat, SEPARATOR, &iniLen);
  saveAppend(fmuAbsPat, idfNamNoExt, &iniLen);
  saveAppend(fmuAbsPat, ".fmu", &iniLen);
  free(idfNamNoExt);

  return;
}


char * getIDFNameWithoutExtension(const char* idfName){
  char * namWitSla;
  char * nam;
  char * namOnl;
  char * ext;
  size_t lenNam;

  namWitSla = strrchr(idfName, '/');

  if ( namWitSla == NULL )
    ModelicaFormatError("Failed to parse idfName '%s'. Expected an absolute path with slash '%s'?", idfName, "/");

  /* Remove the first slash */
  nam = namWitSla + 1;
  /* Get the extension */
  ext = strrchr(nam, '.');
  if ( ext == NULL )
    ModelicaFormatError("Failed to parse idfName '%s'. Expected a file extension such as '.idf'?", idfName);

  /* Get the file name without extension */
  lenNam = strlen(nam) - strlen(ext);

  namOnl = malloc((lenNam+1) * sizeof(char));
  if ( namOnl == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");
  memset(namOnl, '\0', lenNam+1);
  /* Copy nam to namOnl */
  strncpy(namOnl, nam, lenNam);

  return namOnl;
}

void getEnergyPlusTemporaryDirectory(const char* idfName, char** dirNam){
  /* Return the absolute name of the temporary directory to be used for EnergyPlus
     in the form "/mnt/xxx/tmp-eplus-ValidationRefBldgSmallOfficeNew2004_Chicago"
     This must be an absolute path as it is used to load the .so of the fmu, which
     requires the path to be absolute.
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
  const char* pre = "tmp-eplus-\0";

  writeLog(3, "Getting EnergyPlus temporary directory.");
  /* Current directory */
  curDir = malloc(lenCurDir * sizeof(char));
  if (curDir == NULL)
    ModelicaError("Failed to allocate memory for current working directory in getEnergyPlusTemporaryDirectory.");

  memset(curDir, '\0', lenCurDir);

  while ( getcwd(curDir, lenCurDir) == NULL ){
    if ( errno == ERANGE){
      lenCurDir += incLenCurDir;
      if (lenCurDir > maxLenCurDir){
        ModelicaFormatError("Temporary directories with names longer than %u characters are not supported in FMUEnergyPlusStructure.c.", maxLenCurDir);
      }
      curDir = realloc(curDir, lenCurDir * sizeof(char));
      if (curDir == NULL)
        ModelicaError("Failed to reallocate memory for current working directory in getEnergyPlusTemporaryDirectory.");
      memset(curDir, '\0', lenCurDir);
    }
    else{ /* Other error than insufficient length */
      ModelicaFormatError("Unknown error when allocating memory for temporary directory in FMUEnergyPlusStructure.c.");
    }
  }

  namOnl = getIDFNameWithoutExtension(idfName);
  lenNam = strlen(namOnl);
  lenCur = strlen(curDir);
  lenSep = 1;
  lenPre = strlen(pre);
  writeLog(3, "*** Got string length.");

  *dirNam = malloc((lenCur+lenSep+lenPre+lenNam+1) * sizeof(char));
  if ( *dirNam == NULL )
    ModelicaFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");
  memset(*dirNam, '\0', (lenCur+lenSep+lenPre+lenNam+1));
  strncpy(*dirNam, curDir, lenCur);
  strcat(*dirNam, "/");
  strcat(*dirNam, pre);
  strcat(*dirNam, namOnl);
  free(namOnl);
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

void getEnergyPlusDLLName(char** epLibName) {
char * epLib = "libepfmi-9.0.1.so"; /* fixme */
  size_t len = strlen(epLib);
  *epLibName = (char *)malloc((len + 1) * sizeof(char));
  if ( *epLibName == NULL)
    ModelicaError("Failed to allocate memory for epLibName.");
  memset(*epLibName, '\0', len+1);
  memcpy(*epLibName, epLib, len);

/*
#if defined _WIN32
    // TODO this probably needs improvement to work on windows
    TCHAR szPath[MAX_PATH];
    if( GetModuleFileName( nullptr, szPath, MAX_PATH ) ) {
      *epLibName = szPath;
    }
#else
    Dl_info info;
    if (dladdr("main", &info)) {
      const char * fullpath = info.dli_fname;
      const char * filename = strrchr(fullpath, '/');
      const char * extension = strrchr(fullpath, '.');

      const char* libepfmi="/libepfmi-9.0.1";
      size_t lenLibepfmi = strlen(libepfmi);
      size_t lenPat = strlen(fullpath) - strlen(filename);
      size_t length = lenPat + strlen(libepfmi) + strlen(extension);
      *epLibName = (char *)malloc((length + 1) * sizeof(char));
      if ( *epLibName == NULL)
        ModelicaError("Failed to allocate memory for epLibName.");
      memset(*epLibName, '\0', length+1);
      strncpy(*epLibName, fullpath, lenPat);

      memcpy(*epLibName + lenPat,
          libepfmi, lenLibepfmi);
      memcpy(*epLibName + lenPat + lenLibepfmi,
          extension, strlen(extension));
    }
#endif
*/
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
        ModelicaError("Failed to allocate memory for ptrVarNames in FMUZoneInstantiate.c.");

    for (i=0; i<nVar; i++){
      (*ptrVarNames)[i] = (char*)malloc( (len+1) * sizeof(char));
      if ( (*ptrVarNames)[i] == NULL)
        ModelicaError("Failed to allocate memory for ptrVarNames[i] in FMUZoneInstantiate.c.");
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
      ModelicaError("Failed to allocate memory for ptrFullNames in FMUZoneInstantiate.c.");

    for (i=0; i<nVar; i++){
      (*ptrFullNames)[i] = (char*)malloc(( len + 1 ) * sizeof(char));
      if ( (*ptrFullNames)[i] == NULL)
        ModelicaError("Failed to allocate memory for ptrFullNames[i] in FMUZoneInstantiate.c.");
    }
    /* Copy the string */
    for (i=0; i<nVar; i++){
      memset((*ptrFullNames)[i], '\0', len+1);
      strcpy((*ptrFullNames)[i], zoneName);
      strcat((*ptrFullNames)[i], ",");
      strcat((*ptrFullNames)[i], variableNames[i]);
    }
    return;
    }


void createDirectory(const char* dirName){
  struct stat st = {0};

  if (stat(dirName, &st) == -1) {
    if ( mkdir(dirName, 0700) == -1)
      ModelicaFormatError("Failed to create directory %s", dirName);
  }
}


FMUBuilding* FMUZoneAllocateBuildingDataStructure(const char* idfName, const char* weaName,
  const char* iddName, const char* zoneName, FMUZone* zone){
  /* Allocate memory */

  const size_t nFMU = getBuildings_nFMU();
  writeLog(2, "Allocating data structure for building.");

  if (nFMU == 0)
    Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
  else
    Buildings_FMUS = realloc(Buildings_FMUS, (nFMU+1) * sizeof(struct FMUBuilding*));
  if ( Buildings_FMUS == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMU.");

  Buildings_FMUS[nFMU] = malloc(sizeof(FMUBuilding));
  if ( Buildings_FMUS[nFMU] == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMU[0].");

  Buildings_FMUS[nFMU]->fmu = NULL;
  Buildings_FMUS[nFMU]->context = NULL;
  Buildings_FMUS[nFMU]->GUID = NULL;

  Buildings_FMUS[nFMU]->zoneNames = malloc(sizeof(char*));
  if ( Buildings_FMUS[nFMU]->zoneNames == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMUS[0]->zoneNames.");

  /* Assign the fmu name */
  Buildings_FMUS[nFMU]->name = (char*) malloc((strlen(idfName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->name == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate fmu name.");
  strcpy(Buildings_FMUS[nFMU]->name, idfName);

  /* Assign the weather name */
  Buildings_FMUS[nFMU]->weather = (char*) malloc((strlen(weaName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->weather == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate weather name.");
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);

  /* Assign the idd name */
  Buildings_FMUS[nFMU]->idd = (char*) malloc((strlen(iddName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->idd == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate IDD name.");
  strcpy(Buildings_FMUS[nFMU]->idd, iddName);

  /* Assign the zone name */
  Buildings_FMUS[nFMU]->zoneNames[0] = malloc((strlen(zoneName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->zoneNames[0] == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(Buildings_FMUS[nFMU]->zoneNames[0], zoneName);

  Buildings_FMUS[nFMU]->nZon = 1;

  Buildings_FMUS[nFMU]->zones=malloc(sizeof(FMUZone *));
  if ( Buildings_FMUS[nFMU]->zones== NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zones.");

  getEnergyPlusTemporaryDirectory(idfName, &(Buildings_FMUS[nFMU]->tmpDir));

  getEnergyPlusFMUName(idfName, Buildings_FMUS[nFMU]->tmpDir, &(Buildings_FMUS[nFMU]->fmuAbsPat));
  /* Create the temporary directory */
  createDirectory(Buildings_FMUS[nFMU]->tmpDir);

  /* Assign the dll name */
  if (nFMU == 0) {
    getEnergyPlusDLLName(&(Buildings_FMUS[nFMU]->epLib));
  }
  else{
    /* All FMUs share the same dll name. Copy it from the Buildings_FMUS[0] */
    size_t len = strlen(Buildings_FMUS[0]->epLib);
    Buildings_FMUS[nFMU]->epLib = (char *)malloc((len + 1) * sizeof(char));
    if ( Buildings_FMUS[nFMU]->epLib == NULL)
      ModelicaError("Failed to allocate memory for epLibName.");
    memset(Buildings_FMUS[nFMU]->epLib, '\0', len+1);
    strncpy(Buildings_FMUS[nFMU]->epLib, Buildings_FMUS[0]->epLib, len);
  }

  /* Assign the zone */
  Buildings_FMUS[nFMU]->zones[0] = zone;

  incrementBuildings_nFMU();
  /* ModelicaMessage("*** Leaving instantiateEnergyPlusFMU."); */

  /* Return the pointer to the FMU for this EnergyPlus instance */
  return Buildings_FMUS[nFMU];
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
  if (Buildings_nFMU == 0){
     free(Buildings_FMUS);
   }
  /* ModelicaFormatMessage("*** Decreased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

unsigned int getBuildings_nFMU(){
  return Buildings_nFMU;
}
