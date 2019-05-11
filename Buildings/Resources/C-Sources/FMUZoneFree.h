/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_FMUZoneFree_h
#define Buildings_FMUZoneFree_h

#include "FMUEnergyPlusStructure.h"

void FMUBuildingFree(FMUBuilding* ptrBui);

void FMUZoneFree(void* object);

#endif
