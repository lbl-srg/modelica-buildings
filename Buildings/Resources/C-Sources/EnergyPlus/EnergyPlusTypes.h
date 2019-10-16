/*
 * Type definitions for EnergyPlus.
 */

#ifndef Buildings_EnergyPlusTypes_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_EnergyPlusTypes_h

#include <stdbool.h>

#include "fmilib.h"
#include "FMI2/fmi2FunctionTypes.h"

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
enum verbosity {QUIET = 4, MEDIUM = 5, TIMESTEP = 6};

typedef struct FMUBuilding
{
  fmi2_import_t* fmu;
  fmi_import_context_t* context;
  const char* GUID;
  char* buildingsLibraryRoot; /* Root directory of Buildings library */
  char* modelicaNameBuilding; /* Name of the Modelica instance of this zone */
  fmi2Byte* idfName; /* if usePrecompiledFMU == true, the user-specified fmu name, else the idf name */
  fmi2Byte* weather;
  fmi2Byte* idd;
  fmi2Integer nZon; /* Number of zones that use this FMU */
  void** zones; /* Pointers to all zones*/

  fmi2Integer nOutputVariables; /* Number of output variables that this FMU has */
  void** outputVariables; /* Pointers to all output variables */

  char* tmpDir; /* Temporary directory used by EnergyPlus */
  char* fmuAbsPat; /* Absolute name of the fmu */
  bool usePrecompiledFMU; /* if true, a pre-compiled FMU will be used (for debugging) */
  char* precompiledFMUAbsPat; /* Name of pre-compiled FMU (if usePrecompiledFMU = true, otherwise set the NULL) */
  char* modelHash; /* Hash code of the model definition used to create the FMU (except the FMU path) */
  fmi2Boolean dllfmu_created; /* Flag to indicate if dll fmu functions were successfully created */
  fmi2Real time; /* Time that is set in the building fmu */
  FMUMode mode; /* Mode that the FMU is in */
  size_t iFMU; /* Number of this FMU */
} FMUBuilding;

/*#define ZONE_N_PAR_INP 1 Number of parameter value references to be set in EnergyPlus per zone*/
#define ZONE_N_PAR_OUT 3 /* Number of parameter value references to be read from EnergyPlus per zone*/
#define ZONE_N_INP 5 /* Number of input value references per zone*/
#define ZONE_N_OUT 4 /* Number of output value references per zone*/

typedef struct FMUZone
{
  /*int index;*/
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  char* modelicaNameThermalZone; /* Name of the Modelica instance of this zone */
  char* name;      /* Name of this zone in the idf file */

/* char** parInpNames; */
  char** parOutNames;
  char** inpNames;
  char** outNames;

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


typedef struct FMUOutputVariable
{
  /*int index;*/
  FMUBuilding* ptrBui; /* Pointer to building with this output variable */
  char* modelicaNameOutputVariable; /* Name of the Modelica instance of this zone */
  char* name;      /* Name of this output variable in the idf file */
  char* key;       /* Key of this output variable in the idf file */

  fmi2ValueReference* outValReferences; /* Value references of output variables*/

  fmi2Byte* outVarName; /* Full name of output variable (used to get value reference). */

  fmi2Boolean isInstantiated; /* Flag set to true when the output variable has been completely instantiated */
  fmi2Boolean isInitialized; /* Flag set to true after the output variable has executed a get call in the initializion mode
                                of the FMU */
} FMUOutputVariable;

#endif
