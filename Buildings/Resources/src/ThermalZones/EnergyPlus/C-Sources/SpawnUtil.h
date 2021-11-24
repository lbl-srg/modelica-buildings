/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_SpawnUtil_h
#define Buildings_SpawnUtil_h

#include "SpawnTypes.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#ifdef _MSC_VER
#include <direct.h> /* Provides _getcwd() */
#include <windows.h>
#define R_OK 4
#define W_OK 2
#define X_OK 1
#define F_OK 0
#else
#include <unistd.h>
#include <execinfo.h>
#endif

#ifdef __linux__
#include <execinfo.h>
#endif

#include <sys/types.h> /* To create directory */
#include <sys/stat.h>  /* To create directory */
/* #include <unistd.h> */   /* To use stat to check for directory */
#include <errno.h>
#include <math.h> /* For isnan */

#include "fmilib.h"
#include "FMI2/fmi2FunctionTypes.h"

#define SPAWN_LOGGER_BUFFER_LENGTH 1000

void mallocSpawnReals(const size_t n, spawnReals** r, void (*SpawnFormatError)(const char *string, ...));
void mallocSpawnDerivatives(const size_t n, spawnDerivatives** r, void (*SpawnFormatError)(const char *string, ...));


void mallocString(
  size_t nChar,
  const char *error_message, char** str,
  void (*SpawnFormatError)(const char *string, ...));

char* fmuModeToString(FMUMode mode);

void setVariables(
  FMUBuilding* bui,
  const char* modelicaInstanceName,
  const spawnReals* ptrReals);

void getVariables(FMUBuilding* bui, const char* modelicaInstanceName, spawnReals* ptrReals);

double do_event_iteration(FMUBuilding* bui, const char* modelicaInstanceName);

void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen, void (*SpawnFormatError)(const char *string, ...));

void saveAppendJSONElements(
  char* *buffer,
  const char* values[],
  size_t n,
  size_t* bufLen,
  void (*SpawnFormatError)(const char *string, ...));

void checkAndSetVerbosity(FMUBuilding* bui, const int logLevel);

void setFMUMode(FMUBuilding* bui, FMUMode mode);

void setSimulationFMUName(FMUBuilding* bui, const char* modelicaNameBuilding);

char* getFileNameWithoutExtension(const char* idfName, void (*SpawnFormatError)(const char *string, ...));

void getSimulationTemporaryDirectory(
  const char* modelicaNameBuilding,
  char** dirNam,
  void (*SpawnFormatError)(const char *string, ...));

void createDirectory(const char* dirName, void (*SpawnFormatError)(const char *string, ...));

void buildVariableNames(
  const char* firstPart,
  const char** secondParts,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFMINames,
  void (*SpawnFormatError)(const char *string, ...));

void loadFMU_setupExperiment_enterInitializationMode(FMUBuilding* bui, double startTime);

void advanceTime_completeIntegratorStep_enterEventMode(FMUBuilding* bui, const char* modelicaInstanceName, double time);

#endif
