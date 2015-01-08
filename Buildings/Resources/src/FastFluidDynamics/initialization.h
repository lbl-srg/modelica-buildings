///////////////////////////////////////////////////////////////////////////////
///
/// \file   initialization.h
///
/// \brief  Set the initial values
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

#ifndef _INITIALIZATION_H
#define _INITIALIZATION_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _PARAMETER_READER_H
#define _PARAMETER_READER_H
#include "parameter_reader.h"
#endif
#ifndef _COSIMULATION_H
#define _COSIMULATION_H
#include "cosimulation.h"
#endif

#ifndef _SCI_READER_H
#define _SCI_READER_H
#include "sci_reader.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _SOLVER_H
#define _SOLVER_H
#include "solver.h"
#endif

#ifndef _GEOMETRY_H
#define _GEMOMETRY_H
#include "geometry.h"
#endif

///////////////////////////////////////////////////////////////////////////////
/// Initialize the parameters
///
///\param para Pointer to FFD parameters
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int initialize(PARA_DATA *para);

///////////////////////////////////////////////////////////////////////////////
/// Set the default value for parameters
///
///\param para Pointer to FFD parameters
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void set_default_parameter(PARA_DATA *para);

///////////////////////////////////////////////////////////////////////////////
/// Set default initial values for simulation variables
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int set_initial_data (PARA_DATA *para, REAL **var, int **BINDEX);
