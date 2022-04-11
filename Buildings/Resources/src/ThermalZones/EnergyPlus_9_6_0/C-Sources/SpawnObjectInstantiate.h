/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_SpawnObjectInstantiate_h
#define Buildings_SpawnObjectInstantiate_h

#include "SpawnTypes.h"
#include "SpawnFMU.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#ifdef _MSC_VER
#include <windows.h>
#else
#include <unistd.h>
#endif

#include "fmilib.h"
#include "JM/jm_portability.h"

LBNL_Spawn_EXPORT void EnergyPlusSpawnInitialize(void* object, int *nObj);

LBNL_Spawn_EXPORT void EnergyPlusSpawnGetParameters(void* object, double *parOut);

#endif
