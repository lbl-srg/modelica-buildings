/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "BuildingInstantiate.h"
#ifndef Buildings_BuildingInstantiate_c
#define Buildings_BuildingInstantiate_c

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <stdbool.h>


void buildJSONKeyLiteralValue(
  char* *buffer, size_t level, const char* key, const char* value, bool addComma, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){
  size_t i;
  for(i = 0; i < level; i++)
    saveAppend(buffer, "  ", size, SpawnFormatError);
  saveAppend(buffer, "\"", size, SpawnFormatError);
  saveAppend(buffer, key, size, SpawnFormatError);
  saveAppend(buffer, "\": ", size, SpawnFormatError);
  saveAppend(buffer, value, size, SpawnFormatError);
  if (addComma)
    saveAppend(buffer, ",\n", size, SpawnFormatError);
  else
    saveAppend(buffer, "\n", size, SpawnFormatError);
}

void buildJSONKeyStringValue(
  char* *buffer, size_t level, const char* key, const char* value, bool addComma, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){

  char* litVal;
  const char quote[] = "\""  ;

  /* Allocate memory for string with quotes */
  const size_t len = strlen(value) + 2;
  mallocString(len+1, "Failed to allocate memory json key.", &litVal, SpawnFormatError);
  memset(litVal, '\0', len+1);
  /* Add quotes before and after string */
  strcpy(litVal, quote);
  strcat(litVal, value);
  strcat(litVal, quote);

  /* Build json snippet */
  buildJSONKeyLiteralValue(buffer, level, key, litVal, addComma, size, SpawnFormatError);
}

void buildJSONKeyDoubleValue(
  char* *buffer, size_t level, const char* key, double value, bool addComma, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){

  char litVal[20];
  sprintf(litVal, "%4.2e", value);

  /* Build json snippet */
  buildJSONKeyLiteralValue(buffer, level, key, litVal, addComma, size, SpawnFormatError);
}

void openJSONModelBracket(char* *buffer, size_t* size, void (*SpawnFormatError)(const char *string, ...)){
  saveAppend(buffer, "      {\n", size, SpawnFormatError);
}

void closeJSONModelBracket(
  char* *buffer, size_t i, size_t iMax, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){
  if (i < iMax -1)
    saveAppend(buffer, "      },\n", size, SpawnFormatError);
  else
    saveAppend(buffer, "      }\n", size, SpawnFormatError);
}

void closeJSONModelArrayBracket(
  char* *buffer, size_t iMod, size_t nMod, size_t* size,
  void (*SpawnFormatError)(const char *string, ...)){
  /* Close json array bracket */
  if (iMod == nMod){
    /* There are no more other objects that belong to "model" */
    saveAppend(buffer, "    ]\n", size, SpawnFormatError);
  }
  else{
    /* There are other objects that belong to "model" */
    saveAppend(buffer, "    ],\n", size, SpawnFormatError);
  }
}

void buildJSONModelStructureForEnergyPlus(
  const FMUBuilding* bui, char* *buffer, size_t* size, char** modelHash){
  size_t i;
  size_t iWri;
  SpawnObject** ptrSpaObj = (SpawnObject**)bui->exchange;

  /* Number of models written to json so far */
  size_t iMod = 0;
  int objectType;
  size_t objectCount[6];
  const int nObjectTypes = sizeof(objectCount)/sizeof(objectCount[0]);

  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  /* Total number of models */
  const size_t nMod = bui->nExcObj;

  /* Count number of objects */
  for(objectType = 0; objectType < nObjectTypes; objectType++){
    objectCount[objectType] = 0;
    for(i = 0; i < bui->nExcObj; i++){
        if ( ptrSpaObj[i]->objectType == (objectType+1) ){ /* Modelica uses 1-based objectType */
          objectCount[objectType]++;
        }
    }
  }

  saveAppend(buffer, "{\n", size, SpawnFormatError);
  buildJSONKeyStringValue(buffer, 1, "version", "0.1", true, size, SpawnFormatError);
  saveAppend(buffer, "  \"EnergyPlus\": {\n", size, SpawnFormatError);
  /* idf name */
  buildJSONKeyStringValue(buffer, 2, "idf", bui->idfName, true, size, SpawnFormatError);

  /* weather file */
  buildJSONKeyStringValue(buffer, 2, "weather", bui->weather, true, size, SpawnFormatError);

  /* Tolerance of solver for surface heat balance */
  buildJSONKeyDoubleValue(buffer, 2, "relativeSurfaceTolerance", bui->relativeSurfaceTolerance,
    false, size, SpawnFormatError);

  saveAppend(buffer, "  },\n", size, SpawnFormatError);

  /* model information */
  saveAppend(buffer, "  \"model\": {\n", size, SpawnFormatError);

  /* Write all json objects (thermal zones, actuators, etc.) */
  for(objectType = 0; objectType < nObjectTypes; objectType++){
    for(i = 0, iWri = 0; i < bui->nExcObj; i++){
      if ( ptrSpaObj[i]->objectType == (objectType+1) ) { /* Modelica uses 1-based objectType */
        /* Check if json keyword needs to be written */
        if (iWri == 0){
          saveAppend(buffer, "    \"", size, SpawnFormatError);
          saveAppend(buffer, ptrSpaObj[i]->jsonName, size, SpawnFormatError);
          saveAppend(buffer, "\": [\n", size, SpawnFormatError);
        }
        /* Write content */
        openJSONModelBracket(buffer, size, SpawnFormatError);
        saveAppend(buffer, ptrSpaObj[i]->jsonKeysValues, size, SpawnFormatError);
        saveAppend(buffer, "\n", size, SpawnFormatError);
        closeJSONModelBracket(buffer, iWri, objectCount[objectType], size, SpawnFormatError);
        iWri++;
      }
    }

    iMod += iWri;
    if (iWri > 0)
      closeJSONModelArrayBracket(buffer, iMod, nMod, size, SpawnFormatError);
  }

  /* Close json object for model */
  saveAppend(buffer, "  },\n", size, SpawnFormatError);

  *modelHash = (char*)( cryptographicsHash(*buffer, bui->SpawnError) );

    /* fmu */
  saveAppend(buffer, "  \"fmu\": {\n", size, SpawnFormatError);
  buildJSONKeyStringValue(buffer, 3, "name", bui->fmuAbsPat, true, size, SpawnFormatError);
  buildJSONKeyStringValue(buffer, 3, "version", "2.0", true, size, SpawnFormatError);
  buildJSONKeyStringValue(buffer, 3, "kind", "ME", false, size, SpawnFormatError);
  saveAppend(buffer, "  }\n", size, SpawnFormatError);

  /* Close json structure */
  saveAppend(buffer, "}\n", size, SpawnFormatError);

  return;
}


void writeModelStructureForEnergyPlus(const FMUBuilding* bui, char** modelicaBuildingsJsonFile, char** modelHash){
  char * buffer;
  size_t size;
  size_t lenNam;
  FILE* fp;

  const char* MOD_BUI_JSON = "ModelicaBuildingsEnergyPlus.json";

  /* Initial size which will grow as needed */
  size = 1024;

  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  mallocString(size+1, "Failed to allocate memory for json buffer.", &buffer, SpawnFormatError);
  memset(buffer, '\0', size + 1);

  /* Build the json structure */
  buildJSONModelStructureForEnergyPlus(bui, &buffer, &size, modelHash);

  /* Write to file */
  /* Build the file name */
  lenNam = strlen(bui->tmpDir) + strlen(SEPARATOR) + strlen(MOD_BUI_JSON);

  mallocString(lenNam+1, "Failed to allocate memory for json file name.", modelicaBuildingsJsonFile, SpawnFormatError);
  memset(*modelicaBuildingsJsonFile, '\0', lenNam+1);
  strcpy(*modelicaBuildingsJsonFile, bui->tmpDir);
  strcat(*modelicaBuildingsJsonFile, SEPARATOR);
  strcat(*modelicaBuildingsJsonFile, MOD_BUI_JSON);

  /* Open and write file */
  fp = fopen(*modelicaBuildingsJsonFile, "w");
  if (fp == NULL)
    SpawnFormatError("Failed to open '%s' with write mode.", *modelicaBuildingsJsonFile);
  fprintf(fp, "%s", buffer);
  fclose(fp);
}

void setAttributesReal(
  FMUBuilding* bui,
  fmi2_import_variable_list_t* varLis,
  const fmi2_value_reference_t varValRef[],
  const size_t nVar,
  const spawnReals* ptrSpawnReals){

  const char* fmuNam = bui->fmuAbsPat;
  size_t iFMI;
  fmi2_import_variable_t* var;
  bool found;
  size_t i;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  for(i = 0; i < ptrSpawnReals->n; i++){
    found = false;
    if (bui->logLevel >= TIMESTEP)
        SpawnFormatMessage("%.3f %s: Setting variable reference for %s.\n",
          bui->time, bui->modelicaNameBuilding, ptrSpawnReals->fmiNames[i]);

    for (iFMI = 0; iFMI < nVar; iFMI++){
      var = fmi2_import_get_variable(varLis, iFMI);
      if (strcmp(ptrSpawnReals->fmiNames[i], fmi2_import_get_variable_name(var)) == 0){
        /* Found the variable */
        fmi2_import_real_variable_t* varRea = fmi2_import_get_variable_as_real(var);
        ptrSpawnReals->units[i] = fmi2_import_get_real_variable_unit(varRea);
        /* If a unit is not specified in modelDescription.xml, then unit is NULL */

        if (ptrSpawnReals->units[i] == NULL){
          SpawnFormatMessage("%.3f %s: Warning: Variable %s does not specify units in %s. It will not be converted to SI units.\n",
            bui->time, bui->modelicaNameBuilding, ptrSpawnReals->fmiNames[i], fmuNam);
        }

        if (bui->logLevel >= MEDIUM){
          if (ptrSpawnReals->units[i] == NULL)
            SpawnFormatMessage("%.3f %s: Variable with name %s has no units and valRef= %d.\n",
              bui->time, bui->modelicaNameBuilding, ptrSpawnReals->fmiNames[i], varValRef[iFMI]);
          else{
            const char* unitName = fmi2_import_get_unit_name(ptrSpawnReals->units[i]); /* This is 'W', 'm2', etc. */
            SpawnFormatMessage("%.3f %s: Variable with name %s has unit = %s and valRef= %d.\n",
              bui->time, bui->modelicaNameBuilding, ptrSpawnReals->fmiNames[i], unitName, varValRef[iFMI]);
          }
        }
        ptrSpawnReals->valRefs[i] = varValRef[iFMI];
        found = true;
        break;
      }
    }
    if (!found)
      SpawnFormatError("%s: Failed to find variable %s in %s.", bui->modelicaNameBuilding,
        ptrSpawnReals->fmiNames[i], fmuNam);
  }
}

void setValueReferences(FMUBuilding* bui){
  size_t i;
  SpawnObject* ptrSpaObj;

  fmi2_import_variable_list_t* vl = fmi2_import_get_variable_list(bui->fmu, 0);
  const fmi2_value_reference_t* vrl = fmi2_import_get_value_referece_list(vl);
  size_t nv = fmi2_import_get_variable_list_size(vl);

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;

  /* Set value references for the ptrSpaObj by assigning the values obtained from the FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Setting variable references for ptrSpaObj.\n",
      bui->time, bui->modelicaNameBuilding);

  for(i = 0; i < bui->nExcObj; i++){
    ptrSpaObj = (SpawnObject*) bui->exchange[i];
    setAttributesReal(bui, vl, vrl, nv, ptrSpaObj->parameters);
    setAttributesReal(bui, vl, vrl, nv, ptrSpaObj->inputs);
    setAttributesReal(bui, vl, vrl, nv, ptrSpaObj->outputs);
    ptrSpaObj->valueReferenceIsSet = true;
  }

  /* Free the variable list */
  fmi2_import_free_variable_list(vl);

  return;
}

/* Return the path the the Spawn executable, consisting of path + delimiter + spawnExe.
   If an executable is found, this function returns a char* pointer to the full path.
   The calling routine is responsible to free memory for that point once it is no longer used.
   Otherwise it returns NULL.
*/
char* returnSpawnExecutable(FMUBuilding* bui, const char* path, const char* spawnExe){
  size_t len;
  bool found;
  char *spawnFullPath; /* Path to the executable, including the name of the executable file */

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  len = strlen(path) + strlen(SEPARATOR) + strlen(spawnExe) + 1;
#ifdef _WIN32 /* Win32 or Win64 */
  len = len + strlen(".exe");
#endif

  mallocString(len, "Failed to allocate memory in returnSpawnExecutable() for spawnFullPath.",
    &spawnFullPath, SpawnFormatError);

  memset(spawnFullPath, '\0', len);

  strcpy(spawnFullPath, path);
  strcat(spawnFullPath, SEPARATOR);
  strcat(spawnFullPath, spawnExe);
#ifdef _WIN32 /* Win32 or Win64 */
  strcat(spawnFullPath, ".exe");
#endif

  /* Check if the executable exists and is executable. For this, the leading and trailing space needs to be removed.
     (But later on, for invoking the executable, the spaces need to be present if there is a white space in the directory name.)
  */
  /* Check if executable exists. Linux returns 0, and Windows returns 2 if file does not exist */
  if( access(spawnFullPath, F_OK ) == 0 ) {
    found = true;
  }
  else{
    found = false;
    if (bui->logLevel >= MEDIUM){
      SpawnFormatMessage("%.3f %s: File '%s' does not exists: '%s'.\n",
        bui->time, bui->modelicaNameBuilding, spawnFullPath, strerror(errno));
    }
  }
  /* Make sure the file is executable */
  /* Windows has no mode X_OK = 1, see https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/access-waccess?view=vs-2019 */
#ifndef _WIN32
  if( found && (! access(spawnFullPath, X_OK ) == 0) ) {
    found = false;
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: File '%s' exists, but fails to have executable flag set: '%s.",
        bui->time, bui->modelicaNameBuilding, spawnFullPath, strerror(errno));
  }
#endif

  if (bui->logLevel >= MEDIUM){
    if (found)
      SpawnFormatMessage("%.3f %s: Found executable '%s' in '%s'.\n", bui->time, bui->modelicaNameBuilding, spawnExe, path);
    else
      SpawnFormatMessage("%.3f %s: Did not find executable '%s' in '%s'.\n", bui->time, bui->modelicaNameBuilding, spawnExe, path);
  }

  /* Return the allocated string, or NULL */
  if (found){
    return spawnFullPath;
  }
  else{
    free(spawnFullPath);
    return NULL;
  }
}

/* Find the executable to spawn.
   If SEARCHPATH is NULL, then this function searches spawnExe in the Buildings library.
   Otherwise, it searches it on SEARCHPATH. On Windows, SEARCHPATH is semi-colon separated,
   and on Linux, it is colon separated, so the same at the PATH entry.
   spawnExe is a string such as spawn-0.2.0-a23bb23, without extension. On Windows, .exe is appended by this function.
   If an executable is found, this function returns a char* pointer to the full path.
   The calling routine is responsible to free memory for that point once it is no longer used.
   Otherwise it returns NULL.
*/
char* findSpawnExe(FMUBuilding* bui, const char* SEARCHPATH, const char* spawnExe){
  size_t len;
  char *spawnFullPath; /* Path to the executable, including the name of the executable file */
  char *pathToExe;     /* Path to the executable, without the name of the executable file */
  char *nameSpawnLight; /* Name of Spawn-light, such as Spawn-light-{version}-{commit[0:10]} */

  char *str;
  char *token;
  char *saveptr;
  char *searchPathCopy;

  const size_t extra_len_light = strlen("Spawn-light-") - strlen("spawn-");

  const char* prefix = "/Resources/bin/";
  const char* suffix = "/bin";
#ifdef _WIN32 /* Win32 or Win64 */
  const char* binDir = "/win64";
  const char delimiter[2] = ";";
#elif __APPLE__
  const char* binDir = "/darwin64";
  const char delimiter[2] = ":";
#else
  const char* binDir = "/linux64";
  const char delimiter[2] = ":";
#endif

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Entered findSpawnExe.\n", bui->time, bui->modelicaNameBuilding);

  if (SEARCHPATH == NULL){
    /* SEARCHPATH is NULL. Try to find the executable in the Modelica Buildings Library installation. */
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: In findSpawnExe, trying to to use buildingsLibraryRoot to find spawn.\n", bui->time, bui->modelicaNameBuilding);

    /* Construct Spawn-light-{version}-{commit[0:10]} from spawn-{version}-{commit[0:10]} */

    mallocString(strlen(spawnExe) + 1 + extra_len_light, "Failed to allocate memory in findSpawnExe() for nameSpawnLight",
      &nameSpawnLight, SpawnFormatError);
    memset(nameSpawnLight, '\0', strlen(spawnExe) + 1 + extra_len_light);
    strcpy(nameSpawnLight, "Spawn-light-");
    /* Don't copy spawn-, but copy {version}-{commit[0:10]} from spawn-{version}-{commit[0:10]} */
    memcpy(&nameSpawnLight[strlen("Spawn-light-")], &spawnExe[strlen("spawn-")], strlen(spawnExe)-strlen("spawn-"));

    len = strlen(bui->buildingsLibraryRoot) + strlen(prefix) + strlen(nameSpawnLight) + strlen(binDir) + strlen(suffix) + 1;
    mallocString(len, "Failed to allocate memory in findSpawnExe() for pathToExe.",
      &pathToExe, SpawnFormatError);
    memset(pathToExe, '\0', len);
    strcpy(pathToExe, bui->buildingsLibraryRoot);
    strcat(pathToExe, prefix);
    strcat(pathToExe, nameSpawnLight);
    strcat(pathToExe, binDir);
    strcat(pathToExe, suffix);

    /* Recursively call this function, but now with SEARCHPATH set */
    spawnFullPath = findSpawnExe(bui, pathToExe, spawnExe);
    free(nameSpawnLight);
    if (spawnFullPath == NULL){
      /* Did not find it. */
      free(pathToExe);
      return NULL;
    }
    else{
      /* Found the executable */
      return spawnFullPath;
    }
  }
  /* ****************************************************************************************** */
  /* If we are here, then SEARCHPATH is not NULL. Split it into tokens, and invoke this function
     for each token.
     Code adapted from https://man7.org/linux/man-pages/man3/strtok_r.3.html */

  saveptr = NULL;
  /* If SEARCHPATH contains tokens, then parse them, else try the value of SEARCHPATH */
  /* Use delimiter[0] because delimiter[2] = ":" is a char pointer */
  if ( strchr(SEARCHPATH, delimiter[0]) != NULL){
    /* The string has at least one delimiter */
    /* strtok_r modifies the first argument. Hence, we make a copy of it. */
    len = strlen(SEARCHPATH) + 1;
    mallocString(len, "Failed to allocate memory in findSpawnExe() for searchPathCopy.",
      &searchPathCopy, SpawnFormatError);
    memset(searchPathCopy, '\0', len);
    strcpy(searchPathCopy, SEARCHPATH);

    for (str = searchPathCopy; ; str = NULL) {
#ifdef _WIN32 /* Win32 or Win64 */
      token = strtok_s(str, delimiter, &saveptr);
#else
      token = strtok_r(str, delimiter, &saveptr);
#endif
      if (token == NULL){
        /* All tokens have been parsed, but did not find the executable. */
          free(searchPathCopy);
          return NULL;
      }
      else{
        /* Found a token. Try to see if this is the right path */
        spawnFullPath = findSpawnExe(bui, token, spawnExe);
        if (spawnFullPath != NULL){
          /* Did find it. Return */
          free(searchPathCopy);
          return spawnFullPath;
        }
      }
    } /* end of for loop */
    free(searchPathCopy);
  }

  /* ****************************************************************************************** */
  /* Now, we know SEARCHPATH is a single token. Try to see if it contains spawnExe */
  spawnFullPath = returnSpawnExecutable(bui, SEARCHPATH, spawnExe);
  /* This is NULL if it is not the executable */
  return spawnFullPath;
}


void terminateIfSpacesInInstallation(FMUBuilding* bui){
  const char sep = '/';
  char* libBaseName;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;
  size_t lasPosInd;

  const char* ptr = strrchr(bui->buildingsLibraryRoot, sep);

  if (ptr == NULL){
      SpawnFormatError("Error. Expected separator '%c' in '%s'.", sep, bui->buildingsLibraryRoot);
  }

  /* Index of last position of the separator */
  lasPosInd = (size_t)(ptr - bui->buildingsLibraryRoot);

  mallocString(lasPosInd + 1, "Failed to allocate memory in terminateIfSpacesInInstallation().", &libBaseName, SpawnFormatError);
  /* Copy the path except for the last part of the path, which is Buildings or Buildings 8.0.0 */
  memcpy(libBaseName, bui->buildingsLibraryRoot, lasPosInd);
  libBaseName[lasPosInd] = '\0';


  if ( strchr(libBaseName, ' ') != NULL){
    SpawnFormatError("To use EnergyPlus, the Modelica Buildings Library must be installed in a directory that has no spaces. (The Buildings directory can however have spaces such as in 'Buildings 9.0.0'.) Installing in '%s' is not supported.",
      libBaseName);
  }
}

void generateFMU(FMUBuilding* bui, const char* spawnFullPath, const char* modelicaBuildingsJsonFile){
  /* Generate the FMU */
  char* optionFlags;
  char* outputFlag;
  char* createFlag;
  char* fulCmd;
  int retVal;
  size_t len;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Entered generateFMU with FMUPath = %s.\n",
      bui->time, bui->modelicaNameBuilding, bui->fmuAbsPat);

  if( access(modelicaBuildingsJsonFile, F_OK ) == -1 ) {
    SpawnFormatError("Requested to use json file '%s' which does not exist.", modelicaBuildingsJsonFile);
  }

  optionFlags = " energyplus create-fmu "; /* Flag for command */
  outputFlag = " --output-path ";          /* Flag for command */
  len = strlen("\"") + strlen(spawnFullPath) + strlen("\"") + strlen(optionFlags)
    + strlen(outputFlag) + strlen("\"") + strlen(bui->fmuAbsPat) + strlen("\" ")
    + strlen("\"") + strlen(modelicaBuildingsJsonFile) + strlen("\"")
    + 1;
#ifdef _WIN32 /* Win32 or Win64 */
  /* Windows needs double quotes in the system call, see https://stackoverflow.com/questions/2642551/windows-c-system-call-with-spaces-in-command */
  len = len + 2 * strlen("\"");
#endif

  mallocString(len, "Failed to allocate memory in generateFMU().", &fulCmd, SpawnFormatError);
  memset(fulCmd, '\0', len);

  /* Build version of string with leading and trailing quotes, which is needed to invoke the command if the directory has empty spaces. */
  strcpy(fulCmd, "\""); /* For Linux, add a quote to allow for spaces in directory, such as for Buildings 8.0.0 */
#ifdef _WIN32 /* Win32 or Win64, add leading quote */
  strcat(fulCmd, "\"");
#endif
  strcat(fulCmd, spawnFullPath);
  strcat(fulCmd, "\"");
  /* Continue building the command line */
  strcat(fulCmd, optionFlags);
  strcat(fulCmd, outputFlag);
  strcat(fulCmd, "\"");
  strcat(fulCmd, bui->fmuAbsPat);
  strcat(fulCmd, "\" ");
  strcat(fulCmd, "\"");
  strcat(fulCmd, modelicaBuildingsJsonFile);
  strcat(fulCmd, "\"");
#ifdef _WIN32 /* Win32 or Win64, add trailing quote */
  strcat(fulCmd, "\"");
#endif

  /* Generate the FMU */
  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Executing %s\n", bui->time, bui->modelicaNameBuilding, fulCmd);

  retVal = system(fulCmd);
  /* Check if generated FMU indeed exists */
  if( access( bui->fmuAbsPat, F_OK ) != 0 ) {
    SpawnFormatError("%.3f %s: Executing '%s' failed to generate fmu '%s'.", bui->time, bui->modelicaNameBuilding, fulCmd, bui->fmuAbsPat);
  }
  if (retVal != 0){
    SpawnFormatError("%.3f %s: Generating FMU returned value %d, but FMU exists.\n", bui->time, bui->modelicaNameBuilding, retVal);
  }
  free(fulCmd);
}


/* Set the categories to be logged.
   Note that EnergyPlus has the following levels:
      std::map<EnergyPlus::Error, fmi2Status> logLevelMap = {
        {EnergyPlus::Error::Info, fmi2OK},
        {EnergyPlus::Error::Warning, fmi2Warning},
        {EnergyPlus::Error::Severe, fmi2Error},
        {EnergyPlus::Error::Fatal, fmi2Fatal}
      };
   bui->logLevel is {ERRORS = 1, WARNINGS = 2, QUIET = 3, MEDIUM = 4, TIMESTEP = 5};
*/
void setFMUDebugLevel(FMUBuilding* bui){
  fmi2_string_t* categories;
  size_t i;
  fmi2Status status;

  /* Get the number of log categories defined in the XML */
  const size_t nCat = fmi2_import_get_log_categories_num(bui->fmu);
  /* Number of log categories needed from EnergyPlus. Note that Modelica has
     one more category for log at time step level */
  size_t nCatReq;
  if ((size_t)(bui->logLevel) <= nCat){
    nCatReq = (size_t)(bui->logLevel);
  }
  else{
    nCatReq = nCat;
  }
/*
  if (nCat != 4){
    bui->SpawnFormatError("FMU %s specified %u categories, but require 4 categories.",
      bui->fmuAbsPat, nCat, bui->logLevel);
  }
*/

  /* Get the log categories that we need */
  categories = NULL;
  categories = (fmi2_string_t*)malloc(nCatReq * sizeof(fmi2_string_t));
  if (categories == NULL){
    bui->SpawnFormatError("Failed to allocate memory for error categories for FMU %s", bui->fmuAbsPat);
  }
  /* Assign the categories as specified in modelDescription.xml */
  for(i=0; i < nCatReq; i++){
    categories[i] = fmi2_import_get_log_category(bui->fmu, i);
  }

  if (bui->logLevel >= MEDIUM)
    bui->SpawnFormatMessage("%.3f %s: Setting debug logging.\n", bui->time, bui->modelicaNameBuilding);
  status = fmi2_import_set_debug_logging(
    bui->fmu,
    fmi2_true,        /* Logging on */
    (size_t)nCatReq, /* nCategories */
    categories);        /* Which categories to log */
  if( status != (fmi2Status)fmi2_status_ok ){
    bui->SpawnMessage("Log categories:");
    for(i = 0; i < nCatReq; i++){
      bui->SpawnFormatMessage("  Category[%u] = '%s'\n", i, categories[i]);
    }
    bui->SpawnFormatError("fmi2SetDebugLogging returned '%s' for FMU with name %s. Verbosity = %u", fmi2_status_to_string(status), bui->fmuAbsPat, bui->logLevel);
  }
  /* Free storage */
  /* This gives Warning C4090 in Microsoft compiler
  free(categories);
  */
}

void spawnLogger(
  fmi2_component_environment_t env,
  fmi2_string_t instanceName,
  fmi2_status_t status,
  fmi2_string_t category,
  fmi2_string_t message, ...)
{
  /* EnergyPlus has for category always "EnergyPlus message", so we don't report this here */
  int len;
  const char* signature = "%.3f %s: %s from EnergyPlus: %s\n";
  char msg[SPAWN_LOGGER_BUFFER_LENGTH];

  FMUBuilding* bui = (FMUBuilding*)env;

  va_list argp;
  va_start(argp, message);

  len = vsnprintf(msg, SPAWN_LOGGER_BUFFER_LENGTH, message, argp);
  if (len < 0)
    bui->SpawnFormatError("Failed to parse message '%s' from EnergyPlus.", message);

  if (status == fmi2_status_ok || status == fmi2_status_pending || status == fmi2_status_discard){
    if (bui->logLevel >= QUIET)
      bui->SpawnFormatMessage(signature, bui->time, instanceName, "Info", msg);
  }
  else if (status == fmi2_status_warning){
    if (bui->logLevel >= WARNINGS)
      bui->SpawnFormatMessage(signature, bui->time, instanceName, fmi2_status_to_string(status), msg);
  }
  else{
    /* This captures fmi2_status_error and fmi2_status_fatal.
       They are written for any logLevel. */
    bui->SpawnFormatMessage(signature, bui->time, instanceName, fmi2_status_to_string(status), msg);
  }

  va_end(argp);
}

/* Import the EnergyPlus FMU
*/
void importSpawnFMU(FMUBuilding* bui){
  const fmi2Boolean visible = fmi2False;

  /* fmi2_import_model_counts_t  mc; */
  fmi2_callback_functions_t callBackFunctions;
  jm_callbacks* callbacks;
  fmi_version_enu_t version;
  fmi2_fmu_kind_enu_t fmukind;
  jm_status_enu_t jm_status;

  const char* tmpPath = bui->tmpDir;
  const char* FMUPath = bui->fmuAbsPat;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  /* Set callback functions */
  callbacks = jm_get_default_callbacks();
  /* Set the log level for the fmi-library */
  callbacks->log_level = (bui->logLevel >= TIMESTEP) ? jm_log_level_debug : jm_log_level_warning;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Calling fmi_import_allocate_context(callbacks = %p)\n", bui->time, bui->modelicaNameBuilding, callbacks);
  bui->context = fmi_import_allocate_context(callbacks);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Getting fmi version, FMUPath = %s, tmpPath = %s.\n",
      bui->time, bui->modelicaNameBuilding, FMUPath, tmpPath);
  version = fmi_import_get_fmi_version(bui->context, FMUPath, tmpPath);

  if (version != fmi_version_2_0_enu){
    SpawnFormatError("Wrong FMU version for %s, require FMI 2.0 for Model Exchange, received %s.",
    FMUPath, fmi_version_to_string(version));
  }

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Parsing xml file %s\n", bui->time, bui->modelicaNameBuilding, tmpPath);
  bui->fmu = fmi2_import_parse_xml(bui->context, tmpPath, 0);
	if(!bui->fmu) {
		SpawnFormatError("Error parsing XML for %s.", FMUPath);
	}

	/* modelName = fmi2_import_get_model_name(bui->fmu); */
	bui->GUID = fmi2_import_get_GUID(bui->fmu);

  fmukind = fmi2_import_get_fmu_kind(bui->fmu);
  if(fmukind != fmi2_fmu_kind_me){
    SpawnFormatError("Unxepected FMU kind for %s, require ME.", FMUPath);
  }

  /* Get model statistics
  fmi2_import_collect_model_counts(bui->fmu, &mc);
  printf("*** Number of discrete variables %lu.\n", mc.num_discrete);
 */
  callBackFunctions.logger = spawnLogger;
  callBackFunctions.allocateMemory = calloc;
  callBackFunctions.freeMemory = free;
  callBackFunctions.stepFinished = NULL; /* synchronous execution */
  callBackFunctions.componentEnvironment = bui;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Loading dllfmu.\n", bui->time, bui->modelicaNameBuilding);

  jm_status = fmi2_import_create_dllfmu(bui->fmu, fmukind, &callBackFunctions);
  if (jm_status == jm_status_error) {
  	SpawnFormatError("Could not create the DLL loading mechanism (C-API) for %s.", FMUPath);
  }
  else{
    bui->dllfmu_created = fmi2_true;
  }

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Instantiating fmu.\n", bui->time, bui->modelicaNameBuilding);

  /* Instantiate EnergyPlus */
  jm_status = fmi2_import_instantiate(
    bui->fmu,
    bui->modelicaNameBuilding,
    fmi2_model_exchange,
    NULL,
    visible);

  /* SpawnFormatError("%s", "***** This line is never reached on Windows.\n"); */

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Returned from instantiating fmu.\n", bui->time, bui->modelicaNameBuilding);
  if(jm_status == jm_status_error){
    SpawnFormatError("Failed to instantiate building FMU with name %s.",  bui->modelicaNameBuilding);
  }
  /* Set the FMU mode to instantiationMode */
  setFMUMode(bui, instantiationMode);

  /* Set the debug level in the FMU */
  setFMUDebugLevel(bui);

}

void setReusableFMU(FMUBuilding* bui){
  size_t iBui;
  FMUBuilding* ptrBui;

  for(iBui = 0; iBui < getBuildings_nFMU(); iBui++){
    ptrBui = (FMUBuilding*)(getBuildingsFMU(iBui));
    if ((iBui != bui->iFMU) && (ptrBui->modelHash != NULL)){
      if (strcmp(bui->modelHash, ptrBui->modelHash) == 0 ){
        /* Check if the FMU indeed was generated */
        if( access( ptrBui->fmuAbsPat, F_OK ) != -1 ) {
          /* We can use the same FMU as will be used for building iBui */
          bui->usePrecompiledFMU = true;
          bui->precompiledFMUAbsPat = ptrBui->fmuAbsPat;
        }
      }
    }
  }
}

void copyBinaryFile(
  const char* src,
  const char* des,
  void (*SpawnFormatError)(const char *string, ...)){

    FILE* srcFil;
    FILE* desFil;
    size_t n, m;
    unsigned char buff[8192];

    srcFil = fopen(src, "rb");

    if( srcFil == NULL )
    {
        SpawnFormatError("Failed to open %s, %s.", src, strerror(errno));
     }

    desFil = fopen(des, "wb");

    if( desFil == NULL )
    {
      fclose(srcFil);
      SpawnFormatError("Failed to open %s, %s.", des, strerror(errno));
    }

    do {
        n = fread(buff, 1, sizeof buff, srcFil);
        if (n)
          m = fwrite(buff, 1, n, desFil);
        else
          m = 0;
    } while ((n > 0) && (n == m));
    if (m)
      SpawnFormatError("Error during copying %s to %s.", src, des);

    if ( fclose(srcFil) != 0 )
      SpawnFormatError("Failed to close %s, %s.", src, strerror(errno));
    if ( fclose(desFil) != 0 )
      SpawnFormatError("Failed to close %s, %s.", des, strerror(errno));
  }


void generateAndInstantiateBuilding(FMUBuilding* bui){
  /* This is the first call for this idf file.
     Allocate memory and load the fmu.
  */
  char* modelicaBuildingsJsonFile;
  char* spawnFullPath;
  char* env;

  void (*SpawnFormatMessage)(const char *string, ...) = bui->SpawnFormatMessage;
  void (*SpawnFormatError)(const char *string, ...) = bui->SpawnFormatError;

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: Entered generateAndInstantiateBuilding.\n",
      bui->time, bui->modelicaNameBuilding);

  if (bui->usePrecompiledFMU)
    SpawnFormatMessage("%.3f %s: Using pre-compiled FMU %s\n",
      bui->time, bui->modelicaNameBuilding, bui->precompiledFMUAbsPat);

  /* Write the model structure to the FMU Resources folder so that EnergyPlus can
     read it and set up the data structure.
  */
  writeModelStructureForEnergyPlus(bui, &modelicaBuildingsJsonFile, &(bui->modelHash));

  setReusableFMU(bui);

  if ( deleteFile(bui->fmuAbsPat) != 0 )
    SpawnFormatError("Failed to remove old FMU '%s': '%s'.", bui->fmuAbsPat, strerror(errno));

  if (bui->usePrecompiledFMU){
    if (bui->logLevel >= MEDIUM)
      SpawnFormatMessage("%.3f %s: Copying FMU %s to %s as buildings are identical.\n",
        bui->time, bui->modelicaNameBuilding, bui->precompiledFMUAbsPat, bui->fmuAbsPat);
    copyBinaryFile(bui->precompiledFMUAbsPat, bui->fmuAbsPat, SpawnFormatError);
  }
  else{
    /* Find where the spawn executable is located, and return it in spawnFullPath.
       If not found, then spawnFullPath == NULL.

      Search in this order:
      1. Check for Buildings[ x.y.z]/Resources/bin/spawn-[linux64,win64]/bin/spawn-0.2.0-a23bb23[.exe]
         where Buildings[ x.y.z] is the installation folder of the Modelica Buildings Library.
      2. Check on the environment variable SPAWNPATH for spawn-0.2.0-a23bb23[.exe].
      3. Check on the environment variable PATH for spawn-0.2.0-a23bb23[.exe].

    */
    spawnFullPath = findSpawnExe(bui, NULL, bui->spawnExe);
    if (spawnFullPath == NULL){
      env = getenv("SPAWNPATH");
      if (env != NULL)
        spawnFullPath = findSpawnExe(bui, env, bui->spawnExe);
    }
    if (spawnFullPath == NULL){
      env = getenv("PATH");
      if (env != NULL)
        spawnFullPath = findSpawnExe(bui, env, bui->spawnExe);
    }
    if (spawnFullPath == NULL){
      SpawnFormatError("Failed to find spawn executable in Buildings Library installation, on SPAWNPATH and on PATH. See installation instructions at Buildings.ThermalZones.EnergyPlus_%s.UsersGuide.Installation", bui->idfVersion);
    }
    terminateIfSpacesInInstallation(bui);
    /* Generate FMU using spawnFullPath */
    generateFMU(bui, spawnFullPath, modelicaBuildingsJsonFile);
    free(spawnFullPath);
  }

  free(modelicaBuildingsJsonFile);

  if( access( bui->fmuAbsPat, F_OK ) == -1 ) {
    SpawnFormatError("Requested to load fmu '%s' which does not exist.", bui->fmuAbsPat);
  }

  importSpawnFMU(bui);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: FMU is at %p.\n",
      bui->time, bui->modelicaNameBuilding, bui->fmu);

  /* Set the value references for all parameters, inputs and outputs */
  setValueReferences(bui);

  if (bui->logLevel >= MEDIUM)
    SpawnFormatMessage("%.3f %s: FMU returns from generateAndInstantiateBuilding.\n",
      bui->time, bui->modelicaNameBuilding);

  return;
}
#endif
