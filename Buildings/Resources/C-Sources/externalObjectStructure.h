/*
 * A structure to store an increasing number of double
 * values.
 */

#ifndef BUILDINGS_EXTERNALOBJECTSTRUCTURE_H /* Not needed since it is only a typedef; added for safety */
#define BUILDINGS_EXTERNALOBJECTSTRUCTURE_H

typedef struct ExternalObjectStructure
{
  /* array where the data are stored during the simulation */
  double* x;
  /* Number of element in the array */
  size_t n;
} ExternalObjectStructure;

#endif
