/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include "EnergyPlusModelicaUtilities.h"

#include <stdlib.h>
#include <string.h>

void writeLog(unsigned int level, const char* msg)
{
    if (level <= FMU_EP_VERBOSITY){
      const char* prefix = "*** Log: ";
      char* m;
      m = (char*)malloc( (strlen(msg)+strlen(prefix)+1) * sizeof(char));
      if (m == NULL)
        EnergyPlusError("Failed to allocate string array in writeLog.\n");
      strcpy(m, prefix);
      strcat(m, msg);
      fprintf(stdout, "%s\n", m);
      fflush(stdout);
    }
}

void logStringArray(unsigned int level,
                    const char* msg,
                    const char** array,
                    size_t n){
  int i;
  if (level <= FMU_EP_VERBOSITY){
    writeLog(level, msg);
    for(i = 0; i < n; i++)
      writeLog(level, array[i]);
    writeLog(level, "End of array.");
  }
}

void logValueReferenceArray(unsigned int level,
                            const char* msg,
                            const fmi2ValueReference* array,
                            size_t n){
  int i;
  if (level <= FMU_EP_VERBOSITY){
    char res[100];
    writeLog(level, msg);
    for(i = 0; i < n; i++){
      sprintf(res, "%d", array[i]);
      writeLog(level, res);
    }
    writeLog(level, "End of array.");
  }
}


void printBacktrace(){
  void* callstack[128];
  int i, frames = backtrace(callstack, 128);
  char** strs = backtrace_symbols(callstack, frames);
  for (i = 0; i < frames; ++i) {
    printf("%s\n", strs[i]);
  }
  free(strs);
}

static unsigned int Buildings_nFMU = 0;     /* Number of FMUs */
static struct FMUBuilding** Buildings_FMUS; /* Array with pointers to all FMUs */

void buildVariableNames(
  const char* zoneName,
  const char** variableNames,
  const size_t nVar,
  char** *fullNames,
  size_t* len){
  /* Map the output values to correct parameters */
  /* Compute longest output name */
  size_t i;
  *len = 0;
  for (i=0; i<nVar; i++)
    *len = max(*len, strlen(zoneName) + 2 + strlen(variableNames[i]));

  *fullNames = (char**)malloc(nVar * sizeof(char*));

  if (*fullNames == NULL)
    EnergyPlusError("Failed to allocate memory for fullNames in FMUZoneInstantiate.c.");

  for (i=0; i<nVar; i++){
    (*fullNames)[i] = (char*)malloc(( (*len) + 2 ) * sizeof(char));
    if ( (*fullNames)[i] == NULL)
      EnergyPlusError("Failed to allocate memory for fullNames[i] in FMUZoneInstantiate.c.");
  }
  /* Copy the string */
  for (i=0; i<nVar; i++){
    strcpy((*fullNames)[i], zoneName);
    strcat((*fullNames)[i], ",");
    strcat((*fullNames)[i], variableNames[i]);

  }
  return;
}

FMUBuilding* FMUZoneAllocateBuildingDataStructure(const char* idfName, const char* weaName,
  const char* iddName, const char* epLibName, const char* zoneName, FMUZone* zone){
  /* Allocate memory */
  writeLog(1, "Allocating data structure for building.");

  const size_t nFMU = getBuildings_nFMU();
  if (nFMU == 0)
    Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
  else
    Buildings_FMUS = realloc(Buildings_FMUS, (nFMU+1) * sizeof(struct FMUBuilding*));
  if ( Buildings_FMUS == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMU.");

  Buildings_FMUS[nFMU] = malloc(sizeof(FMUBuilding));
  if ( Buildings_FMUS[nFMU] == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMU[0].");
  Buildings_FMUS[nFMU]->zoneNames = malloc(sizeof(char*));
  if ( Buildings_FMUS[nFMU]->zoneNames == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMUS[0]->zoneNames.");

  /* Assign the fmu name */
  Buildings_FMUS[nFMU]->name = (char*) malloc((strlen(idfName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->name == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate fmu name.");
  strcpy(Buildings_FMUS[nFMU]->name, idfName);

  /* Assign the weather name */
  Buildings_FMUS[nFMU]->weather = (char*) malloc((strlen(weaName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->weather == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate weather name.");
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);

  /* Assign the idd name */
  Buildings_FMUS[nFMU]->idd = (char*) malloc((strlen(iddName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->idd == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate IDD name.");
  strcpy(Buildings_FMUS[nFMU]->idd, iddName);

  /* Assign the Energyplus library name */
  Buildings_FMUS[nFMU]->epLib = (char*) malloc((strlen(epLibName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->epLib == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate IDD name.");
  strcpy(Buildings_FMUS[nFMU]->epLib, epLibName);

  /* Assign the zone name */
  Buildings_FMUS[nFMU]->zoneNames[0] = malloc((strlen(zoneName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->zoneNames[0] == NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(Buildings_FMUS[nFMU]->zoneNames[0], zoneName);

  Buildings_FMUS[nFMU]->nZon = 1;

  Buildings_FMUS[nFMU]->zones=malloc(sizeof(FMUZone *));
  if ( Buildings_FMUS[nFMU]->zones== NULL )
    EnergyPlusError("Not enough memory in FMUZoneInit.c. to allocate zones.");

  getEnergyPlusTemporaryDirectory(idfName, &(Buildings_FMUS[nFMU]->tmpDir));

  /* Assign the zone */
  Buildings_FMUS[nFMU]->zones[0] = zone;

  incrementBuildings_nFMU();
  /* EnergyPlusMessage("*** Leaving instantiateEnergyPlusFMU."); */

  /* Return the pointer to the FMU for this EnergyPlus instance */
  return Buildings_FMUS[nFMU];
}

FMUBuilding* getBuildingsFMU(size_t iFMU){
  return Buildings_FMUS[iFMU];
}

void incrementBuildings_nFMU(){
  Buildings_nFMU++;
  /* EnergyPlusFormatMessage("*** Increased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

void decrementBuildings_nFMU(){
  Buildings_nFMU--;
  if (Buildings_nFMU == 0){
     free(Buildings_FMUS);
   }
  /* EnergyPlusFormatMessage("*** Decreased Buildings_nFMU to %zu.", Buildings_nFMU); */
  return;
}

unsigned int getBuildings_nFMU(){
  return Buildings_nFMU;
}

void getEnergyPlusTemporaryDirectory(const char* idfName, char** dirNam){
  /* Return the name of the temporary directory to be used for EnergyPlus */
  /* Get file name without path */
  /* return "tmp-eplus-ValidationRefBldgSmallOfficeNew2004_Chicago"; */
  fmi2Byte * namWitSla = strrchr(idfName, '/');

  if ( namWitSla == NULL )
    EnergyPlusFormatError("Failed to parse idfName '%s'. Expected an absolute path with forward slash '/'?", idfName);
  /* Remove the first slash */
  char * nam = namWitSla + 1;
  /* Get the extension */
  char * ext = strrchr(nam, '.');
  if ( ext == NULL )
    EnergyPlusFormatError("Failed to parse idfName '%s'. Expected a file extension such as '.idf'?", idfName);

  /* Get the file name without extension */
  size_t lenNam = strlen(nam) - strlen(ext);
  char * namOnl;
  namOnl = malloc((lenNam) * sizeof(char));
  if ( namOnl == NULL )
    EnergyPlusFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(namOnl, nam, lenNam);
  /* Add termination character */
  namOnl[lenNam] = '\0';

  /* Prefix for temporary directory */
  const char* pre = "tmp-eplus-\0";
  size_t lenPre = strlen(pre);

  *dirNam = malloc((lenPre+lenNam+1) * sizeof(char));
  if ( *dirNam == NULL )
    EnergyPlusFormatError("Failed to allocate memory for temporary directory name in FMUZoneInstantiate.c.");

  strncpy(*dirNam, pre, lenPre);
  (*dirNam)[lenPre] = '\0';
  /* Add termination character */
  strcat(*dirNam, namOnl);
  free(namOnl);

  return;
}
