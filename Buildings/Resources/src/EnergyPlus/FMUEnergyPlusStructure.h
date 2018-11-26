/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

#include <stdlib.h>
#include <stddef.h>  /* stddef defines size_t */
#include <string.h>
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

typedef unsigned int (*fTerminate)(fmi2String log);


typedef struct FMU{
  HANDLE dllHandle;
  fInstantiate instantiate;
  fSetupExperiment setupExperiment;
  fSetTime setTime;
  fSetVariables setVariables;
  fGetVariables getVariables;
  fGetNextEventTime getNextEventTime;
  fTerminate terminate;
} FMU;

typedef struct FMUBuilding
{
  int _firstCall;
  fmi2Byte* name;
  fmi2Byte* weather;
  fmi2Byte* idd;
  fmi2Byte* epLib;
  fmi2Integer nZon; /* Number of zones that use this FMU */
  fmi2Byte** zoneNames; /* Names of zones in this FMU */
  void** zones; /* Pointers to all zones*/
  FMU* fmu;
} FMUBuilding;

typedef struct FMUZone
{
  int index;
  fmi2Byte* name;      /* Name of this zone */
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  size_t nInputValueReferences;/* Number of input value references per zone*/
  fmi2Byte inputVariableNames[1][100]; /* Names of input variables*/
  fmi2ValueReference inputValueReferences[1]; /* Value reference of input variables*/
  size_t nOutputValueReferences;/* Number of output value references per zone*/
  fmi2Byte outputVariableNames[4][100]; /* Names of output variables*/
  fmi2ValueReference outputValueReferences[4]; /* Value references of output variables*/
} FMUZone;

void incrementBuildings_nFMU();
void decrementBuildings_nFMU();
unsigned int getBuildings_nFMU();

FMUBuilding* instantiateZone(
  const char* idfName, const char* weaName,
  const char* iddName, const char* epLibName,
  const char* zoneName, FMUZone* zone);

FMUBuilding* getBuildingsFMU(size_t iFMU);

#endif
