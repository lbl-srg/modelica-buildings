/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/9/19
 */
#ifndef Buildings_OutputVariableInstantiate_h
#define Buildings_OutputVariableInstantiate_h

#include "EnergyPlusFMU.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#include <unistd.h>

#include "fmilib.h"
#include "JM/jm_portability.h"

void OutputVariableInstantiate(void* object, double t0);

#endif
