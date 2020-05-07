/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneInstantiate_h
#define Buildings_ZoneInstantiate_h

#include "EnergyPlusFMU.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#include <unistd.h>

#include "fmilib.h"
#include "JM/jm_portability.h"

void ZoneInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac);

#endif
