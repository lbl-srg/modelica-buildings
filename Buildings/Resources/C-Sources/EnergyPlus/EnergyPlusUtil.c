/*
 * Modelica external function to intialize EnergyPlus.
 *
 * Michael Wetter, LBNL                  3/1/2018
 * Thierry S. Nouidui, LBNL              3/23/2018
 */

#include "EnergyPlusUtil.h"

#include <stdlib.h>
#include <string.h>
#include <stdio.h>

void mallocString(const size_t nChar, const char *error_message, char** str){
  *str = malloc(nChar * sizeof(char));
  if ( *str == NULL )
    ModelicaError(error_message);
}