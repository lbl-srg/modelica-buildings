/*
 * gFunctionComputeDisWDis.c
 *
 * Computes the maximum number of unique separation distances across all
 * cluster pairs for the g-function evaluation of a geothermal borefield.
 * Uses dynamically growing per-pair arrays to avoid the O(max_cluSiz^2)
 * worst-case static allocation that causes "Out of memory for reals" when
 * Dymola and similar translators encounter large borefields.
 *
 * The grouping logic mirrors exactly the algorithm in gFunction.mo so that
 * the returned n_dis_max is a tight upper bound for sizing the Modelica-side
 * dis[nClu,nClu,n_dis_max] and wDis[nClu,nClu,n_dis_max] arrays.
 *
 * Issue: https://github.com/lbl-srg/modelica-buildings/issues/4597
 *
 * Michael Wetter, LBNL, 2026.
 */

#include <stdlib.h>
#include <math.h>
#include "ModelicaUtilities.h"
#include "gFunctionComputeDisWDis.h"

int Buildings_gFunctionCountMaxDis(
    int nBor, const double* cooBor,
    int nClu, const int* labels,
    const int* cluSiz,
    double rLin, double relTol)
{
    int p, i, j, n;
    int nPairs = nClu * nClu;

    /* Per-cluster-pair growing arrays of unique distances */
    double** dis_lists = (double**)calloc(nPairs, sizeof(double*));
    int*     n_dis     = (int*)    calloc(nPairs, sizeof(int));
    int*     cap       = (int*)    calloc(nPairs, sizeof(int));

    if (!dis_lists || !n_dis || !cap)
        ModelicaError("Buildings_gFunctionCountMaxDis: insufficient memory for index arrays.");

    /* Iterate over all upper-triangular borehole pairs (i <= j), matching
     * the loop structure in gFunction.mo so the distance-grouping outcome
     * is identical.  cooBor is column-major: x at [i], y at [nBor+i]. */
    for (i = 0; i < nBor; i++) {
        for (j = i; j < nBor; j++) {
            double dis_ij;
            int ci, cj, pij, pji;
            int found;

            if (i != j) {
                double dx = cooBor[i]        - cooBor[j];
                double dy = cooBor[nBor + i] - cooBor[nBor + j];
                dis_ij = sqrt(dx*dx + dy*dy);
            } else {
                dis_ij = rLin;
            }

            /* labels[] is 1-based (Modelica convention) */
            ci  = labels[i] - 1;
            cj  = labels[j] - 1;
            pij = ci * nClu + cj;
            pji = cj * nClu + ci;

            /* Check whether dis_ij already exists in the (ci,cj) list */
            found = 0;
            for (n = 0; n < n_dis[pij]; n++) {
                if (fabs(dis_ij - dis_lists[pij][n]) / dis_lists[pij][n] < relTol) {
                    found = 1;
                    break;
                }
            }

            if (!found) {
                /* Append dis_ij to the (ci,cj) list, growing 2x when needed */
                if (n_dis[pij] >= cap[pij]) {
                    int new_cap = (cap[pij] == 0) ? 16 : cap[pij] * 2;
                    double* tmp = (double*)realloc(dis_lists[pij], new_cap * sizeof(double));
                    if (!tmp)
                        ModelicaError("Buildings_gFunctionCountMaxDis: insufficient memory for distance list.");
                    dis_lists[pij] = tmp;
                    cap[pij] = new_cap;
                }
                dis_lists[pij][n_dis[pij]++] = dis_ij;

                /* Replicate gFunction.mo's unconditional symmetric update:
                 * when i != j the Modelica code always appends dis_ij to
                 * dis[labels[j],labels[i],...] WITHOUT checking whether it is
                 * already present there.  For cross-cluster pairs (pji != pij)
                 * this adds dis_ij to the transposed list.  For within-cluster
                 * pairs (pji == pij) dis_ij is appended a second time to the
                 * same list, reproducing the intentional double-entry that
                 * gFunction.mo creates for same-cluster borehole pairs. */
                if (i != j) {
                    if (n_dis[pji] >= cap[pji]) {
                        int new_cap = (cap[pji] == 0) ? 16 : cap[pji] * 2;
                        double* tmp = (double*)realloc(dis_lists[pji], new_cap * sizeof(double));
                        if (!tmp)
                            ModelicaError("Buildings_gFunctionCountMaxDis: insufficient memory for distance list.");
                        dis_lists[pji] = tmp;
                        cap[pji] = new_cap;
                    }
                    dis_lists[pji][n_dis[pji]++] = dis_ij;
                }
            }
        }
    }

    /* Find the maximum count and release all allocated memory */
    {
        int n_dis_max = 1; /* at least 1 to avoid zero-size arrays */
        for (p = 0; p < nPairs; p++) {
            if (n_dis[p] > n_dis_max) n_dis_max = n_dis[p];
            free(dis_lists[p]);
        }
        free(dis_lists);
        free(n_dis);
        free(cap);
        return n_dis_max;
    }
}
