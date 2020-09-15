/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneInstantiate_h
#define Buildings_ZoneInstantiate_h

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

LBNL_EnergyPlus_EXPORT void EnergyPlusZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac);

#endif
