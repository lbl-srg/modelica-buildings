/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

#include <stdlib.h>
#include <stddef.h>  /* stddef defines size_t */
#include <string.h>
#include <stdio.h>
#include <execinfo.h>
#include "fmi2FunctionTypes.h"
#include "ModelicaUtilities.h"

/* Use windows.h only for Windows */
#ifdef _WIN32
#include <windows.h>
#define WINDOWS 1
#else
#define WINDOWS 0
#define HANDLE void *
/* See http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html */
#include <dlfcn.h>
#endif

#define FMU_EP_VERBOSITY 3 /* Verbosity flag, 0: quiet, 3: all output */

#ifndef max
  #define max( a, b ) ( ((a) > (b)) ? (a) : (b) )
#endif

void writeLog(unsigned int level, const char* msg);

void logStringArray(unsigned int level,
                    const char* msg,
                    const char** array,
                    size_t n);

void logValueReferenceArray(unsigned int level,
                            const char* msg,
                            const fmi2ValueReference* array,
                            size_t n);


typedef unsigned int (*fInstantiate)(fmi2String input,
                         fmi2String weather,
                         fmi2String idd,
                         fmi2String instanceName,
                         fmi2String* parameterNames,
                         const unsigned int parameterValueReferences[],
                         size_t nPar,
                         fmi2String* inputNames,
                         const fmi2ValueReference inputValueReferences[],
                         size_t nInp,
                         fmi2String* outputNames,
                         const fmi2ValueReference outputValueReferences[],
                         size_t nOut,
                         fmi2String log);

typedef unsigned int (*fSetupExperiment)(fmi2Real tStart,
                             int stopTimeDefined,
                             fmi2String log);

typedef unsigned int (*fSetTime)(fmi2Real time,
                     fmi2String log);

typedef unsigned int (*fSetVariables)(const fmi2ValueReference valueReferences[],
                          const fmi2Real variablePointers[],
                          size_t nVars1,
                          fmi2String log);

typedef unsigned int (*fGetVariables)(const unsigned int valueReferences[],
                          fmi2Real variablePointers[],
                          size_t nVars2,
                          fmi2String log);

typedef unsigned int (*fGetNextEventTime)(fmi2EventInfo *eventInfo,
                              fmi2String log);

typedef unsigned int (*fTerminateSim)(fmi2String log);


typedef struct FMU{
  HANDLE dllHandle;
  fInstantiate instantiate;
  fSetupExperiment setupExperiment;
  fSetTime setTime;
  fSetVariables setVariables;
  fGetVariables getVariables;
  fGetNextEventTime getNextEventTime;
  fTerminateSim terminateSim;
} FMU;

typedef struct FMUBuilding
{
  fmi2Byte* name;
  fmi2Byte* weather;
  fmi2Byte* idd;
  char* epLib;
  fmi2Integer nZon; /* Number of zones that use this FMU */
  fmi2Byte** zoneNames; /* Names of zones in this FMU */
  void** zones; /* Pointers to all zones*/
  FMU* fmu;
  char* tmpDir; /* Temporary directory used by EnergyPlus */
} FMUBuilding;

typedef struct FMUZone
{
  int index;
  fmi2Byte* name;      /* Name of this zone */
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  size_t nParameterValueReferences;/* Number of parameter value references per zone*/
  fmi2Byte** parameterVariableNames; /* Names of parameter variables*/
  fmi2ValueReference* parameterValueReferences; /* Value reference of parameter variables*/
  size_t nInputValueReferences;/* Number of input value references per zone*/
  fmi2Byte** inputVariableNames; /* Names of input variables*/
  fmi2ValueReference* inputValueReferences; /* Value reference of input variables*/
  size_t nOutputValueReferences;/* Number of output value references per zone*/
  fmi2Byte** outputVariableNames; /* Names of output variables*/
  fmi2ValueReference* outputValueReferences; /* Value references of output variables*/
} FMUZone;

void getEnergyPlusDLLName(char** epLibName);

void incrementBuildings_nFMU();
void decrementBuildings_nFMU();
unsigned int getBuildings_nFMU();

void buildVariableNames(
  const char* zoneName,
  const char** variableNames,
  const size_t nVar,
  char** *fullNames,
  size_t* len);

FMUBuilding* FMUZoneAllocateBuildingDataStructure(
  const char* idfName, const char* weaName,
  const char* iddName,
  const char* zoneName, FMUZone* zone);

FMUBuilding* getBuildingsFMU(size_t iFMU);
void getEnergyPlusTemporaryDirectory(const char* idfName, char** dirNam);

#endif
