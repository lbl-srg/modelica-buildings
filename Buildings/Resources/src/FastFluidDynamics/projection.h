/****************************************************************************
|
|  \file   projection.c
|
|  \brief  Solver for projection step
|
|  \author Mingang Jin, Qingyan Chen
|          Purdue University
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|
|  \date   6/15/2017
|
****************************************************************************/
#ifndef _PROJECTION_H
#define _PROJECTION_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _SOLVER_H
#define _SOLVER_H
#include "solver_gs.h"
#endif

#ifndef _SOLVER_TDMA_H
#define _SOLVER_TDMA_H
#include "solver_tdma.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _BOUNDARY_H
#define _BOUNDARY_H
#include "boundary.h"
#endif

/****************************************************************************
|  Project the velocity
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int project(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Check the mass imbalance after projection
|  This usually indicates that the energy balance after advection could be problematic.
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int check_mass_imbalance(PARA_DATA *para, REAL **var);


