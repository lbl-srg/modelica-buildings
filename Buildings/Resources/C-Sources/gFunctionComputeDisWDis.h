/*
 * Header for gFunctionComputeDisWDis.c
 *
 * Provides dynamic-memory routines used by
 * Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.
 * ThermalResponseFactors.gFunctionCountMaxDis to avoid pre-allocating
 * worst-case distance arrays during model translation.
 *
 * Issue: https://github.com/lbl-srg/modelica-buildings/issues/4597
 */
#ifndef GFUNCTION_COMPUTE_DIS_WDIS_H
#define GFUNCTION_COMPUTE_DIS_WDIS_H

/* Returns the maximum number of unique separation distances found across
 * all nClu*nClu cluster pairs, using dynamically growing per-pair arrays.
 *
 * Arguments follow Modelica external function calling conventions:
 *   cooBor  – column-major array of shape [nBor,2]:
 *               x_i = cooBor[i],  y_i = cooBor[nBor+i]  (0-based i)
 *   labels  – 1-based cluster index for each borehole
 *   cluSiz  – size of each cluster (not used in computation, kept for
 *               interface symmetry with the Modelica caller)
 *   rLin    – radius used as the self-distance for borehole i == j
 *   relTol  – relative tolerance for distance grouping
 */
int Buildings_gFunctionCountMaxDis(
    int nBor, const double* cooBor,
    int nClu, const int* labels,
    const int* cluSiz,
    double rLin, double relTol);

#endif /* GFUNCTION_COMPUTE_DIS_WDIS_H */
