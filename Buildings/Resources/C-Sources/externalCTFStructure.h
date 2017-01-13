/*
 * A structure to store an increasing number of double
 * values.
 *
 * Michael Wetter, LBNL                  1/12/2017
 *
 */

#ifndef BUILDINGS_EXTERNAL_CTF_STRUCTURE_H /* Not needed since it is only a typedef; added for safety */
#define BUILDINGS_EXTERNAL_CTF_STRUCTURE_H

/* fixme: this data structure needs to be adapted to what is needed for the CTF calculations */
typedef struct ExternalCTFStructure
{
  /* array where the data are stored during the simulation */
  double* x;
  /* Number of element in the array */
  size_t n;
  double time;
} ExternalCTFStructure;

#endif
