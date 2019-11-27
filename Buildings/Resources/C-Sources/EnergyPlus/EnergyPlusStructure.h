/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_EnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_EnergyPlusStructure_h

#include <stdlib.h>
#include <stddef.h>  /* stddef defines size_t */
#include <string.h>
#include <stdio.h>
#include <execinfo.h>
#include <sys/types.h> /* To create directory */
#include <sys/stat.h>  /* To create directory */
#include <unistd.h>    /* To use stat to check for directory */
#include <errno.h>
#include <stdbool.h>

#include "fmilib.h"
#include "FMI2/fmi2FunctionTypes.h"
#include <ModelicaUtilities.h>

/* Use windows.h only for Windows */
#ifdef _WIN32
#include <windows.h>
#define WINDOWS 1
#else
#define WINDOWS 0
#define HANDLE void *
/* See http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html */
#define _GNU_SOURCE
#include <dlfcn.h>
#endif

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
enum verbosity {QUIET = 1, MEDIUM = 2, TIMESTEP = 3};

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

typedef struct FMUBuilding
{
  fmi2_import_t* fmu;
  fmi_import_context_t* context;
  const char* GUID;
  char* buildingsLibraryRoot; /* Root directory of Buildings library */
  fmi2Byte* name; /* if usePrecompiledFMU == true, the user-specified fmu name, else the idf name */
  fmi2Byte* weather;
  fmi2Byte* idd;
  fmi2Integer nZon; /* Number of zones that use this FMU */
  fmi2Byte** zoneNames; /* Names of zones in this FMU */
  void** zones; /* Pointers to all zones*/
  char* tmpDir; /* Temporary directory used by EnergyPlus */
  char* fmuAbsPat; /* Absolute name of the fmu */
  bool usePrecompiledFMU; /* if true, a pre-compiled FMU will be used (for debugging) */
  char* precompiledFMUAbsPat; /* Name of pre-compiled FMU (if usePrecompiledFMU = true, otherwise set the NULL) */
  fmi2Boolean dllfmu_created; /* Flag to indicate if dll fmu functions were successfully created */
  fmi2Real time; /* Time that is set in the building fmu */
  FMUMode mode; /* Mode that the FMU is in */
} FMUBuilding;

/*#define ZONE_N_PAR_INP 1 Number of parameter value references to be set in EnergyPlus per zone*/
#define ZONE_N_PAR_OUT 3 /* Number of parameter value references to be read from EnergyPlus per zone*/
#define ZONE_N_INP 5 /* Number of input value references per zone*/
#define ZONE_N_OUT 4 /* Number of output value references per zone*/

typedef struct FMUZone
{
  /*int index;*/
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  char* name;      /* Name of this zone */
  char* modelicaInstanceName; /* Name of the Modelica instance of this zone */

/* char** parInpNames; */
  char** parOutNames;
  char** inpNames;
  char** outNames;

  /* fmi2ValueReference* parInpValReferences; Value reference of parameter variables*/
  fmi2ValueReference* parOutValReferences; /* Value reference of parameter variables*/
  fmi2ValueReference* inpValReferences; /* Value reference of input variables*/
  fmi2ValueReference* outValReferences; /* Value references of output variables*/

  fmi2Byte** parInpVarNames; /* Full names of parameter variables (used to get value reference) */
  fmi2Byte** parOutVarNames; /* Full names of parameter variables (used to get value reference) */
  fmi2Byte** inpVarNames; /* Full names of input variables (used to get value reference)*/
  fmi2Byte** outVarNames; /* Full names of output variables (used to get value reference)*/

  fmi2Boolean isInstantiated; /* Flag set to true when the zone has been completely instantiated */
  fmi2Boolean isInitialized; /* Flag set to true after the zone has executed all get/set calls in the initializion mode
                                of the FMU */
} FMUZone;

void fmilogger(jm_callbacks* c, jm_string module, jm_log_level_enu_t log_level, jm_string message);

void saveAppend(char* *buffer, const char *toAdd, size_t *bufLen);

void saveAppendJSONElements(char* *buffer, const char* values[], size_t n, size_t* bufLen);

void setFMUMode(FMUBuilding* bui, FMUMode mode);

void getSimulationFMUName(const char* idfName, const char* tmpDir, char** fmuAbsPat);

char* getFileNameWithoutExtension(const char* idfName);

void getSimulationTemporaryDirectory(const char* idfName, char** dirNam);

void incrementBuildings_nFMU();
void decrementBuildings_nFMU();
unsigned int getBuildings_nFMU();

void buildVariableNames(
  const char* zoneName,
  const char** variableNames,
  const size_t nVar,
  char** *ptrVarNames,
  char** *ptrFullNames);

size_t ZoneAllocateBuildingDataStructure(
  const char* idfName, const char* weaName,
  const char* iddName,
  const char* zoneName, FMUZone* zone,
  int usePrecompiledFMU,
  const char* fmuName,
  const char* buildingsLibraryRoot);

FMUBuilding* getBuildingsFMU(size_t iFMU);
void getSimulationTemporaryDirectory(const char* idfName, char** dirNam);

#endif
