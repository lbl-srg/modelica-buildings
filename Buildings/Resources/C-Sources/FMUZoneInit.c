/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

/* Create the structure and return a pointer to its address. */
void* FMUZoneInit(const char* fmuName, const char* zoneName, int nFluPor)
{
  /* Note: The fmuName is needed to unpack the fmu so that the valueReference
     for the zone with zoneName can be obtained */
  char msg[100];
  unsigned int i;

  snprintf(msg, 100, "*** Pointer is %p.\n", ptrToFmu);
  ModelicaMessage(msg);

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

  /* Assign the fmu name */
  zone->fmu = malloc(strlen(fmuName) * sizeof(char));
  if ( zone->fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(zone->fmu, fmuName);

  /* Assign the zone name */
  zone->name = malloc(strlen(zoneName) * sizeof(char));
  if ( zone->name == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(zone->name, zoneName);

  snprintf(msg, 100, "*** Initialized data for %s, room %s.\n", zone->fmu, zone->name);
  ModelicaMessage(msg);

  return (void*) zone;
};
