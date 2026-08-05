/*
  Shared helper for gFunctionGetNMax and gFunctionGetDis.

  Both functions include this header so that the distance comparison
  is compiled from exactly the same source code, avoiding any
  numerical difference that could arise from platform-dependent
  compilation of duplicate code.

  Arrays passed from Modelica use column-major (Fortran) storage.
  For an array declared as A[n1, n2, n3] in Modelica, element
  A[i1, i2, i3] (1-indexed) is stored at
    (i1-1) + (i2-1)*n1 + (i3-1)*n1*n2
  in the flat C array.
*/

#ifndef G_FUNCTION_DIS_SHARED_H
#define G_FUNCTION_DIS_SHARED_H

#include <math.h>

/*
  Search for dis_ij among n_known distances stored at stride-spaced
  positions starting at dis_base.

  For a cluster-pair slice of dis[nClu, nClu, n_max] with fixed
  (c1, c2), the base pointer is dis + c1 + c2*nClu and the stride is
  nClu*nClu.

  Returns the 0-based index of the first match, or -1 if none found.
  A match satisfies  |dis_ij - d| / d  < relTol,
  which is identical to the comparison used in the original Modelica
  code in gFunction.
*/
static int gFunctionFindDis(
    const double *dis_base,
    int stride,
    int n_known,
    double dis_ij,
    double relTol)
{
    int k;
    for (k = 0; k < n_known; k++) {
        const double d = dis_base[(size_t)k * stride];
        if (fabs(dis_ij - d) / d < relTol) {
            return k;
        }
    }
    return -1;
}

#endif /* G_FUNCTION_DIS_SHARED_H */
