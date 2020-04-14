/***************************************************************************
|
|  \file   advection.h
|
|  \brief  Solver for advection step
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
|
|
|  \date   6/16/2017
|
|  This file provides functions that are used for the advection step of FFD method.
|  The advection starts with \c advect(). Then different subroutines are
|  called according to the properties of the variables that are sorted by
|  the location of variables assigned in the control volume.
|  Velocities at X, Y and Z directions are located
|  on the surface of the control volume. They are computed using
|  subroutines: \c trace_vx(), \c trace_vy() and \c trace_vz().
|  Scalar variables are in the center of control volume and they are computed
|  using \c trace_scalar().
|
***************************************************************************/

#ifndef _ADVECTION_H
#define _ADVECTION_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _BOUNDARY_H
#define _BOUNDARY_H
#include "boundary.h"
#endif

#ifndef _INTERPOLATION_H
#define _INTERPOLATION_H
#include "interpolation.h"
#endif

#ifndef _SOLVER_H
#define _SOLVER_H
#include "solver.h"
#endif


/***************************************************************************
|  Entrance of advection step
|
|  Specific method for advection will be selected according to the variable
|  type.
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type The type of variable for advection solver
| \param index Index of trace substances or species
| \param d Pointer to the computed variables at previous time step
| \param d0 Pointer to the computed variables for current time step
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
***************************************************************************/
int advect(PARA_DATA *para, REAL **var, int var_type, int index,
           REAL *d, REAL *d0, int **BINDEX);

/***************************************************************************
|  Advection for velocity at X-direction
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type The type of variable for advection solver
| \param d Pointer to the computed variables at previous time step
| \param d0 Pointer to the computed variables for current time step
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
***************************************************************************/
int trace_vx(PARA_DATA *para, REAL **var, int var_type, REAL *d, REAL *d0,
             int **BINDEX);

/***************************************************************************
|  Advection for velocity at Y-direction
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type The type of variable for advection solver
| \param d Pointer to the computed variables at previous time step
| \param d0 Pointer to the computed variables for current time step
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
***************************************************************************/
int trace_vy(PARA_DATA *para, REAL **var, int var_type, REAL *d, REAL *d0,
             int **BINDEX);

/***************************************************************************
|  Advection for velocity at Z-direction
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type The type of variable for advection solver
| \param d Pointer to the computed variables at previous time step
| \param d0 Pointer to the computed variables for current time step
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
***************************************************************************/
int trace_vz(PARA_DATA *para, REAL **var, int var_type, REAL *d, REAL *d0,
             int **BINDEX);


/***************************************************************************
|  Advection for scalar variables located in the center of control volume
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type The type of variable for advection solver
| \param index Index of trace substances or species
| \param d Pointer to the computed variables at previous time step
| \param d0 Pointer to the computed variables for current time step
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
***************************************************************************/
int trace_scalar(PARA_DATA *para, REAL **var, int var_type, int index,
                 REAL *d, REAL *d0, int **BINDEX);

/***************************************************************************
|  Find the X-location and coordinates at previous time step
|
|  Conducting backward tracing for the particle's X-location and
|  corresponding coordinates at the previous time step.
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param flag Pointer to the property of the cell
| \param x Pointer to the current position x(t) of particle
| \param u0 X-velocity at time (t-1) in location x(t)
| \param i I-index for cell at time t at x(t)
| \param j J-index for cell at time t at x(t)
| \param k K-index for cell at time t at x(t)
| \param OL Pointer to the locations of particle at time (t-1)
| \param OC Pointer to the coordinates of particle at time (t-1)
| \param LOC Pointer to flags recording if tracing back hits the boundary
| \param COOD Pointer to record the status of tracing back process
|
| \return void No return needed
***************************************************************************/
void set_x_location(PARA_DATA* para, REAL** var, REAL* flag, REAL* x, REAL u0,
	int i, int j, int k,
	REAL* OL, int* OC, int* LOC, int* COOD);

/***************************************************************************
|  Find the Y-location and coordinates at previous time step
|
|  Conducting backward tracing for the particle's Y-location and
|  corresponding coordinates at the previous time step.
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param flag Pointer to the property of the cell
| \param y Pointer to the current position y(t) of particle
| \param v0 Y-velocity at time (t-1) in location y(t)
| \param i I-index for cell at time t at y(t)
| \param j J-index for cell at time t at y(t)
| \param k K-index for cell at time t at y(t)
| \param OL Pointer to the locations of particle at time (t-1)
| \param OC Pointer to the coordinates of particle at time (t-1)
| \param LOC Pointer to flags recording if tracing back hits the boundary
| \param COOD Pointer to record the status of tracing back process
|
| \return void No return needed
***************************************************************************/
void set_y_location(PARA_DATA* para, REAL** var, REAL* flag, REAL* y, REAL v0,
	int i, int j, int k,
	REAL* OL, int* OC, int* LOC, int* COOD);


void set_z_location(PARA_DATA* para, REAL** var, REAL* flag, REAL* z, REAL w0,
	int i, int j, int k,
	REAL* OL, int* OC, int* LOC, int* COOD);

int coef_adv(PARA_DATA* para, REAL** var, REAL* psi, REAL* psi0, int var_type, int index, int** BINDEX);
int implicit_vx(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX);
int implicit_vy(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX);
int implicit_vz(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX);
int implicit_scalar(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX);
