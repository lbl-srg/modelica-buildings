/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_InputOutputInstantiate_h
#define Buildings_InputOutputInstantiate_h

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

LBNL_EnergyPlus_EXPORT void EnergyPlusInputOutputInstantiate(void* object, double t0, double* AFlo, double* V, double* mSenFac);

#endif
