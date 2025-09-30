/****************************************************************************
| 
|  \file   diffusion.c
| 
|  \brief  Calculate the diffusion equation
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
|  \date   6/15/2017
| 
|  This file provides functions that are used for calculating the diffusion
|  equations.
| 
****************************************************************************/

#include "diffusion.h"

/****************************************************************************
|  Entrance of calculating diffusion equation
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type Type of variable
| \param index Index of trace substance or species
| \param psi Pointer to the variable at current time step
| \param psi0 Pointer to the variable at previous time step
| \param BINDEX Pointer to boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
int diffusion(PARA_DATA *para, REAL **var, int var_type, int index,
               REAL *psi, REAL *psi0, int **BINDEX) {
  int flag = 0;

  /****************************************************************************
  | Define the coefficients for diffusion equation
  ****************************************************************************/
  flag = coef_diff(para, var, psi, psi0, var_type, index, BINDEX);
  if(flag!=0) {
    ffd_log("diffsuion(): Could not calculate coefficients for "
            "diffusion equation.", FFD_ERROR);
    return flag;
  }
  
  /* Solve the equations */
  if(equ_solver(para, var, DIF, var_type, psi)!=0) {
    ffd_log("diffusion(): failed to solve the equation", FFD_ERROR);
    return 1;
  }

  /* Define B.C. */
  set_bnd(para, var, var_type, index, psi, BINDEX);

  return flag;
} /* End of diffusion( ) */

/****************************************************************************
|  Calculate coefficients for diffusion equation solver
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to the variable at current time step
| \param psi0 Pointer to the variable at previous time step
| \param var_type Type of variable
| \param index Index of trace substance or species
| \param BINDEX Pointer to boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
int coef_diff(PARA_DATA *para, REAL **var, REAL *psi, REAL *psi0,
               int var_type, int index, int **BINDEX) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *aw = var[AW], *ae = var[AE], *as = var[AS], *an = var[AN];
  REAL *af = var[AF], *ab = var[AB], *ap = var[AP], *ap0 = var[AP0], *b = var[B];
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *gx = var[GX], *gy = var[GY], *gz = var[GZ];
  REAL *pp = var[PP];
  REAL *Temp = var[TEMP];
  REAL dxe, dxw, dyn, dys, dzf, dzb, Dx, Dy, Dz;
  REAL dt = para->mytime->dt, beta = para->prob->beta;
  REAL Temp_Buoyancy = para->prob->Temp_Buoyancy;
  REAL gravx = para->prob->gravx, gravy = para->prob->gravy,
       gravz = para->prob->gravz;
  REAL kapa, kapaE, kapaW, kapaN, kapaS, kapaF, kapaB;
  REAL coef_CONSTANT = para->prob->coef_CONSTANT;

  /* define kapa */
  switch(var_type) {
    /*-------------------------------------------------------------------------
    | X-velocity
    -------------------------------------------------------------------------*/
    case VX:
      if(para->prob->tur_model==LAM)
        kapa = para->prob->nu;
      else if(para->prob->tur_model==CONSTANT)
        kapa = (REAL) coef_CONSTANT * para->prob->nu;

      FOR_U_CELL
        dxe = gx[IX(i+1,j  ,k)] - gx[IX(i  ,j,k)];
        dxw = gx[IX(i  ,j  ,k)] - gx[IX(i-1,j,k)];
        dyn =  y[IX(i  ,j+1,k)] -  y[IX(i  ,j,k)];
        dys =  y[IX(i,j,k)] -      y[IX(i,j-1,k)];
        dzf =  z[IX(i,j,k+1)] -    z[IX(i,j,k)];
        dzb =  z[IX(i,j,k)] -      z[IX(i,j,k-1)];
        Dx =   x[IX(i+1,j,k)] -    x[IX(i,j,k)];
        Dy =  gy[IX(i,j,k)] -     gy[IX(i,j-1,k)];
        Dz =  gz[IX(i,j,k)] -     gz[IX(i,j,k-1)];

        if(para->prob->tur_model==CHEN)
          kapa = nu_t_chen_zero_equ(para, var, i, j, k)+ para->prob->nu;

        aw[IX(i,j,k)] = kapa*Dy*Dz/dxw;
        ae[IX(i,j,k)] = kapa*Dy*Dz/dxe;
        an[IX(i,j,k)] = kapa*Dx*Dz/dyn;
        as[IX(i,j,k)] = kapa*Dx*Dz/dys;
        af[IX(i,j,k)] = kapa*Dx*Dy/dzf;
        ab[IX(i,j,k)] = kapa*Dx*Dy/dzb;
        ap0[IX(i,j,k)] = Dx*Dy*Dz/dt;
        b[IX(i,j,k)] = psi0[IX(i,j,k)]*ap0[IX(i,j,k)]
                     - beta*gravx*(Temp[IX(i,j,k)]-Temp_Buoyancy)*Dx*Dy*Dz
                     + (pp[IX(i,j,k)]-pp[IX(i+1,j,k)])*Dy*Dz;
      END_FOR

      set_bnd(para, var, var_type, index, psi, BINDEX);
      /*set_bnd(para, var, var_type, psi, BINDEX);*/
      FOR_U_CELL
          ap[IX(i,j,k)] = ap0[IX(i,j,k)] + ae[IX(i,j,k)] + aw[IX(i,j,k)]
                        + an[IX(i,j,k)]  + as[IX(i,j,k)] + af[IX(i,j,k)]
                        + ab[IX(i,j,k)];
      END_FOR


      /* Add the source terms */
      source_diff(para, var, var_type, index);
      break;
    /*-------------------------------------------------------------------------
    | Y-velocity
    -------------------------------------------------------------------------*/
    case VY:
      if(para->prob->tur_model==LAM)
        kapa = para->prob->nu;
      else if(para->prob->tur_model==CONSTANT)
        kapa = (REAL) coef_CONSTANT * para->prob->nu;

      FOR_V_CELL
        dxe = x[IX(i+1,j,k)] - x[IX(i,j,k)];
        dxw = x[IX(i,j,k)] - x[IX(i-1,j,k)];
        dyn = gy[IX(i,j+1,k)] - gy[IX(i,j,k)];
        dys = gy[IX(i,j,k)] - gy[IX(i,j-1,k)];
        dzf = z[IX(i,j,k+1)] - z[IX(i,j,k)];
        dzb = z[IX(i,j,k)] - z[IX(i,j,k-1)];
        Dx = gx[IX(i,j,k)] - gx[IX(i-1,j,k)];
        Dy = y[IX(i,j+1,k)] - y[IX(i,j,k)];
        Dz = gz[IX(i,j,k)] - gz[IX(i,j,k-1)];

        if(para->prob->tur_model==CHEN)
          kapa = nu_t_chen_zero_equ(para, var, i, j, k) + para->prob->nu;

        aw[IX(i,j,k)] = kapa*Dy*Dz/dxw;
        ae[IX(i,j,k)] = kapa*Dy*Dz/dxe;
        an[IX(i,j,k)] = kapa*Dx*Dz/dyn;
        as[IX(i,j,k)] = kapa*Dx*Dz/dys;
        af[IX(i,j,k)] = kapa*Dx*Dy/dzf;
        ab[IX(i,j,k)] = kapa*Dx*Dy/dzb;
        ap0[IX(i,j,k)] = Dx*Dy*Dz/dt;
        b[IX(i,j,k)] = psi0[IX(i,j,k)]*ap0[IX(i,j,k)]
                     - beta*gravy*(Temp[IX(i,j,k)]-Temp_Buoyancy)*Dx*Dy*Dz
                     + (pp[IX(i,j,k)]-pp[IX(i ,j+1,k)])*Dx*Dz;
      END_FOR

      set_bnd(para, var, var_type, index, psi, BINDEX);
      /*set_bnd(para, var, var_type, psi,BINDEX);*/
      FOR_V_CELL
        ap[IX(i,j,k)] = ap0[IX(i,j,k)] + ae[IX(i,j,k)] + aw[IX(i,j,k)]
                      + an[IX(i,j,k)] + as[IX(i,j,k)] + af[IX(i,j,k)]
                      + ab[IX(i,j,k)];
      END_FOR

      /* Add the source terms */
      source_diff(para, var, var_type, index);
      break;
    /*-------------------------------------------------------------------------
    | Z-velocity
    -------------------------------------------------------------------------*/
    case VZ:
      if(para->prob->tur_model==LAM)
        kapa = para->prob->nu;
      else if(para->prob->tur_model==CONSTANT)
        kapa = (REAL) coef_CONSTANT * para->prob->nu;

      FOR_W_CELL
        dxe = x[IX(i+1,j,k)] - x[IX(i,j,k)];
        dxw = x[IX(i,j,k)] - x[IX(i-1,j,k)];
        dyn = y[IX(i,j+1,k)] - y[IX(i,j,k)];
        dys = y[IX(i,j,k)] - y[IX(i,j-1,k)];
        dzf = gz[IX(i,j,k+1)] - gz[IX(i,j,k)];
        dzb = gz[IX(i,j,k)] - gz[IX(i,j,k-1)];
        Dx = gx[IX(i,j,k)] - gx[IX(i-1,j,k)];
        Dy = gy[IX(i,j,k)] - gy[IX(i,j-1,k)];
        Dz = z[IX(i,j,k+1)] - z[IX(i,j,k)];

        if(para->prob->tur_model==CHEN)
          kapa = nu_t_chen_zero_equ(para, var, i, j, k) + para->prob->nu;

        aw[IX(i,j,k)] = kapa*Dy*Dz/dxw;
        ae[IX(i,j,k)] = kapa*Dy*Dz/dxe;
        an[IX(i,j,k)] = kapa*Dx*Dz/dyn;
        as[IX(i,j,k)] = kapa*Dx*Dz/dys;
        af[IX(i,j,k)] = kapa*Dx*Dy/dzf;
        ab[IX(i,j,k)] = kapa*Dx*Dy/dzb;
        ap0[IX(i,j,k)] = Dx*Dy*Dz/dt;
        b[IX(i,j,k)] = psi0[IX(i,j,k)]*ap0[IX(i,j,k)]
                     - beta*gravz*(Temp[IX(i,j,k)]-Temp_Buoyancy)*Dx*Dy*Dz
                     + (pp[IX(i,j,k)]-pp[IX(i ,j,k+1)])*Dy*Dx;
      END_FOR

      set_bnd(para, var, var_type, index, psi, BINDEX);
      /*set_bnd(para, var, var_type, psi, BINDEX);*/

      FOR_W_CELL
        ap[IX(i,j,k)] = ap0[IX(i,j,k)] + ae[IX(i,j,k)] + aw[IX(i,j,k)]
                      +  an[IX(i,j,k)] + as[IX(i,j,k)] + af[IX(i,j,k)]
                      + ab[IX(i,j,k)];
      END_FOR

      /* Add the source terms */
      source_diff(para, var, var_type, index);
      break;
    /*-------------------------------------------------------------------------
    | Scalar Variable
    -------------------------------------------------------------------------*/
    case TEMP:
    case Xi1:
    case Xi2:
    case C1:
    case C2:
        
        if (para->prob->tur_model == LAM)
            kapa = para->prob->alpha;
        
        if (para->prob->tur_model == CONSTANT)
            kapa = (REAL)coef_CONSTANT * para->prob->alpha;
        
      FOR_EACH_CELL
        dxe = x[IX(i+1,j,k)] - x[IX(i,j,k)];
        dxw = x[IX(i,j,k)] - x[IX(i-1,j,k)];
        dyn = y[IX(i,j+1,k)] - y[IX(i,j,k)];
        dys = y[IX(i,j,k)] - y[IX(i,j-1,k)];
        dzf = z[IX(i,j,k+1)] - z[IX(i,j,k)];
        dzb = z[IX(i,j,k)] - z[IX(i,j,k-1)];
        Dx = gx[IX(i,j,k)] - gx[IX(i-1,j,k)];
        Dy = gy[IX(i,j,k)] - gy[IX(i,j-1,k)];
        Dz = gz[IX(i,j,k)] - gz[IX(i,j,k-1)];
        /************************important notes*********************************
        |  As the Chen's Zero Equation turbulence model is being using, the thermal
        |  diffusivity is not constant over the space any more. Acutally it has a
        |  non-uniform distribution over the space. Thus, when discretizing the equation
        |  it is crtical to averge the thermal diffusivity at two neibouring cells to
        |  calculate the value at the face.
        | 
        |  Failing to do this may result into the energy imbalance during the diffusion term.
        |  To put in other words, one may observe that the heat flux from the walls is not
        |  equal to the energy changing rate of the fluids.
        | 
        |  Author: Wei Tian, Wei.Tian@Schneider-Electric.com
        |  Date: 7/21/2017
        *******************************END**************************************/
        if (para->prob->tur_model == CHEN) {
            kapa = nu_t_chen_zero_equ(para, var, i, j, k) + para->prob->nu;
            kapaE = nu_t_chen_zero_equ(para, var, i + 1, j, k) + para->prob->nu;
            kapaW = nu_t_chen_zero_equ(para, var, i - 1, j, k) + para->prob->nu;
            kapaN = nu_t_chen_zero_equ(para, var, i, j + 1, k) + para->prob->nu;
            kapaS = nu_t_chen_zero_equ(para, var, i, j - 1, k) + para->prob->nu;
            kapaF = nu_t_chen_zero_equ(para, var, i, j, k + 1) + para->prob->nu;
            kapaB = nu_t_chen_zero_equ(para, var, i, j, k - 1) + para->prob->nu;
            aw[IX(i, j, k)] = 0.5*(kapa + kapaW)*Dy*Dz / dxw;
            ae[IX(i, j, k)] = 0.5*(kapa + kapaE)*Dy*Dz / dxe;
            an[IX(i, j, k)] = 0.5*(kapa + kapaN)*Dx*Dz / dyn;
            as[IX(i, j, k)] = 0.5*(kapa + kapaS)*Dx*Dz / dys;
            af[IX(i, j, k)] = 0.5*(kapa + kapaF)*Dx*Dy / dzf;
            ab[IX(i, j, k)] = 0.5*(kapa + kapaB)*Dx*Dy / dzb;
        }
        else {
            aw[IX(i, j, k)] = kapa*Dy*Dz / dxw;
            ae[IX(i, j, k)] = kapa*Dy*Dz / dxe;
            an[IX(i, j, k)] = kapa*Dx*Dz / dyn;
            as[IX(i, j, k)] = kapa*Dx*Dz / dys;
            af[IX(i, j, k)] = kapa*Dx*Dy / dzf;
            ab[IX(i, j, k)] = kapa*Dx*Dy / dzb;
        }
              
        ap0[IX(i,j,k)] = Dx*Dy*Dz/dt;
        b[IX(i,j,k)] = psi0[IX(i,j,k)]*ap0[IX(i,j,k)];
      END_FOR

      /* Set boundary conditions */
      set_bnd(para, var, var_type, index, psi, BINDEX);

      FOR_EACH_CELL
        ap[IX(i,j,k)] = ap0[IX(i,j,k)] + ae[IX(i,j,k)] + aw[IX(i,j,k)]
                      +  an[IX(i,j,k)] + as[IX(i,j,k)] + af[IX(i,j,k)] + ab[IX(i,j,k)];
      END_FOR

      /* Add the source terms */
      source_diff(para, var, var_type, index);

      break;
    default:
      sprintf(msg, "coe_diff(): No function for variable type %d", var_type);
      ffd_log(msg, FFD_ERROR);
      return 1;
  }

  return 0;
}/* End of coef_diff( ) */

/****************************************************************************
|  Calculate source term in the diffusion equation
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type Type of variable
| \param index Index of trace substances or species
| 
| \return 0 if no error occurred
****************************************************************************/
int source_diff(PARA_DATA *para, REAL **var, int var_type, int index) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  REAL *b = var[B];
  REAL *ap = var[AP];

  FOR_EACH_CELL
    switch(var_type) {
      case VX:
        b[IX(i,j,k)] += var[VXS][IX(i,j,k)];
        ap[IX(i,j,k)] += var[APXS][IX(i,j,k)];
        break;
      case VY:
        b[IX(i,j,k)] += var[VYS][IX(i,j,k)];
        ap[IX(i,j,k)] += var[APYS][IX(i,j,k)];
        break;
      case VZ:
        b[IX(i,j,k)] += var[VZS][IX(i,j,k)];
        ap[IX(i,j,k)] += var[APZS][IX(i,j,k)];
        break;
      case TEMP:
        b[IX(i,j,k)] += var[TEMPS][IX(i,j,k)]/(para->prob->rho*para->prob->Cp);
        break;
      case C1:
      case C2:
        b[IX(i,j,k)] += var[C1S+index][IX(i,j,k)];
        break;
      case Xi1:
      case Xi2:
        b[IX(i,j,k)] += var[Xi1S+index][IX(i,j,k)];
        break;
    }
  END_FOR

  return 0;
} /* End of source_diff() */
