/*
 * A structure to store the data needed to communicate with EnergyPlus.
 */

#ifndef Buildings_FMUEnergyPlusStructure_h /* Not needed since it is only a typedef; added for safety */
#define Buildings_FMUEnergyPlusStructure_h

#include <stddef.h>  /* stddef defines size_t */

// Use windows.h only for Windows
#ifdef _WIN32
#include <windows.h>
#define WINDOWS 1
#else
#define WINDOWS 0
#define HANDLE void *
/* See http://www.yolinux.com/TUTORIALS/LibraryArchives-StaticAndDynamic.html */
#include <sys/stat.h> // for creating dirs on Linux
#include <sys/types.h>
#include<sys/sysinfo.h>
#include <dlfcn.h>
#endif


typedef struct fmi2EventInfo{
  int newDiscreteStatesNeeded;
  int terminateSimulation;
  int nominalsOfContinuousStatesChanged;
  int valuesOfContinuousStatesChanged;
  int nextEventTimeDefined;
  double nextEventTime; // next event if nextEventTimeDefined=fmi2True
  } fmi2EventInfo;

typedef unsigned int (*fInstantiate)(const char *input,
                         const char *weather,
                         const char *idd,
                         const char *instanceName,
                         const char ** parameterNames,
                         const unsigned int parameterValueReferences[],
                         size_t nPar,
                         const char ** inputNames,
                         const unsigned int inputValueReferences[],
                         size_t nInp,
                         const char ** outputNames,
                         const unsigned int outputValueReferences[],
                         size_t nOut,
                         const char *log);

typedef unsigned int (*fSetupExperiment)(double tStart,
                             int stopTimeDefined,
                             const char *log);

typedef unsigned int (*fSetTime)(double time,
                     const char *log);

typedef unsigned int (*fSetVariables)(const unsigned int valueReferences[],
                          const double variablePointers[],
                          size_t nVars1,
                          const char *log);

typedef unsigned int (*fGetVariables)(const unsigned int valueReferences[],
                          double variablePointers[],
                          size_t nVars2,
                          const char *log);

typedef unsigned int (*fGetNextEventTime)(double *eventInfo,
                              const char *log);

typedef unsigned int (*fTerminate)(const char *log);


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
  char* name;
  int nZon; /* Number of zones that use this FMU */
  char** zoneNames; /* Names of zones in this FMU */
  void** zones; /* Pointers to all zones*/
  FMU* fmu;
} FMUBuilding;

typedef struct FMUZone
{
  char* name;          /* Name of this zone */
  FMUBuilding* ptrBui; /* Pointer to building with this zone */
  unsigned int* valueReference; /* Value references for this zone */
  size_t nValueReference;
  size_t nInputValueReferences;/* Number of input value references*/
  char** inputVariableNames; /* Names of input variables*/
  int* inputValueReferences; /* Value reference of input variables*/
  size_t nOutputValueReferences;/* Number of output value references*/
  char** outputVariableNames; /* Names of output variables*/
  int* outputValueReferences; /* Value references of output variables*/
} FMUZone;


static struct FMUBuilding** Buildings_FMUS; /* Array with pointers to all FMUs */
static unsigned int Buildings_nFMU = 0;     /* Number of FMUs */
#endif
