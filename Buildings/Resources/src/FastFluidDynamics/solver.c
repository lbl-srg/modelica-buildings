/****************************************************************************
|
|  \file   solver.c
|
|  \brief  Solver of FFD
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
|	   	   Cary Faulkner
| 	       University of Colorado Boulder
|	       cary.faulkner@colorado.edu
|
|  \date   4/5/2020
|
****************************************************************************/

#include "solver.h"

/****************************************************************************
|  FFD solver
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int FFD_solver(PARA_DATA *para, REAL **var, int **BINDEX) {
  int step_total = para->mytime->step_total;
  REAL t_steady = para->mytime->t_steady;
  double t_cosim;
  int flag, next, bar=0;
  char tmpName[10];

  if (para->solv->cosimulation == 1)
	  t_cosim = para->mytime->t + para->cosim->modelica->dt;

  /***************************************************************************
  | Solver Loop
  ***************************************************************************/
  next = 1;
  while(next==1) {
    flag =0;
    flag = vel_step(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not solve velocity.", FFD_ERROR);
      return flag;
    }
    else if(para->outp->version==DEBUG)
      ffd_log("FFD_solver(): solved velocity step.", FFD_NORMAL);

    flag = temp_step(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not solve temperature.", FFD_ERROR);
      return flag;
    }
    else if(para->outp->version==DEBUG)
      ffd_log("FFD_solver(): solved temperature step.", FFD_NORMAL);

    flag = den_step(para, var, BINDEX);
    if(flag != 0) {
      ffd_log("FFD_solver(): Could not solve trace substance.", FFD_ERROR);
      return flag;
    }
    else if(para->outp->version==DEBUG)
      ffd_log("FFD_solver(): solved density step.", FFD_NORMAL);

    timing(para);

	/*-------------------------------------------------------------------------*/
   /* Process for Coupled simulation*/
   /*-------------------------------------------------------------------------*/
	if (para->solv->cosimulation == 1) {
		/*.......................................................................
		| Condition 1: If synchronization point is reached,
		| Action:     Do data exchange
		.......................................................................*/
		if (fabs(para->mytime->t - t_cosim) < SMALL) {
			if (para->outp->version == DEBUG)
				ffd_log("FFD_solver(): Coupled simulation, reached synchronization point",
					FFD_NORMAL);

			/* Average the FFD simulation data*/
			flag = average_time(para, var);
			if (flag != 0) {
				ffd_log("FFD_solver(): Could not average the data over time.",
					FFD_ERROR);
				return flag;
			}

			/*.......................................................................
			| Check if Modelica asks to stop the simulation
			.......................................................................*/
			if (para->cosim->para->flag == 0) {
				/* Stop the solver*/
				next = 0;
				sprintf(msg,
					"ffd_solver(): Received stop command from Modelica at "
					"FFD time: %f[s], Modelica Time: %f[s].",
					para->mytime->t, para->cosim->modelica->t);
				ffd_log(msg, FFD_NORMAL);
			}
			else {
				/* the data for coupled simulation*/
				flag = read_cosim_data(para, var, BINDEX);
				if (flag != 0) {
					ffd_log("FFD_solver(): Could not read coupled simulation data.", FFD_ERROR);
					return flag;
				}
			}
			/*.......................................................................
			| Check if Modelica asks to stop the simulation
			.......................................................................*/
			if (para->cosim->para->flag == 0) {
				/* Stop the solver*/
				next = 0;

				/*write vtk or plt file*/
				if (para->outp->result_file == VTK) {
					if (write_vtk_data(para, var, "result") != 0) {
						ffd_log("FFD_solver(): Could not write the result file.", FFD_ERROR);
						return 1;
					}
				}
				else {
					write_tecplot_data(para, var, "result");
				}

				sprintf(msg,
					"ffd_solver(): Received stop command from Modelica at "
					"FFD time: %f[s], Modelica Time: %f[s].",
					para->mytime->t, para->cosim->modelica->t);
				ffd_log(msg, FFD_NORMAL);
			}
			else {
				flag = write_cosim_data(para, var);
				if (flag != 0) {
					ffd_log("FFD_solver(): Could not write coupled simulation data.", FFD_ERROR);
					return flag;
				}
				sprintf(msg, "ffd_solver(): Synchronized data at t=%f[s]\n", para->mytime->t);
				ffd_log(msg, FFD_NORMAL);

			}
			/* Set the next synchronization time*/
			t_cosim += para->cosim->modelica->dt;
			/* Reset all the averaged data to 0*/
			flag = reset_time_averaged_data(para, var);
			if (flag != 0) {
				ffd_log("FFD_solver(): Could not reset averaged data.",
					FFD_ERROR);
				return flag;
			}

			continue;
		} /* End of Condition 1*/
		/*.......................................................................
		| Condition 2: synchronization point is not reached ,
		|             but already miss the synchronization point
		| Action:     Stop simulation
		.......................................................................*/
		else if (para->mytime->t - t_cosim > SMALL) {
			sprintf(msg,
				"ffd_solver(): Mis-matched synchronization step with "
				"t_ffd=%f[s], t_cosim=%f[s], dt_syn=%f[s], dt_ffd=%f[s].",
				para->mytime->t, t_cosim,
				para->cosim->modelica->dt, para->mytime->dt);
			ffd_log(msg, FFD_ERROR);
			sprintf(msg, "para->mytime->t - t_cosim=%lf", para->mytime->t - t_cosim);
			ffd_log(msg, FFD_ERROR);
			return 1;
		} /* end of Condition 2*/
		/*.......................................................................
		| Condition 3: synchronization point is not reached
		|             and not miss the synchronization point
		| Action:     Do FFD internal simulation and add data for future average
		.......................................................................*/
		else {
			if (para->outp->version == DEBUG)
				ffd_log("FFD_solver(): Coupled simulation, prepare next step for FFD",
					FFD_NORMAL);

			/* Integrate the data on the boundary surface*/
			flag = surface_integrate(para, var, BINDEX);
			if (flag != 0) {
				ffd_log("FFD_solver(): "
					"Could not average the data on boundary.",
					FFD_ERROR);
				return flag;
			}
			else if (para->outp->version == DEBUG)
				ffd_log("FFD_solver(): completed surface integration",
					FFD_NORMAL);

			flag = add_time_averaged_data(para, var);
			if (flag != 0) {
				ffd_log("FFD_solver(): "
					"Could not add the averaged data.",
					FFD_ERROR);
				return flag;
			}
			else if (para->outp->version == DEBUG)
				ffd_log("FFD_solver(): completed time average",
					FFD_NORMAL);

		} /* End of Condition 3*/
	} /* End of coupled simulation*/
	
	else {
		if (para->outp->version == DEBUG)
			ffd_log("FFD_solver(): Single Simulation, prepare for next time step",
				FFD_NORMAL);

		/* Start to record data for calculating mean velocity if needed */
		if (para->mytime->t > t_steady && para->outp->cal_mean == 0) {
			para->outp->cal_mean = 1;
			flag = reset_time_averaged_data(para, var);
			if (flag != 0) {
				ffd_log("FFD_solver(): Could not reset averaged data.",
					FFD_ERROR);
				return flag;
			}
			else
				ffd_log("FFD_solver(): Start to calculate mean properties.",
					FFD_NORMAL);
		}

		if (para->outp->cal_mean == 1) {

#ifdef FFD_ISAT  /*if called by ISAT*/
			/* Integrate the data on the boundary surface*/
			flag = surface_integrate(para, var, BINDEX);
			if (flag != 0) {
				ffd_log("FFD_solver(): "
					"Could not average the data on boundary.",
					FFD_ERROR);
				return flag;
			}
			else if (para->outp->version == DEBUG)
				ffd_log("FFD_solver(): completed surface integration",
					FFD_NORMAL);
#endif

			flag = add_time_averaged_data(para, var);
			if (flag != 0) {
				ffd_log("FFD_solver(): Could not add the averaged data.",
					FFD_ERROR);
				return 1;
			}
		}
		next = para->mytime->step_current < step_total ? 1 : 0;
	}
  } /* End of While loop */
  return flag;
} /* End of FFD_solver( ) */

/****************************************************************************
|  Calculate the temperature
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int temp_step(PARA_DATA* para, REAL** var, int** BINDEX) {
  REAL* T = var[TEMP], * T0 = var[TMP1];
  int flag = 0;
  int size = (para->geom->imax + 2) * (para->geom->jmax + 2) * (para->geom->kmax + 2);
  REAL residual = 0.0;

  flag = advect(para, var, TEMP, 0, T0, T, BINDEX);
  if (flag != 0) {
	ffd_log("temp_step(): Could not advect temperature.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->advection_solver == UPWIND && para->solv->check_residual == 1) {
	residual = check_residual(para, var, T0, var[FLAGP]);
	sprintf(msg, "Residual in advection T using implicit scheme: %f", residual);
	ffd_log(msg, FFD_NORMAL);

	para->prob->Energy_Imb_Adv = adv_inconservation(para, var, T, T0, BINDEX);
	sprintf(msg, "Energy imbalance (W) after using implicit scheme: %f", para->prob->Energy_Imb_Adv);
	ffd_log(msg, FFD_NORMAL);
  }

  /* if using the standard Semi-Lagrangian method for advection
  then apply the restoration of energy conservation
  Wei Tian 6/20/2017, @Schneider Electric, Andover, MA */
  if (para->solv->advection_solver == SEMI) {
	/*flag = scalar_conservation(para, var, T, T0, BINDEX);*/
	if (flag != 0) {
		ffd_log("temp_step(): Could not conserve temperature.", FFD_ERROR);
		return flag;
	}
  }

  flag = diffusion(para, var, TEMP, 0, T, T0, BINDEX);
  if (flag != 0) {
	ffd_log("temp_step(): Could not diffuse temperature.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->check_residual == 1) {
	residual = check_residual(para, var, T, var[FLAGP]);
	sprintf(msg, "Residual in diffusion T: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }
  return flag;
} /* End of temp_step( ) */

/****************************************************************************
|  Calculate the contaminant concentration
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int den_step(PARA_DATA* para, REAL** var, int** BINDEX) {
  REAL* den, * den0 = var[TMP1];
  int i, flag = 0;

  /****************************************************************************
  | Solve the species
  ****************************************************************************/
  for (i = 0; i < para->bc->nb_Xi; i++) {
	if (para->outp->version == DEBUG) {
		sprintf(msg, "den_step(): start to solve Xi%d", i + 1);
		ffd_log(msg, FFD_NORMAL);
	}
	den = var[Xi1 + i];
	flag = advect(para, var, Xi1 + i, i, den0, den, BINDEX);
	if (flag != 0) {
		sprintf(msg, "den_step(): Could not advect species %d", i + 1);
		ffd_log(msg, FFD_ERROR);
		return flag;
	}

	flag = diffusion(para, var, Xi1 + i, i, den, den0, BINDEX);
	if (flag != 0) {
		sprintf(msg, "den_step(): Could not diffuse species %d", i + 1);
		ffd_log(msg, FFD_ERROR);
		return flag;
	}
  }

  /****************************************************************************
  | Solve the trace substances
  ****************************************************************************/
  for (i = 0; i < para->bc->nb_C; i++) {
	if (para->outp->version == DEBUG) {
		sprintf(msg, "den_step(): start to solve C%d", i + 1);
		ffd_log(msg, FFD_NORMAL);
	}
	den = var[C1 + i];
	flag = advect(para, var, Xi1, i, den0, den, BINDEX);
	if (flag != 0) {
		sprintf(msg, "den_step(): Could not advect trace substance %d", i + 1);
		ffd_log(msg, FFD_ERROR);
		return flag;
	}

	flag = diffusion(para, var, Xi1, i, den, den0, BINDEX);
	if (flag != 0) {
		sprintf(msg, "den_step(): Could not diffuse trace substance %d", i + 1);
		ffd_log(msg, FFD_ERROR);
		return flag;
	}
  }
  return flag;
} /* End of den_step( ) */

/****************************************************************************
|  Calculate the velocity
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int vel_step(PARA_DATA *para, REAL **var,int **BINDEX) {
  REAL *u  = var[VX],  *v  = var[VY],    *w  = var[VZ];
  REAL *u0 = var[TMP1], *v0 = var[TMP2], *w0 = var[TMP3];
  REAL residual = 0.0;
  int flag = 0;

  /* Model tile */
  if (para->bc->hasTile) {
	if (para->solv->tile_flow_correct == PRESSURE_BASE)
		flag = assign_tile_velocity(para, var, BINDEX);
	else if (para->solv->tile_flow_correct == NS_SOURCE)
		flag = tile_source(para, var, BINDEX);
	else
		flag = 0;

	if (flag != 0) {
		ffd_log("vel_step(): Could not determine the velocity for the tiles in pure tile modeling.", FFD_ERROR);
		return flag;
	}
  }

  /* Call rack black model if there is any rack */
  if (para->bc->nb_rack != 0) {
	if (rack_model_black_box(para, var, BINDEX) != 0) {
		ffd_log("tile_room_coupled: can not execute the black box model", FFD_ERROR);
	}
  }

  /* Output the flow information */
  flag = advect(para, var, VX, 0, u0, u, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not advect for velocity X.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->advection_solver == UPWIND && para->solv->check_residual == 1) {
	residual = check_residual(para, var, u0, var[FLAGU]);
	sprintf(msg, "Residual in advection U: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }

  flag = advect(para, var, VY, 0, v0, v, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not advect for velocity Y.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->advection_solver == UPWIND && para->solv->check_residual == 1) {
	residual = check_residual(para, var, v0, var[FLAGV]);
	sprintf(msg, "Residual in advection V: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }

  flag = advect(para, var, VZ, 0, w0, w, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not advect for velocity Z.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->advection_solver == UPWIND && para->solv->check_residual == 1) {
	residual = check_residual(para, var, w0, var[FLAGW]);
	sprintf(msg, "Residual in advection W: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }

  flag = diffusion(para, var, VX, 0, u, u0, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not diffuse velocity X.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->check_residual == 1) {
	residual = check_residual(para, var, u, var[FLAGU]);
	sprintf(msg, "Residual in diffusion U: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }

  flag = diffusion(para, var, VY, 0, v, v0, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not diffuse velocity Y.", FFD_ERROR);
	return flag;
  }

  /* check residual after iterative solver */
  if (para->solv->check_residual == 1) {
	residual = check_residual(para, var, v, var[FLAGV]);
	sprintf(msg, "Residual in diffusion V: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }

  flag = diffusion(para, var, VZ, 0, w, w0, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not diffuse velocity Z.", FFD_ERROR);
	return flag;
  }


  /* check residual after iterative solver */
  if (para->solv->check_residual == 1) {
	residual = check_residual(para, var, w, var[FLAGW]);
	sprintf(msg, "Residual in diffusion W: %f", residual);
	ffd_log(msg, FFD_NORMAL);
  }

  flag = project(para, var, BINDEX);
  if (flag != 0) {
	ffd_log("vel_step(): Could not project velocity.", FFD_ERROR);
	return flag;
  }

  /* forced mass conservation function is NOT on after projection is Pressure-based correction is applied to tiles. */
  if(para->bc->nb_outlet!=0 && para->solv->mass_conservation_on ==1) flag = mass_conservation(para, var,BINDEX);
  if(flag!=0) {
    ffd_log("vel_step(): Could not conduct mass conservation correction.",
            FFD_ERROR);
    return flag;
  }
  return flag;
} /* End of vel_step( ) */

/****************************************************************************
|  Solver for equations
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param var_type Variable type
| \param Pointer to variable
| 
| \return 0 if not error occurred
****************************************************************************/
int equ_solver(PARA_DATA* para, REAL** var, FFD_TERM which_term, int var_type, REAL* psi) {
  REAL* flagp = var[FLAGP], * flagu = var[FLAGU];
  REAL* flagv = var[FLAGV], * flagw = var[FLAGW];
  int flag = 0;
  int num_swipe = 0;
  /*************************************************************************************************
  |  By knowing the different terms, either advection, or, diffusion
  |  now FFD can allow setting different number of iterations for each term, separately
  |  However, users cannot set different number of iterations for same terms for solving different
  |  variables.
  |  Users can set different number of swipes for GS or Jacobi in input file, input.ffd
  |  Wei Tian, 06/23/17
  *************************************************************************************************/
  if (which_term == ADV) {
	  /* advection */
	  num_swipe = para->solv->swipe_adv;
  }
  else if (which_term == DIF) {
	  /* diffusion */
	  num_swipe = para->solv->swipe_dif;
  }
  else
	  /* by default it is 5 swipes, or 30 iterations */
	  num_swipe = 5;

  switch (var_type) {
  case VX:
	  if (para->solv->solver == GS) {
		  Gauss_Seidel(para, var, psi, flagu, num_swipe);
	  }
	  else {
		  Jacobi(para, var, psi, flagu, num_swipe);
	  }
	  break;

  case VY:
	  if (para->solv->solver == GS) {
		  Gauss_Seidel(para, var, psi, flagv, num_swipe);
	  }
	  else {
		  Jacobi(para, var, psi, flagv, num_swipe);
	  }
	  break;

  case VZ:
	  if (para->solv->solver == GS) {
          Gauss_Seidel(para, var, psi, flagw, num_swipe);
      }
      else {
          Jacobi(para, var, psi, flagw, num_swipe);
      }
    break;
    case TEMP:
    case IP:
    case Xi1:
    case Xi2:
    case C1:
    case C2:
      if (para->solv->solver == GS) {
          Gauss_Seidel(para, var, psi, flagp, num_swipe);
      }
      else {
          Jacobi(para, var, psi, flagp, num_swipe);
      }
    break;
    default:
      sprintf(msg, "equ_solver(): Solver for variable type %d is not defined.",
              var_type);
      ffd_log(msg, FFD_ERROR);
      flag = 1;
      break;
  }
  return flag;
}/* end of equ_solver */

/****************************************************************************
|  Check Imbalance (the unit is W, so there is no need to multiply a time step to inlet and outlet)
| 
|  Wei Tian, update 6/20/2017, @Schneider Electric, Andover, MA
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
FILE* FILE_IM;
int CheckImbalance(PARA_DATA* para, REAL** var, int var_type, int** BINDEX) {
  /* declare variables */
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL* psi = var[TEMP];
  REAL in = 0.0, out = 0.0, wall = 0.0;
  REAL V = 0.0; /*volume of fluid*/
  REAL T_ave = 0.0; /*average temperature of fluid*/
  REAL rate_of_change = 0.0; /*energy change rate of fluid*/
  REAL rho_cp = para->prob->rho * para->prob->Cp;

  /* calculate the inflow energy */
  in = inflow(para, var, psi, BINDEX);
  in *= rho_cp;
  /* calculate the outflow energy */
  out = outflow(para, var, psi, BINDEX);
  out *= rho_cp;
  /* calculate the heat transfer rate from the wall */
  wall = qwall(para, var, BINDEX);

  /* sum up of the energy changing rate of each cell */

  FOR_EACH_CELL
	if (var[FLAGP][IX(i, j, k)] >= 0) continue;
	V = vol(para, var, i, j, k);
	T_ave = var[TEMP][IX(i, j, k)] - var[TMP1][IX(i, j, k)];
	rate_of_change += para->prob->rho * para->prob->Cp * T_ave * V / para->mytime->dt;
  END_FOR

  /* output the time-wise imbalance to a .dat file */
  if (para->mytime->step_current == 1) {
	/* create a new .dat file */
	if ((FILE_IM = fopen("imbalance.dat", "w+")) == NULL) {
		fprintf(stderr, "Error:can not open error file!\n");
		exit(1);
	}
	fprintf(FILE_IM, "Time\t\tInflow\t\tOutflow\t\tWall\t\tDeficit\t\tEnergyRate\t\tAdvEnergy\t\tImbalance (Ein+Ewall-Eout)/Ewall\n");
	fprintf(FILE_IM, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", para->mytime->t, in, out, wall, (in - out + wall), rate_of_change, para->prob->Energy_Imb_Adv, fabs(in - out + wall) / wall);
	fclose(FILE_IM);
  }
  else {
	/* open an existing file */
	if ((FILE_IM = fopen("imbalance.dat", "a+")) == NULL) {
		fprintf(stderr, "Error:can not open error file!\n");
		exit(1);
	}
	fprintf(FILE_IM, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", para->mytime->t, in, out, wall, (in - out + wall), rate_of_change, para->prob->Energy_Imb_Adv, fabs(in - out + wall) / wall);
	fclose(FILE_IM);
  }
  return 0;
}

/****************************************************************************
|  Restore the conservation of scalar virables after advection using Semi-Lagrangian
|  method
|  Literature: https://engineering.purdue.edu/~yanchen/paper/2015-1.pdf
|  Wei Tian 6/20/2017 first implementation, @ Schneider Electric, Andover, MA
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \Param psi Pointer to scalar variables after advection
| \Param psi0 Pointer to scalar variables before advection
| \return 0 if no error occurred
|
|  6/20/2017 Note: the whole idea is about the energy conservation which states that
|  the energy injected into the room should be energy gain in the fluid
|  when calculating the energy injection from the inlet and outlet, note that a "dt" must be
|  applied as in this function, the unit is J, instead of W.
|
|  The whole comments are made under context of energy. Surely, the codes also work for
|  other scalar variables, like species concentration.
|
|  the density of the air is assumed to be one.
|
|  The equation of 14 and 15 in the paper is incorrect. The denominator should essentially be
|  the sum up of the numerator.
****************************************************************************/
int scalar_conservation(PARA_DATA* para, REAL** var, REAL* psi0, REAL* psi, int** BINDEX) {
  /* declare variables */
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL* gx = var[GX], * gy = var[GY], * gz = var[GZ]; /* the surface coordinates of the cell */
  REAL surplus = 0.0; /*calculate the global surplus, can be a nagtive*/
  REAL tmp = 0.0; /* variable to store temporal values */
  REAL Cp = para->prob->Cp; /* Cp of the air, 1005 */
  REAL V_cell = 0.0; /* the volume of the cell */
  REAL rho = para->prob->rho; /*density of the air, 1.0*/
  REAL ita = 0.0; /* the coefficient to distribute the global deficit into each cell */
  REAL denominator = 0.0; /* the denominator to calculate the ita */
  REAL* local_max = var[LOCMAX], * local_min = var[LOCMIN]; /* store local maximum or minimum */
  REAL* flagp = var[FLAGP]; /* flag for cells */
  int depX = 0, depY = 0, depZ = 0; /* the departure point dimensions for point (i,j,k) */

  /* calculate the deficit or suplus of the variable */
  surplus = 0.0;
  /*1 Inflow scalar before advection*/
  surplus += inflow(para, var, psi0, BINDEX) * Cp * rho; /* without multiplying a dt, the unit is W */
  /*2 outflow scalar before advection*/
  surplus -= outflow(para, var, psi0, BINDEX) * Cp * rho; /* without multiplying a dt, the unit is W */
  surplus *= para->mytime->dt; /* multiple a time step size and W converts into J. */
  /*3 Embody scalar before advection*/
  /*4 Embody scalar after advection*/
  FOR_EACH_CELL
	if (flagp[IX(i, j, k)] >= 0) continue;
	V_cell = (gx[IX(i, j, k)] - gx[IX(i - 1, j, k)]) * (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]) *
		(gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);
	surplus += V_cell * rho * Cp * psi0[IX(i, j, k)];
	surplus -= V_cell * rho * Cp * psi[IX(i, j, k)];
  END_FOR

  /* calculate the maximum and minimum of the original and departure value as denominator for ita */
  denominator = SMALL; /* to avoid divide by zero */
  if (surplus > 0) {
	FOR_ALL_CELL
		if (flagp[IX(i, j, k)] >= 0) continue;
		denominator += fabs(psi[IX(i, j, k)] - local_max[IX(i, j, k)]);
	END_FOR
  }
  else {
	FOR_ALL_CELL
		if (flagp[IX(i, j, k)] >= 0) continue;
		denominator += fabs(psi[IX(i, j, k)] - local_min[IX(i, j, k)]);
	END_FOR
  }
  /* restore the scalar filed cell by cell */
  tmp = 0.0;
  if (surplus > 0) {
	FOR_ALL_CELL
		if (flagp[IX(i, j, k)] >= 0) continue;
	V_cell = (gx[IX(i, j, k)] - gx[IX(i - 1, j, k)]) * (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]) *
		(gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);
	tmp = fabs(psi[IX(i, j, k)] - local_max[IX(i, j, k)]);
	psi[IX(i, j, k)] += surplus * (tmp / denominator/*ita*/) / (rho * Cp * V_cell);
	END_FOR
	}
  else {
	FOR_ALL_CELL
		if (flagp[IX(i, j, k)] >= 0) continue;
	V_cell = (gx[IX(i, j, k)] - gx[IX(i - 1, j, k)]) * (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]) *
		(gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);
	tmp = fabs(psi[IX(i, j, k)] - local_min[IX(i, j, k)]);
	psi[IX(i, j, k)] += surplus * (tmp / denominator/*ita*/) / (rho * Cp * V_cell);
	END_FOR
  }
  return 0;
}

/****************************************************************************
|  Check energy inconservation after advection
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \Param psi Pointer to scalar variables after advection
| \Param psi0 Pointer to scalar variables before advection
| \return 0 if no error occurred
| \ Wei Tian
| \ 7/7/2017
****************************************************************************/
REAL adv_inconservation(PARA_DATA* para, REAL** var, REAL* psi0, REAL* psi, int** BINDEX) {
  /* declare variables */
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL* gx = var[GX], * gy = var[GY], * gz = var[GZ]; /* the surface coordinates of the cell */
  REAL surplus = 0.0; /*calculate the global surplus, can be a nagtive*/
  REAL tmp = 0.0; /* variable to store temporal values */
  REAL Cp = para->prob->Cp; /* Cp of the air, 1005 */
  REAL V_cell = 0.0; /* the volume of the cell */
  REAL rho = para->prob->rho; /*density of the air, 1.0*/
  REAL ita = 0.0; /* the coefficient to distribute the global deficit into each cell */
  REAL denominator = 0.0; /* the denominator to calculate the ita */
  REAL* local_max = var[LOCMAX], * local_min = var[LOCMIN]; /* store local maximum or minimum */
  REAL* flagp = var[FLAGP]; /* flag for cells */
  int depX = 0, depY = 0, depZ = 0; /* the departure point dimensions for point (i,j,k) */

  /* calculate the deficit or suplus of the variable */
  surplus = 0.0;
  /*1 Inflow scalar before advection*/
  surplus += inflow(para, var, psi0, BINDEX) * Cp; /* without multiplying a dt, the unit is W */
   /*2 outflow scalar before advection*/
  surplus -= outflow(para, var, psi0, BINDEX) * Cp; /* without multiplying a dt, the unit is W */
  surplus *= para->mytime->dt; /* multiple a time step size and W converts into J. */
  /*3 Embody scalar before advection*/
  /*4 Embody scalar after advection*/
  FOR_EACH_CELL
	if (flagp[IX(i, j, k)] >= 0) continue;
	V_cell = (gx[IX(i, j, k)] - gx[IX(i - 1, j, k)]) * (gy[IX(i, j, k)] - gy[IX(i, j - 1, k)]) *
		(gz[IX(i, j, k)] - gz[IX(i, j, k - 1)]);
	surplus += V_cell * rho * Cp * psi0[IX(i, j, k)];
	surplus -= V_cell * rho * Cp * psi[IX(i, j, k)];
  END_FOR

  return (surplus / para->mytime->dt); /* unit: W */
}

/****************************************************************************
|  Assign the the velocity for the tiles after determining the pressure correction
|  A bisec method is used to solve the non-linear equations.
|  For more insights of the solver, refer to http://cims.nyu.edu/~donev/Teaching/NMI-Fall2010/Lecture6.handout.pdf
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \return 0 if no error occurred
| \ Wei Tian
| \ 09/05/2017
****************************************************************************/
int assign_tile_velocity(PARA_DATA* para, REAL** var, int** BINDEX) {
  REAL* u = var[VX], * v = var[VY], * w = var[VZ];
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  int it;
  int index = para->geom->index;
  REAL* flagp = var[FLAGP];
  REAL total_resistance_initil = 0.000000001;
  REAL in_flowrate = 0.0, out_flowrate = 0.0;
  REAL P_ave = 0.0;
  REAL* p = var[IP]; /* pressure */
  REAL p_corr1 = 0, p_corr2 = 0, p_corr3 = 0; /* the correction for the pressure that is applied to the whole fluid field */
  REAL epsilon1 = 1.0, epsilon2 = 1.0, epsilon3 = 1.0;
  int NEXT = 1;
  REAL corrected_flow = 0.0;
  REAL axy = 0.0, ayz = 0.0, azx = 0.0;
  REAL rho = para->prob->rho;
  int count = 0;
  /* if it is the begin of the simulation, then do an estimation */
  if (para->mytime->step_current == 0) {
	for (it = 0; it < index; it++) {
		i = BINDEX[0][it];
		j = BINDEX[1][it];
		k = BINDEX[2][it];
		if (flagp[IX(i, j, k)] == TILE) {
			total_resistance_initil += 1 / pow(var[TILE_RESI_BC][IX(i, j, k)], 0.5);
		}
	} /*end of for*/
	/* find the volumetric inflow */
	/* since it is before the start of calculation, calling inflow function is not working. */
	in_flowrate = initial_inflows(para, var, BINDEX);
	out_flowrate = vol_outflow(para, var, BINDEX);
	in_flowrate -= out_flowrate;
	/* caclulate the P_ave */
	P_ave = pow(in_flowrate, 2) / pow(total_resistance_initil, 2);
	/* Calculate the velocity for each tile */
	for (it = 0; it < index; it++) {
		i = BINDEX[0][it];
		j = BINDEX[1][it];
		k = BINDEX[2][it];
		axy = area_xy(para, var, i, j, k);
		ayz = area_yz(para, var, i, j, k);
		azx = area_zx(para, var, i, j, k);
		if (flagp[IX(i, j, k)] == TILE) {
			if (i == imax + 1) {
				var[TILE_FLOW_BC][IX(i, j, k)] = pow(P_ave / var[TILE_RESI_BC][IX(i, j, k)], 0.5) / ayz;
			}
			if (i == 0) {
				var[TILE_FLOW_BC][IX(i, j, k)] = -1 * pow(P_ave / var[TILE_RESI_BC][IX(i, j, k)], 0.5) / ayz;
			}
			if (j == jmax + 1) {
				var[TILE_FLOW_BC][IX(i, j, k)] = pow(P_ave / var[TILE_RESI_BC][IX(i, j, k)], 0.5) / azx;
			}
			if (j == 0) {
				var[TILE_FLOW_BC][IX(i, j, k)] = -1 * pow(P_ave / var[TILE_RESI_BC][IX(i, j, k)], 0.5) / azx;
			}
			if (k == kmax + 1) {
				var[TILE_FLOW_BC][IX(i, j, k)] = pow(P_ave / var[TILE_RESI_BC][IX(i, j, k)], 0.5) / axy;
			}
			if (k == 0) {
				var[TILE_FLOW_BC][IX(i, j, k)] = -1 * pow(P_ave / var[TILE_RESI_BC][IX(i, j, k)], 0.5) / axy;
			}
		}
	} /*end of for*/
  }
  /* otherwise, correct the pressure to meet the mass flow rate */
  else {
	/* initial values for p_corr with two rough assumptions */
	p_corr1 = 0;
	epsilon1 = pressure_correction(para, var, BINDEX, p_corr1);
	
	/*current pressure is too large to provide surplus outflows*/
	if (epsilon1 > 1e-6)
		p_corr2 = -1000;
	/*current pressure is too small to provide enough outflows*/
	else if (epsilon1 < -1 * 1e-6)
		p_corr2 = +1000;
	/*current pressure is good and correction is not needed*/
	else {
		p_corr2 = 0;
		p_corr3 = 0;
		NEXT = 0;
	}
	if (NEXT) {
		/* evaluate the guessed corrected pressure good enough or not */
		epsilon2 = pressure_correction(para, var, BINDEX, p_corr2);
		/*printf("epsilon1 and epsilon2 is %f %f\n", epsilon1, epsilon2);*/
		/*getchar();*/

		if (epsilon2 * epsilon1 < 0.0)
			p_corr3 = 0.5 * (p_corr1 + p_corr2);
		else {
			sprintf(msg, "assign_tile_velocity(): epsilon 2, epsilon1, p_corr2 are %f %f %f", epsilon2, epsilon1, p_corr2);
			ffd_log(msg, FFD_NORMAL);
			ffd_log("assign_tile_velocity(): the inital value is not right", FFD_ERROR);
			return 1;
		}
	}
	/* find p_corr */
	while (NEXT) {
		epsilon3 = pressure_correction(para, var, BINDEX, p_corr3);
		if (fabs(epsilon3) < 1e-5) {
			NEXT = 0;
			/*printf("epsilon3 and p_corr is %f %f\n", epsilon3, p_corr3);*/
		}

		/* stop bisecting if 100 times are performed */
		if (count >= 100) NEXT = 0;

		if (epsilon3 * epsilon1 < 0.0) {
			p_corr2 = p_corr3;
			epsilon2 = epsilon3;
			p_corr3 = 0.5 * (p_corr1 + p_corr3);
		}
		else {
			p_corr1 = p_corr3;
			epsilon1 = epsilon3;
			p_corr3 = 0.5 * (p_corr2 + p_corr3);
		}
		count += 1;
	}
	/* correct all the pressures */
	FOR_ALL_CELL
		p[IX(i, j, k)] += p_corr3;
	END_FOR

	/* update the flow rates at the tiles */
	for (it = 0; it < index; it++) {
		i = BINDEX[0][it];
		j = BINDEX[1][it];
		k = BINDEX[2][it];
		if (flagp[IX(i, j, k)] == TILE) {
			if (i == imax + 1 || j == imax + 1 || k == kmax + 1) {
				if (p[IX(i, j, k)] > 0)
					var[TILE_FLOW_BC][IX(i, j, k)] = pow((p[IX(i, j, k)]) / (var[TILE_RESI_BC][IX(i, j, k)] * rho), 0.5);
				else
					var[TILE_FLOW_BC][IX(i, j, k)] = -1 * pow(fabs((p[IX(i, j, k)]) / (var[TILE_RESI_BC][IX(i, j, k)] * rho)), 0.5);
			}
			else {
				if (p[IX(i, j, k)] > 0)
					var[TILE_FLOW_BC][IX(i, j, k)] = -1 * pow((p[IX(i, j, k)]) / (var[TILE_RESI_BC][IX(i, j, k)] * rho), 0.5);
				else
					var[TILE_FLOW_BC][IX(i, j, k)] = pow(fabs((p[IX(i, j, k)]) / (var[TILE_RESI_BC][IX(i, j, k)] * rho)), 0.5);
			}
		}
	} /*end of for*/
  }/* end of if (para->mytime->step_current == 0) */
  return 0;
}

/****************************************************************************
|  Calculate the flow rates through the tiles using corrected pressure
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \p_corr corrected pressure
| \return 0 if no error occurred
| \ Wei Tian
| \ 09/05/2017
****************************************************************************/
REAL pressure_correction(PARA_DATA* para, REAL** var, int** BINDEX, REAL p_corr) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  int it;
  int index = para->geom->index;
  REAL* flagp = var[FLAGP];
  REAL* p = var[IP]; /* pressure */
  REAL epsilon = 1e6, corrected_flow = 0.0, in_flowrate = 0.0, out_flowrate = 0.0;
  REAL axy, ayz, azx;
  REAL rho = para->prob->rho;

  in_flowrate = vol_inflow(para, var, BINDEX);
  out_flowrate = vol_outflow(para, var, BINDEX);
  in_flowrate -= out_flowrate;
  for (it = 0; it < index; it++) {
	i = BINDEX[0][it];
	j = BINDEX[1][it];
	k = BINDEX[2][it];
	axy = area_xy(para, var, i, j, k);
	ayz = area_yz(para, var, i, j, k);
	azx = area_zx(para, var, i, j, k);
	if (flagp[IX(i, j, k)] == TILE) {
		if (i == imax + 1 || i == 0) {
			if ((p[IX(i, j, k)] + p_corr) > 0)
				corrected_flow += pow((p[IX(i, j, k)] + p_corr) / (var[TILE_RESI_BC][IX(i, j, k)] * rho), 0.5) * ayz;
			else
				corrected_flow -= pow(fabs((p[IX(i, j, k)] + p_corr) / (var[TILE_RESI_BC][IX(i, j, k)] * rho)), 0.5) * ayz;
		}
		if (j == jmax + 1 || j == 0) {
			if ((p[IX(i, j, k)] + p_corr) > 0)
				corrected_flow += pow((p[IX(i, j, k)] + p_corr) / (var[TILE_RESI_BC][IX(i, j, k)] * rho), 0.5) * azx;
			else
				corrected_flow -= pow(fabs((p[IX(i, j, k)] + p_corr) / (var[TILE_RESI_BC][IX(i, j, k)] * rho)), 0.5) * azx;
		}
		if (k == kmax + 1 || k == 0) {
			if ((p[IX(i, j, k)] + p_corr) > 0)
				corrected_flow += pow((p[IX(i, j, k)] + p_corr) / (var[TILE_RESI_BC][IX(i, j, k)] * rho), 0.5) * axy;
			else
				corrected_flow -= pow(fabs((p[IX(i, j, k)] + p_corr) / (var[TILE_RESI_BC][IX(i, j, k)] * rho)), 0.5) * axy;
		}
	}
  } /*end of for*/
	epsilon = corrected_flow - in_flowrate;
	return epsilon;
}

/****************************************************************************
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \return 0 if no error occurred
|
| \ Wei Tian, 10-19-2017, Wei.Tian@Schneider-Electric.com
****************************************************************************/
int tile_source(PARA_DATA* para, REAL** var, int** BINDEX) {
  int i, j, k, tile_index;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  int it;
  int index = para->geom->index;
  REAL* flagp = var[FLAGP];
  REAL* u = var[VX], * v = var[VY], * w = var[VZ];
  REAL axy, ayz, azx;
  int put_X = para->geom->tile_putX, put_Y = para->geom->tile_putY, put_Z = para->geom->tile_putZ;
  int split_limitX = 1, split_limitY = 1, split_limitZ = 1;
  REAL frac = 0.0; /* percentage to explicit for source term */

  /*Calculate the velocity in cells above*/
  for (it = 0; it < index; it++) {
	i = BINDEX[0][it];
	j = BINDEX[1][it];
	k = BINDEX[2][it];

	axy = area_xy(para, var, i, j, k);
	ayz = area_yz(para, var, i, j, k);
	azx = area_zx(para, var, i, j, k);

	if (flagp[IX(i, j, k)] == TILE) {
		if (put_X) {
			if (u[IX(i, j, k)] > 0) {
				for (tile_index = 0; tile_index < split_limitX; tile_index++) {
					var[APXS][IX(i - tile_index - 2, j, k)] = 2 * ayz * var[TILE_RESI_BC][IX(i, j, k)] * pow(u[IX(i, j, k)], 1) * 1.0 / (REAL)split_limitX;
					var[VXS][IX(i - tile_index - 2, j, k)] = 1 * ayz * var[TILE_RESI_BC][IX(i, j, k)] * pow(u[IX(i, j, k)], 2) * 1.0 / (REAL)split_limitX;
				}
			}
			else {
				for (tile_index = 0; tile_index < split_limitX; tile_index++) {
					var[APXS][IX(i - tile_index - 2, j, k)] = -2 * ayz * var[TILE_RESI_BC][IX(i, j, k)] * pow(u[IX(i, j, k)], 1) * 1.0 / (REAL)split_limitX;
					var[VXS][IX(i - tile_index - 2, j, k)] = -ayz * var[TILE_RESI_BC][IX(i, j, k)] * pow(u[IX(i, j, k)], 2) * 1.0 / (REAL)split_limitX;
				}
			}
		}
		else if (put_Y) {
			if (v[IX(i, j, k)] > 0) {
				for (tile_index = 0; tile_index < split_limitY; tile_index++) {
					var[APYS][IX(i, j - tile_index - 2, k)] = 2 * azx * var[TILE_RESI_BC][IX(i, j, k)] * pow(v[IX(i, j, k)], 1) * 1.0 / (REAL)split_limitY;
					var[VYS][IX(i, j - tile_index - 2, k)] = 1 * azx * var[TILE_RESI_BC][IX(i, j, k)] * pow(v[IX(i, j, k)], 2) * 1.0 / (REAL)split_limitY;
				}
			}
			else {
				for (tile_index = 0; tile_index < split_limitY; tile_index++) {
					var[APYS][IX(i, j - tile_index - 2, k)] = -2 * azx * var[TILE_RESI_BC][IX(i, j, k)] * pow(v[IX(i, j, k)], 1) * 1.0 / (REAL)split_limitY;
					var[VYS][IX(i, j - tile_index - 2, k)] = -azx * var[TILE_RESI_BC][IX(i, j, k)] * pow(v[IX(i, j, k)], 2) * 1.0 / (REAL)split_limitY;
				}
			}
		}
		else {
			if (w[IX(i, j, k - 1)] > 0) {
				for (tile_index = 0; tile_index < split_limitZ; tile_index++) {
					/*Semi-Implicit*/
					var[APZS][IX(i, j, k - tile_index - 2)] = 2 * (1 - frac) * axy * var[TILE_RESI_BC][IX(i, j, k)] * pow(w[IX(i, j, k - 1)], 1) * 1.0 / (REAL)split_limitZ;
					var[VZS][IX(i, j, k - tile_index - 2)] = -1 * (2 * frac - 1) * axy * var[TILE_RESI_BC][IX(i, j, k)] * pow(w[IX(i, j, k - 1)], 2) * 1.0 / (REAL)split_limitZ;
				}
			}
			else {
				for (tile_index = 0; tile_index < split_limitZ; tile_index++) {
					/*Semi-Implicit*/
					var[APZS][IX(i, j, k - tile_index - 2)] = -2 * (1 - frac) * axy * var[TILE_RESI_BC][IX(i, j, k)] * pow(w[IX(i, j, k - 1)], 1) * 1.0 / (REAL)split_limitZ;
					var[VZS][IX(i, j, k - tile_index - 2)] = (2 * frac - 1) * axy * var[TILE_RESI_BC][IX(i, j, k)] * pow(w[IX(i, j, k - 1)], 2) * 1.0 / (REAL)split_limitZ;
				}
			}
		}
	}/* end of if (flagp[IX(i, j, k)] == TILE) */
  }/* end of for (it = 0; it < index; it++) */

  /* Output the tile flow rates information */
  if (check_tile_flowrate(para, var, BINDEX) != 0) {
	ffd_log("tile_room_split: can not output the flow rates at tiles", FFD_ERROR);
  }
  return 0;
}

/****************************************************************************
|  The black box model of rack, which treat the rack as a box with inlet outlet and heat dissipation
|  The temperature stratification of inlet temperature is kept in the outlet temperature
|  The velocity at inlet and outlet is the same
|  The inlet of rack is treated as outlet for the DC room while the outlet of rack is treated as inlet for DC room
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| \return 0 if no error occurred
| \ Version 1.0
| \ Wei Tian, 1-20-2018, Wei.Tian@Schneider-Electric.com
****************************************************************************/
int rack_model_black_box(PARA_DATA* para, REAL** var, int** BINDEX) {
  int i, j, k, it, id, obj_type;
  int iin, jin, kin;
  REAL* flagp = var[FLAGP];
  int index = para->geom->index, imax = para->geom->imax,
	jmax = para->geom->jmax, kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL axy, ayz, azx;
  REAL mDot_Cp, Q_dot;

  /* Loop all the boundary cells */
  for (it = 0; it < index; it++) {
	i = BINDEX[0][it];
	j = BINDEX[1][it];
	k = BINDEX[2][it];
	id = BINDEX[4][it];
	obj_type = BINDEX[5][it];

	/* calculate the area */
	axy = area_xy(para, var, i, j, k);
	ayz = area_yz(para, var, i, j, k);
	azx = area_zx(para, var, i, j, k);

	/* If it is rack cell and it is a rack inlet boundary */
	if (obj_type == RACK) {
		/* Assign velocity to the inlet of rack */
		if (flagp[IX(i, j, k)] == RACK_INLET) {
			if (para->bc->RackDir[id] == 1 || para->bc->RackDir[id] == -1) {
				var[VXBC][IX(i, j, k)] = para->bc->RackFlowRate[id] / para->bc->RackArea[id] * sign(para->bc->RackDir[id])/*direction*/;
				var[VYBC][IX(i, j, k)] = 0.0;
				var[VZBC][IX(i, j, k)] = 0.0;
				/* Assign the adjacent fluid cell temperature to the inlet of rack */
				var[TEMPBC][IX(i, j, k)] = var[TEMP][IX(i - sign(para->bc->RackDir[id]), j, k)];
			}
			else if (para->bc->RackDir[id] == 2 || para->bc->RackDir[id] == -2) {
				var[VYBC][IX(i, j, k)] = para->bc->RackFlowRate[id] / para->bc->RackArea[id] * sign(para->bc->RackDir[id])/*direction*/;
				var[VXBC][IX(i, j, k)] = 0.0;
				var[VZBC][IX(i, j, k)] = 0.0;
				/* Assign the adjacent fluid cell temperature to the inlet of rack */
				var[TEMPBC][IX(i, j, k)] = var[TEMP][IX(i, j - sign(para->bc->RackDir[id]), k)];
			}
			else if (para->bc->RackDir[id] == 3 || para->bc->RackDir[id] == -3) {
				var[VZBC][IX(i, j, k)] = para->bc->RackFlowRate[id] / para->bc->RackArea[id] * sign(para->bc->RackDir[id])/*direction*/;
				var[VXBC][IX(i, j, k)] = 0.0;
				var[VYBC][IX(i, j, k)] = 0.0;
				/* Assign the adjacent fluid cell temperature to the inlet of rack */
				var[TEMPBC][IX(i, j, k)] = var[TEMP][IX(i, j, k - sign(para->bc->RackDir[id]))];
			}
			else {
				ffd_log("rack_model_black_box(): fail to detect the flow direction of the rack", FFD_ERROR);
				return 1;
			}

		}
		/* Assign velocity and temperature to outlet of rack */
		else if (flagp[IX(i, j, k)] == RACK_OUTLET) {
			if (para->bc->RackDir[id] == 1 || para->bc->RackDir[id] == -1) {
				var[VXBC][IX(i, j, k)] = para->bc->RackFlowRate[id] / para->bc->RackArea[id] * sign(para->bc->RackDir[id])/*direction*/;
				var[VYBC][IX(i, j, k)] = 0.0;
				var[VZBC][IX(i, j, k)] = 0.0;
				/* Calculate the temperature at the outlet of rack */
				if (k == 0) {/* This is to eliminate the divide by zero scenario */
					ayz = area_yz(para, var, i, j, k + 1);
				}
				iin = i - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][0];
				jin = j - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][1];
				kin = k - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][2];
				Q_dot = para->bc->HeatDiss[id] * ayz / para->bc->RackArea[id]; /* heat dissipation by area */
				mDot_Cp = para->prob->rho * var[VXBC][IX(i, j, k)] * ayz * para->prob->Cp; /* mass flow rate multiply Cp */
				var[TEMPBC][IX(i, j, k)] = var[TEMPBC][IX(iin, jin, kin)] + sign(para->bc->RackDir[id]) * Q_dot / mDot_Cp;
			}
			else if (para->bc->RackDir[id] == 2 || para->bc->RackDir[id] == -2) {
				var[VYBC][IX(i, j, k)] = para->bc->RackFlowRate[id] / para->bc->RackArea[id] * sign(para->bc->RackDir[id])/*direction*/;
				var[VXBC][IX(i, j, k)] = 0.0;
				var[VZBC][IX(i, j, k)] = 0.0;
				/* Calculate the temperature at the outlet of rack */
				iin = i - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][0];
				jin = j - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][1];
				kin = k - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][2];
				Q_dot = para->bc->HeatDiss[id] * azx / para->bc->RackArea[id]; /* heat dissipation by area */
				mDot_Cp = para->prob->rho * var[VYBC][IX(i, j, k)] * azx * para->prob->Cp; /* mass flow rate multiply Cp */
				var[TEMPBC][IX(i, j, k)] = var[TEMPBC][IX(iin, jin, kin)] + Q_dot / mDot_Cp;
			}
			else if (para->bc->RackDir[id] == 3 || para->bc->RackDir[id] == -3) {
				var[VZBC][IX(i, j, k)] = para->bc->RackFlowRate[id] / para->bc->RackArea[id] * sign(para->bc->RackDir[id])/*direction*/;
				var[VXBC][IX(i, j, k)] = 0.0;
				var[VYBC][IX(i, j, k)] = 0.0;
				/* Calculate the temperature at the outlet of rack */
				iin = i - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][0];
				jin = j - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][1];
				kin = k - sign(para->bc->RackDir[id]) * para->bc->RackMap[id][2];
				Q_dot = para->bc->HeatDiss[id] * axy / para->bc->RackArea[id]; /* heat dissipation by area */
				mDot_Cp = para->prob->rho * var[VZBC][IX(i, j, k)] * axy * para->prob->Cp; /* mass flow rate multiply Cp */
				var[TEMPBC][IX(i, j, k)] = var[TEMPBC][IX(iin, jin, kin)] + Q_dot / mDot_Cp;
			}
			else {
				ffd_log("rack_model_black_box(): fail to detect the flow direction of the rack", FFD_ERROR);
				return 1;
			}
		} /*end of else if (flagp[IX(i,j,k)]==RACK_OUTLET)*/
		/* Pass internal rack cells */
		else {
			continue;
		} /*end of else*/
	} /*end of if (obj_type == RACK)*/
  } /*end of for(it=0; it<index; it++)*/
  /* return 0 */
  return 0;
}
