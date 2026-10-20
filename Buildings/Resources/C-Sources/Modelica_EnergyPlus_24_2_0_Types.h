/*
 * Type definitions for EnergyPlus used by the Modelica wrapper functions
 * and by the Spawn library (via SpawnTypes.h).
 */

#ifndef Modelica_EnergyPlus_24_2_0_Types_h
#define Modelica_EnergyPlus_24_2_0_Types_h

#include <stdbool.h>
#include <stddef.h>

#include "EnergyPlus_24_2_0_definitions.h"

/* FMI2 basic types per the FMI 2.0 standard (fmi2TypesPlatform.h).
   When fmilib is available (e.g. via SpawnTypes.h), these are already
   defined and the block is skipped. */
#ifndef fmi2TypesPlatform_h
typedef double          fmi2Real;
typedef char            fmi2Byte;
typedef int             fmi2Boolean;
typedef unsigned int    fmi2ValueReference;
#endif

/* FMI Library opaque types (forward declarations for standalone use).
   When fmilib is available, the full definitions are already provided
   and these blocks are skipped. */
#ifndef FMI_IMPORT_CONTEXT_H_
typedef struct fmi_xml_context_t fmi_import_context_t;
typedef struct fmi2_import_t fmi2_import_t;
#endif

#ifndef FMI2_IMPORT_UNIT_H_
typedef struct fmi2_xml_unit_t fmi2_import_unit_t;
#endif

typedef enum {instantiationMode, initializationMode, eventMode, continuousTimeMode, terminatedMode} FMUMode;

enum logLevels {ERRORS = 1, WARNINGS = 2, QUIET = 3, MEDIUM = 4, TIMESTEP = 5};
enum objectTypes {THERMALZONE = 1, SCHEDULE = 2, ACTUATOR = 3, OUTPUT = 4, SURFACE = 5, DETAILEDSURFACE = 6};

typedef struct FMUBuilding
{
  fmi2_import_t* fmu;
  fmi_import_context_t* context;
  const char* GUID;
  char* buildingsLibraryRoot; /* Root directory of Buildings library */
  char* modelicaNameBuilding; /* Name of the Modelica instance of this zone */
  char* spawnExe;   /* Name of the spawn executable without extension, such as spawn-0.2.0-d7f1e095f3 */
  char* idfVersion; /* IDF version with underscores, such as 24_2_0. This must be the same as is used as suffix for Buildings.ThermalZones.EnergyPlus_ */
  fmi2Byte* idfName; /* if usePrecompiledFMU == true, the user-specified fmu name, else the idf name */
  fmi2Byte* weather;
  runPeriod* runPer; /* EnergyPlus RunPeriod */
  double relativeSurfaceTolerance; /* Relative surface tolerance for heat balance calculations */
  size_t nExcObj; /* Number of exc that use this FMU */
  void** exchange; /* Pointers to all exchange objects*/

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
  char** unitsModelica;        /* Unit specified in the Modelica model */
  fmi2ValueReference* valRefs; /* Value references */
  fmi2Byte** fmiNames; /* Full names, as listed in modelDescripton.xml file */
} spawnReals;

typedef struct spawnDerivatives{
  size_t n;        /* Number of derivatives */
  /* Note that structure below uses a 0-based index (as we use it in C) rather than the 1-based
     index that Modelica uses when initializing the C structure */
  size_t** structure; /* 2-d array with list of derivatives (0-based index, [i,j] means dy_i/du_j */
  fmi2Real* delta; /* Step used to compute the derivatives */
  fmi2Real* vals;  /* Values of the derivatives */
} spawnDerivatives;


typedef struct SpawnObject
{
  int objectType; /* Type of the EnergyPlus object */
  FMUBuilding* bui; /* Pointer to building with this zone */
  char* modelicaName; /* Name of the Modelica instance of this zone */
  char* epName; /* Name of the EnergyPlus instance in the idf file */
  char* hvacZone;     /* Name of the HVAC zone that this room belongs to. For other objects, this will be "n/a". */
  char* jsonName;        /* Name of the json keyword */
  char* jsonKeysValues;  /* Keys and values string to be written to the json configuration file */
  char** parOutNames;
  char** inpNames;
  char** outNames;

  spawnReals* parameters;        /* Parameters */
  spawnReals* inputs;            /* Inputs */
  spawnReals* outputs;           /* Outputs */
  spawnDerivatives* derivatives; /* Derivatives */

  bool printUnit;                   /* Flag whether unit diagnostics should be printed (used for OutputVariable) */
  fmi2Boolean unitPrinted;                 /* Flag, false at start and set to true after units are printed (used for OutputVariable) */

  fmi2Boolean isInstantiated; /* Flag set to true when the zone has been completely instantiated */
  fmi2Boolean isInitialized;  /* Flag set to true after the zone has executed all get/set calls in the initializion mode
                                of the FMU */
  bool valueReferenceIsSet;         /* Flag, set to true after value references are set,
                                       and used to check for Dymola 2020x whether the flag 'Hidden.AvoidDoubleComputation=true' is set */
  double airChaRatInf;             /* Infiltration air change rate */
  double cpAir;               /* Heat capacity of air */
  double hfgWater;            /* Heat of vaporization of water */
  double rhoAir;              /* Density of air */

} SpawnObject;

#endif
