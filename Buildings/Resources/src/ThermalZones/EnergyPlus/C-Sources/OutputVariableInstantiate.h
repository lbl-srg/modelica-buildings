/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  10/9/19
 */
#ifndef Buildings_OutputVariableInstantiate_h
#define Buildings_OutputVariableInstantiate_h

#include "EnergyPlusTypes.h"
#include "EnergyPlusFMU.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#ifdef _MSC_VER
#include <windows.h>
#else
#include <unistd.h>
#endif

#include "fmilib.h"
#include "JM/jm_portability.h"

LBNL_EnergyPlus_EXPORT void EnergyPlusOutputVariableInstantiate(void* object, double t0);

#endif
