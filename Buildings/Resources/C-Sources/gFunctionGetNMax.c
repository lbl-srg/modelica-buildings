/*
  Compute the maximum number of unique pairwise distances across all
  cluster pairs in a bore field.

  This function mirrors the distance-accumulation loop from gFunction.mo
  but uses dynamic memory allocation so that the returned value n_max is
  tight rather than the conservative upper bound max(cluSiz.*cluSiz).

  The distance comparison (gFunctionFindDis from gFunctionDisShared.h)
  is identical to the one used in gFunctionGetDis.c, ensuring that both
  functions produce exactly the same partition of distances into bins.

  Array layout (omc passes multi-dimensional arrays in row-major order,
  last index varies fastest):
    cooBor[nBor, 2]:  element [i,j] at flat index (i-1)*2 + (j-1).
                      x-coord of borehole i (1-indexed) at 2*(i-1),
                      y-coord of borehole i at 2*(i-1)+1.
    labels[nBor]:     1-indexed cluster labels (1-D, no layout issue).

  Internal arrays dis_dyn and n_dis are purely local to this function
  and use column-major layout (first index fastest) for simplicity.
*/

#ifndef G_FUNCTION_GET_N_MAX_C
#define G_FUNCTION_GET_N_MAX_C

#include <stdlib.h>
#include <math.h>
#include "ModelicaUtilities.h"
#include "gFunctionDisShared.h"

int gFunctionGetNMax(
    int nBor,
    const double *cooBor,
    double rLin,
    int nClu,
    const int *labels,
    double relTol)
{
    const int nPairs = nClu * nClu;
    int cap = 16;           /* initial capacity for the distance dimension */
    double *dis_dyn = NULL; /* [nClu, nClu, cap] column-major, dynamically grown */
    int *n_dis = NULL;      /* [nClu, nClu] column-major */
    int n_max, i, j, c, li, lj, k, new_cap;
    double dis_ij, dxi, dyi;
    double *new_dis;

    dis_dyn = (double *)calloc((size_t)nPairs * cap, sizeof(double));
    n_dis   = (int *)calloc((size_t)nPairs, sizeof(int));
    if (!dis_dyn || !n_dis) {
        free(dis_dyn);
        free(n_dis);
        ModelicaError("gFunctionGetNMax: initial calloc failed.\n");
    }

    /*
      Replicate the loop from gFunction.mo:
        for i in 1:nBor loop
          for j in i:nBor loop
      (converted to 0-based C indices)
    */
    for (i = 0; i < nBor; i++) {
        for (j = i; j < nBor; j++) {
            /* Separation distance (row-major cooBor: x at 2*i, y at 2*i+1) */
            if (i != j) {
                dxi = cooBor[2*i] - cooBor[2*j];
                dyi = cooBor[2*i+1] - cooBor[2*j+1];
                dis_ij = sqrt(dxi * dxi + dyi * dyi);
            } else {
                dis_ij = rLin;
            }

            li = labels[i] - 1; /* convert 1-indexed Modelica label to 0-indexed */
            lj = labels[j] - 1;

            /* Search for an existing distance within relTol in cluster pair (li, lj) */
            if (gFunctionFindDis(
                    dis_dyn + li + (size_t)lj * nClu,
                    nPairs,
                    n_dis[li + lj * nClu],
                    dis_ij,
                    relTol) >= 0) {
                /* Distance already known — nothing to add */
                continue;
            }

            /* New distance: grow dynamic array if needed, then store */

            /* --- (li, lj) --- */
            if (n_dis[li + lj * nClu] >= cap) {
                new_cap = cap * 2;
                new_dis = (double *)realloc(
                    dis_dyn, (size_t)nPairs * new_cap * sizeof(double));
                if (!new_dis) {
                    free(dis_dyn);
                    free(n_dis);
                    ModelicaError("gFunctionGetNMax: realloc failed while growing dis_dyn.\n");
                }
                dis_dyn = new_dis;
                cap = new_cap;
            }
            k = n_dis[li + lj * nClu];
            dis_dyn[li + lj * nClu + (size_t)k * nPairs] = dis_ij;
            n_dis[li + lj * nClu] = k + 1;

            if (i != j) {
                /* --- symmetric pair (lj, li) --- */
                if (n_dis[lj + li * nClu] >= cap) {
                    new_cap = cap * 2;
                    new_dis = (double *)realloc(
                        dis_dyn, (size_t)nPairs * new_cap * sizeof(double));
                    if (!new_dis) {
                        free(dis_dyn);
                        free(n_dis);
                        ModelicaError("gFunctionGetNMax: realloc failed while growing dis_dyn.\n");
                    }
                    dis_dyn = new_dis;
                    cap = new_cap;
                }
                k = n_dis[lj + li * nClu];
                dis_dyn[lj + li * nClu + (size_t)k * nPairs] = dis_ij;
                n_dis[lj + li * nClu] = k + 1;
            }
        }
    }

    /* Return the maximum n_dis across all cluster pairs */
    n_max = 0;
    for (c = 0; c < nPairs; c++) {
        if (n_dis[c] > n_max) {
            n_max = n_dis[c];
        }
    }

    free(dis_dyn);
    free(n_dis);
    return n_max;
}

#endif /* G_FUNCTION_GET_N_MAX_C */
