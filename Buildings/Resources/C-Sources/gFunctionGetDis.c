/*
  Fill the pre-allocated distance arrays dis, wDis, and n_dis for all
  cluster pairs in a bore field.

  This function applies the same distance-accumulation loop as
  gFunctionGetNMax.c and uses the same comparison function
  (gFunctionFindDis from gFunctionDisShared.h), so the bin boundaries
  are guaranteed to be identical regardless of the platform.

  The caller (gFunction.mo) must have called gFunctionGetNMax first to
  obtain n_max, which sizes the third dimension of dis and wDis.

  Array layout (omc passes multi-dimensional arrays in row-major order,
  last index varies fastest):
    cooBor[nBor, 2]:   element [i,j] at (i-1)*2 + (j-1).
                       x-coord of borehole i (1-indexed) at 2*(i-1),
                       y-coord at 2*(i-1)+1.
    labels[nBor]:      1-indexed cluster labels (1-D, no layout issue).
    dis [nClu, nClu, n_max]: element [k1,k2,k3] at
                       (k1-1)*nClu*n_max + (k2-1)*n_max + (k3-1).
    wDis[nClu, nClu, n_max]: same layout as dis.
    n_dis[nClu, nClu]:  element [k1,k2] at (k1-1)*nClu + (k2-1).
*/

#ifndef G_FUNCTION_GET_DIS_C
#define G_FUNCTION_GET_DIS_C

#include <string.h>
#include <math.h>
#include "gFunctionDisShared.h"

void gFunctionGetDis(
    int nBor,
    const double *cooBor,
    double rLin,
    int nClu,
    const int *labels,
    double relTol,
    int n_max,
    double *dis,
    int *wDis,
    int *n_dis)
{
    const int nPairs = nClu * nClu;
    int i, j, li, lj, found_idx, k;
    double dis_ij, dxi, dyi;

    /* Zero-initialise output arrays */
    memset(n_dis, 0, (size_t)nPairs * sizeof(int));
    memset(wDis,  0, (size_t)nPairs * n_max * sizeof(int));

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

            /*
              Row-major [nClu, nClu, n_max]: base pointer for pair (li, lj),
              stride 1 (k varies fastest as last index).
            */
            found_idx = gFunctionFindDis(
                dis + li * nClu * n_max + lj * n_max,
                1,
                n_dis[li * nClu + lj],
                dis_ij,
                relTol);

            if (found_idx >= 0) {
                /* Distance already known: increment occurrence counters */
                wDis[li * nClu * n_max + lj * n_max + found_idx] += 1;
                if (i != j) {
                    wDis[lj * nClu * n_max + li * n_max + found_idx] += 1;
                }
            } else {
                /* New distance: append to cluster pair (li, lj) */
                k = n_dis[li * nClu + lj];
                n_dis[li * nClu + lj] = k + 1;
                wDis[li * nClu * n_max + lj * n_max + k] += 1;
                dis [li * nClu * n_max + lj * n_max + k]  = dis_ij;

                if (i != j) {
                    /* Symmetric update for cluster pair (lj, li) */
                    k = n_dis[lj * nClu + li];
                    n_dis[lj * nClu + li] = k + 1;
                    wDis[lj * nClu * n_max + li * n_max + k] += 1;
                    dis [lj * nClu * n_max + li * n_max + k]  = dis_ij;
                }
            }
        }
    }
}

#endif /* G_FUNCTION_GET_DIS_C */
