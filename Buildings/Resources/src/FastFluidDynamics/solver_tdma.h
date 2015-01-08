///////////////////////////////////////////////////////////////////////////////
///
/// \file   solver_tdma.h
///
/// \brief Tri-Diagonal Matrix Algorithm Solver
///
/// \author Mingang Jin, Qingyan Chen
///         Purdue University
///         Jin55@purdue.edu, YanChen@purdue.edu
///         Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////
#ifndef _SOLVER_TDMA_H
#define _SOLVER_TDMA_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _BOUNDARY_H
#define _BOUNDARY_H
#include "boundary.h"
#endif


///////////////////////////////////////////////////////////////////////////////
/// TDMA solver for 3D
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param type Type of variable
///\param psi Pointer to variable
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int TDMA_3D(PARA_DATA *para, REAL **var, int type, REAL *psi);

///////////////////////////////////////////////////////////////////////////////
/// TDMA solver for XY-plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to variable
///\param k K-index of the plane
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int TDMA_XY(PARA_DATA *para, REAL **var, REAL *psi, int k);

///////////////////////////////////////////////////////////////////////////////
/// TDMA solver for YZ-plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to variable
///\param i I-index of the plane
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int TDMA_YZ(PARA_DATA *para, REAL **var, REAL *psi, int i);

///////////////////////////////////////////////////////////////////////////////
/// TDMA solver for ZX-plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to variable
///\param j J-index of the plane
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int TDMA_ZX(PARA_DATA *para, REAL **var, REAL *psi, int j);

//////////////////////////////////////////////////////////////////////////////
/// TDMA solver for 1D array
///
///\param ap Pointer to coefficient for center
///\param ae Pointer to coefficient for east
///\param aw Pointer to coefficient for west
///\param b Pointer to b
///\param psi Pointer to variable
///\param LENGTH Length of the array
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int TDMA_1D(REAL *a, REAL *b, REAL *c, REAL *d, REAL *psi, int LENGTH);
