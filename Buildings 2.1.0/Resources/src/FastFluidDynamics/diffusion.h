///////////////////////////////////////////////////////////////////////////////
///
/// \file   diffusion.h
///
/// \brief  Calculate the diffusion equation
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
/// This file provides functions that are used for calculating the diffusion
/// equations.
///
///////////////////////////////////////////////////////////////////////////////
#ifndef _DIFFUSION_H_
#define _DIFFUSION_H_
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _BOUNDARY_H
#define _BOUNDARY_H
#include "boundary.h"
#endif

#ifndef _SOLVER_H
#define _SOLVER_H
#include "solver.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _CHEN_ZERO_EQU_MODEL_h
#define _CHEN_ZERO_EQU_MODEL_h
#include "chen_zero_equ_model.h"
#endif

///////////////////////////////////////////////////////////////////////////////
/// Entrance of calculating diffusion equation
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type Type of variable
///\param index Index of trace substance or species
///\param psi Pointer to the variable at current time step
///\param psi0 Pointer to the variable at previous time step
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int diffusion(PARA_DATA *para, REAL **var, int var_type, int index,
               REAL *psi, REAL *psi0, int **BINDEX);

///////////////////////////////////////////////////////////////////////////////
/// Calculate coefficients for diffusion equation solver
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param psi Pointer to the variable at current time step
///\param psi0 Pointer to the variable at previous time step
///\param var_type Type of variable
///\param index Index of trace substance or species
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int coef_diff(PARA_DATA *para, REAL **var, REAL *psi, REAL *psi0,
               int var_type, int index, int **BINDEX);

///////////////////////////////////////////////////////////////////////////////
/// Calculate source term in the diffusion equation
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type Type of variable
///\param index Index of trace substances or species
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int source_diff(PARA_DATA *para, REAL **var, int var_type, int index);
