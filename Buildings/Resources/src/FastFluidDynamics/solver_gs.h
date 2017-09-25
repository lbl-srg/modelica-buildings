/*
	*
	* @file   solver_gs.h
	*
	* @brief  Gauss-Seidel solvers
	*
	* @author Mingang Jin, Qingyan Chen
	*         Purdue University
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*         Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* @date   8/3/2013
	*
	*/

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

/*
	* Gauss-Seidel solver for pressure
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param Type Type of variable
	* @param x Pointer to variable
	*
	* @return Residual
	*/
REAL GS_P(PARA_DATA *para, REAL **var, int Type, REAL *x);

/*
	* Gauss-Seidel solver
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param flag Pointer to the cell property flag
	* @param x Pointer to variable
	*
	* @return Residual
	*/
REAL Gauss_Seidel(PARA_DATA *para, REAL **var, REAL *flagp, REAL *x);
