/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_EnergyPlusUtil_h
#define Buildings_EnergyPlusUtil_h

#include "EnergyPlusTypes.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#include <unistd.h>
#include <execinfo.h>
#include <sys/types.h> /* To create directory */
#include <sys/stat.h>  /* To create directory */
#include <unistd.h>    /* To use stat to check for directory */
#include <errno.h>

#include "fmilib.h"
#include "FMI2/fmi2FunctionTypes.h"

void writeFormatLog(unsigned int level, const char *fmt, ...);

void writeLog(unsigned int level, const char* msg);

void logStringArray(unsigned int level,
                    const char* msg,
                    const char** array,
                    size_t n);

void logValueReferenceArray(unsigned int level,
                            const char* msg,
                            const fmi2ValueReference* array,
                            size_t n);

void mallocSpawnReals(const size_t n, spawnReals** r);

void mallocString(size_t nChar, const char *error_message, char** str);

void setVariables(FMUBuilding* bui, const char* modelicaInstanceName, const spawnReals* ptrReals);

void getVariables(FMUBuilding* bui, const char* modelicaInstanceName, spawnReals* ptrReals);

double do_event_iteration(FMUBuilding* bui, const char* modelicaInstanceName);

void fmilogger(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message);

void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen);

void saveAppendJSONElements(char* *buffer, const char* values[], size_t n, size_t* bufLen);

void checkAndSetVerbosity(const int verbosity);

void setFMUMode(FMUBuilding* bui, FMUMode mode);

void getSimulationFMUName(const char* modelicaNameBuilding, const char* tmpDir, char** fmuAbsPat);

char* getFileNameWithoutExtension(const char* idfName);

void getSimulationTemporaryDirectory(const char* modelicaNameBuilding, char** dirNam);

void buildVariableName(
  const char* firstPart,
  const char* secondPart,
  char* *ptrFullName);

void buildVariableNames(
  const char* firstPart,
  const char** secondParts,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFullNames);
void getSimulationTemporaryDirectory(const char* idfName, char** dirNam);

void loadFMU_setupExperiment_enterInitializationMode(FMUBuilding* bui, double startTime);

void advanceTime_completeIntegratorStep_enterEventMode(FMUBuilding* bui, const char* modelicaInstanceName, double time);

#endif
