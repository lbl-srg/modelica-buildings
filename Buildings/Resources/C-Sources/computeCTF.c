/*
 * External function that implements the CTF calculations.
 *
 * Arguments
 * ---------
 * object: C structure for storage of the array
 * iX: index where x will be stored (1-based index)
 * x:  value to be stored
 * iY: value to be returned (1-based index)
 *
 * Michael Wetter, LBNL                  1/12/2017
 */

#include "externalCTFStructure.h"
#include <string.h>
#include <stdlib.h>

double computeCTF(
  void* object,
  double time,
  double Q_a_flow,
  double Q_b_flow,
  double* T_a,
  double* T_b){

  ExternalCTFStructure* ctfData = (ExternalCTFStructure*) object;

  size_t n=ctfData->n;
  double dT_a;

  /* Check input */
  if (1 == 2)
        ModelicaError("There is an error.");
  /* Manage memory
   * At first call, initialize storage */
  if ( ctfData->n == 0 ){
    ctfData->x= malloc( n * sizeof(double) );
    if ( ctfData->x == NULL )
      ModelicaError("Out of memory in computeCTF when allocating memory for x.");
    ctfData->n = 1;
    ctfData->x[0] = 293.15;
    ctfData->time = time;
  }

  // Assign values
  dT_a = ctfData->x[0];

  /* Do the CTF calculations */
  dT_a = dT_a + (time-ctfData->time) * (Q_a_flow + Q_b_flow)/10000.;
  /*printf ("returning: %4.2f", ctfData->x[0]);*/
  // Store the output for the next invocation
  ctfData->x[0] = dT_a;
  ctfData->time = time;

  // Assign the output to pass the values to Modelica
  *T_a = dT_a;
  *T_b = dT_a;
  return 0;
}
