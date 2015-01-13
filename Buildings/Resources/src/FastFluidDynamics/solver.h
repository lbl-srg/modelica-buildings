///////////////////////////////////////////////////////////////////////////////
///
/// \file   solver.h
///
/// \brief  Solver of FFD
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
#ifndef _SOLVER_H
#define _SOLVER_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _DATA_WRITER_H
#define _DATA_WRITER_H
#include "data_writer.h"
#endif

#ifndef _DIFFUSION_H
#define _DIFFUSION_H
#include "diffusion.h"
#endif

#ifndef _PROJECTION_H
#define _PROJECTION_H
#include "projection.h"
#endif

#ifndef _ADVECTION_H
#define _ADVECTION_H
#include "advection.h"
#endif

#ifndef _TIMING_H
#define _TIMING_H
#include "timing.h"
#endif

#ifndef _SOLVER_GS_H
#define _SOLVER_GS_H
#include "solver_gs.h"
#endif

#ifndef _SOLVER_TDMA_H
#define _SOLVER_TDMA_H
#include "solver_tdma.h"
#endif

#ifndef _BOUNDARY_H
#define _BOUNDARY_H
#include "boundary.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _COSIMULATION_H
#define _COSIMULATION_H
#include "cosimulation.h"
#endif

///////////////////////////////////////////////////////////////////////////////
/// FFD solver
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int FFD_solver(PARA_DATA *para, REAL **var, int **BINDEX);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the temperature
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int temp_step(PARA_DATA *para, REAL **var, int **BINDEX);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the contaminant concentration
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int den_step(PARA_DATA *para, REAL **var, int **BINDEX);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the velocity
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int vel_step(PARA_DATA *para, REAL **var,int **BINDEX);

///////////////////////////////////////////////////////////////////////////////
/// Solver for equations
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param var_type Variable type
///\param Pointer to variable
///
///\return 0 if not error occurred
///////////////////////////////////////////////////////////////////////////////
int equ_solver(PARA_DATA *para, REAL **var, int Type, REAL *x);
