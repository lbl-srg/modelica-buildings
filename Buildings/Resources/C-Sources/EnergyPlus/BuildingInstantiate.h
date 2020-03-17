/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_BuildingInstantiate_h
#define Buildings_BuildingInstantiate_h

#include "EnergyPlusFMU.h"
#include "EnergyPlusUtil.h"
#include "../cryptographicsHash.h"

#include <stdio.h>
#include <unistd.h>

#include "fmilib.h"
#include "JM/jm_portability.h"

void generateAndInstantiateBuilding(FMUBuilding* bui);

#endif
