/*
 * Type definitions for EnergyPlus.
 */

#ifndef Buildings_EnergyPlusTypes_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_EnergyPlusTypes_h

#include <stdbool.h>
#include <stdio.h>

#include "fmilib.h"
#include "FMI2/fmi2FunctionTypes.h"

#ifndef _WIN32
#include <errno.h>
extern int errno;
#endif

#ifdef _WIN32
#include <windows.h>
#include <io.h>
#define WINDOWS 1
#else
#define WINDOWS 0
#define HANDLE void *
/* See http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html */

#ifndef  _GNU_SOURCE
#define _GNU_SOURCE
#endif

#include <dlfcn.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif
#ifdef _MSC_VER
#ifdef EXTERNAL_FUNCTION_EXPORT
# define LBNL_EnergyPlus_EXPORT __declspec( dllexport )
#else
# define LBNL_EnergyPlus_EXPORT __declspec( dllimport )
#endif
#elif __GNUC__ >= 4
/* In gnuc, all symbols are by default exported. It is still often useful,
to not export all symbols but only the needed ones */
# define LBNL_EnergyPlus_EXPORT __attribute__ ((visibility("default")))
#else
# define LBNL_EnergyPlus_EXPORT
#endif

#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

static char* MOD_BUI_JSON = "ModelicaBuildingsEnergyPlus.json";

#ifdef _WIN32 /* Win32 or Win64 */
#define access(a, b) (_access_s(a, b))
#endif
static char* SEPARATOR = "/";

typedef enum {instantiationMode, initializationMode, eventMode, continuousTimeMode} FMUMode;

enum logLevels {ERRORS = 1, WARNINGS = 2, QUIET = 3, MEDIUM = 4, TIMESTEP = 5};

typedef struct FMUBuilding
{
  fmi2_import_t* fmu;
  fmi_import_context_t* context;
  const char* GUID;
  char* buildingsLibraryRoot; /* Root directory of Buildings library */
  char* modelicaNameBuilding; /* Name of the Modelica instance of this zone */
  fmi2Byte* idfName; /* if usePrecompiledFMU == true, the user-specified fmu name, else the idf name */
  fmi2Byte* weather;
  size_t nZon; /* Number of zones that use this FMU */
  void** zones; /* Pointers to all zones*/

  size_t nInputVariables; /* Number of input variables that this FMU has */
  void** inputVariables; /* Pointers to all input variables */

  size_t nOutputVariables; /* Number of output variables that this FMU has */
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

  int logLevel; /* Log level */
  void (*SpawnMessage)(const char *string);
  void (*SpawnError)(const char *string);
  void (*SpawnFormatMessage)(const char *string, ...);
  void (*SpawnFormatError)(const char *string, ...);

} FMUBuilding;


typedef struct spawnReals{
  size_t n; /* Number of values */
  fmi2Real* valsEP; /* Values as used by EnergyPlus */
  fmi2Real* valsSI; /* vals in SI units as used by Modelica */
  fmi2_import_unit_t** units; /* Unit type, or NULL if not specified */
  fmi2ValueReference* valRefs; /* Value references */
  fmi2Byte** fmiNames; /* Full names, as listed in modelDescripton.xml file */
} spawnReals;


typedef struct FMUZone
{
  FMUBuilding* bui; /* Pointer to building with this zone */
  char* modelicaNameThermalZone; /* Name of the Modelica instance of this zone */
  char* name;      /* Name of this zone in the idf file */

  char** parOutNames;
  char** inpNames;
  char** outNames;

  spawnReals* parameters; /* Parameters */
  spawnReals* inputs;     /* Inputs */
  spawnReals* outputs;    /* Outputs */

  fmi2Boolean isInstantiated; /* Flag set to true when the zone has been completely instantiated */
  fmi2Boolean isInitialized;  /* Flag set to true after the zone has executed all get/set calls in the initializion mode
                                of the FMU */
} FMUZone;


typedef struct FMUInputVariable
{
  FMUBuilding* bui;              /* Pointer to building with this input variable */
  char* modelicaNameInputVariable; /* Name of the Modelica instance of this zone */
  char* name;                       /* Name of this schedule or EMS actuator in the idf file */
  char* componentType;              /* Component type in the idf file if actuator, else void pointer */
  char* controlType;                /* Control type in the idf file if actuator, else void pointer */
  char* unit;                       /* Unit specified in the Modelica model */
  bool valueReferenceIsSet;         /* Flag, set to true after value references are set,
                                       and used to check for Dymola 2020x whether the flag 'Hidden.AvoidDoubleComputation=true' is set */
  spawnReals* inputs;               /* Outputs (vector with 1 element) */

  fmi2Boolean isInstantiated;       /* Flag set to true when the input variable has been completely instantiated */
  fmi2Boolean isInitialized;        /* Flag set to true after the input variable has executed a get call in the initializion mode
                                       of the FMU */
} FMUInputVariable;

typedef struct FMUOutputVariable
{
  FMUBuilding* bui;              /* Pointer to building with this output variable */
  char* modelicaNameOutputVariable; /* Name of the Modelica instance of this zone */
  char* name;                       /* Name of this output variable in the idf file */
  char* key;                        /* Key of this output variable in the idf file */

  bool valueReferenceIsSet;         /* Flag, set to true after value references are set,
                                       and used to check for Dymola 2020x whether the flag 'Hidden.AvoidDoubleComputation=true' is set */
  spawnReals* outputs;              /* Outputs (vector with 1 element) */

  bool printUnit;                   /* Flag whether unit diagnostics should be printed */

  fmi2Boolean isInstantiated;       /* Flag set to true when the output variable has been completely instantiated */
  fmi2Boolean isInitialized;        /* Flag set to true after the output variable has executed a get call in the initializion mode
                                       of the FMU */
  size_t count;                     /* Counter for how many Modelica instances use this output variable */
} FMUOutputVariable;

#endif
