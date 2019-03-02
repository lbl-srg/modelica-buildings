/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_FMUZoneInstantiate_h
#define Buildings_FMUZoneInstantiate_h

#include "FMUEnergyPlusStructure.h"

void FMUZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac);

#endif
