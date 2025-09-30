/****************************************************************************
| 
|  \file   ffd_wrap.c
| 
|  \brief  wrapper to call FFD engine to evaluate the input; the function ffd_isat
|          is then called by usrfgh. A important note is that this function call only
|          evaluate f, not g, which is the jacobian matrix.
| 
|  \author Xu Han
|          Univeristy of Colorado Boulder, xuha3556@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Dan Li
|          University of Miami
| 
|  \date   4/5/2020
| 
| \  All RIGHTS RESERVED.
****************************************************************************/

#include "ffd_wrap.h"

/*Extern global variables form mpc.c*/
extern int useErrorControlCorrection;
extern float VPower;
extern int readexisting;
extern int writeexisting;

extern int num_input;
extern int num_output;
extern int divide_grid;
extern double outp_Boundary_upper[];
extern double outp_Boundary_lower[];
extern OUTPUT_TYPE outp_name[];
extern INPUT_TYPE inpu_name[];

/*Global variables shared with ffd()*/
double ffdInput[nx_SIZE];          /* westWallT, eastWallT */
double ffdOutput[nf_SIZE];         /* centerT, centerUx, centerUy, centerUz */
/*double **ffd_exist_result; */        /* used to store the existing data */

/****************************************************************************
|  Solver to evaluate f, g, and h which called by USRFGH
| 
| \param Array of need
|                      Note: if need[0] = 1, evaluate f
|                            if need[1] = 1, evaluate g
| \param Array of x
| \param Array of f
| \param Array of g
| \param Pointer of user definded struct
| 
| \return No return needed
****************************************************************************/
void ffd_ISAT (int need[], double x[], double f[], double g[][nf_SIZE], void *p){
  /* static 2D array requires that second level of pointers be constpointer to static array */

  int i, i_index = 0;
	double tmp = 0;
	cosim_log("ffd_ISAT(): simulation started", COSIM_NORMAL);

  /****************************************************************************
  | Copy input to global variables
  ****************************************************************************/
  for (i = 0; i < num_input; i++){
    ffdInput[i] = x[i];
  }

  /****************************************************************************
  | Read existing data or Call FFD to perform full simulations
  ****************************************************************************/
  if (need[0]) {
	/* Read existing results */
	if (readexisting == 1) {
		/* If existing data matches */
		if (read_existing() == 0) {
			for (i = 0; i < num_output; i++) {
				f[i] = ffdOutput[i];
			}
			sprintf(logMsg, "ffd_ISAT(): Return results from existing data");
			cosim_log(logMsg, FFD_NORMAL);
		}
		/* If existing data does not match, call ffd */
		else {
			sprintf(logMsg, "ffd_ISAT(): Existing data does not match");
			cosim_log(logMsg, FFD_NORMAL);

			if (ffd(0) != 0) {
				cosim_log("ffd_ISAT(): simulation failed", COSIM_ERROR);
			}
			else {
				if (writeexisting == 1) {
					write_existing();
				}
				for (i = 0; i < num_output; i++) {
					f[i] = ffdOutput[i];
				}
			}
		}
	}
	/* Directly call ffd */
	else {
		if (ffd(0) != 0) {
			cosim_log("ffd_ISAT(): simulation failed", COSIM_ERROR);
		}
		else {
			if (writeexisting == 1) {
				write_existing();
			}
			for (i = 0; i < num_output; i++) {
				f[i] = ffdOutput[i];
			}
		}
	}
  }

  /****************************************************************************
  | Normarize outputs for error control 
  | This is needed since each compoinet of output vector has different order of magnitudes
  ****************************************************************************/
  if (useErrorControlCorrection){
	for (i = 0; i < num_output; i++) {
		f[i] = (f[i] - outp_Boundary_lower[i]) / (outp_Boundary_upper[i] - outp_Boundary_lower[i]);
	}
  }

}
/****************************************************************************
|  Read existing ffd_isat log file
| 
| \return No return needed
****************************************************************************/
FILE *file_params_isat;
extern char filepath[];
int read_existing() {
  char string[400], tmp[400], tmp1[400], filenametmp[400];
  int i = 0, j = 0, num_input_tmp, num_output_tmp;
  double input_tmp[nx_SIZE];
  double output_tmp[nf_SIZE + 1];

  /*cosim_log("------------------------------------------------------------", COSIM_NORMAL);*/
  snprintf(filenametmp, sizeof(filenametmp), "%s%s", filepath, "existing.isat");

  if ((file_params_isat = fopen(filenametmp, "r")) == NULL) {
	sprintf(logMsg, "read_existing(): Could not open the file \"%s\".", "existing.isat");
	cosim_log(logMsg, FFD_ERROR);
	return 1;
  }

  /* Read data from file */
  int next = 0;
  int index_match = 0;
  int flag_match = 0;
  while (next == 0) {
	if (fgets(string, 400, file_params_isat) == NULL)
		next = 1;
	if (EOF == sscanf(string, "%s", tmp)) {
		continue;
	}

	/* Read isat.num_output */
	if (!strcmp(tmp, "/*num_input:")) {
		sscanf(string, "%s%d%s%d", tmp, &num_input_tmp, tmp1, &num_output_tmp);
		if (num_input_tmp == num_input && num_output_tmp == num_output) {
			index_match = 0;
			for (i = 0; i < num_input; i++) {
				fgets(string, 400, file_params_isat);
				sscanf(string, "%lf", &input_tmp[i]);
					if ((input_tmp[i] - ffdInput[i]) < 0.001 && (ffdInput[i] - input_tmp[i]) < 0.001) {
						index_match = index_match + 1;
					}
					else {
						break;
					}
			}
			if (index_match == num_input) {
				for (i = 0; i < num_output; i++) {
					fgets(string, 400, file_params_isat);
					sscanf(string, "%lf", &output_tmp[i]);
					ffdOutput[i] = output_tmp[i];
				}
				flag_match = 1;
				next = 1;
			}
		}
	}
  }

  fclose(file_params_isat);

  if (flag_match == 0) {
	  return 1;
  }
  else {
	  return 0;
  }
}

int write_existing() {
  int i;
  char filenametmp[400];
  snprintf(filenametmp, sizeof(filenametmp), "%s%s", filepath, "existing.isat");

  if ((file_params_isat = fopen(filenametmp, "a")) == NULL) {
	sprintf(logMsg, "read_existing(): Could not open the file \"%s\".", "existing.mpc");
	cosim_log(logMsg, FFD_ERROR);
	return 1;
  }

  fprintf(file_params_isat, "/*num_input: %d num_output: %d */\n", num_input, num_output);
  for (i = 0; i < num_input; i++) {
	fprintf(file_params_isat, "%lf\n", ffdInput[i]);	
  }
  for (i = 0; i < num_output; i++) {
	fprintf(file_params_isat, "%lf\n", ffdOutput[i]);
  }

  fclose(file_params_isat);
  return 0;
}


/****************************************************************************																			   
|  Evaluate Numerical Differentiation of f(x), essentially a jacobian function
| 
| \param Pointer of g[nx][nf]
| 
| \return No return needed
****************************************************************************/
void numericalDifferentiation (double g[][nf_SIZE]){
  /* Evaluate Numerical Differentiation of f(x) */

  cosim_log("numericalDifferentiation(): Numerical Differentiation has not been implemented", MPC_ERROR);
  exit(1);
}
