/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */
#ifndef Buildings_InputVariableInstantiate_h
#define Buildings_InputVariableInstantiate_h

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

LBNL_EnergyPlus_EXPORT void EnergyPlusInputVariableInstantiate(void* object, double t0);

#endif
