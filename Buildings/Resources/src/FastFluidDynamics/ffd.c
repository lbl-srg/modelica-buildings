/****************************************************************************
|
|  \file ffd.c
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

#include "ffd.h"

/* global variables */
REAL** var;
int** BINDEX;
REAL* locmin, * locmax;
static PARA_DATA para;
static GEOM_DATA geom;
static PROB_DATA prob;
static TIME_DATA mytime;
static INPU_DATA inpu;
static OUTP_DATA outp1;
static BC_DATA bc;
static SOLV_DATA solv;
static SENSOR_DATA sens;
static INIT_DATA init;

clock_t start, end;

/****************************************************************************
|  Allocate memory for variables
|
| \param para Pointer to FFD parameters
|
| \return No return needed
****************************************************************************/
int allocate_memory(PARA_DATA* para) {

  int nb_var, i, j;
  int size = (geom.imax + 2) * (geom.jmax + 2) * (geom.kmax + 2);

  /****************************************************************************
  | Allocate memory for variables
  ****************************************************************************/
  nb_var = C2BC + 1;
  var = (REAL * *) malloc(nb_var * sizeof(REAL*));
  if (var == NULL) {
	ffd_log("allocate_memory(): Could not allocate memory for var.",
		FFD_ERROR);
	return 1;
  }

  for (i = 0; i < nb_var; i++) {
	var[i] = (REAL*) calloc(size, sizeof(REAL));
	if (var[i] == NULL) {
		sprintf(msg,
			"allocate_memory(): Could not allocate memory for var[%d]", i);
		ffd_log(msg, FFD_ERROR);
		return 1;
	}
  }

  /****************************************************************************
  | Allocate memory for boundary cells
  | BINDEX[0]: i of global coordinate in IX(i,j,k)
  | BINDEX[1]: j of global coordinate in IX(i,j,k)
  | BINDEX[2]: k of global coordinate in IX(i,j,k)
  | BINDEX[3]: Fixed temperature or fixed heat flux
  | BINDEX[4]: Boundary ID to identify which boundary it belongs to
  | BINDEX[5]: Type of object that cell belongs to, for example, Rack
  ****************************************************************************/
  BINDEX = (int**) malloc(6 * sizeof(int*));
  if (BINDEX == NULL) {
	ffd_log("allocate_memory(): Could not allocate memory for BINDEX.",
		FFD_ERROR);
	return 1;
  }

  for (i = 0; i < 6; i++) {
	BINDEX[i] = (int*) malloc(size * sizeof(int));
	if (BINDEX[i] == NULL) {
		sprintf(msg,
			"allocate_memory(): Could not allocate memory for BINDEX[%d]", i);
		ffd_log(msg, FFD_ERROR);
		return 1;
	}
  }

  /* initialize the BINDEX */
  for (i = 0; i < 6; i++) {
	for (j = 0; j < size; j++) {
		BINDEX[i][j] = 0;
	}
  }

  return 0;
} /* End of allocate_memory() */

/*
	* Assign the parameter for coupled simulation
	*
	* @para cosim Pointer to the coupled simulation parameters
	*
	* @return 0 if no error occurred
	*/
int ffd_cosimulation(CosimulationData *cosim) {
  para.cosim = (CosimulationData*) malloc(sizeof(CosimulationData));
  para.cosim = cosim;

  if (ffd(1) != 0) {
	cosim->para->ffdError = 1;
	return 1;
  }
  else
	return 0;
} /* End of ffd_cosimulation()*/

/****************************************************************************
|  Main routine of FFD
|
| \para coupled simulation Integer to identify the simulation type
|
| \return 0 if no error occurred
****************************************************************************/
int ffd(int cosimulation) {
	
  /* Initialize the parameters */
  para.geom = &geom;
  para.inpu = &inpu;
  para.outp = &outp1;
  para.prob = &prob;
  para.mytime = &mytime;
  para.bc     = &bc;
  para.solv   = &solv;
  para.sens   = &sens;
  para.init   = &init;
  /* Stand alone simulation: 0; Cosimulaiton: 1*/
  para.solv->cosimulation = cosimulation;

  ffd_log("Start running Fast Fluid Dynamics simulation",	FFD_NEW);

  if(initialize(&para)!=0) {
    ffd_log("ffd(): Could not initialize simulation parameters.", FFD_ERROR);
    return 1;
  }

  /* Overwrite the mesh and simulation data using SCI generated file */
  if(para.inpu->parameter_file_format == SCI) {
    if(read_sci_max(&para, var)!=0) {
      ffd_log("ffd(): Could not read SCI data.", FFD_ERROR);
      return 1;
    }
  }

  /* Allocate memory for the variables */
  if (allocate_memory(&para) != 0) {
	  ffd_log("ffd(): Could not allocate memory for the simulation.", FFD_ERROR);
	  return 1;
  }

  /* Set the initial values for the simulation data */
  if (set_initial_data(&para, var, BINDEX)) {
	  ffd_log("ffd(): Could not set initial data.", FFD_ERROR);
	  return 1;
  }

  /* Read previous simulation data as initial values */
  if (para.inpu->read_old_ffd_file == 1) read_ffd_data(&para, var);

  ffd_log("ffd.c: Start FFD solver.", FFD_NORMAL);

  /* Launch FFD core */
  if(FFD_solver(&para, var, BINDEX)!=0) {
      ffd_log("ffd(): FFD solver failed.", FFD_ERROR);
      return 1;
  }

  /*---------------------------------------------------------------------------
  | Post Process
  ---------------------------------------------------------------------------*/
  /* Calculate mean value */
  if(para.outp->cal_mean == 1)
    average_time(&para, var);

  #ifdef FFD_ISAT
	/* Write output data to ffdoutput[] */
	if (write_output_data(&para, var, BINDEX)) {
		ffd_log("ffd(): Could not write output data to ISAT.", FFD_ERROR);
		return 1;
	}
	ffd_log("ffd(): successfully write ouput data to ISAT.", FFD_NORMAL);
  #endif
  
  if (para.solv->cosimulation != 1) {
	if (para.outp->result_file == VTK) {
		if (write_vtk_data(&para, var, "result") != 0) {
			ffd_log("FFD_solver(): Could not write the result file.", FFD_ERROR);
			return 1;
		}
	}
	else if (para.outp->result_file == PLT) {
		if (write_tecplot_data(&para, var, "result") != 0) {
			ffd_log("FFD_solver(): Could not write the result file.", FFD_ERROR);
			return 1;
		}
	}
  }

  /* Free the memory */
  free_data(var);
  free_index(BINDEX);

  /* Inform Modelica the stopping command has been received*/
  #ifndef FFD_ISAT
	  if (para.solv->cosimulation == 1) {
		  para.cosim->para->flag = 2;
		  ffd_log("ffd(): Sent stopping signal to Modelica", FFD_NORMAL);
	  }
  #endif

  return 0;
} /* End of ffd( ) */

/*
	* Write error message to Modelica
	*
	* @para msg Pointer to message to be written.
	*
	* @return no return
	*/
void modelicaError(char* msg) {
  /*Allocate memory for cosim->ffd->msg*/
  para.cosim->ffd->msg = (char*)malloc(400 * sizeof(char));
  if (para.cosim->ffd->msg == NULL) {
	ffd_log("ffd(): Failed to allocate memory for cosim->ffd->msg", FFD_ERROR);
  }

  strcpy(para.cosim->ffd->msg, msg);
  /* Write the command to stop the cosimulation*/
  para.cosim->para->flag = 2;
  /* Indicate there is an error*/
  para.cosim->para->ffdError = 1;

  /*Free memory for cosim->ffd->msg*/
  free(para.cosim->ffd->msg);

} /* End of modelicaError*/
