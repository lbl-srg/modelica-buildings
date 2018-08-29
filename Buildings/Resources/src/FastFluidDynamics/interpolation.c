/*
	*
	* \file   interpolation.c
	*
	* \brief  Interpolate the data for advection step
	*
	* \author Mingang Jin, Qingyan Chen
	*         Purdue University
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*         Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* \date   8/3/2013
	*
	*/
#include "interpolation.h"

/*
	* Entrance of interpolation
	*
	* @param para Pointer to FFD parameters
	* @param d0 Pointer to the variable for interpolation
	* @param p I-index of the control volume
	* @param q J-index of the control volume
	* @param r K-index of the control volume
	* @param x_1 Reciprocal of X-length
	* @param y_1 Reciprocal of Y-length
	* @param z_1 Reciprocal of Z-length
	*
	* @return Interpolated value
	*/
REAL interpolation(PARA_DATA *para, REAL *d0, REAL x_1, REAL y_1, REAL z_1,
                   int p, int q, int r) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  switch(para->solv->interpolation) {
    case BILINEAR:
      return interpolation_bilinear(x_1, y_1, z_1,
        d0[IX(p,q,r)],  d0[IX(p,q+1,r)],  d0[IX(p+1,q,r)],  d0[IX(p+1,q+1,r)],
        d0[IX(p,q,r+1)],d0[IX(p,q+1,r+1)],d0[IX(p+1,q,r+1)],d0[IX(p+1,q+1,r+1)]);
     break;
    default:
      sprintf(msg,
        "interpolation(): the required interpolation method %d is not available.",
        para->solv->interpolation);
      ffd_log(msg, FFD_ERROR);
      return -1;
  }
} /* End of interpolation()*/

	/*
		* Bilinear interpolation
		*
		* @param x_1 Reciprocal of X-length
		* @param y_1 Reciprocal of Y-length
		* @param z_1 Reciprocal of Z-length
		* @param d000 parameter for interpolation
		* @param d010 parameter for interpolation
		* @param d100 parameter for interpolation
		* @param d110 parameter for interpolation
		* @param d001 parameter for interpolation
		* @param d011 parameter for interpolation
		* @param d101 parameter for interpolation
		* @param d111 parameter for interpolation
		*
		* @return Interpolated value
		*/
REAL interpolation_bilinear(REAL x_1, REAL y_1, REAL z_1,
                            REAL d000, REAL d010, REAL d100, REAL d110,
                            REAL d001, REAL d011, REAL d101, REAL d111) {
  REAL x_0, y_0, z_0;
  REAL tmp0, tmp1;

  /*-------------------------------------------------------------------------
  | Interpolating for all variables
  -------------------------------------------------------------------------*/
  x_0 = (REAL) 1.0 - x_1;
  y_0 = (REAL) 1.0 - y_1;
  z_0 = (REAL) 1.0 - z_1;

  tmp0 = x_0*(y_0*d000+y_1*d010) + x_1*(y_0*d100+y_1*d110);
  tmp1 = x_0*(y_0*d001+y_1*d011) + x_1*(y_0*d101+y_1*d111);

  return z_0*tmp0+z_1*tmp1;

} /* End of interpolation_bilinear()*/
