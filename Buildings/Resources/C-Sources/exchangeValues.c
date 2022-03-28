/*
 * External function that exchanges a value with
 * an array. The array size is dynamically changed
 * as needed.
 *
 * Arguments
 * ---------
 * object: C structure for storage of the array
 * iX: index where x will be stored (1-based index)
 * x:  value to be stored
 * iY: value to be returned (1-based index)
 *
 * Pierre Vigouroux, LBNL                  7/18/2011
 */

#include "externalObjectStructure.h"

#include <string.h>
#include <stdlib.h>

double exchangeValues(void* object, size_t iX, double x, size_t iY){
  ExternalObjectStructure* table = (ExternalObjectStructure*) object;
  const size_t nInc = 10;
  size_t nTab=table->n;
  size_t nNew=iX-1+nInc;
  /*  temporary array used while increasing the size of table */
  double *tab2=NULL;

  /* Check input */
  if (iX == 0 || iY == 0)
        ModelicaError("Index is one-based in exchangeValues.c.");
  /* Manage memory
   * At first call, initialize storage */
  if ( table->x == NULL ){
    table->x= malloc( nNew * sizeof(double) );
    if ( table->x == NULL )
      ModelicaError("Out of memory in storeValue.c when allocating memory for table.");
    table->n = nNew;
    table->x[iX-1] = x;
    if (iX == iY)
      return x;
    else
      return 0;
  }

  if (iX > nTab){
    /* Assign more memory before storing the value */
    tab2 = malloc( nTab * sizeof(double) );
    if ( tab2 == NULL )
      ModelicaError("Out of memory in storeValue.c when allocating memory for tab2.");

    /* Copy the values of x in tab2 */
    memcpy(tab2, table->x, nTab * sizeof(double) );

    /* Increase the size of x */
    free(table->x);
    table->x = malloc(nNew * sizeof(double) );
    if ( table->x == NULL )
      ModelicaError("Out of memory in storeValue.c when allocating memory for table->x.");
    table->n = nNew;
    /* Copy previous values */
    memcpy(table->x, tab2, nTab * sizeof(double));
    free(tab2);
  }

  /* Store and return the data */
  table->x[iX-1] = x;
  /* printf ("returning: %4.2f", table->x[iY-1]); */
  return table->x[iY-1];
}
