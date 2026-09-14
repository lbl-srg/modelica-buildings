/****************************************************************************
|
|  \file   initialization.h
|
|  \brief  Set the initial values
|
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Mingang Jin, Qingyan Chen
|          Purdue University
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
|
|  \date   4/5/2020
|
****************************************************************************/

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

#ifndef FFD_ISAT
#ifndef _COSIMULATION_H
#define _COSIMULATION_H
#include "cosimulation.h"
#endif
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


/****************************************************************************
| Initialize the parameters
|
| \param para Pointer to FFD parameters
|
| \return 0 if no error occurred
****************************************************************************/
int initialize(PARA_DATA * para);

/****************************************************************************
|  Set the default value for parameters
|
| \param para Pointer to FFD parameters
|
| \return No return needed
****************************************************************************/
void set_default_parameter(PARA_DATA* para);

/****************************************************************************
|  Set default initial values for simulation variables
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int set_initial_data(PARA_DATA* para, REAL** var, int** BINDEX);

/****************************************************************************
|  Loop through all the BC cells and find if tiles there
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int if_exist_tiles(PARA_DATA* para, REAL** var, int** BINDEX);

int init_para_simp(PARA_DATA* para, PARA_DATA_SIMP* para_simp);

/*flatten var*/
int flat_var(PARA_DATA* para, REAL** var, REAL* var_flat);
/* flatten bindex */
int flat_index(PARA_DATA* para, int** BINDEX, int* bindex_flat);
int unflat_var(PARA_DATA* para, REAL** var, REAL* var_flat);


