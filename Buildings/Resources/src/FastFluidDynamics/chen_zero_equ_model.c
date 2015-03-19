///////////////////////////////////////////////////////////////////////////////
///
/// \file   chen_zero_equ_model.c
///
/// \brief  Computes turbulent viscosity using Chen's zero equ model
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
/// This file provides function that computes the turbulent viscosity using
/// Chen's zero equation model
///
///////////////////////////////////////////////////////////////////////////////
#include "chen_zero_equ_model.h"

///////////////////////////////////////////////////////////////////////////////
/// Computes turbulent viscosity using Chen's zero equation model
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param k K-index of the control volume
///
///\return Turbulent Kinematic viscosity
///////////////////////////////////////////////////////////////////////////////
REAL nu_t_chen_zero_equ(PARA_DATA *para, REAL **var, int i, int j, int k) {
  REAL nu_t, l, lx, lx1, lx2, ly, ly1, ly2, lz, lz1, lz2;
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VX], *v = var[VY], *w = var[Z];
  int imax = para->geom->imax, jmax = para->geom->jmax,
      kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);

  lx1 = x[IX(i,j,k)] - x[IX(0,j,k)];
  lx2 = x[IX(imax+1,j,k)] - x[IX(i,j,k)];
  lx = lx1 < lx2 ? lx1 : lx2;

  ly1 = y[IX(i,j,k)] - y[IX(i,0,k)];
  ly2 = y[IX(i,jmax,k)] - y[IX(i,j,k)];
  ly = ly1 < ly2 ? ly1 : ly2;

  lz1 = z[IX(i,j,k)] - z[IX(i,j,0)];
  lz2 = z[IX(i,j,kmax+1)] - z[IX(i,j,k)];
  lz = lz1 < lz2 ? lz1 : lz2;

  l = lx < ly ? lx : ly;
  l = lz < l ? lz : l;
  nu_t = para->prob->chen_a * l
       * (REAL)sqrt( u[IX(i,j,k)]*u[IX(i,j,k)]
                    +v[IX(i,j,k)]*v[IX(i,j,k)]
                    +w[IX(i,j,k)]*w[IX(i,j,k)] );

  return nu_t;
} // End of nu_t_chen_zero_equ()
