/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneFree_h
#define Buildings_ZoneFree_h

#include "EnergyPlusStructure.h"
#include "FMI2/fmi2_import.h"

void FMUBuildingFree(FMUBuilding* ptrBui);

void ZoneFree(void* object);

#endif
