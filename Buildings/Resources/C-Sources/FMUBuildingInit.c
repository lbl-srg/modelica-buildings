/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/14/2018
 */

#include "FMUEnergyPlusStructure.h"
#include <stdlib.h>

/* Create the structure and return a pointer to its address. */
void* FMUBuildingInit(const char* fmuName)
{
  char msg[100];

  snprintf(msg, 100, "*** Pointer is %p.\n", ptrToFmu);
  ModelicaMessage(msg);

  FMUBuilding* bld = malloc(sizeof(FMUBuilding));
  if ( bld == NULL )
    ModelicaError("Not enough memory in FMUBuildingInit.c.");

  /* Assign the fmu name */
  bld->fmu = malloc(strlen(fmuName) * sizeof(char));
  if ( bld->fmu == NULL )
    ModelicaError("Not enough memory in FMUZoneInit.c. to allocate zone name.");
  strcpy(bld->fmu, fmuName);

  snprintf(msg, 100, "*** Initializing pointer for building %s.\n", fmuName);
  ModelicaMessage(msg);
  ptrToFmu=(void*)1;   /* set the pointer to the address where the bld is */

  return (void*) bld;
};
