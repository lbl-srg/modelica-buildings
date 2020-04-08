/****************************************************************************
|
|  \file   solver_gs.c
|
|  \brief  Gauss-Seidel solvers
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

#ifndef _SOLVER_GS_H
#define _SOLVER_GS_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _BOUNDARY_H
#define _BOUNDARY_H
#include "boundary.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif


/****************************************************************************
|  Gauss-Seidel scheme
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param Type Type of variable
| \param x Pointer to variable
|
| \return Residual
****************************************************************************/
int GS_itr(PARA_DATA* para, REAL** var, REAL* x, REAL* flag, int num_swipe);

/****************************************************************************
|  Gauss-Seidel solver for terms other than pressure
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param flag Pointer to the cell property flag
| \param x Pointer to variable
|
| \return Residual
****************************************************************************/
int Gauss_Seidel(PARA_DATA* para, REAL** var, REAL* x, REAL* flagp, int num_swipe);

/****************************************************************************
|  Jacobi Scheme for pressure
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param Type Type of variable
| \param x Pointer to variable
|
| \return Residual
****************************************************************************/
int Jacobi_iter(PARA_DATA* para, REAL** var, REAL* x, REAL* flag, int num_swipe);

/****************************************************************************
|  Jacobi solver for pressure
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param Type Type of variable
| \param x Pointer to variable
|
| \return Residual
****************************************************************************/
int Jacobi(PARA_DATA *para, REAL **var, REAL *flag, REAL *x, int num_swipe);

