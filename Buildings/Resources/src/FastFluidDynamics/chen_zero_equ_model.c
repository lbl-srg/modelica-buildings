/****************************************************************************
| 
|  \file   chen_zero_equ_model.c
| 
|  \brief  Computes turbulent viscosity using Chen's zero equ model
| 
|  \author Mingang Jin, Qingyan Chen
|          Purdue University
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
| 
|  \date   4/5/2020
| 
|  This file provides function that computes the turbulent viscosity using
|  Chen's zero equation model
| 
|  Update the standard Chen's zero equation model by add Jim's revision on 
|  boundary cells, by Wei Tian
****************************************************************************/
#include "chen_zero_equ_model.h"

/****************************************************************************
|  Computes turbulent viscosity using Chen's zero equation model
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param i I-index of the control volume
| \param j J-index of the control volume
| \param k K-index of the control volume
| 
| \return Turbulent Kinematic viscosity
****************************************************************************/
REAL nu_t_chen_zero_equ(PARA_DATA *para, REAL **var, int i, int j, int k) {
  REAL nu_t, l;
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL *flagp = var[FLAGP];
  int imax = para->geom->imax, jmax = para->geom->jmax,
      kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL coeff = para->prob->chen_a;
  REAL jim_a = 0.0185;
  REAL lx=0, ly=0, lz =0;
  REAL lx1=0,lx2=0, ly1=0, ly2=0, lz1=0, lz2=0;
  
  /****************************************************************************
  |  reserve the flexibility to implement the revised CHEN's model
  |  proposed by Jim and Chris, assigning a different coefficient of chen_a
  |  for the fluid cell adjacent to the boudnary cells
  |  Refer to the Turbulence_Model_Assessment_v17.pdf
  | \ Note Makers: Wei Tian
  | \ Contact: Wei.Tian@Schneider-Electric.com, Schneider Electric
  | \ Date: 7/04/2017
  ****************************************************************************/
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
  /* check if surrounding cell is solid */

  if (flagp[IX(i - 1, j, k)] >= 0 || flagp[IX(i + 1, j, k)] >= 0 ||
		flagp[IX(i, j - 1, k)] >= 0 || flagp[IX(i, j + 1, k)] >= 0 ||
		flagp[IX(i, j, k - 1)] >= 0 || flagp[IX(i, j, k + 1)] >= 0) {
	/* if the cell is adjacent to solid boundaries, assign a otherwise coffecient */
	coeff = jim_a;
  }
  else {
	/* if the cell is not adjacent to solid boundaries, assign a standard coffecient */
	coeff = para->prob->chen_a;
  }

	nu_t = coeff * l * (REAL)sqrt(u[IX(i,j,k)]*u[IX(i,j,k)]
		+v[IX(i,j,k)]*v[IX(i,j,k)] +w[IX(i,j,k)]*w[IX(i,j,k)] );

  return nu_t;
} /* End of nu_t_chen_zero_equ() */

/****************************************************************************
|  Computes turbulent thermal diffusivity using Chen's zero equation model
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \Author: Wei Tian @ Schneider Electric, Andover, MA
| 
| \Initial Implementation: 7/11/2017
| \return Turbulent Kinematic viscosity
| 
| \ This is to reimplement the turbulent thermal diffusivity for FFD using Chen's
|   zero equation model. Theoretically, by diving the turbulent viscosity over the 
|   Pr number, we can easily get the turbulent themal diffusivity coefficients. However,
|   according to our test, that could cause severe energy imblance for the whole space.
|   The root reason to explain that is not fully identified yet. However, we presumably beleive that
|   the dramatically (over 100) spatial difference of the thermal diffusivity coefficient may lead 
|   to energy imbalance, happening in the diffusion term. We also tried using constant turbulence  
|   model, which essentially multiplies 100 to the lamninar one. Applying that in the FFD, we did 
|   not see the deterioration of energy balance, at any level.
|
| \ Inspired by this, we propose to uniformly disseminate the turbulent thermal diffusivity over 
|   the whole fluid space. According to our test, this method can perfectly achieve energy balance 
|   for the room space, while keeping the turbulent features in some extent of the thermal 
|   environment.
| 
| \ Last update: 7/11/2017
****************************************************************************/
REAL alpha_t_chen_zero_equ(PARA_DATA *para, REAL **var) {
  int i, j, k;
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL *flagp = var[FLAGP];
  int imax = para->geom->imax, jmax = para->geom->jmax,
	kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2)*(jmax + 2);
  REAL sum_tur_alpha = 0.0;
  int count = 0;
        
  FOR_EACH_CELL
	if (flagp[IX(i, j, k)] >= 0) continue;
	sum_tur_alpha += nu_t_chen_zero_equ(para, var, i, j, k) / 0.900000 /*Pr number*/;
	count += 1;
  END_FOR

  return sum_tur_alpha / count; /* turbulent alpha for each cell */
} /* end of alpha_t */


