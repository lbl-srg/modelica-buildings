/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  5/22/2020
 */
#ifndef Buildings_InputVariableInstantiate_h
#define Buildings_InputVariableInstantiate_h

#include "EnergyPlusFMU.h"
#include "BuildingInstantiate.h"

#include <stdio.h>
#include <unistd.h>

#include "fmilib.h"
#include "JM/jm_portability.h"

void InputVariableInstantiate(void* object, double t0);

#endif
