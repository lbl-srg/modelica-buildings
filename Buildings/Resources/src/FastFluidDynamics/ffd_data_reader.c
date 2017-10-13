/*
	*
	* \file   ffd_data_reader.c
	*
	* \brief  Read the previous FFD result file (Tecplot format)
	*
	* \author Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*         Mingang Jin, Qingyan Chen
	*         Purdue University
	*         Jin55@purdue.edu, YanChen@purdue.edu
	*
	* \date   8/3/2013
	*
	*/

#include "ffd_data_reader.h"

/*
	* Read the previous FFD simulation data in a format of standard output
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
int read_ffd_data(PARA_DATA *para, REAL **var) {
  int i,j, k;
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  char string[400];

  if((file_old_ffd=fopen(para->inpu->old_ffd_file_name,"r"))==NULL) {
    sprintf(msg, "ffd_data_reader.c: Can not open file \"%s\".",
            para->inpu->old_ffd_file_name);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  FOR_ALL_CELL
   fgets(string, 400, file_old_ffd);
   sscanf(string,"%lf%lf%lf%lf%lf%lf", &var[VX][IX(i,j,k)], &var[VY][IX(i,j,k)],
          &var[VZ][IX(i,j,k)], &var[TEMP][IX(i,j,k)],
          &var[Xi1][IX(i,j,k)], &var[IP][IX(i,j,k)]);
  END_FOR

  fclose(file_old_ffd);
  sprintf(msg, "read_ffd_data(): Read previous ffd simulation data file %s.",
          para->inpu->old_ffd_file_name);
  ffd_log(msg, FFD_NORMAL);
  return 0;
} /* End of read_ffd_data()*/
