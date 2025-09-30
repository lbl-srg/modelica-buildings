/*****************************************************************************
|
|  \file   advection.c
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
*****************************************************************************/

#include "advection.h"

/*****************************************************************************
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
*****************************************************************************/
int advect(PARA_DATA *para, REAL **var, int var_type, int index,
           REAL *d/*Current Value*/, REAL *d0 /*Future Value*/, int **BINDEX) {
  int flag;

  /****************************************************************************
  | Select different advection function according to the variables
  ****************************************************************************/
  switch (var_type) {
  /*-------------------------------------------------------------------------
  | Velocity at x direction
  -------------------------------------------------------------------------*/
  case VX:
      if (para->solv->advection_solver == UPWIND || para->solv->advection_solver == CENTRAL) {
        flag = implicit_vx(para, var, var_type, d, d0, index, BINDEX);
      }
      else
        flag = trace_vx(para, var, var_type, d, d0, BINDEX);

      if(flag!=0)
    ffd_log("advect(): Failed in advection for X-velocity.",
        FFD_ERROR);
    break;
  /*-------------------------------------------------------------------------
  | Velocity at y direction
  -------------------------------------------------------------------------*/
  case VY:
      if (para->solv->advection_solver == UPWIND || para->solv->advection_solver == CENTRAL) {
        flag = implicit_vy(para, var, var_type, d, d0, index, BINDEX);
      }
      else
        flag = trace_vy(para, var, var_type, d, d0, BINDEX);

    if(flag!=0)
    ffd_log("advect(): Failed in advection for Y-velocity.",
        FFD_ERROR);
    break;
  /*-------------------------------------------------------------------------
  | Velocity at z direction
  -------------------------------------------------------------------------*/
  case VZ:
      if (para->solv->advection_solver == UPWIND || para->solv->advection_solver == CENTRAL) {
        flag = implicit_vz(para, var, var_type, d, d0, index, BINDEX);
      }
      else
        flag = trace_vz(para, var, var_type, d, d0, BINDEX);

    if(flag!=0)
    ffd_log("advect(): Failed in advection for Z-velocity.",
        FFD_ERROR);
    break;
  /*-------------------------------------------------------------------------
  | Temperature, Trace and Species
  -------------------------------------------------------------------------*/
  case TEMP:
  case Xi1:
  case Xi2:
  case C1:
  case C2:
    if (para->solv->advection_solver == UPWIND || para->solv->advection_solver == CENTRAL) {
      flag = implicit_scalar(para, var, var_type, d, d0, index, BINDEX);
    }
    else
      flag = trace_scalar(para, var, var_type, index, d, d0, BINDEX);

    if(flag!=0) {
      sprintf(msg,
        "advect(): Failed in advection for scalar variable type %d.",
        var_type);
      ffd_log(msg, FFD_ERROR);
    }
    break;
  /*-------------------------------------------------------------------------
  | Variables not available in the FFD
  -------------------------------------------------------------------------*/
  default:
    flag = 1;
    sprintf(msg, "advect(): Advection function not defined for variable "
    "type %d.", var_type);
    ffd_log(msg, FFD_ERROR);
  }

  return flag;
} /*End of advect()*/


/****************************************************************************
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
****************************************************************************/
int trace_vx(PARA_DATA *para, REAL **var, int var_type, REAL *d, REAL *d0,
	int **BINDEX) {
  int i, j, k;
  int it;
  int itmax = 20000; /*Max number of iterations for backward tracing*/
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL x_1, y_1, z_1;
  REAL dt = para->mytime->dt;
  REAL u0, v0, w0;
  REAL *x = var[X], *y = var[Y],  *z = var[Z];
  REAL *gx = var[GX];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL *flagu = var[FLAGU];
  int  COOD[3], LOC[3];
  REAL OL[3];
  int  OC[3];

  /****************************************************************************
  | Go through all the cells with VX
  ****************************************************************************/
  FOR_U_CELL
    if(flagu[IX(i,j,k)]>=0) continue;
	
	/*-------------------------------------------------------------------------
	| Step 1: Tracing Back
	-------------------------------------------------------------------------*/
	/* Get velocities at the location of VX */
	u0 = u[IX(i, j, k)];
	v0 = (REAL)0.5
	  * ((v[IX(i, j, k)] + v[IX(i, j - 1, k)]) * (x[IX(i + 1, j, k)] - gx[IX(i, j, k)])
		  + (v[IX(i + 1, j, k)] + v[IX(i + 1, j - 1, k)]) * (gx[IX(i, j, k)] - x[IX(i, j, k)]))
	  / (x[IX(i + 1, j, k)] - x[IX(i, j, k)]);
	w0 = (REAL)0.5
	  * ((w[IX(i, j, k)] + w[IX(i, j, k - 1)]) * (x[IX(i + 1, j, k)] - gx[IX(i, j, k)])
		  + (w[IX(i + 1, j, k)] + w[IX(i + 1, j, k - 1)]) * (gx[IX(i, j, k)] - x[IX(i, j, k)]))
	  / (x[IX(i + 1, j, k)] - x[IX(i, j, k)]);
	/* Find the location at previous time step */
	/* Due to the staggered grids utilized, gx is the location for vx */
	OL[X] = gx[IX(i, j, k)] - u0 * dt;
	OL[Y] = y[IX(i, j, k)] - v0 * dt;
	OL[Z] = z[IX(i, j, k)] - w0 * dt;
	/* Initialize the coordinates of previous step */
	/* Start to find the according coordinates of OL in previous step */
	/* OC is the trace back coordinates */
	OC[X] = i;
	OC[Y] = j;
	OC[Z] = k;
	/* Indicators for completeness */
	/* Completed: 0; In process: 1 */
	COOD[X] = 1;
	COOD[Y] = 1;
	COOD[Z] = 1;
	/* Indicators for hitting the boundary */
	/* Hit the boundary: 0; Not hit the boundary: 1 */
	LOC[X] = 1;
	LOC[Y] = 1;
	LOC[Z] = 1;
	/*Initialize the number of iterations*/
	it = 1;
	/* Trace back more if the any of the trace is still in process */
	while (COOD[X] == 1 || COOD[Y] == 1 || COOD[Z] == 1)
	{
	  it++;
	  /* If trace in X is NOT finished and does NOT hit the boundary */
	  if (COOD[X] == 1 && LOC[X] == 1)
		  set_x_location(para, var, flagu, gx, u0, i, j, k, OL, OC, LOC, COOD);
	  /* If trace in Y is NOT finished and does NOT hit the boundary */
	  if (COOD[Y] == 1 && LOC[Y] == 1)
		  set_y_location(para, var, flagu, y, v0, i, j, k, OL, OC, LOC, COOD);
	  /* If trace in Z is NOT finished and does NOT hit the boundary */
	  if (COOD[Z] == 1 && LOC[Z] == 1)
		  set_z_location(para, var, flagu, z, w0, i, j, k, OL, OC, LOC, COOD);

	  if (it > itmax)
	  {
		  printf("Error: advection.c, can not track the location for VX(%d, %d,%d)",
			  i, j, k);
		  printf("after %d iterations.\n", it);
		  return 1;
	  }
	} /* End of while() for backward tracing */

	/* Set the coordinates of previous location if it is as boundary */
	/* To step back one cell is because in set_x_location when hitting the wall */
	/* the coordinates moves forward for one cell */
	if (u0 > 0 && LOC[X] == 0) OC[X] -= 1;
	if (v0 > 0 && LOC[Y] == 0) OC[Y] -= 1;
	if (w0 > 0 && LOC[Z] == 0) OC[Z] -= 1;

	/* Set coordinates of the previous location if not hitting the boundary */
	/* To move one step back is for sake of the interpolation */
	if (u0 < 0 && LOC[X] == 1) OC[X] -= 1;
	if (v0 < 0 && LOC[Y] == 1) OC[Y] -= 1;
	if (w0 < 0 && LOC[Z] == 1) OC[Z] -= 1;

	/*-------------------------------------------------------------------------
	| Interpolate
	-------------------------------------------------------------------------*/
	x_1 = (OL[X] - gx[IX(OC[X], OC[Y], OC[Z])])
	  / (gx[IX(OC[X] + 1, OC[Y], OC[Z])] - gx[IX(OC[X], OC[Y], OC[Z])]);
	y_1 = (OL[Y] - y[IX(OC[X], OC[Y], OC[Z])])
	  / (y[IX(OC[X], OC[Y] + 1, OC[Z])] - y[IX(OC[X], OC[Y], OC[Z])]);
	z_1 = (OL[Z] - z[IX(OC[X], OC[Y], OC[Z])])
	  / (z[IX(OC[X], OC[Y], OC[Z] + 1)] - z[IX(OC[X], OC[Y], OC[Z])]);

	d[IX(i, j, k)] = interpolation(para, d0, x_1, y_1, z_1, OC[X], OC[Y], OC[Z]);

  END_FOR /* End of loop for all cells */

  /****************************************************************************
  | define the boundary condition
  ****************************************************************************/
  set_bnd(para, var, var_type, 0, d, BINDEX);

  return 0;
} /*End of trace_vx()*/

/****************************************************************************
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
****************************************************************************/
int trace_vy(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0,
	int** BINDEX) {
  int i, j, k;
  int it;
  int itmax = 20000; /* Max number of iterations for backward tracing */
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL x_1, y_1, z_1;
  REAL dt = para->mytime->dt;
  REAL u0, v0, w0;
  REAL* x = var[X], * y = var[Y], * z = var[Z];
  REAL* gy = var[GY];
  REAL* u = var[VX], * v = var[VY], * w = var[VZ];
  REAL* flagv = var[FLAGV];
  int  COOD[3], LOC[3];
  REAL OL[3];
  int  OC[3];

  FOR_V_CELL
	/* Do not trace for boundary cells */
	if (flagv[IX(i, j, k)] >= 0) continue;

	/*-------------------------------------------------------------------------
	| Step 1: Tracing Back
	-------------------------------------------------------------------------*/
	/* Get velocities at the location of VY */
	u0 = (REAL)0.5
		* ((u[IX(i, j, k)] + u[IX(i - 1, j, k)]) * (y[IX(i, j + 1, k)] - gy[IX(i, j, k)])
			+ (u[IX(i, j + 1, k)] + u[IX(i - 1, j + 1, k)]) * (gy[IX(i, j, k)] - y[IX(i, j, k)]))
		/ (y[IX(i, j + 1, k)] - y[IX(i, j, k)]);
	v0 = v[IX(i, j, k)];
	w0 = (REAL)0.5
		* ((w[IX(i, j, k)] + w[IX(i, j, k - 1)]) * (y[IX(i, j + 1, k)] - gy[IX(i, j, k)])
			+ (w[IX(i, j + 1, k)] + w[IX(i, j + 1, k - 1)]) * (gy[IX(i, j, k)] - y[IX(i, j, k)]))
		/ (y[IX(i, j + 1, k)] - y[IX(i, j, k)]);
	/* Find the location at previous time step */
	OL[X] = x[IX(i, j, k)] - u0 * dt;
	OL[Y] = gy[IX(i, j, k)] - v0 * dt;
	OL[Z] = z[IX(i, j, k)] - w0 * dt;
	/* Initialize the coordinates of previous step */
	OC[X] = i;
	OC[Y] = j;
	OC[Z] = k;
	/* Initialize the signs for track process */
	/* Completed: 0; In process: 1 */
	COOD[X] = 1;
	COOD[Y] = 1;
	COOD[Z] = 1;
	/* Initialize the signs for recording if the track back hits the boundary */
	/* Hit the boundary: 0; Not hit the boundary: 1 */
	LOC[X] = 1;
	LOC[Y] = 1;
	LOC[Z] = 1;
	/*Initialize the number of iterations */
	it = 1;

	/* Trace back more if the any of the trace is still in process */
	while (COOD[X] == 1 || COOD[Y] == 1 || COOD[Z] == 1) {
		it++;
		if (COOD[X] == 1 && LOC[X] == 1)
			set_x_location(para, var, flagv, x, u0, i, j, k, OL, OC, LOC, COOD);
		if (COOD[Y] == 1 && LOC[Y] == 1)
			set_y_location(para, var, flagv, gy, v0, i, j, k, OL, OC, LOC, COOD);
		if (COOD[Z] == 1 && LOC[Z] == 1)
			set_z_location(para, var, flagv, z, w0, i, j, k, OL, OC, LOC, COOD);

		if (it > itmax) {
			printf("Error: advection.c can not track the location for VY(%d, %d,%d)",
				i, j, k);
			printf("after %d iterations.\n", it);
			return 1;
		}
	} /* End of while() loop */

	/* Set the coordinates of previous location if it is as boundary */
	if (u0 >= 0 && LOC[X] == 0) OC[X] -= 1;
	if (v0 >= 0 && LOC[Y] == 0) OC[Y] -= 1;
	if (w0 >= 0 && LOC[Z] == 0) OC[Z] -= 1;

	if (u0 < 0 && LOC[X] == 1) OC[X] -= 1;
	if (v0 < 0 && LOC[Y] == 1) OC[Y] -= 1;
	if (w0 < 0 && LOC[Z] == 1) OC[Z] -= 1;

	/*-------------------------------------------------------------------------
	| Interpolating for all variables
	-------------------------------------------------------------------------*/
	x_1 = (OL[X] - x[IX(OC[X], OC[Y], OC[Z])])
		/ (x[IX(OC[X] + 1, OC[Y], OC[Z])] - x[IX(OC[X], OC[Y], OC[Z])]);
	y_1 = (OL[Y] - gy[IX(OC[X], OC[Y], OC[Z])])
		/ (gy[IX(OC[X], OC[Y] + 1, OC[Z])] - gy[IX(OC[X], OC[Y], OC[Z])]);
	z_1 = (OL[Z] - z[IX(OC[X], OC[Y], OC[Z])])
		/ (z[IX(OC[X], OC[Y], OC[Z] + 1)] - z[IX(OC[X], OC[Y], OC[Z])]);
	d[IX(i, j, k)] = interpolation(para, d0, x_1, y_1, z_1, OC[X], OC[Y], OC[Z]);
  END_FOR /* End of For() loop for each cell */

  /*---------------------------------------------------------------------------
  | define the b.c.
  ---------------------------------------------------------------------------*/
  set_bnd(para, var, var_type, 0, d, BINDEX);
  return 0;
} /* End of trace_vy() */

/****************************************************************************
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
****************************************************************************/
int trace_vz(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0,
	int** BINDEX) {
  int i, j, k;
  int it;
  int itmax = 20000; /* Max number of iterations for backward tracing */
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL x_1, y_1, z_1;
  REAL dt = para->mytime->dt;
  REAL u0, v0, w0;
  REAL* x = var[X], * y = var[Y], * z = var[Z];
  REAL* gz = var[GZ];
  REAL* u = var[VX], * v = var[VY], * w = var[VZ];
  REAL* flagw = var[FLAGW];
  int  COOD[3], LOC[3];
  REAL OL[3];
  int  OC[3];

  FOR_W_CELL
	/* Do not trace for boundary cells */
	if (flagw[IX(i, j, k)] >= 0) continue;

	/*-------------------------------------------------------------------------
	| Step 1: Tracing Back
	-------------------------------------------------------------------------*/
	/* Get velocities at the location of VZ */
	u0 = (REAL)0.5
		* ((u[IX(i, j, k)] + u[IX(i - 1, j, k)]) * (z[IX(i, j, k + 1)] - gz[IX(i, j, k)])
			+ (u[IX(i, j, k + 1)] + u[IX(i - 1, j, k + 1)]) * (gz[IX(i, j, k)] - z[IX(i, j, k)]))
		/ (z[IX(i, j, k + 1)] - z[IX(i, j, k)]);
	v0 = (REAL)0.5
		* ((v[IX(i, j, k)] + v[IX(i, j - 1, k)]) * (z[IX(i, j, k + 1)] - gz[IX(i, j, k)])
			+ (v[IX(i, j, k + 1)] + v[IX(i, j - 1, k + 1)]) * (gz[IX(i, j, k)] - z[IX(i, j, k)]))
		/ (z[IX(i, j, k + 1)] - z[IX(i, j, k)]);
	w0 = w[IX(i, j, k)];
	/* Find the location at previous time step */
	OL[X] = x[IX(i, j, k)] - u0 * dt;
	OL[Y] = y[IX(i, j, k)] - v0 * dt;
	OL[Z] = gz[IX(i, j, k)] - w0 * dt;
	/* Initialize the coordinates of previous step */
	OC[X] = i;
	OC[Y] = j;
	OC[Z] = k;
	/* Initialize the signs for track process */
	/* Completed: 0; In process: 1 */
	COOD[X] = 1;
	COOD[Y] = 1;
	COOD[Z] = 1;
	/* Initialize the signs for recording if the track back hits the boundary */
	/* Hit the boundary: 0; Not hit the boundary: 1 */
	LOC[X] = 1;
	LOC[Y] = 1;
	LOC[Z] = 1;
	/*Initialize the number of iterations*/
	it = 1;

	/* Trace back more if the any of the trace is still in process */
	while (COOD[X] == 1 || COOD[Y] == 1 || COOD[Z] == 1) {
		it++;
		if (COOD[X] == 1 && LOC[X] == 1)
			set_x_location(para, var, flagw, x, u0, i, j, k, OL, OC, LOC, COOD);
		if (COOD[Y] == 1 && LOC[Y] == 1)
			set_y_location(para, var, flagw, y, v0, i, j, k, OL, OC, LOC, COOD);
		if (COOD[Z] == 1 && LOC[Z] == 1)
			set_z_location(para, var, flagw, gz, w0, i, j, k, OL, OC, LOC, COOD);

		if (it > itmax) {
			printf("Error: advection.c can not track the location for VY(%d, %d,%d)",
				i, j, k);
			printf("after %d iterations.\n", it);
			return 1;
		}
	} /* End of while() loop */

	/* Set the coordinates of previous location if it is as boundary */
	if (u0 >= 0 && LOC[X] == 0) OC[X] -= 1;
	if (v0 >= 0 && LOC[Y] == 0) OC[Y] -= 1;
	if (w0 >= 0 && LOC[Z] == 0) OC[Z] -= 1;

	if (u0 < 0 && LOC[X] == 1) OC[X] -= 1;
	if (v0 < 0 && LOC[Y] == 1) OC[Y] -= 1;
	if (w0 < 0 && LOC[Z] == 1) OC[Z] -= 1;

	/*-------------------------------------------------------------------------
	| Interpolating for all variables
	-------------------------------------------------------------------------*/
	x_1 = (OL[X] - x[IX(OC[X], OC[Y], OC[Z])])
		/ (x[IX(OC[X] + 1, OC[Y], OC[Z])] - x[IX(OC[X], OC[Y], OC[Z])]);
	y_1 = (OL[Y] - y[IX(OC[X], OC[Y], OC[Z])])
		/ (y[IX(OC[X], OC[Y] + 1, OC[Z])] - y[IX(OC[X], OC[Y], OC[Z])]);
	z_1 = (OL[Z] - gz[IX(OC[X], OC[Y], OC[Z])])
		/ (gz[IX(OC[X], OC[Y], OC[Z] + 1)] - gz[IX(OC[X], OC[Y], OC[Z])]);
	d[IX(i, j, k)] = interpolation(para, d0, x_1, y_1, z_1, OC[X], OC[Y], OC[Z]);
  END_FOR

  /*---------------------------------------------------------------------------
  | define the b.c.
  ---------------------------------------------------------------------------*/
  set_bnd(para, var, var_type, 0, d, BINDEX);
  return 0;
} /* End of trace_vz() */

/****************************************************************************
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
****************************************************************************/
int trace_scalar(PARA_DATA* para, REAL** var, int var_type, int index,
	REAL* d, REAL* d0, int** BINDEX) {
  int i, j, k;
  int it;
  int itmax = 20000; /* Max number of iterations for backward tracing */
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL x_1, y_1, z_1;
  REAL dt = para->mytime->dt;
  REAL u0, v0, w0;
  REAL* x = var[X], * y = var[Y], * z = var[Z];
  REAL* u = var[VX], * v = var[VY], * w = var[VZ];
  REAL* flagp = var[FLAGP];
  int  COOD[3], LOC[3];
  REAL OL[3];
  int  OC[3];

  FOR_EACH_CELL
	/* Do not trace for boundary cells */
	if (flagp[IX(i, j, k)] >= 0) continue;

	/*-------------------------------------------------------------------------
	| Step 1: Tracing Back
	-------------------------------------------------------------------------*/
	/* Get velocities at the location of scalar variable */
	u0 = (REAL)0.5 * (u[IX(i, j, k)] + u[IX(i - 1, j, k)]);
	v0 = (REAL)0.5 * (v[IX(i, j, k)] + v[IX(i, j - 1, k)]);
	w0 = (REAL)0.5 * (w[IX(i, j, k)] + w[IX(i, j, k - 1)]);
	/* Find the location at previous time step */
	OL[X] = x[IX(i, j, k)] - u0 * dt;
	OL[Y] = y[IX(i, j, k)] - v0 * dt;
	OL[Z] = z[IX(i, j, k)] - w0 * dt;
	/* Initialize the coordinates of previous step */
	OC[X] = i;
	OC[Y] = j;
	OC[Z] = k;
	/* Initialize the signs for tracing process */
	/* Completed: 0; In process: 1 */
	COOD[X] = 1;
	COOD[Y] = 1;
	COOD[Z] = 1;
	/* Initialize the flags for recording if the tracing back hits the boundary */
	/* Hit the boundary: 0; Not hit the boundary: 1 */
	LOC[X] = 1;
	LOC[Y] = 1;
	LOC[Z] = 1;
	/*Initialize the number of iterations*/
	it = 1;

	/* Trace back more if the any of the trace is still in process */
	while (COOD[X] == 1 || COOD[Y] == 1 || COOD[Z] == 1) {
		it++;
		/* If trace in X is in process and has not hit the boundary */
		if (COOD[X] == 1 && LOC[X] == 1)
			set_x_location(para, var, flagp, x, u0, i, j, k, OL, OC, LOC, COOD);
		/* If trace in Y is in process and has not hit the boundary */
		if (COOD[Y] == 1 && LOC[Y] == 1)
			set_y_location(para, var, flagp, y, v0, i, j, k, OL, OC, LOC, COOD);
		/* If trace in Z is in process and has not hit the boundary */
		if (COOD[Z] == 1 && LOC[Z] == 1)
			set_z_location(para, var, flagp, z, w0, i, j, k, OL, OC, LOC, COOD);
		if (it > itmax) {
			sprintf(msg, "trace_scalar(): Could not track the location for scalar "
				"variable %d at cell(%d, %d,%d) after %d iterations",
				var_type, i, j, k, it);
			ffd_log(msg, FFD_ERROR);
			return 1;
		}
	} /* End of while() for backward tracing */

	/* Set the coordinates of previous location if it is as boundary */
	if (u0 >= 0 && LOC[X] == 0) OC[X] -= 1;
	if (v0 >= 0 && LOC[Y] == 0) OC[Y] -= 1;
	if (w0 >= 0 && LOC[Z] == 0) OC[Z] -= 1;

	if (u0 < 0 && LOC[X] == 1) OC[X] -= 1;
	if (v0 < 0 && LOC[Y] == 1) OC[Y] -= 1;
	if (w0 < 0 && LOC[Z] == 1) OC[Z] -= 1;

	/*Store the local minimum and maximum values*/
	var[LOCMIN][IX(i, j, k)] = check_min(para, d0, OC[X], OC[Y], OC[Z]);
	var[LOCMAX][IX(i, j, k)] = check_max(para, d0, OC[X], OC[Y], OC[Z]);

	/*-------------------------------------------------------------------------
	| Interpolate
	-------------------------------------------------------------------------*/
	x_1 = (OL[X] - x[IX(OC[X], OC[Y], OC[Z])])
		/ (x[IX(OC[X] + 1, OC[Y], OC[Z])] - x[IX(OC[X], OC[Y], OC[Z])]);
	y_1 = (OL[Y] - y[IX(OC[X], OC[Y], OC[Z])])
		/ (y[IX(OC[X], OC[Y] + 1, OC[Z])] - y[IX(OC[X], OC[Y], OC[Z])]);
	z_1 = (OL[Z] - z[IX(OC[X], OC[Y], OC[Z])])
		/ (z[IX(OC[X], OC[Y], OC[Z] + 1)] - z[IX(OC[X], OC[Y], OC[Z])]);
	d[IX(i, j, k)] = interpolation(para, d0, x_1, y_1, z_1, OC[X], OC[Y], OC[Z]);
  END_FOR /* End of loop for all cells */

  /*---------------------------------------------------------------------------
  | Define the b.c.
  ---------------------------------------------------------------------------*/
  set_bnd(para, var, var_type, index, d, BINDEX);
  return 0;
} /* End of trace_scalar() */

/****************************************************************************
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
****************************************************************************/
void set_x_location(PARA_DATA* para, REAL** var, REAL* flag, REAL* x, REAL u0,
	int i, int j, int k,
	REAL* OL/*the coordinates*/, int* OC/*the index*/, int* LOC/*hit wall*/, int* COOD/*finish*/) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);

  /****************************************************************************
  | If the previous location is equal to current position
  | stop the process (COOD[X] = 0)
  ****************************************************************************/
  if (OL[X] == x[IX(OC[X], OC[Y], OC[Z])])
	COOD[X] = 0;
  /****************************************************************************
  | Otherwise, if previous location is on the west of the current position
  ****************************************************************************/
  else if (OL[X] < x[IX(OC[X], OC[Y], OC[Z])]) {
	/* If has not reached the boundary yet, move to west */
	if (OC[X] > 0)
		OC[X] -= 1;

	/* If the previous position is on the east of new location, stop the process */
	if (OL[X] >= x[IX(OC[X], OC[Y], OC[Z])])
		COOD[X] = 0;

	/* If the new position is solid */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 1) {
		/* Use the east cell for new location */
		OL[X] = x[IX(OC[X] + 1, OC[Y], OC[Z])];
		OC[X] += 1;
		/* Hit the boundary */
		LOC[X] = 0;
		/* Stop the trace process */
		COOD[X] = 0;
	} /* End of if() for solid */

	/* If the new position is inlet or outlet */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 0 || flag[IX(OC[X], OC[Y], OC[Z])] == 2 || flag[IX(OC[X], OC[Y], OC[Z])] == 3) {
		/* Use new position */
		OL[X] = x[IX(OC[X], OC[Y], OC[Z])];
		/* use east cell for coordinate */
		OC[X] += 1;
		/* Hit the boundary */
		LOC[X] = 0;
		/* Stop the trace process */
		COOD[X] = 0;
	} /* End of if() for inlet or outlet */
  } /* End of if() for previous position is on the west of new position */
  /****************************************************************************
  | Otherwise, if previous location is on the east of the current position
  ****************************************************************************/
  else {
	/* If not at the east boundary */
	if (OC[X] <= imax)
		/* Move to east */
		OC[X] += 1;

	/* If the previous position is  on the west of new position */
	if (OL[X] <= x[IX(OC[X], OC[Y], OC[Z])])
		/* Stop the trace process */
		COOD[X] = 0;

	/* If the cell is solid */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 1) {
		/* Use west cell */
		OL[X] = x[IX(OC[X] - 1, OC[Y], OC[Z])];
		OC[X] -= 1;
		/* Hit the boundary */
		LOC[X] = 0;
		/* Stop the trace process */
		COOD[X] = 0;
	} /* End of if() for solid */

	/* If the new position is inlet or outlet */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 0 || flag[IX(OC[X], OC[Y], OC[Z])] == 2 || flag[IX(OC[X], OC[Y], OC[Z])] == 3) {
		/* Use the current cell for previous location */
		OL[X] = x[IX(OC[X], OC[Y], OC[Z])];
		/* Use the west cell for coordinate */
		OC[X] -= 1;
		/* Hit the boundary */
		LOC[X] = 0;
		/* Stop the trace process */
		COOD[X] = 0;
	} /* End of if() for inlet or outlet */
  } /* End of if() for previous position is on the east of new position */
} /* End of set_x_location() */


/****************************************************************************
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
****************************************************************************/
void set_y_location(PARA_DATA* para, REAL** var, REAL* flag, REAL* y, REAL v0,
	int i, int j, int k, REAL* OL, int* OC, int* LOC, int* COOD) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);

  /****************************************************************************
  | If the previous location is equal to current position,
  | stop the process (COOD[X] = 0)
  ****************************************************************************/
  if (OL[Y] == y[IX(OC[X], OC[Y], OC[Z])])
	COOD[Y] = 0;
  /****************************************************************************
  | Otherwise, if previous location is on the south of the current position
  ****************************************************************************/
  else if (OL[Y] < y[IX(OC[X], OC[Y], OC[Z])]) {
	/* If has not reached the boundary yet */
	if (OC[Y] > 0)
		OC[Y] -= 1;

	/* If the previous position is on the north of new location */
	if (OL[Y] >= y[IX(OC[X], OC[Y], OC[Z])])
		/* Stop the process */
		COOD[Y] = 0;

	/* If the new position is solid */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 1) {
		/* Use the north cell for new location */
		OL[Y] = y[IX(OC[X], OC[Y] + 1, OC[Z])];
		OC[Y] += 1;
		/* Hit the boundary */
		LOC[Y] = 0;
		/* Stop the trace process */
		COOD[Y] = 0;
	} /* End of if() for solid */

	/* If the new position is inlet or outlet */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 0 || flag[IX(OC[X], OC[Y], OC[Z])] == 2 || flag[IX(OC[X], OC[Y], OC[Z])] == 3) {
		/* Use new position */
		OL[Y] = y[IX(OC[X], OC[Y], OC[Z])];
		/* Use north cell for coordinate */
		OC[Y] += 1;
		/* Hit the boundary */
		LOC[Y] = 0;
		/* Stop the trace process */
		COOD[Y] = 0;
	} /* End of if() for inlet or outlet */
  } /* End of if() for previous position is on the south of new position */
  /****************************************************************************
  | Otherwise, if previous location is on the north of the current position
  ****************************************************************************/
  else {
	/* If not at the north boundary */
	if (OC[Y] <= jmax)
		/* Move to north */
		OC[Y] += 1;

	/* If the previous position is on the south of new position */
	if (OL[Y] <= y[IX(OC[X], OC[Y], OC[Z])])
		/* Stop the trace process */
		COOD[Y] = 0;

	/* If the cell is solid */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 1) {
		/* Use south cell */
		OL[Y] = y[IX(OC[X], OC[Y] - 1, OC[Z])];
		OC[Y] -= 1;
		/* Hit the boundary */
		LOC[Y] = 0;
		/* Stop the trace process */
		COOD[Y] = 0;
	} /* End of if() for solid */

	/* If the new position is inlet or outlet */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 0 || flag[IX(OC[X], OC[Y], OC[Z])] == 2 || flag[IX(OC[X], OC[Y], OC[Z])] == 3) {
		/* Use the current cell for previous location */
		OL[Y] = y[IX(OC[X], OC[Y], OC[Z])];
		/* Use the south cell for coordinate */
		OC[Y] -= 1;
		/* Hit the boundary */
		LOC[Y] = 0;
		/* Stop the trace process */
		COOD[Y] = 0;
	} /* End of if() for inlet or outlet */
  } /* End of if() for previous position is on the east of new position */
} /* End of set_x_location() */

/****************************************************************************
|  Find the Z-location and coordinates at previous time step
|
|  Conducting backward tracing for the particle's Z-location and
|  corresponding coordinates at the previous time step.
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param flag Pointer to the property of the cell
| \param Z Pointer to the current position y(t) of particle
| \param w0 Z-velocity at time (t-1) in location z(t)
| \param i I-index for cell at time t at z(t)
| \param j J-index for cell at time t at z(t)
| \param k K-index for cell at time t at z(t)
| \param OL Pointer to the locations of particle at time (t-1)
| \param OC Pointer to the coordinates of particle at time (t-1)
| \param LOC Pointer to flags recording if tracing back hits the boundary
| \param COOD Pointer to record the status of tracing back process
|
| \return void No return needed
****************************************************************************/
void set_z_location(PARA_DATA* para, REAL** var, REAL* flag, REAL* z, REAL w0,
	int i, int j, int k, REAL* OL, int* OC, int* LOC, int* COOD) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);

  /****************************************************************************
  | If the previous location is equal to current position,
  | stop the process (COOD[Z] = 0)
  ****************************************************************************/
  if (OL[Z] == z[IX(OC[X], OC[Y], OC[Z])])
	COOD[Z] = 0;
  /****************************************************************************
  | Otherwise, if previous location is on the floor of the current position
  ****************************************************************************/
  else if (OL[Z] < z[IX(OC[X], OC[Y], OC[Z])]) {
	/* If has not reached the boundary yet */
	if (OC[Z] > 0)
		OC[Z] -= 1;

	/* If the previous position is on the ceiling of new location */
	if (OL[Z] >= z[IX(OC[X], OC[Y], OC[Z])])
		/* Stop the process */
		COOD[Z] = 0;

	/* If the new position is solid */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 1) {
		/* Use the ceiling cell for new location */
		OL[Z] = z[IX(OC[X], OC[Y], OC[Z] + 1)];
		OC[Z] += 1;
		/* Hit the boundary */
		LOC[Z] = 0;
		/* Stop the trace process */
		COOD[Z] = 0;
	} /* End of if() for solid */

	/* If the new position is inlet or outlet */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 0 || flag[IX(OC[X], OC[Y], OC[Z])] == 2 || flag[IX(OC[X], OC[Y], OC[Z])] == 3) {
		/* Use new position */
		OL[Z] = z[IX(OC[X], OC[Y], OC[Z])];
		/* Use ceiling cell for coordinate */
		OC[Z] += 1;
		/* Hit the boundary */
		LOC[Z] = 0;
		/* Stop the trace process */
		COOD[Z] = 0;
	} /* End of if() for inlet or outlet */
  } /* End of if() for previous position is on the floor of new position */
  /****************************************************************************
  | Otherwise, if previous location is on the ceiling of the current position
  -***************************************************************************/
  else {
	/* If not at the ceiling boundary */
	if (OC[Z] <= kmax)
		/* Move to ceiling */
		OC[Z] += 1;

	/* If the previous position is on the floor of new position */
	if (OL[Z] <= z[IX(OC[X], OC[Y], OC[Z])])
		/* Stop the trace process */
		COOD[Z] = 0;

	/* If the cell is solid */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 1) {
		/* Use floor cell */
		OL[Z] = z[IX(OC[X], OC[Y], OC[Z] - 1)];
		OC[Z] -= 1;
		/* Hit the boundary */
		LOC[Z] = 0;
		/* Stop the trace process */
		COOD[Z] = 0;
	} /* End of if() for solid */

	/* If the new position is inlet or outlet */
	if (flag[IX(OC[X], OC[Y], OC[Z])] == 0 || flag[IX(OC[X], OC[Y], OC[Z])] == 2 || flag[IX(OC[X], OC[Y], OC[Z])] == 3) {
		/* Use the current cell for previous location */
		OL[Z] = z[IX(OC[X], OC[Y], OC[Z])];
		/* Use the floor cell for coordinate */
		OC[Z] -= 1;
		/* Hit the boundary */
		LOC[Z] = 0;
		/* Stop the trace process */
		COOD[Z] = 0;
	} /* End of if() for inlet or outlet */
  } /* End of if() for previous position is on the east of new position */
} /* End of set_z_location() */


/***************************************************************************
|  Calculate coefficients for advection equation solver using implicit scheme
|  The advection term can be either descritized in first-order upwind scheme or
|  centeral differencing scheme
|  Wei Tian 6/2/2017 @ Andover, MA
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable at current time step
| \param psi0 Pointer to the variable at previous time step
| \param var_type Type of variable
| \param index Index of trace substance or species
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
***************************************************************************/
int coef_adv(PARA_DATA* para, REAL** var, REAL* psi, REAL* psi0,
	int var_type, int index, int** BINDEX) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL* aw = var[AW], * ae = var[AE], * as = var[AS], * an = var[AN];
  REAL* af = var[AF], * ab = var[AB], * ap = var[AP], * ap0 = var[AP0], * b = var[B];
  REAL* x = var[X], * y = var[Y], * z = var[Z];
  REAL* gx = var[GX], * gy = var[GY], * gz = var[GZ];
  REAL* u = var[VX], * v = var[VY], * w = var[VZ];
  REAL* Temp = var[TEMP];
  REAL dxe, dxw, dyn, dys, dzf, dzb, Dx, Dy, Dz;
  /* define the velocity at the face of control volume */
  REAL uw, ue, vs, vn, wb, wf;
  /* define the flow rate at the surface */
  REAL Fw, Fe, Fs, Fn, Fb, Ff;
  REAL dt = para->mytime->dt, beta = para->prob->beta;

  /* define kapa */
  switch (var_type) {
	/*-------------------------------------------------------------------------
	| X-velocity
	| Initially implemented by Wei Tian at Schneider Electric, Andover, MA
	| 6/5/2017
	-------------------------------------------------------------------------*/
	case VX:

		FOR_U_CELL
			/* define the dimensions */
			dxe = gx[IX(i + 1, j, k)] - gx[IX(i, j, k)];
			dxw = gx[IX(i, j, k)] - gx[IX(i - 1, j, k)];
			Dx = x[IX(i + 1, j, k)] - x[IX(i, j, k)];
			Dy = gy[IX(i, j, k)] - gy[IX(i, j - 1, k)];
			Dz = gz[IX(i, j, k)] - gz[IX(i, j, k - 1)];

			/* define the velocity at the surface */
			uw = 0.5 * (u[IX(i - 1, j, k)] + u[IX(i, j, k)]);
			ue = 0.5 * (u[IX(i, j, k)] + u[IX(i + 1, j, k)]);
			vs = 0.5 * (v[IX(i, j - 1, k)] + v[IX(i + 1, j - 1, k)]);
			vn = 0.5 * (v[IX(i, j, k)] + v[IX(i + 1, j, k)]);
			wb = 0.5 * (w[IX(i, j, k - 1)] + w[IX(i + 1, j, k - 1)]);
			wf = 0.5 * (w[IX(i, j, k)] + w[IX(i + 1, j, k)]);

			/* define the flow rate at the surface */
			Fw = uw * Dy * Dz;
			Fe = ue * Dy * Dz;
			Fs = vs * Dx * Dz;
			Fn = vn * Dx * Dz;
			Fb = wb * Dx * Dy;
			Ff = wf * Dx * Dy;

			/* define the coefficient for calculation */
			aw[IX(i, j, k)] = max(Fw, 0);
			ae[IX(i, j, k)] = max(-Fe, 0);
			as[IX(i, j, k)] = max(Fs, 0);
			an[IX(i, j, k)] = max(-Fn, 0);
			ab[IX(i, j, k)] = max(Fb, 0);
			af[IX(i, j, k)] = max(-Ff, 0);
			ap0[IX(i, j, k)] = Dx * Dy * Dz / dt;
			b[IX(i, j, k)] = psi0[IX(i, j, k)] * ap0[IX(i, j, k)];
		END_FOR

		/* Set boundary conditions */
		set_bnd_vel_adv(para, var, var_type, psi, BINDEX);

		/* Set coefficient AP */
		FOR_U_CELL
			ap[IX(i, j, k)] = ap0[IX(i, j, k)] + ae[IX(i, j, k)] + aw[IX(i, j, k)]
			+ an[IX(i, j, k)] + as[IX(i, j, k)] + af[IX(i, j, k)] + ab[IX(i, j, k)]
			+ Fe - Fw + Fn - Fs + Ff - Fb;
		END_FOR

		break;
	/*-------------------------------------------------------------------------
	| Y-velocity
	| Initially implemented by Wei Tian at Schneider Electric, Andover, MA
	| 6/5/2017
	-------------------------------------------------------------------------*/
	case VY:

		FOR_V_CELL
			/* define the dimensions */
			dyn = gy[IX(i, j + 1, k)] - gy[IX(i, j, k)];
			dys = gy[IX(i, j, k)] - gy[IX(i, j - 1, k)];
			Dx = gx[IX(i, j, k)] - gx[IX(i - 1, j, k)];
			Dy = y[IX(i, j + 1, k)] - y[IX(i, j, k)];
			Dz = gz[IX(i, j, k)] - gz[IX(i, j, k - 1)];

			/* define the velocity at the surface */
			uw = 0.5 * (u[IX(i - 1, j, k)] + u[IX(i - 1, j + 1, k)]);
			ue = 0.5 * (u[IX(i, j, k)] + u[IX(i, j + 1, k)]);
			vs = 0.5 * (v[IX(i, j - 1, k)] + v[IX(i, j, k)]);
			vn = 0.5 * (v[IX(i, j, k)] + v[IX(i, j + 1, k)]);
			wb = 0.5 * (w[IX(i, j, k - 1)] + w[IX(i, j + 1, k - 1)]);
			wf = 0.5 * (w[IX(i, j, k)] + w[IX(i, j + 1, k)]);

			/* define the flow rate at the surface */
			Fw = uw * Dy * Dz;
			Fe = ue * Dy * Dz;
			Fs = vs * Dx * Dz;
			Fn = vn * Dx * Dz;
			Fb = wb * Dx * Dy;
			Ff = wf * Dx * Dy;

			/* define the coefficient for calculation */
			aw[IX(i, j, k)] = max(Fw, 0);
			ae[IX(i, j, k)] = max(-Fe, 0);
			as[IX(i, j, k)] = max(Fs, 0);
			an[IX(i, j, k)] = max(-Fn, 0);
			ab[IX(i, j, k)] = max(Fb, 0);
			af[IX(i, j, k)] = max(-Ff, 0);
			ap0[IX(i, j, k)] = Dx * Dy * Dz / dt;
			b[IX(i, j, k)] = psi0[IX(i, j, k)] * ap0[IX(i, j, k)];
		END_FOR

		/* Set boundary conditions */
		set_bnd_vel_adv(para, var, var_type, psi, BINDEX);

		/* Set coefficient AP */
		FOR_V_CELL
			ap[IX(i, j, k)] = ap0[IX(i, j, k)] + ae[IX(i, j, k)] + aw[IX(i, j, k)]
			+ an[IX(i, j, k)] + as[IX(i, j, k)] + af[IX(i, j, k)] + ab[IX(i, j, k)]
			+ Fe - Fw + Fn - Fs + Ff - Fb;
		END_FOR
		
		break;
	/*-------------------------------------------------------------------------
	| Z-velocity
	| Initially implemented by Wei Tian at Schneider Electric, Andover, MA
	| 6/5/2017
	-------------------------------------------------------------------------*/
	case VZ:

		FOR_W_CELL
			/* define the dimensions */
			dzf = gz[IX(i, j, k + 1)] - gz[IX(i, j, k)];
			dzb = gz[IX(i, j, k)] - gz[IX(i, j, k - 1)];
			Dx = gx[IX(i, j, k)] - gx[IX(i - 1, j, k)];
			Dy = gy[IX(i, j, k)] - gy[IX(i, j - 1, k)];
			Dz = z[IX(i, j, k + 1)] - z[IX(i, j, k)];

			/* define the velocity at the surface */
			uw = 0.5 * (u[IX(i - 1, j, k)] + u[IX(i - 1, j, k + 1)]);
			ue = 0.5 * (u[IX(i, j, k)] + u[IX(i, j, k + 1)]);
			vs = 0.5 * (v[IX(i, j - 1, k)] + v[IX(i, j - 1, k + 1)]);
			vn = 0.5 * (v[IX(i, j, k)] + v[IX(i, j, k + 1)]);
			wb = 0.5 * (w[IX(i, j, k - 1)] + w[IX(i, j, k)]);
			wf = 0.5 * (w[IX(i, j, k)] + w[IX(i, j, k + 1)]);


			/* define the flow rate at the surface */
			Fw = uw * Dy * Dz;
			Fe = ue * Dy * Dz;
			Fs = vs * Dx * Dz;
			Fn = vn * Dx * Dz;
			Fb = wb * Dx * Dy;
			Ff = wf * Dx * Dy;

			/* define the coefficient for calculation */
			aw[IX(i, j, k)] = max(Fw, 0);
			ae[IX(i, j, k)] = max(-Fe, 0);
			as[IX(i, j, k)] = max(Fs, 0);
			an[IX(i, j, k)] = max(-Fn, 0);
			ab[IX(i, j, k)] = max(Fb, 0);
			af[IX(i, j, k)] = max(-Ff, 0);
			ap0[IX(i, j, k)] = Dx * Dy * Dz / dt;
			b[IX(i, j, k)] = psi0[IX(i, j, k)] * ap0[IX(i, j, k)];
		END_FOR

		/* Set boundary conditions */
		set_bnd_vel_adv(para, var, var_type, psi, BINDEX);

		FOR_W_CELL
			ap[IX(i, j, k)] = ap0[IX(i, j, k)] + ae[IX(i, j, k)] + aw[IX(i, j, k)]
			+ an[IX(i, j, k)] + as[IX(i, j, k)] + af[IX(i, j, k)] + ab[IX(i, j, k)]
			+ Fe - Fw + Fn - Fs + Ff - Fb;
		END_FOR

		break;
	/*-------------------------------------------------------------------------
	| Scalar Variable
	| Initially implemented by Wei Tian at Schneider Electric, Andover, MA
	| 6/5/2017
	-------------------------------------------------------------------------*/
	case TEMP:
	case Xi1:
	case Xi2:
	case C1:
	case C2:

		FOR_EACH_CELL
			/* define the dimensions */
			Dx = gx[IX(i, j, k)] - gx[IX(i - 1, j, k)];
			Dy = gy[IX(i, j, k)] - gy[IX(i, j - 1, k)];
			Dz = gz[IX(i, j, k)] - gz[IX(i, j, k - 1)];

			/* define the velocity at the surface */
			uw = u[IX(i - 1, j, k)];
			ue = u[IX(i, j, k)];
			vs = v[IX(i, j - 1, k)];
			vn = v[IX(i, j, k)];
			wb = w[IX(i, j, k - 1)];
			wf = w[IX(i, j, k)];


			/* define the flow rate at the surface */
			Fw = uw * Dy * Dz;
			Fe = ue * Dy * Dz;
			Fs = vs * Dx * Dz;
			Fn = vn * Dx * Dz;
			Fb = wb * Dx * Dy;
			Ff = wf * Dx * Dy;

			/* define the coefficient for calculation */
			aw[IX(i, j, k)] = max(Fw, 0);
			ae[IX(i, j, k)] = max(-Fe, 0);
			as[IX(i, j, k)] = max(Fs, 0);
			an[IX(i, j, k)] = max(-Fn, 0);
			ab[IX(i, j, k)] = max(Fb, 0);
			af[IX(i, j, k)] = max(-Ff, 0);
			ap0[IX(i, j, k)] = Dx * Dy * Dz / dt;
			b[IX(i, j, k)] = psi0[IX(i, j, k)] * ap0[IX(i, j, k)];
		END_FOR

		/* Set boundary conditions */
		set_bnd_temp_adv(para, var, var_type, psi, BINDEX);

		/* This idea is derived from Chris at Schneider Electric */
		/* Often, the projection cannot be solved in desired accuracy, */
		/* Thus, there exists imbalance of mass after projection */
		/* Then, the temperature field is likely to be blown off. */
		/* The solution is to change the denominator by removing Fe - Fw + Fn - Fs + Ff - Fb in AP */
		FOR_EACH_CELL
			ap[IX(i, j, k)] = ap0[IX(i, j, k)] + ae[IX(i, j, k)] + aw[IX(i, j, k)]
			+ an[IX(i, j, k)] + as[IX(i, j, k)] + af[IX(i, j, k)] + ab[IX(i, j, k)];
		/*+ Fe - Fw + Fn - Fs + Ff - Fb;*/
		END_FOR

		break;
	default:
		sprintf(msg, "coe_adv(): No function for variable type %d", var_type);
		ffd_log(msg, FFD_ERROR);
		return 1;
  }

  return 0;
}/* End of coef_adv( ) */

int implicit_vx(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX) {
  int flag = 0;
  coef_adv(para, var, d, d0, var_type, index, BINDEX);
  if (flag != 0) {
	ffd_log("implicit_vx(): Could not calculate coefficients for "
		"advection equation.", FFD_ERROR);
	return flag;
  }
  if (equ_solver(para, var, ADV, var_type, d) != 0) {
	ffd_log("implicit_vx(): failed to solve the equation for advection", FFD_ERROR);
	return 1;
  }
  /* Define B.C. */
  set_bnd_vel_adv(para, var, var_type, d, BINDEX);

  return 0;
}

int implicit_vy(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX) {
  int flag = 0;
  coef_adv(para, var, d, d0, var_type, index, BINDEX);
  if (flag != 0) {
	ffd_log("implicit_vy(): Could not calculate coefficients for "
		"advection equation.", FFD_ERROR);
	return flag;
  }
  if (equ_solver(para, var, ADV, var_type, d) != 0) {
	ffd_log("implicit_vy(): failed to solve the equation for advection", FFD_ERROR);
	return 1;
  }
  /* Define B.C. */
  set_bnd_vel_adv(para, var, var_type, d, BINDEX);

  return 0;
}

int implicit_vz(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX) {
  int flag = 0;
  coef_adv(para, var, d, d0, var_type, index, BINDEX);
  if (flag != 0) {
	ffd_log("implicit_vz(): Could not calculate coefficients for "
		"advection equation.", FFD_ERROR);
	return flag;
  }
  if (equ_solver(para, var, ADV, var_type, d) != 0) {
	ffd_log("implicit_vz(): failed to solve the equation for advection", FFD_ERROR);
	return 1;
  }
  /* Define B.C. */
  set_bnd_vel_adv(para, var, var_type, d, BINDEX);

  return 0;
}

int implicit_scalar(PARA_DATA* para, REAL** var, int var_type, REAL* d, REAL* d0, int index, int** BINDEX) {
  int flag = 0;
  coef_adv(para, var, d, d0, var_type, index, BINDEX);
  if (flag != 0) {
	ffd_log("implicit_scalar(): Could not calculate coefficients for "
		"advection equation.", FFD_ERROR);
	return flag;
  }
  if (equ_solver(para, var, ADV, var_type, d) != 0) {
	ffd_log("implicit_scalar(): failed to solve the equation for advection", FFD_ERROR);
	return 1;
  }
  /* Define B.C. */
  /*set_bnd(para, var, var_type, index, d, BINDEX);*/
  set_bnd_temp_adv(para, var, var_type, d, BINDEX);

  return 0;
}
