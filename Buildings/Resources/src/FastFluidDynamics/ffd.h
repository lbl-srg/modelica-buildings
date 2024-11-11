/****************************************************************************
|
|  \file ffd.h
|
|  \brief Main routine of Fast Fluid Dynamics
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
#ifndef _FFD_H
#define _FFD_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef FFD_ISAT
#ifndef _FFD_DLL_H
#define FFD_DLL_H
#include "ffd_dll.h"
#endif
#endif

#ifndef _TIMING_H
#define _TIMING_H
#include "timing.h"
#endif

#ifndef _SOLVER_H
#define _SOLVER_H
#include "solver.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _DATA_WRITER_H
#define _DATA_WRITER_H
#include "data_writer.h"
#endif

#ifndef _INITIALIZATION_H
#define _INITIALIZATION_H
#include "initialization.h"
#endif

/*
* Assign the parameter for coupled simulation
*
* @para cosim Pointer to the coupled simulation parameters
*
* @return 0 if no error occurred
*/
int ffd_cosimulation(CosimulationData * cosim);

/****************************************************************************
|  Main routine of FFD
|
| \para coupled simulation Integer to identify the simulation type
|
| \return 0 if no error occurred
****************************************************************************/
int ffd(int cosimulation);

/****************************************************************************
|  Allocate memory for variables
|
| \param para Pointer to FFD parameters
|
| \return No return needed
****************************************************************************/
int allocate_memory(PARA_DATA* para);

int write_output_data(PARA_DATA *para, REAL **var, int **BINDEX);

/****************************************************************************
|  Write error message to Modelica
|
| \para msg Pointer to message to be written.
|
| \return no return
****************************************************************************/
void modelicaError(char *msg);


