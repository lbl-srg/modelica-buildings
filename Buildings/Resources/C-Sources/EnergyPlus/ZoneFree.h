/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_ZoneFree_h
#define Buildings_ZoneFree_h

#include "EnergyPlusFMU.h"
#include "FMI2/fmi2_import.h"

void ZoneFree(void* object);

#endif
