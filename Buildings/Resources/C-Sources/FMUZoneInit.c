/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>
#include <string.h>

/* Create the structure and return a pointer to its address. */
FMUBuilding* instantiateEnergyPlusFMU(const char* fmuName)
{
  char msg[100];

  /* Allocate memory */
 // if (Buildings_nFMU == 0){
 //   ModelicaMessage("Calling malloc.");
 //   Buildings_FMUS = malloc(sizeof(struct FMUBuilding*));
 // }
 // else{
    //Buildings_FMUS* = realloc(&Buildings_FMUS, (Buildings_nFMU+1) * sizeof(FMUBuilding));
 //   ModelicaError("Instantiation of multiple FMUs not yet implemented.");
//  }

  Buildings_FMUS[Buildings_nFMU] = malloc(sizeof(FMUBuilding*));
  if ( Buildings_FMUS[Buildings_nFMU] == NULL )
    ModelicaError("Not enough memory in FMUBuildingInit.c to allocate building fmu.");

  /* Assign the fmu name */
  Buildings_FMUS[Buildings_nFMU]->fmu = malloc(strlen(fmuName) * sizeof(char));
  if ( Buildings_FMUS[Buildings_nFMU]->fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(Buildings_FMUS[Buildings_nFMU]->fmu, fmuName);

  Buildings_FMUS[Buildings_nFMU]->nZon = 1;

  snprintf(msg, 100, "*** Instantizated new fmu for %s at %p.\n", fmuName, Buildings_FMUS[Buildings_nFMU]);
  ModelicaMessage(msg);

  Buildings_nFMU++;
  // Return the pointer to the FMU for this EnergyPlus instance
  return Buildings_FMUS[Buildings_nFMU-1];
};

/* Create the structure and return a pointer to its address. */
void* FMUZoneInit(const char* fmuName, const char* zoneName, int nFluPor)
{
  /* Note: The fmuName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  char msg[100];
  unsigned int i;

  /* ********************************************************************** */
  /* Initialize the zone */
  FMUZone* zone = malloc(sizeof(FMUZone));
  if ( zone == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone.");
  zone->valueReference = NULL;

  zone->valueReference = malloc(nFluPor * sizeof(unsigned int));
  if ( zone->valueReference == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate valueReference.");
  zone->nValueReference = nFluPor; /* Will need to be fixed later */

  /* Assign the value reference. This should be done by using the values from modeliDescription.xml */
  for(i = 0; i < nFluPor; i++){
    zone->valueReference[i] = i;
  }

  /* Assign the zone name */
  zone->name = malloc(strlen(zoneName) * sizeof(char));
  if ( zone->name == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(zone->name, zoneName);

  /* ********************************************************************** */
  /* Initialize the pointer for the FMU to which this zone belongs */
  /* Check if there are any zones */
  if (Buildings_nFMU == 0){
    /* No FMUs exist. Instantiate an FMU and
    /* assign this fmu pointer to the zone that will invoke its setXXX and getXXX */
    zone->ptrBui = instantiateEnergyPlusFMU(fmuName);
    snprintf(msg, 100, "*** Made new fmu for %s at %p.\n", zoneName, zone->ptrBui);
    ModelicaMessage(msg);
  } else {
    /* There is already a Buildings FMU allocated.
       Check if the current zone is for this FMU. */
      zone->ptrBui = NULL;
      for(i = 0; i < Buildings_nFMU; i++){

        snprintf(msg, 100, "*** Comparing %s to %s: %d.\n", fmuName, Buildings_FMUS[i]->fmu, strcmp(fmuName, Buildings_FMUS[i]->fmu));
        ModelicaMessage(msg);

        if (strcmp(fmuName, Buildings_FMUS[i]->fmu) == 0){
          /* This is the same FMU as before. */
          struct FMUBuilding* bld = Buildings_FMUS[i];
          snprintf(msg, 100, "*** Found existing fmu for %s at %p.\n", zoneName, bld);
          ModelicaMessage(msg);
          zone->ptrBui = bld;
          /* Increment the count of zones to this building. (Used to free storage again.) */
          bld->nZon++;
        }
      }
      /* Check if we found an FMU */
      if (zone->ptrBui == NULL){
        /* Did not find an FMU. */
        zone->ptrBui = instantiateEnergyPlusFMU(fmuName);
        snprintf(msg, 100, "*+* Made new fmu for %s at %p.\n", zoneName, zone->ptrBui);
        ModelicaMessage(msg);
      }
  }
  snprintf(msg, 100, "*** Initialized data for bld %s, room %s.\n", zone->ptrBui->fmu, zone->name);
  ModelicaMessage(msg);

  for(i = 0; i < Buildings_nFMU; i++){
    snprintf(msg, 100, "*** BuildingsFMU %d, %s.\n", i, Buildings_FMUS[i]->fmu);
    ModelicaMessage(msg);
  }

  /* Return a pointer to this zone */
  return (void*) zone;
};
