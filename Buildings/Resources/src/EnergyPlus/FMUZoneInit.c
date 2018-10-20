/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include "ModelicaUtilities.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>


/* Create the structure and return a pointer to its address. */
FMUBuilding* instantiateEnergyPlusFMU(const char* idfName, const char* weaName,
  const char* iddName, const char* epLibName, const char* zoneName, FMUZone* zone )
{
  ModelicaMessage("*** Entered instantiateEnergyPlusFMU.\n");

  /* Allocate memory */
  const size_t nFMU = getBuildings_nFMU();
  if (nFMU == 0)
    Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
  else
    Buildings_FMUS = realloc(Buildings_FMUS, (nFMU+1) * sizeof(struct FMUBuilding*));
  if ( Buildings_FMUS == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMU.");

  Buildings_FMUS[nFMU] = malloc(sizeof(FMUBuilding));
  if ( Buildings_FMUS[nFMU] == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMU[0].");
  Buildings_FMUS[nFMU]->zoneNames = malloc(sizeof(char*));
  if ( Buildings_FMUS[nFMU]->zoneNames == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate array for Buildings_FMUS[0]->zoneNames.");

  /* Assign the fmu name */
  Buildings_FMUS[nFMU]->name = (char*) malloc((strlen(idfName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->name == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate fmu name.");
  strcpy(Buildings_FMUS[nFMU]->name, idfName);

  /* Assign the weather name */
  Buildings_FMUS[nFMU]->weather = (char*) malloc((strlen(weaName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->weather == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate weather name.");
  strcpy(Buildings_FMUS[nFMU]->weather, weaName);

  /* Assign the idd name */
  Buildings_FMUS[nFMU]->idd = (char*) malloc((strlen(iddName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->idd == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate IDD name.");
  strcpy(Buildings_FMUS[nFMU]->idd, iddName);

  /* Assign the Energyplus library name */
  Buildings_FMUS[nFMU]->epLib = (char*) malloc((strlen(epLibName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->epLib == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate IDD name.");
  strcpy(Buildings_FMUS[nFMU]->epLib, epLibName);

  /* Assign the zone name */
  Buildings_FMUS[nFMU]->zoneNames[0] = malloc((strlen(zoneName)+1) * sizeof(char));
  if ( Buildings_FMUS[nFMU]->zoneNames[0] == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(Buildings_FMUS[nFMU]->zoneNames[0], zoneName);

  Buildings_FMUS[nFMU]->nZon = 1;

  Buildings_FMUS[nFMU]->zones=malloc(sizeof(FMUZone *));
  if ( Buildings_FMUS[nFMU]->zones== NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zones.");

  /* Assign the zone */
  Buildings_FMUS[nFMU]->zones[0] = zone;

  incrementBuildings_nFMU();
  ModelicaMessage("*** Leaving instantiateEnergyPlusFMU.\n");

  /* Return the pointer to the FMU for this EnergyPlus instance */
  return Buildings_FMUS[nFMU];
};

int zoneIsUnique(const struct FMUBuilding* fmuBld, const char* zoneName){
  int iZ;
  int isUnique = 1;
  for(iZ = 0; iZ < fmuBld->nZon; iZ++){
    if (!strcmp(zoneName, fmuBld->zoneNames[iZ])){
      isUnique = 0;
      break;
    }
  }
  return isUnique;
}

/* Create the structure and return a pointer to its address. */
void* FMUZoneInit(const char* idfName, const char* weaName, const char* iddName, const char* epLibName, const char* zoneName)
{
  /* Note: The idfName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  unsigned int i;
  const size_t nFMU = getBuildings_nFMU();
  ModelicaMessage("*** Entered FMUZoneInit.\n");

  /* ModelicaFormatMessage("****** Initializing zone %s, fmu = %s****** \n", zoneName, idfName); */

  /* ********************************************************************** */
  /* Initialize the zone */
  FMUZone* zone = (FMUZone*) malloc(sizeof(FMUZone));
  if ( zone == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone.");

  /* Assign the value reference. This should be done by using the values from modelDescription.xml */
  /*for(i = 0; i < nFluPor; i++){
    zone->valueReference[i] = i;
  }
  */

  /* Assign the zone name */
  zone->name = malloc((strlen(zoneName)+1) * sizeof(char));
  if ( zone->name == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(zone->name, zoneName);

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */
  /* Check if there are any zones */
  if (nFMU == 0){
    /* No FMUs exist. Instantiate an FMU and */
    /* assign this fmu pointer to the zone that will invoke its setXXX and getXXX */
    zone->ptrBui = instantiateEnergyPlusFMU(idfName, weaName, iddName, epLibName, zoneName, zone);
    zone->index = 1;
  } else {
    /* There is already a Buildings FMU allocated.
       Check if the current zone is for this FMU. */
      zone->ptrBui = NULL;
      for(i = 0; i < nFMU; i++){

        if (strcmp(idfName, Buildings_FMUS[i]->name) == 0){
          /* This is the same FMU as before. */
          if (! zoneIsUnique(Buildings_FMUS[i], zoneName)){
            ModelicaFormatError("Modelica model specifies zone %s twice for the FMU %s. Each zone must only be specified once.",
            zoneName, Buildings_FMUS[i]->name);
          }

          struct FMUBuilding* bld = Buildings_FMUS[i];
          zone->ptrBui = bld;
          /* Increment size of vector that contains the zone names. */
          bld->zoneNames = realloc(bld->zoneNames, (bld->nZon + 1) * sizeof(char*));
          bld->zones = realloc(bld->zones, (bld->nZon + 1) * sizeof(FMUZone*));
          if (bld->zoneNames == NULL){
            ModelicaError("Not enough memory in FMUZoneInit.c. to allocate memory for bld->zoneNames.");
          }
          /* Add storage for new zone name, and copy the zone name */
          bld->zoneNames[bld->nZon] = malloc((strlen(zoneName)+1) * sizeof(char));
          if ( bld->zoneNames[bld->nZon] == NULL )
            ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
          bld->zones[bld->nZon] = zone;
          strcpy(bld->zoneNames[bld->nZon], zoneName);
          /* Increment the count of zones to this building. */
          bld->nZon++;
          zone->index = bld->nZon;
          break;
        }
      }
      /* Check if we found an FMU */
      if (zone->ptrBui == NULL){
        /* Did not find an FMU. */
        zone->ptrBui = instantiateEnergyPlusFMU(idfName, weaName, iddName, epLibName, zoneName, zone);;
      }
  }
  /*Set the fmu to null to control execution*/
  zone->ptrBui->fmu=NULL;
  ModelicaMessage("*** Leaving FMUZoneInit.\n");

  /* Return a pointer to this zone */
  return (void*) zone;
};
