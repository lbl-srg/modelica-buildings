/*
  Fill the pre-allocated distance arrays dis, wDis, and n_dis for all
  cluster pairs in a bore field.

  This function applies the same distance-accumulation loop as
  gFunctionGetNMax.c and uses the same comparison function
  (gFunctionFindDis from gFunctionDisShared.h), so the bin boundaries
  are guaranteed to be identical regardless of the platform.

  The caller (gFunction.mo) must have called gFunctionGetNMax first to
  obtain n_max, which sizes the third dimension of dis and wDis.

  Array layout (Modelica column-major, first index varies fastest):
    cooBor[nBor, 2]:           x-coords at 0..nBor-1,
                               y-coords at nBor..2*nBor-1.
    labels[nBor]:              1-indexed cluster labels.
    dis [nClu, nClu, n_max]:   element [c1,c2,k] at c1 + c2*nClu + k*nClu*nClu.
    wDis[nClu, nClu, n_max]:   same layout as dis.
    n_dis[nClu, nClu]:         element [c1,c2] at c1 + c2*nClu.
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

    /* Zero-initialise output arrays (mirrors  n_dis := zeros(...) and
       wDis := zeros(...)  at the top of the Modelica algorithm section) */
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
            /* Separation distance */
            if (i != j) {
                dxi = cooBor[i] - cooBor[j];
                dyi = cooBor[nBor + i] - cooBor[nBor + j];
                dis_ij = sqrt(dxi * dxi + dyi * dyi);
            } else {
                dis_ij = rLin;
            }

            li = labels[i] - 1; /* convert 1-indexed Modelica label to 0-indexed */
            lj = labels[j] - 1;

            /* Search for an existing distance within relTol in cluster pair (li, lj) */
            found_idx = gFunctionFindDis(
                dis + li + (size_t)lj * nClu,
                nPairs,
                n_dis[li + lj * nClu],
                dis_ij,
                relTol);

            if (found_idx >= 0) {
                /* Distance already known: increment occurrence counters */
                wDis[li + lj * nClu + (size_t)found_idx * nPairs] += 1;
                if (i != j) {
                    wDis[lj + li * nClu + (size_t)found_idx * nPairs] += 1;
                }
            } else {
                /* New distance: append to cluster pair (li, lj) */
                k = n_dis[li + lj * nClu];
                n_dis[li + lj * nClu] = k + 1;
                wDis[li + lj * nClu + (size_t)k * nPairs] += 1;
                dis [li + lj * nClu + (size_t)k * nPairs]  = dis_ij;

                if (i != j) {
                    /* Symmetric update for cluster pair (lj, li) */
                    k = n_dis[lj + li * nClu];
                    n_dis[lj + li * nClu] = k + 1;
                    wDis[lj + li * nClu + (size_t)k * nPairs] += 1;
                    dis [lj + li * nClu + (size_t)k * nPairs]  = dis_ij;
                }
            }
        }
    }
}

#endif /* G_FUNCTION_GET_DIS_C */
