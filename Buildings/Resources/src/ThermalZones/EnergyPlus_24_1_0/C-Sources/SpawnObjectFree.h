/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_SpawnObjectFree_h
#define Buildings_SpawnObjectFree_h

#include "SpawnTypes.h"
#include "SpawnFMU.h"
#include "FMI2/fmi2_import.h"

LBNL_Spawn_EXPORT void free_Spawn_EnergyPlus_24_1_0(void* object);

#endif
