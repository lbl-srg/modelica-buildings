/****************************************************************************
|
|  \file   initialization.c
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
|  \add: call function min_distance to calculate the distance of
| 	 a fluid cell to the nearest solid boundary condition, which
| 	 is to be used by Chen's zero equation turbulence model
****************************************************************************/

#include "initialization.h"

/****************************************************************************
|  Initialize the parameters
|
| \param para Pointer to FFD parameters
|
| \return 0 if no error occurred
****************************************************************************/
int initialize(PARA_DATA* para) {
  /* Define the default value for parameter */
  set_default_parameter(para);

  /* Overwrite the default values using user defined values */
  if (read_parameter(para)) {
	ffd_log("initialize(): Failed to read paramter file.", FFD_ERROR);
	return 1;
  }

  /*---------------------------------------------------------------------------
  | Output the help information
  ---------------------------------------------------------------------------*/
  if (para->outp->version == DEMO) {
	printf("\n\nHow to use this demo:\n\n");
	printf("\t Switch Windows: \n");
	printf("\t\tVelocity: key '1'\n");
	printf("\t\tContaminant: key '2'\n");
	printf("\t\tTemperature: key '3'\n");
	printf("\t Choose plane: \n");
	printf("\t\tXY plane: key 'Z' or 'z'\n");
	printf("\t\tXZ plane: key 'Y' or 'y'\n");
	printf("\t\tYZ plane: key 'X' or 'x'\n");
	printf("\t Move the plane forward with '+' key\n");
	printf("\t Move the plane backward with '-' key\n");
	printf("\t Add densities with the right mouse button\n");
	printf("\t Add velocities with the left mouse button\n");
	printf("\t Increase the velocity scale with 'K' or 'k' key\n");
	printf("\t Decrease the velocity scale with 'L' or 'l' key\n");
	printf("\t Calcualte mean value with 'M' or 'm' key\n");
	printf("\t Generate result file with 'S' or 's' key\n");
	/*printf("\t Increase the BC temperature with 'H' or 'h' key\n");*/
	/*printf("\t Decrease the BC temperature with 'C' or 'c' key\n" );*/
	printf("\t Clear the simulation by pressing the '0' key\n");
	printf("\t Quit by pressing the 'q' key\n");
  }

  return 0;
} /* End of initialize( ) */

/****************************************************************************
|  Set the default value for parameters
|
| \param para Pointer to FFD parameters
|
| \return No return needed
****************************************************************************/
void set_default_parameter(PARA_DATA* para) {
  para->mytime->t = 0.0;
  para->mytime->step_current = 0;
  para->mytime->t_start = clock();

  para->prob->alpha = (REAL)2.376e-5; /* Thermal diffusity */
  para->prob->diff = 0.00001;
  para->prob->force = 1.0;
  para->prob->heat = 1.0;
  para->prob->source = 100.0;

  para->prob->chen_a = (REAL)0.03874; /* Coeffcient of Chen's model */
  para->prob->Prt = (REAL)0.9; /* Turbulent Prandl number */
  para->prob->rho = (REAL)1.0;
  para->prob->tur_model = LAM; /* No turbulence model */

  para->solv->check_residual = 0; /* Donot check residual */
  para->solv->solver = GS; /* Gauss-Seidel Solver */
  para->solv->interpolation = BILINEAR; /* Bilinear interpolation */

  /* Default values for Input */
  para->inpu->read_old_ffd_file = 0; /* Do not read the old FFD data as initial value */

  /* Default values for Output */
  para->outp->Temp_ref = 0;/*35.5f;*/ /*10.25f;*/
  para->outp->cal_mean = 0;
  para->outp->v_length = 1;
  para->outp->winx = 600;
  para->outp->winy = 600;
  para->outp->winz = 600;
  para->outp->v_ref = 1.0;
  para->outp->version = DEBUG; /* Running the debug version */
  para->outp->i_N = 1;
  para->outp->j_N = 1;
  para->outp->k_N = 1;
  para->outp->tstep_display = 10; /* Update the display for every 10 time steps */
  para->outp->screen = 1; /* Draw velocity */
  para->outp->mouse_i = 0;
  para->outp->mouse_j = 0;
  para->outp->mouse_k = 0;
  para->geom->plane = ZX; /* Draw ZX plane */
  para->bc->nb_port = 0;
  para->bc->nb_Xi = 0;
  para->bc->nb_C = 0;
  para->sens->nb_sensor = 0; /* Number of sensors */
  para->solv->swipe_adv = 5; /* 5 swipes for advection */
  para->solv->swipe_dif = 5; /* 5 swipes for diffusion */
  para->solv->swipe_pro = 10; /* 10 swipes for projection */
  para->solv->solver = GS; /* use gauss seidels solver as default */
  para->solv->check_conservation = 1; /* check the scalar conervation stepwise */
  para->prob->Tem_Ave_LastTime = 0.0;
  para->prob->Energy_Imb_Adv = 0.0;
  para->prob->coef_CONSTANT = 100.0;
  para->prob->coef_stanchion = 0.0;
  para->solv->mass_conservation_on = 1; /* always turn on mass balance */
  para->geom->tile_putX = 0; /* by default the tile is NOT put in X direction */
  para->geom->tile_putY = 0; /* by default the tile is NOT put in Y direction */
  para->geom->tile_putZ = 1; /* by default the tile is put in Z direction */
  para->bc->nb_rack = 0; /* assume no racks */
  para->bc->outlet_bc = ZERO_GRADIENT; /*PRESCRIBED_VALUE;*/ /* assume Neumann BC for outlet */
  para->outp->result_file = PLT; /* set the result file in tecplot format */
} /* End of set_default_parameter */

/****************************************************************************
|  Set default initial values for simulation variables
|
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
|
| \return 0 if no error occurred
****************************************************************************/
int set_initial_data(PARA_DATA* para, REAL** var, int** BINDEX) {
  int i, j;
  int size = (para->geom->imax + 2) * (para->geom->jmax + 2) * (para->geom->kmax + 2);
  int flag = 0;

  para->mytime->t = 0.0;
  para->mytime->step_current = 0;
  para->outp->cal_mean = 0;

  /****************************************************************************
  | Set inital value for FFD variables
  ****************************************************************************/
  for (i = 0; i < size; i++) {
	var[GX][i] = 0.0;
	var[GY][i] = 0.0;
	var[GZ][i] = 0.0;
	var[VX][i] = para->init->u;
	var[VY][i] = para->init->v;
	var[VZ][i] = para->init->w;
	var[VXM][i] = 0.0;
	var[VYM][i] = 0.0;
	var[VZM][i] = 0.0;
	var[VXS][i] = 0.0;
	var[VYS][i] = 0.0;
	var[VZS][i] = 0.0;
	var[TEMP][i] = para->init->T;
	var[TEMPM][i] = 0.0;
	var[TEMPS][i] = 0.0;  /* Source of temperature */
	var[IP][i] = 0.0;
	var[AP][i] = 0.0;
	var[AW][i] = 0.0;
	var[AE][i] = 0.0;
	var[AS][i] = 0.0;
	var[AN][i] = 0.0;
	var[AB][i] = 0.0;
	var[AF][i] = 0.0;
	var[B][i] = 0.0;
	var[AP0][i] = 0.0;
	var[TMP1][i] = 1000.0;
	var[TMP2][i] = 0.0;
	var[TMP3][i] = 0.0;
	var[TMP4][i] = 0.0;
	var[PP][i] = 0.0;
	var[FLAGP][i] = -1.0;
	var[FLAGU][i] = -1.0;
	var[FLAGV][i] = -1.0;
	var[FLAGW][i] = -1.0;
	var[VXBC][i] = 0.0;
	var[VYBC][i] = 0.0;
	var[VZBC][i] = 0.0;
	var[TEMPBC][i] = 0.0;
	var[QFLUXBC][i] = 0.0;
	var[QFLUX][i] = 0.0;
	var[Xi1][i] = 0.0;
	var[Xi2][i] = 0.0;
	var[Xi1S][i] = 0.0;
	var[Xi2S][i] = 0.0;
	var[Xi1BC][i] = 0.0;
	var[Xi2BC][i] = 0.0;
	var[C1][i] = 0.0;
	var[C2][i] = 0.0;
	var[C1S][i] = 0.0;
	var[C2S][i] = 0.0;
	var[C1BC][i] = 0.0;
	var[C2BC][i] = 0.0;
	var[MIN_DISTANCE][i] = 0.0;
	var[TILE_OPEN_BC][i] = 1.0;
	var[TILE_RESI_BC][i] = 0.0;
	var[TILE_FLOW_BC][i] = 0.0;
	var[PBC][i] = 0.0;
	var[IPS][i] = 0.0;
	var[APXS][i] = 0.0;
	var[APYS][i] = 0.0;
	var[APZS][i] = 0.0;
	var[RESX][i] = 0.0;
	var[RESY][i] = 0.0;
	var[RESZ][i] = 0.0;
  }

  /* Calculate the thermal diffusivity */
  para->prob->alpha = para->prob->cond / (para->prob->rho * para->prob->Cp);

  /****************************************************************************
  | Read the configurations defined by SCI
  ****************************************************************************/
  if (para->inpu->parameter_file_format == SCI) {
	/* check number of racks */
	flag = check_num_racks(para, var, BINDEX);
	/* read the sci input file line by line */
	flag = read_sci_input(para, var, BINDEX);
	if (flag != 0) {
		sprintf(msg, "set_inital_data(): Could not read file %s",
			para->inpu->parameter_file_name);
		ffd_log(msg, FFD_ERROR);
		return flag;
	}
	flag = read_sci_zeroone(para, var, BINDEX);
	if (flag != 0) {
		ffd_log("set_inital_data(): Could not read block information file",
			FFD_ERROR);
		return flag;
	}

	/* mark the cells */
	mark_cell(para, var, BINDEX);
  }

  /****************************************************************************
  | Allocate memory for sensor data if there is at least one sensor
  ****************************************************************************/
  if (para->sens->nb_sensor > 0) {
	para->sens->senVal = (REAL*)malloc(para->sens->nb_sensor * sizeof(REAL));
	if (para->sens->senVal == NULL) {
		ffd_log("set_initial_data(): Could not allocate memory for "
			"para->sens->senVal", FFD_ERROR);
		return -1;
	}
	para->sens->senValMean = (REAL*)malloc(para->sens->nb_sensor * sizeof(REAL));
	if (para->sens->senValMean == NULL) {
		ffd_log("set_initial_data(): Could not allocate memory for "
			"para->sens->senValMean", FFD_ERROR);
		return 1;
	}
  }

  /****************************************************************************
  | Allocate memory for Species
  ****************************************************************************/
  if (para->bc->nb_port > 0 && para->bc->nb_Xi > 0) {
	para->bc->XiPort = (REAL * *)malloc(sizeof(REAL*) * para->bc->nb_port);
	para->bc->XiPortAve = (REAL * *)malloc(sizeof(REAL*) * para->bc->nb_port);
	para->bc->XiPortMean = (REAL * *)malloc(sizeof(REAL*) * para->bc->nb_port);
	if (para->bc->XiPort == NULL ||
		para->bc->XiPortAve == NULL ||
		para->bc->XiPortMean == NULL) {
		ffd_log("set_initial_data(): Could not allocate memory for XiPort.",
			FFD_ERROR);
		return 1;
	}

	for (i = 0; i < para->bc->nb_port; i++) {
		para->bc->XiPort[i] = (REAL*)malloc(sizeof(REAL) * para->bc->nb_Xi);
		para->bc->XiPortAve[i] = (REAL*)malloc(sizeof(REAL) * para->bc->nb_Xi);
		para->bc->XiPortMean[i] = (REAL*)malloc(sizeof(REAL) * para->bc->nb_Xi);
		if (para->bc->XiPort[i] == NULL ||
			para->bc->XiPortAve[i] == NULL ||
			para->bc->XiPortMean[i] == NULL) {
			sprintf(msg, "set_initial_data(): Could not allocate memory for "
				"Xi at Port[%d].", i);
			ffd_log(msg, FFD_ERROR);
			return 1;
		}

		for (j = 0; j < para->bc->nb_Xi; j++) {
			para->bc->XiPort[i][j] = 0.0;
			para->bc->XiPortAve[i][j] = 0.0;
			para->bc->XiPortMean[i][j] = 0.0;
		}
	}
	if (para->outp->version == DEBUG) {
		ffd_log("Allocated memory for Xi", FFD_NORMAL);
	}
  }
  else  if (para->outp->version == DEBUG) {
	ffd_log("No Xi in the simulation", FFD_NORMAL);
  }

  /****************************************************************************
  | Allocate memory for Substances
  ****************************************************************************/
  if (para->bc->nb_port > 0 && para->bc->nb_C > 0) {
	para->bc->CPort = (REAL * *)malloc(sizeof(REAL*) * para->bc->nb_port);
	para->bc->CPortAve = (REAL * *)malloc(sizeof(REAL*) * para->bc->nb_port);
	para->bc->CPortMean = (REAL * *)malloc(sizeof(REAL*) * para->bc->nb_port);
	if (para->bc->CPort == NULL || para->bc->CPortAve == NULL
		|| para->bc->CPortMean) {
		ffd_log("set_initial_data(): Could not allocate memory for CPort.",
			FFD_ERROR);
		return 1;
	}

	for (i = 0; i < para->bc->nb_port; i++) {
		para->bc->CPort[i] = (REAL*)malloc(sizeof(REAL) * para->bc->nb_C);
		para->bc->CPortAve[i] = (REAL*)malloc(sizeof(REAL) * para->bc->nb_C);
		para->bc->CPortMean[i] = (REAL*)malloc(sizeof(REAL) * para->bc->nb_C);
		if (para->bc->CPort[i] == NULL || para->bc->CPortAve[i] == NULL
			|| para->bc->CPortMean[i]) {
			ffd_log("set_initial_data(): "
				"Could not allocate memory for C at Port[i].",
				FFD_ERROR);
			return 1;
		}

		for (j = 0; j < para->bc->nb_C; j++) {
			para->bc->CPort[i][j] = 0.0;
			para->bc->CPortAve[i][j] = 0.0;
			para->bc->CPortMean[i][j] = 0.0;
		}
	}
	if (para->outp->version == DEBUG) {
		ffd_log("Allocated memory for C", FFD_NORMAL);
	}
  }
  else if (para->outp->version == DEBUG) {
	ffd_log("No C in the simulation", FFD_NORMAL);
  }

  /****************************************************************************
  | Pre-calculate data needed but not change in the simulation
  ****************************************************************************/
  para->geom->volFlu = fluid_volume(para, var);
  para->geom->pindex = (int)para->geom->jmax / 2;
  /* rack inlet or outlet area */
  if (para->bc->nb_rack != 0) {
	if (rack_fluid_area(para, var, BINDEX) != 0) {
		ffd_log("set_initial_data():  Could not calculate the area of the rack inlet or outlet",
			FFD_ERROR);
	}
  }

  /****************************************************************************
  | Set all the averaged data to 0
  ****************************************************************************/
  flag = reset_time_averaged_data(para, var);
  if (flag != 0) {
	ffd_log("FFD_solver(): Could not reset averaged data.",
		FFD_ERROR);
	return flag;
  }


  /****************************************************************************
  | Conduct the data exchange at the initial state of cosimulation
  ****************************************************************************/
  if (para->solv->cosimulation == 1) {
	  /*------------------------------------------------------------------------
	  | Calculate the area of boundary
	  ------------------------------------------------------------------------*/
	  flag = bounary_area(para, var, BINDEX);
	  if (flag != 0) {
		  ffd_log("set_initial_data(): Could not get the boundary area.",
			  FFD_ERROR);
		  return flag;
	  }
	  /*------------------------------------------------------------------------
	  | Read the cosimulation parameter data (Only need once)
	  ------------------------------------------------------------------------*/
	  flag = read_cosim_parameter(para, var, BINDEX);
	  if (flag != 0) {
		  ffd_log("set_initial_data(): Could not read cosimulation parameters.",
			  FFD_ERROR);
		  return 1;
	  }
	  /*------------------------------------------------------------------------
	  | Read the cosimulation data
	  ------------------------------------------------------------------------*/
	  flag = read_cosim_data(para, var, BINDEX);
	  if (flag != 0) {
		  ffd_log("set_initial_data(): Could not read initial data for "
			  "cosimulaiton.", FFD_ERROR);
		  return flag;
	  }

	  /*------------------------------------------------------------------------
	  | Perform the simulation for one step to update the FFD initial condition
	  ------------------------------------------------------------------------*/

	  flag = vel_step(para, var, BINDEX);
	  if (flag != 0) {
		  ffd_log("FFD_solver(): Could not solve velocity.", FFD_ERROR);
		  return flag;
	  }
	  else if (para->outp->version == DEBUG)
		  ffd_log("FFD_solver(): solved velocity step.", FFD_NORMAL);



	  flag = temp_step(para, var, BINDEX);
	  if (flag != 0) {
		  ffd_log("FFD_solver(): Could not solve temperature.", FFD_ERROR);
		  return flag;
	  }
	  else if (para->outp->version == DEBUG)
		  ffd_log("FFD_solver(): solved temperature step.", FFD_NORMAL);

	  flag = den_step(para, var, BINDEX);
	  if (flag != 0) {
		  ffd_log("FFD_solver(): Could not solve trace substance.", FFD_ERROR);
		  return flag;
	  }
	  else if (para->outp->version == DEBUG)
		  ffd_log("FFD_solver(): solved density step.", FFD_NORMAL);

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

	  /* Average the FFD simulation data*/
	  flag = average_time(para, var);
	  if (flag != 0) {
		  ffd_log("FFD_solver(): Could not average the data over time.",
			  FFD_ERROR);
		  return flag;
	  }
	  
	  /*------------------------------------------------------------------------
	  | Write the cosimulation data
	  ------------------------------------------------------------------------*/
	  flag = write_cosim_data(para, var);
	  if (flag != 0) {
		  ffd_log("set_initial_data(): Could not write initial data for "
			  "cosimulaiton.", FFD_ERROR);
		  return flag;
	  }
  }

  return flag;
} /* set_initial_data() */

/****************************************************************************
|  Loop through all the BC cells and find if tiles there
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param BINDEX Pointer to boundary index
| 
| \return 0 if no error occurred
****************************************************************************/
int if_exist_tiles(PARA_DATA* para, REAL** var, int** BINDEX) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  int it;
  int index = para->geom->index;
  REAL* flagp = var[FLAGP];
  int num_tile = 0;

  for (it = 0; it < index; it++) {
	i = BINDEX[0][it];
	j = BINDEX[1][it];
	k = BINDEX[2][it];

	if (flagp[IX(i, j, k)] == TILE) {
		num_tile += 1;
	}
  }

  if (num_tile > 0)
	return 1;
  else if (num_tile == 0)
	return 0;
  else {
	ffd_log("if_exist_tiles(): can not figure out number of tile cells", FFD_ERROR);
	return -1;
  }
}

/****************************************************************************
|  Set the default value for parameters
|
| \param para Pointer to FFD parameters
|
| \return No return needed
****************************************************************************/
int init_para_simp(PARA_DATA* para, PARA_DATA_SIMP* para_simp) {
  /* geom data */
  para_simp->geom.Lx = para->geom->Lx;
  para_simp->geom.Ly = para->geom->Ly;
  para_simp->geom.Lz = para->geom->Lz;
  para_simp->geom.imax = para->geom->imax;
  para_simp->geom.jmax = para->geom->jmax;
  para_simp->geom.kmax = para->geom->kmax;
  para_simp->geom.index = para->geom->index;
  para_simp->geom.pindex = para->geom->pindex;
  para_simp->geom.plane = para->geom->plane;
  para_simp->geom.dx = para->geom->dx;
  para_simp->geom.dy = para->geom->dy;
  para_simp->geom.dz = para->geom->dz;
  para_simp->geom.volFlu = para->geom->volFlu;
  para_simp->geom.uniform = para->geom->uniform;

  /* outp data */
  para_simp->outp_simp.cal_mean = para->outp->cal_mean;
  para_simp->outp_simp.version = para->outp->version;

  /* prob data */
  para_simp->prob.nu = para->prob->nu;
  para_simp->prob.rho = para->prob->rho;
  para_simp->prob.diff = para->prob->diff;
  para_simp->prob.alpha = para->prob->alpha;
  para_simp->prob.coeff_h = para->prob->coeff_h;
  para_simp->prob.gravx = para->prob->gravx;
  para_simp->prob.gravy = para->prob->gravy;
  para_simp->prob.gravz = para->prob->gravz;
  para_simp->prob.beta = para->prob->beta;
  para_simp->prob.cond = para->prob->cond;
  para_simp->prob.Cp = para->prob->Cp;
  para_simp->prob.force = para->prob->force;
  para_simp->prob.heat = para->prob->heat;
  para_simp->prob.source = para->prob->source;
  para_simp->prob.movie = para->prob->movie;
  para_simp->prob.output = para->prob->output;
  para_simp->prob.tur_model = para->prob->tur_model;
  para_simp->prob.chen_a = para->prob->chen_a;
  para_simp->prob.Prt = para->prob->Prt;
  para_simp->prob.Temp_Buoyancy = para->prob->Temp_Buoyancy;
  para_simp->prob.coef_stanchion = para->prob->coef_stanchion;

  /* bc data */
  para_simp->bc_simp.nb_bc = para->bc->nb_bc;
  para_simp->bc_simp.nb_outlet = para->bc->nb_outlet;
  para_simp->bc_simp.nb_block = para->bc->nb_block;
  para_simp->bc_simp.nb_wall = para->bc->nb_wall;
  para_simp->bc_simp.nb_source = para->bc->nb_source;
  para_simp->bc_simp.nb_bc = para->bc->nb_bc;
  para_simp->bc_simp.nb_ConExtWin = para->bc->nb_ConExtWin;
  para_simp->bc_simp.nb_port = para->bc->nb_port;
  para_simp->bc_simp.nb_Xi = para->bc->nb_Xi;
  para_simp->bc_simp.nb_C = para->bc->nb_C;
  para_simp->bc_simp.sha = para->bc->sha;
  para_simp->bc_simp.mass_in = 0.000000;
  para_simp->bc_simp.mass_out = 0.0000001;
  para_simp->bc_simp.outlet_bc = para->bc->outlet_bc;

  /* sensor data */
  para_simp->sens_simp.nb_sensor = para->sens->nb_sensor;
  para_simp->sens_simp.TRoo = para->sens->TRoo;
  para_simp->sens_simp.TRooMean = para->sens->TRooMean;

  /*time data*/
  para_simp->mytime.dt = (REAL)para->mytime->dt;
  para_simp->mytime.t = (REAL)para->mytime->t;
  para_simp->mytime.step_total = para->mytime->step_total;
  para_simp->mytime.step_current = para->mytime->step_current;
  para_simp->mytime.step_mean = para->mytime->step_mean;
  para_simp->mytime.t_start = para->mytime->t_start;
  para_simp->mytime.t_end = para->mytime->t_end;

  /* solv data */
  para_simp->solv.solver = para->solv->solver;
  para_simp->solv.check_residual = para->solv->check_residual;
  para_simp->solv.advection_solver = para->solv->advection_solver;
  para_simp->solv.interpolation = para->solv->interpolation;
  para_simp->solv.cosimulation = para->solv->cosimulation;
  para_simp->solv.nextstep = para->solv->nextstep;
  para_simp->solv.tile_flow_correct = para->solv->tile_flow_correct;

  /* init data */
  para_simp->init.T = para->init->T;
  para_simp->init.v = para->init->v;
  para_simp->init.w = para->init->w;
  para_simp->init.v = para->init->v;

  return 0;
} /* End of set_default_parameter */

/* flat var */
int flat_var(PARA_DATA* para, REAL** var, REAL* var_flat) {
  int nb_var, i, j;
  int size = (para->geom->imax + 2) * (para->geom->jmax + 2) * (para->geom->kmax + 2);
  nb_var = C2BC + 1;


  for (i = 0; i < nb_var * size; i++) {
	var_flat[i] = 0.0f;
  }

  for (i = 0; i < nb_var; i++) {
	for (j = 0; j < size; j++) {
		var_flat[i * size + j] = var[i][j];
	}
  }
  return 0;
}

int unflat_var(PARA_DATA* para, REAL** var, REAL* var_flat) {
  int nb_var, i, j;
  int size = (para->geom->imax + 2) * (para->geom->jmax + 2) * (para->geom->kmax + 2);
  nb_var = C2BC + 1;

  for (i = 0; i < nb_var; i++) {
	for (j = 0; j < size; j++) {
		var[i][j] = var_flat[i * size + j];
		/*printf("%d\t%f\t%f\n",i*size+j,var_flat[i*size + j],var[i][j]);*/
	}
  }
  return 0;
}



/* flatten bindex */
int flat_index(PARA_DATA* para, int** BINDEX, int* bindex_flat) {
  int row = 5;
  int i, j;
  int size = (para->geom->imax + 2) * (para->geom->jmax + 2) * (para->geom->kmax + 2);
  
  for (i = 0; i < row; i++) {
	for (j = 0; j < size; j++) {
		bindex_flat[i * size + j] = BINDEX[i][j];
	}
  }

  return 0;
}
