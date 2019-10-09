/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_EnergyPlusUtil_h
#define Buildings_EnergyPlusUtil_h

#include "EnergyPlusUtil.h"

#include <stdio.h>
#include <unistd.h>

#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

static char* MOD_BUI_JSON = "ModelicaBuildingsEnergyPlus.json";

#ifdef _WIN32
static char* SEPARATOR = "\\";
#else
static char* SEPARATOR = "/";
#endif


typedef enum {instantiationMode, initializationMode, eventMode, continuousTimeMode} FMUMode;

static int FMU_EP_VERBOSITY = 1; /* Verbosity */
enum verbosity {QUIET = 4, MEDIUM = 5, TIMESTEP = 6};

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

void mallocString(size_t nChar, const char *error_message, char** str);

void setVariables(FMUBuilding* bui, const char* modelicaInstanceName, fmi2ValueReference vr[],  fmi2Real values[], size_t n);

void getVariables(FMUBuilding* bui, const char* modelicaInstanceName, fmi2ValueReference vr[], fmi2Real values[], size_t n);

double do_event_iteration(FMUBuilding* bui, const char* modelicaInstanceName);

void fmilogger(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message);

void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen);

void saveAppendJSONElements(char* *buffer, const char* values[], size_t n, size_t* bufLen);

void checkAndSetVerbosity(const int verbosity);

void setFMUMode(FMUBuilding* bui, FMUMode mode);

void getSimulationFMUName(const char* modelicaNameBuilding, const char* tmpDir, char** fmuAbsPat);

char* getFileNameWithoutExtension(const char* idfName);

void getSimulationTemporaryDirectory(const char* modelicaNameBuilding, char** dirNam);

void buildVariableNames(
  const char* firstPart,
  const char** secondParts,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFullNames);

void getSimulationTemporaryDirectory(const char* idfName, char** dirNam);

#endif
