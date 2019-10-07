/*
 * Modelica external function to communicate with EnergyPlus.
 *
 * Michael Wetter, LBNL                  2/9/2019
 */
#ifndef Buildings_EnergyPlusUtil_h
#define Buildings_EnergyPlusUtil_h

#include "EnergyPlusUtil.h"

#include <stdio.h>
#include <unistd.h>


void mallocString(size_t nChar, const char *error_message, char** str);

#endif
