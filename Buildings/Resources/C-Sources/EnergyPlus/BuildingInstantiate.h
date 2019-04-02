/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_BuildingInstantiate_h
#define Buildings_BuildingInstantiate_h

#include "EnergyPlusStructure.h"

#include <stdio.h>
#include <unistd.h>

#include "fmilib.h"
#include "JM/jm_portability.h"

void generateAndInstantiateBuilding(FMUBuilding* bui);
/*
void writeModelStructureForEnergyPlus(const FMUBuilding* bui);
void setValueReferences(FMUBuilding* fmuBui);
void generateFMU(const char* FMUPath);
void setEnergyPlusDebugLevel(FMUBuilding* bui);
*/
#endif
