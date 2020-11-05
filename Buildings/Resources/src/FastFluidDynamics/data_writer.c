/****************************************************************************
| 
|  \file   data_writer.c
| 
|  \brief  Write the simulation data
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
| 
|  \date   6/15/2017
| 
|  This file provides functions that write the data file in different formats.
| 
****************************************************************************/

#include "data_writer.h"

/****************************************************************************
|  Write standard output data in a format for tecplot
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to file name
| 
| \return 0 if no error occurred
****************************************************************************/
int data_debug(PARA_DATA *para, REAL **var, char *name) {
  int i = 0;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  int size = (imax + 2) * (jmax + 2) * (kmax + 2);
  char *filename;
  FILE *datafile;

  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_tecplot_data(): Failed to allocate memory for file name",
            FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, ".txt");

  if ((datafile = fopen(filename, "w+")) == NULL) {
    ffd_log("write_tecplot_data(): Failed to open output file!\n", FFD_ERROR);
    return 1;
  }

  fprintf(datafile, "AW AE AS AN AB AF AP0 AP B T\n");
  for (i = 0; i < size; i++) {
    fprintf(datafile, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", var[AW][i],
            var[AE][i], var[AS][i], var[AN][i], var[AB][i], var[AF][i],
            var[AP0][i], var[AP][i], var[B][i], var[TEMP][i]);
  }
  free(filename);

  fclose(datafile);
  return 0;
}

/****************************************************************************
|  Write standard output data in a format for tecplot
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to file name
| 
| \return 0 if no error occurred
****************************************************************************/
int write_tecplot_data(PARA_DATA *para, REAL **var, char *name) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VXM], *v = var[VYM], *w = var[VZM], *p = var[IP];
  REAL *T = var[TEMPM], *Xi = var[Xi1];
  REAL *flagp = var[FLAGP];
  char *filename;
  FILE *datafile;

  /****************************************************************************
  | Allocate memory for filename
  | Length of filename should be sizeof(ActualName) + 1
  | Using sizeof(ActualName) will cause memory fault in free(filename)
  ****************************************************************************/
  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_tecplot_data(): Failed to allocate memory for file name",
            FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, ".plt");

  /* Open output file */
  if ((datafile = fopen(filename, "w+")) == NULL) {
    ffd_log("write_tecplot_data(): Failed to open output file!\n", FFD_ERROR);
    return 1;
  }

  convert_to_tecplot(para, var);

  fprintf(datafile, "TITLE = ");
  fprintf(datafile, "\"dt=%fs, t=%fs, nu=%f, Lx=%f, Ly=%f, Lz=%f, ",
          para->mytime->dt, para->mytime->t, para->prob->nu, para->geom->Lx,
          para->geom->Ly, para->geom->Lz);
  fprintf(datafile, "Nx=%d, Ny=%d, Nz=%d \"\n", imax + 2, jmax + 2, kmax + 2);

  fprintf(datafile,
          "VARIABLES =X, Y, Z, I, J, K, U, V, W, T, Xi, FlagP, P, Vel \n");
  fprintf(datafile, "ZONE F=POINT, I=%d, J=%d, K=%d\n", imax + 2, jmax + 2,
          kmax + 2);

  FOR_ALL_CELL
	  fprintf(datafile, "%f\t%f\t%f\t%d\t%d\t%d\t", x[IX(i, j, k)], y[IX(i, j, k)],
			  z[IX(i, j, k)], i, j, k);
	  fprintf(datafile, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n", u[IX(i, j, k)],
			  v[IX(i, j, k)], w[IX(i, j, k)], T[IX(i, j, k)], Xi[IX(i, j, k)],
			  flagp[IX(i, j, k)], p[IX(i, j, k)],
			  sqrt(u[IX(i, j, k)] * u[IX(i, j, k)] +
				   v[IX(i, j, k)] * v[IX(i, j, k)] +
				   w[IX(i, j, k)] * w[IX(i, j, k)]));
  END_FOR

  sprintf(msg, "write_tecplot_data(): Wrote file %s.", filename);
  ffd_log(msg, FFD_NORMAL);

  free(filename);
  fclose(datafile);
  return 0;
} /* write_tecplot_data() */

/****************************************************************************
|  Write standard output data in a format for paraview in VTK (Visualization
|  Toolkit) http://www.vtk.org/wp-content/uploads/2015/04/file-formats.pdf
| \Wei Tian
| \ 6/1/2017, Andover, MA
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to file name
| 
| \return 0 if no error occurred
****************************************************************************/
int write_vtk_data(PARA_DATA *para, REAL **var, char *name) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VXM], *v = var[VYM], *w = var[VZM], *p = var[IP];
  REAL *T = var[TEMPM], *Xi = var[Xi1];
  REAL *flagp = var[FLAGP];
  char *filename;
  FILE *datafile;

  /****************************************************************************
  | Allocate memory for filename
  | Length of filename should be sizeof(ActualName) + 1
  | Using sizeof(ActualName) will cause memory fault in free(filename)
  ****************************************************************************/
  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_tecplot_data(): Failed to allocate memory for file name",
            FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, ".vtk");

  /* Open output file */
  if ((datafile = fopen(filename, "w+")) == NULL) {
    ffd_log("write_vtk_data(): Failed to open output file!\n", FFD_ERROR);
    return 1;
  }

  convert_to_tecplot(para, var);
  /* See file of the attached link for detail */
  /* first line: the version of the VTK format */
  fprintf(datafile, "# vtk DataFile Version 2.0\n");
  /* Next line: title */
  fprintf(datafile, "FFDResults\n");

  /* Next line: data type */
  fprintf(datafile, "ASCII\n");

  /* Next line: geometry type */
  fprintf(datafile, "DATASET RECTILINEAR_GRID\n");

  /* Next line: dimensions */
  fprintf(datafile, "DIMENSIONS\t%d\t%d\t%d\n", imax + 2, jmax + 2, kmax + 2);

  /* Next line: X direction coordinate number */
  fprintf(datafile, "X_COORDINATES %d float\n", imax + 2);

  /* Next line: X direction coordinate */
  for (i = 0; i <= imax + 1; i++) {
    fprintf(datafile, "%f\t", x[IX(i, jmax, kmax)]);
  }
  fprintf(datafile, "\n");

  /* Next line: Y direction coordinate number */
  fprintf(datafile, "Y_COORDINATES %d float\n", jmax + 2);

  /* Next line: Y direction coordinate */
  for (i = 0; i <= jmax + 1; i++) {
    fprintf(datafile, "%f\t", y[IX(imax, i, kmax)]);
  }
  fprintf(datafile, "\n");

  /* Next line: Z direction coordinate number */
  fprintf(datafile, "Z_COORDINATES %d float\n", kmax + 2);

  /* Next line: Z direction coordinate */
  for (i = 0; i <= kmax + 1; i++) {
    fprintf(datafile, "%f\t", z[IX(imax, jmax, i)]);
  }
  fprintf(datafile, "\n");

  /* Next line: Number of data point */
  fprintf(datafile, "POINT_DATA %d\n", (imax + 2) * (jmax + 2) * (kmax + 2));
 
  /* Next three lines: Write scalar variable T */
  fprintf(datafile, "SCALARS T float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_ALL_CELL
	fprintf(datafile, "%f\t", T[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar variable P */
  fprintf(datafile, "SCALARS P float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_ALL_CELL
	fprintf(datafile, "%f\t", p[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar speed VEL */
  fprintf(datafile, "SCALARS VEL float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_ALL_CELL
	  fprintf(datafile, "%f\t",
			  sqrt(u[IX(i, j, k)] * u[IX(i, j, k)] +
				   v[IX(i, j, k)] * v[IX(i, j, k)] +
				   w[IX(i, j, k)] * w[IX(i, j, k)]));
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar U */
  fprintf(datafile, "SCALARS U float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_ALL_CELL
	fprintf(datafile, "%f\t", u[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar V */
  fprintf(datafile, "SCALARS V float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_ALL_CELL
	fprintf(datafile, "%f\t", v[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar W */
  fprintf(datafile, "SCALARS W float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_ALL_CELL
	fprintf(datafile, "%f\t", w[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* From lines: Write velocity vector */
  fprintf(datafile, "VECTORS velocity float\n");
  FOR_ALL_CELL
	fprintf(datafile, "%f\t%f\t%f\n", u[IX(i, j, k)], v[IX(i, j, k)],
			w[IX(i, j, k)]);
  END_FOR

  sprintf(msg, "write_vtk_data(): Wrote file %s.", filename);
  ffd_log(msg, FFD_NORMAL);

  free(filename);
  fclose(datafile);

  /* write to the stream */
  /* FIXME: need to talk to Mike about the coordinate */
  FOR_ALL_CELL_IJK
	  fprintf(stdout, "%f\t%f\t%f\n", u[IX(i, j, k)], v[IX(i, j, k)],
			  w[IX(i, j, k)]);
  END_FOR

  return 0;
}

/****************************************************************************
|  Write standard output data in a format for paraview in VTK (Visualization
|  Toolkit) http://www.vtk.org/wp-content/uploads/2015/04/file-formats.pdf
| \Wei Tian
| \ 6/1/2017, Andover, MA
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to file name
| 
| \return 0 if no error occurred
****************************************************************************/
int write_vtk_fluid(PARA_DATA *para, REAL **var, char *name) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VXM], *v = var[VYM], *w = var[VZM], *p = var[IP];
  REAL *T = var[TEMPM], *Xi = var[Xi1];
  REAL *flagp = var[FLAGP];
  int CellNum = 0;
  char *filename;
  FILE *datafile;

  /****************************************************************************
  | Allocate memory for filename
  | Length of filename should be sizeof(ActualName) + 1
  | Using sizeof(ActualName) will cause memory fault in free(filename)
  ****************************************************************************/
  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_tecplot_fluid(): Failed to allocate memory for file name",
            FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, "_fluid.vtk");

  /* Open output file */
  if ((datafile = fopen(filename, "w+")) == NULL) {
    ffd_log("write_vtk_fluid(): Failed to open output file!\n", FFD_ERROR);
    return 1;
  }

  convert_to_tecplot(para, var);
  /* See file of the attached link for detail */
  /* first line: the version of the VTK format */
  fprintf(datafile, "# vtk DataFile Version 2.0\n");
  /* Next line: title */
  fprintf(datafile, "FFDResults\n");

  /* Next line: data type */
  fprintf(datafile, "ASCII\n");

  /* Next line: geometry type */
  fprintf(datafile, "DATASET RECTILINEAR_GRID\n");
 
  /* Next line: dimensions */
  fprintf(datafile, "DIMENSIONS\t%d\t%d\t%d\n", imax, jmax, kmax);

  /* Next line: X direction coordinate number */
  fprintf(datafile, "X_COORDINATES %d float\n", imax);

  /* Next line: X direction coordinate */
  for (i = 1; i <= imax; i++) {
    fprintf(datafile, "%f\t", x[IX(i, jmax, kmax)]);
  }
  fprintf(datafile, "\n");

  /* Next line: Y direction coordinate number */
  fprintf(datafile, "Y_COORDINATES %d float\n", jmax);

  /* Next line: Y direction coordinate */
  for (i = 1; i <= jmax; i++) {
    fprintf(datafile, "%f\t", y[IX(imax, i, kmax)]);
  }
  fprintf(datafile, "\n");

  /* Next line: Z direction coordinate number */
  fprintf(datafile, "Z_COORDINATES %d float\n", kmax);

  /* Next line: Z direction coordinate */
  for (i = 1; i <= kmax; i++) {
    fprintf(datafile, "%f\t", z[IX(imax, jmax, i)]);
  }
  fprintf(datafile, "\n");

  /* Next line: Number of data point */
  /* Count the number of fluid cells */
  CellNum = 0;
  for (i = 1; i <= imax; i++) {
    for (j = 1; j <= jmax; j++) {
      for (k = 1; k <= kmax; k++) {
        if (flagp[IX(i, j, k)] == FLUID) {
          CellNum++;
        } else {
          continue;
        }
      }
    }
  }
  fprintf(datafile, "POINT_DATA %d\n", CellNum);

  /* Next three lines: Write scalar variable T */
  fprintf(datafile, "SCALARS T float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_EACH_CELL
	fprintf(datafile, "%f\t", T[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar variable P */
  fprintf(datafile, "SCALARS P float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_EACH_CELL
	fprintf(datafile, "%f\t", p[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar speed VEL */
  fprintf(datafile, "SCALARS VEL float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_EACH_CELL
	  fprintf(datafile, "%f\t",
			  sqrt(u[IX(i, j, k)] * u[IX(i, j, k)] +
				   v[IX(i, j, k)] * v[IX(i, j, k)] +
				   w[IX(i, j, k)] * w[IX(i, j, k)]));
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar U */
  fprintf(datafile, "SCALARS U float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_EACH_CELL
	fprintf(datafile, "%f\t", u[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar V */
  fprintf(datafile, "SCALARS V float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_EACH_CELL
	fprintf(datafile, "%f\t", v[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* Next three lines: Write scalar W */
  fprintf(datafile, "SCALARS W float 1\n");
  fprintf(datafile, "LOOKUP_TABLE default\n");
  FOR_EACH_CELL
	fprintf(datafile, "%f\t", w[IX(i, j, k)]);
  END_FOR
  fprintf(datafile, "\n");

  /* From lines: Write velocity vector */
  fprintf(datafile, "VECTORS velocity float\n");
  FOR_EACH_CELL
	fprintf(datafile, "%f\t%f\t%f\n", u[IX(i, j, k)], v[IX(i, j, k)],
			w[IX(i, j, k)]);
  END_FOR

  sprintf(msg, "write_vtk_fluid(): Wrote file %s.", filename);
  ffd_log(msg, FFD_NORMAL);

  free(filename);
  fclose(datafile);
  return 0;
} /* write_vtk_fluid() */

/****************************************************************************
|  Write all available data in a format for tecplot
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to file name
| 
| \return 0 if no error occurred
****************************************************************************/
int write_tecplot_all_data(PARA_DATA *para, REAL **var, char *name) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  char *filename;
  FILE *dataFile;

  /****************************************************************************
  | Allocate memory for filename
  | Length of filename should be sizeof(ActualName) + 1
  | Using sizeof(ActualName) will cause memory fault in free(filename)
  ****************************************************************************/
  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_tecplot_all_data(): Failed to allocate memory for file name",
            FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, ".plt");

  /* Open output file */
  if ((dataFile = fopen(filename, "w")) == NULL) {
    sprintf(msg, "write_tecplot_data(): Failed to open output file %s.",
            filename);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  convert_to_tecplot(para, var);

  fprintf(dataFile, "TITLE = ");

  /* Print simulation, dimension and mesh information */
  fprintf(dataFile, "\"dt=%fs, t=%fs, nu=%f, Lx=%f, Ly=%f, Lz%f, ",
          para->mytime->dt, para->mytime->t, para->prob->nu, para->geom->Lx,
          para->geom->Ly, para->geom->Lz);
  fprintf(dataFile, "Nx=%d, Ny=%d, Nz=%d \"\n", imax + 2, jmax + 2, kmax + 2);

  /* Print variables */
  fprintf(dataFile, "VARIABLES = X, Y, Z, I, J, K, ");
  fprintf(dataFile, "U, V, W, UM, VM, WM, US, VS, WS, ");
  fprintf(dataFile, "P, ");
  fprintf(dataFile, "T, TM, TS, ");
  fprintf(dataFile, "GX, GY, GZ, ");
  fprintf(dataFile, "FLAGU, FLAGV, FLAGW, FLAGP, ");
  fprintf(dataFile, "VXBC, VYBC, VZBV, TEMPBC, Xi1BC, Xi2BC, C1BC, C2BC, ");
  fprintf(dataFile, "QFLUX, QFLUXBC, ");
  fprintf(dataFile, "AP, AN, AS, AW, AE, AF, AB, B, AP0, PP");
  fprintf(dataFile, "\n");
  fprintf(dataFile, "ZONE F=POINT, I=%d, J=%d, K=%d\n", imax + 2, jmax + 2,
          kmax + 2);

  FOR_ALL_CELL
	  /* Coordinates */
	  fprintf(dataFile, "%f\t%f\t%f\t%d\t%d\t%d\t", x[IX(i, j, k)], y[IX(i, j, k)],
			  z[IX(i, j, k)], i, j, k);
	  /* Velocities */
	  fprintf(dataFile, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t",
			  var[VX][IX(i, j, k)], var[VY][IX(i, j, k)], var[VZ][IX(i, j, k)],
			  var[VXM][IX(i, j, k)], var[VYM][IX(i, j, k)], var[VZM][IX(i, j, k)],
			  var[VXS][IX(i, j, k)], var[VYS][IX(i, j, k)], var[VZS][IX(i, j, k)]);
	  /* Pressure */
	  fprintf(dataFile, "%f\t", var[IP][IX(i, j, k)]);
	  /* Temperature */
	  fprintf(dataFile, "%f\t%f\t%f\t", var[TEMP][IX(i, j, k)],
			  var[TEMPM][IX(i, j, k)], var[TEMPS][IX(i, j, k)]);
	  /* Gravity */
	  fprintf(dataFile, "%f\t%f\t%f\t", var[GX][IX(i, j, k)], var[GY][IX(i, j, k)],
			  var[GZ][IX(i, j, k)]);
	  /* Flags for simulation */
	  fprintf(dataFile, "%f\t%f\t%f\t%f\t", var[FLAGU][IX(i, j, k)],
			  var[FLAGV][IX(i, j, k)], var[FLAGW][IX(i, j, k)],
			  var[FLAGP][IX(i, j, k)]);
	  /* Boundary conditions */
	  fprintf(dataFile, "%f\t%f\t%f\t%f\t", var[VXBC][IX(i, j, k)],
			  var[VYBC][IX(i, j, k)], var[VZBC][IX(i, j, k)],
			  var[TEMPBC][IX(i, j, k)]);
	  fprintf(dataFile, "%f\t%f\t%f\t%f\t", var[Xi1BC][IX(i, j, k)],
			  var[Xi2BC][IX(i, j, k)], var[C1BC][IX(i, j, k)],
			  var[C2BC][IX(i, j, k)]);
	  /* Heat flux */
	  fprintf(dataFile, "%f\t%f\t", var[QFLUX][IX(i, j, k)],
			  var[QFLUXBC][IX(i, j, k)]);

	  /* Coefficients */
	  fprintf(dataFile, "%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\n",
			  var[AP][IX(i, j, k)], var[AN][IX(i, j, k)], var[AS][IX(i, j, k)],
			  var[AW][IX(i, j, k)], var[AE][IX(i, j, k)], var[AF][IX(i, j, k)],
			  var[AB][IX(i, j, k)], var[B][IX(i, j, k)], var[AP0][IX(i, j, k)],
			  var[PP][IX(i, j, k)]);

  END_FOR

  fclose(dataFile);
  sprintf(msg, "write_tecplot_all_data(): Wrote file %s.", filename);
  ffd_log(msg, FFD_NORMAL);
  free(filename);

  return 0;
} /* write_tecplot_all_data() */

/****************************************************************************
|  Convert the data to the format for Tecplot
| 
|  FFD uses staggered grid and Tecplot data is for collocated grid.
|  This subroutine transfers the data from FFD format to Tecplot format.
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| 
| \return no return
****************************************************************************/
void convert_to_tecplot(PARA_DATA *para, REAL **var) {
  int i, j, k;
  int imax = para->geom->imax;
  int jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ];
  REAL *um = var[VXM], *vm = var[VYM], *wm = var[VZM];
  REAL *p = var[IP], *d = var[Xi1];
  REAL *T = var[TEMP], *Tm = var[TEMPM];

  /****************************************************************************
  | Convert velocities
  ****************************************************************************/
  for (j = 0; j <= jmax + 1; j++)
    for (k = 0; k <= kmax + 1; k++) {
      u[IX(imax + 1, j, k)] = u[IX(imax, j, k)];
      um[IX(imax + 1, j, k)] = um[IX(imax, j, k)];
      for (i = imax; i >= 1; i--) {
        u[IX(i, j, k)] = (REAL)(0.5 * (u[IX(i, j, k)] + u[IX(i - 1, j, k)]));
        um[IX(i, j, k)] = (REAL)(0.5 * (um[IX(i, j, k)] + um[IX(i - 1, j, k)]));
      }
    }

  for (i = 0; i <= imax + 1; i++)
    for (k = 0; k <= kmax + 1; k++) {
      v[IX(i, jmax + 1, k)] = v[IX(i, jmax, k)];
      vm[IX(i, jmax + 1, k)] = vm[IX(i, jmax, k)];
      for (j = jmax; j >= 1; j--) {
        v[IX(i, j, k)] = (REAL)(0.5 * (v[IX(i, j, k)] + v[IX(i, j - 1, k)]));
        vm[IX(i, j, k)] = (REAL)(0.5 * (vm[IX(i, j, k)] + vm[IX(i, j - 1, k)]));
      }
    }

  for (i = 0; i <= imax + 1; i++)
    for (j = 0; j <= jmax + 1; j++) {
      w[IX(i, j, kmax + 1)] = w[IX(i, j, kmax)];
      wm[IX(i, j, kmax + 1)] = wm[IX(i, j, kmax)];
      for (k = kmax; k >= 1; k--) {
        w[IX(i, j, k)] = (REAL)(0.5 * (w[IX(i, j, k)] + w[IX(i, j, k - 1)]));
        wm[IX(i, j, k)] = (REAL)(0.5 * (wm[IX(i, j, k)] + wm[IX(i, j, k - 1)]));
      }
    }

  /****************************************************************************
  | Convert variables at corners
  ****************************************************************************/
  convert_to_tecplot_corners(para, var, p);
  convert_to_tecplot_corners(para, var, d);
  convert_to_tecplot_corners(para, var, T);
  convert_to_tecplot_corners(para, var, Tm);
} /* End of convert_to_tecplot() */

/****************************************************************************
|  Convert the data at 8 corners to the format for Tecplot
| 
|  FFD uses staggered grid and Tecplot data is for collocated grid.
|  This subroutine transfers the data from FFD format to Tecplot format.
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param psi Pointer to variable to be converted
| 
| \return no return
****************************************************************************/
void convert_to_tecplot_corners(PARA_DATA *para, REAL **var, REAL *psi) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);

  /* West-South-Back */
  psi[IX(0, 0, 0)] =
      (psi[IX(0, 1, 0)] + psi[IX(1, 0, 0)] + psi[IX(0, 0, 1)]) / (REAL)3.0;
  /* West-North-Back */
  psi[IX(0, jmax + 1, 0)] = (psi[IX(1, jmax + 1, 0)] + psi[IX(0, jmax, 0)] +
                             psi[IX(0, jmax + 1, 1)]) /
                            (REAL)3.0;
  /* East-South-Back */
  psi[IX(imax + 1, 0, 0)] = (psi[IX(imax, 0, 0)] + psi[IX(imax + 1, 1, 0)] +
                             psi[IX(imax + 1, 0, 1)]) /
                            (REAL)3.0;
  /* East-North-Back */
  psi[IX(imax + 1, jmax + 1, 0)] =
      (psi[IX(imax, jmax + 1, 0)] + psi[IX(imax + 1, jmax, 0)] +
       psi[IX(imax + 1, jmax + 1, 1)]) /
      (REAL)3.0;
  /* West-South-Front */
  psi[IX(0, 0, kmax + 1)] = (psi[IX(0, 1, kmax + 1)] + psi[IX(1, 0, kmax + 1)] +
                             psi[IX(0, 0, kmax)]) /
                            (REAL)3.0;
  /* West-North-Front */
  psi[IX(0, jmax + 1, kmax + 1)] =
      (psi[IX(1, jmax + 1, kmax + 1)] + psi[IX(0, jmax, kmax + 1)] +
       psi[IX(0, jmax + 1, kmax)]) /
      (REAL)3.0;
  /* East-South-Front */
  psi[IX(imax + 1, 0, kmax + 1)] =
      (psi[IX(imax, 0, kmax + 1)] + psi[IX(imax + 1, 1, kmax + 1)] +
       psi[IX(imax + 1, 0, kmax)]) /
      (REAL)3.0;
  /* Ease-North-Front */
  psi[IX(imax + 1, jmax + 1, kmax + 1)] =
      (psi[IX(imax, jmax + 1, 0)] + psi[IX(imax + 1, jmax, 0)] +
       psi[IX(imax + 1, jmax + 1, kmax)]) /
      (REAL)3.0;
} /* End of convert_to_tecplot_corners() */

/****************************************************************************
|  Write the instantaneous value of variables in Tecplot format
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to the filename
| 
| \return 0 if no error occurred
****************************************************************************/
int write_unsteady(PARA_DATA *para, REAL **var, char *name) {
  int i, j, k;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *u = var[VX], *v = var[VY], *w = var[VZ], *p = var[IP];
  REAL *d = var[Xi1];
  REAL *T = var[TEMP];
  char *filename;
  FILE *datafile;

  /****************************************************************************
  | Allocate memory for filename
  | Length of filename should be sizeof(ActualName) + 1
  | Using sizeof(ActualName) will cause memory fault in free(filename)
  ****************************************************************************/
  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_unsteady(): Failed to allocate memory for file name",
            FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, ".plt");

  /* Open output file */
  if ((datafile = fopen(filename, "w")) == NULL) {
    sprintf(msg, "write_unsteady(): Failed to open file %s.", filename);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  FOR_ALL_CELL
	  fprintf(datafile, "%f\t%f\t%f\t", u[IX(i, j, k)], v[IX(i, j, k)],
			  w[IX(i, j, k)]);
	  fprintf(datafile, "%f\t%f\t%f\n", T[IX(i, j, k)], d[IX(i, j, k)],
			  p[IX(i, j, k)]);
  END_FOR

  sprintf(msg, "write_unsteady(): Wrote the unsteady data file %s.", filename);
  ffd_log(msg, FFD_NORMAL);

  free(filename);
  fclose(datafile);
  return 0;
} /* write_unsteady() */

/****************************************************************************
|  Write the data in a format for SCI program
| 
| \param para Pointer to FFD parameters
| \param var Pointer to FFD simulation variables
| \param name Pointer to the filename
| 
| \return 0 if no error occurred
****************************************************************************/
int write_SCI(PARA_DATA *para, REAL **var, char *name) {
  int i, j, k;
  int IPR, IU, IV, IW, IT, IC1, IC2, IC3, IC4, IC5, IC6, IC7;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax + 2, IJMAX = (imax + 2) * (jmax + 2);
  REAL *x = var[X], *y = var[Y], *z = var[Z];
  REAL *u = var[VX], *v = var[VY], *w = var[VZ], *p = var[IP];
  REAL *um = var[VXM], *vm = var[VYM], *wm = var[VZM];
  REAL *T = var[TEMP];
  char *filename;
  FILE *dataFile;

  /****************************************************************************
  | Allocate memory for filename
  | Length of filename should be sizeof(ActualName) + 1
  | Using sizeof(ActualName) will cause memory fault in free(filename)
  ****************************************************************************/
  filename = (char *)malloc((strlen(name) + 5) * sizeof(char));
  if (filename == NULL) {
    ffd_log("write_SCI(): Failed to allocate memory for file name", FFD_ERROR);
    return 1;
  }

  strcpy(filename, name);
  strcat(filename, ".cfd");

  /* Open output file */
  if ((dataFile = fopen(filename, "w")) == NULL) {
    sprintf(msg, "write_SCI(): Failed to open file %s.", filename);
    ffd_log(msg, FFD_ERROR);
    return 1;
  }

  /****************************************************************************
  | Identify the output variable: 1 Yes; 0 No.
  | IPR: Pressure; IU,IV,IW: velocity in x,y,z direction;
  | IT: Temperature; IC1,IC2,IC3,IC4,IC5,IC6,IC6: other scalars
  ****************************************************************************/
  IPR = 1;
  IU = 1;
  IV = 1;
  IW = 1;
  IT = 1;
  IC1 = 0;
  IC2 = 0;
  IC3 = 0;
  IC4 = 0;
  IC5 = 0;
  IC6 = 0;
  IC7 = 0;

  /****************************************************************************
  | Convert variable value from cell surface to cell center
  ****************************************************************************/
  for (j = 0; j <= jmax + 1; j++) {
    for (k = 0; k <= kmax + 1; k++) {
      u[IX(imax + 1, j, k)] = u[IX(imax, j, k)];
      um[IX(imax + 1, j, k)] = um[IX(imax, j, k)];
      for (i = imax; i >= 1; i--) {
        u[IX(i, j, k)] = (REAL)0.5 * (u[IX(i, j, k)] + u[IX(i - 1, j, k)]);
        um[IX(i, j, k)] = (REAL)0.5 * (um[IX(i, j, k)] + um[IX(i - 1, j, k)]);
      }
    }
  }

  for (i = 0; i <= imax + 1; i++) {
    for (k = 0; k <= kmax + 1; k++) {
      v[IX(i, jmax + 1, k)] = v[IX(i, jmax, k)];
      vm[IX(i, jmax + 1, k)] = vm[IX(i, jmax, k)];
      for (j = jmax; j >= 1; j--) {
        v[IX(i, j, k)] = (REAL)0.5 * (v[IX(i, j, k)] + v[IX(i, j - 1, k)]);
        vm[IX(i, j, k)] = (REAL)0.5 * (vm[IX(i, j, k)] + vm[IX(i, j - 1, k)]);
      }
    }
  }

  for (i = 0; i <= imax + 1; i++) {
    for (j = 0; j <= jmax + 1; j++) {
      w[IX(i, j, kmax + 1)] = w[IX(i, j, kmax)];
      wm[IX(i, j, kmax + 1)] = wm[IX(i, j, kmax)];
      for (k = kmax; k >= 1; k--) {
        w[IX(i, j, k)] = (REAL)0.5 * (w[IX(i, j, k)] + w[IX(i, j, k - 1)]);
        wm[IX(i, j, k)] = (REAL)0.5 * (wm[IX(i, j, k)] + wm[IX(i, j, k - 1)]);
      }
    }
  }

  /****************************************************************************
  | Compute pressure value for the corner of the domain
  ****************************************************************************/
  /* W-S-B */
  p[IX(0, 0, 0)] =
      (p[IX(0, 1, 0)] + p[IX(1, 0, 0)] + p[IX(0, 0, 1)]) / (REAL)3.0;
  /* W-N-B */
  p[IX(0, jmax + 1, 0)] =
      (p[IX(1, jmax + 1, 0)] + p[IX(0, jmax, 0)] + p[IX(0, jmax + 1, 1)]) /
      (REAL)3.0;
  /* E-S-B */
  p[IX(imax + 1, 0, 0)] =
      (p[IX(imax, 0, 0)] + p[IX(imax + 1, 1, 0)] + p[IX(imax + 1, 0, 1)]) /
      (REAL)3.0;
  /* E-N-B */
  p[IX(imax + 1, jmax + 1, 0)] =
      (p[IX(imax, jmax + 1, 0)] + p[IX(imax + 1, jmax, 0)] +
       p[IX(imax + 1, jmax + 1, 1)]) /
      (REAL)3.0;
  /* W-S-F */
  p[IX(0, 0, kmax + 1)] =
      (p[IX(0, 1, kmax + 1)] + p[IX(1, 0, kmax + 1)] + p[IX(0, 0, kmax)]) /
      (REAL)3.0;
  /* W-N-F */
  p[IX(0, jmax + 1, kmax + 1)] =
      (p[IX(1, jmax + 1, kmax + 1)] + p[IX(0, jmax, kmax + 1)] +
       p[IX(0, jmax + 1, kmax)]) /
      (REAL)3.0;

  /* E-S-F */
  p[IX(imax + 1, 0, kmax + 1)] =
      (p[IX(imax, 0, kmax + 1)] + p[IX(imax + 1, 1, kmax + 1)] +
       p[IX(imax + 1, 0, kmax)]) /
      (REAL)3.0;
  /* E-N-F */
  p[IX(imax + 1, jmax + 1, kmax + 1)] =
      (p[IX(imax, jmax + 1, 0)] + p[IX(imax + 1, jmax, 0)] +
       p[IX(imax + 1, jmax + 1, kmax)]) /
      (REAL)3.0;

  /****************************************************************************
  | Output domain length in x, y, z direction
  ****************************************************************************/
  fprintf(dataFile, "%e\t%e\t%e\n", para->geom->Lx, para->geom->Ly,
          para->geom->Lz);
  /****************************************************************************
  | Output maximum cell number in x, y, z direction
  ****************************************************************************/
  fprintf(dataFile, "%d\t%d\t%d\n", imax, jmax, kmax);
  /****************************************************************************
  | Output the variables needs to be exported
  ****************************************************************************/
  fprintf(dataFile, "%d\t%d\t%d\t%d\t%d\t%d\n", IPR, IU, IV, IW, IT, IC1);
  fprintf(dataFile, "%d\t%d\t%d\t%d\t%d\t%d\n", IC2, IC3, IC4, IC5, IC6, IC7);

  /****************************************************************************
 | Output the coordinates of cell center in x, y, z direction
 ****************************************************************************/
  for (i = 1; i <= imax; i++)
    fprintf(dataFile, "%e\t", x[IX(i, j, k)]);
  fprintf(dataFile, "\n");
  for (j = 1; j <= jmax; j++)
    fprintf(dataFile, "%e\t", y[IX(i, j, k)]);
  fprintf(dataFile, "\n");
  for (k = 1; k <= kmax; k++)
    fprintf(dataFile, "%e\t", z[IX(i, j, k)]);
  fprintf(dataFile, "\n");

  /****************************************************************************
 | Output the variables
 | p: Pressure
 | U: Velocity in X direction
 | V: Velocity in Y direction
 | W: Velocity in Z direction
 | T: Temperature
 ****************************************************************************/
  for (j = 1; j <= jmax; j++)
    for (i = 1; i <= imax; i++) {
      fprintf(dataFile, "%d\t%d\n", i, j);
      if (IPR == 1) {
        for (k = 1; k <= kmax; k++)
          fprintf(dataFile, "%e\t", p[IX(i, j, k)]);
        fprintf(dataFile, "\n");
      }
      if (IU == 1) {
        for (k = 1; k <= kmax; k++)
          fprintf(dataFile, "%e\t", u[IX(i, j, k)]);
        fprintf(dataFile, "\n");
      }
      if (IV == 1) {
        for (k = 1; k <= kmax; k++)
          fprintf(dataFile, "%e\t", v[IX(i, j, k)]);
        fprintf(dataFile, "\n");
      }
      if (IW == 1) {
        for (k = 1; k <= kmax; k++)
          fprintf(dataFile, "%e\t", w[IX(i, j, k)]);
        fprintf(dataFile, "\n");
      }

      if (IT == 1) {
        for (k = 1; k <= kmax; k++)
          fprintf(dataFile, "%e\t", T[IX(i, j, k)]);
        fprintf(dataFile, "\n");
      }

      for (k = 1; k <= kmax; k++)
        fprintf(dataFile, "%e\t", T[IX(i, j, k)]);
      fprintf(dataFile, "\n");
      /* Extra line because SCI reads turbulence intensity data */
    }

  fclose(dataFile);
  sprintf(msg, "wrtie_SCI(): Wrote the SCI data file %s.", filename);
  ffd_log(msg, FFD_NORMAL);
  free(filename);
  return 0;

} /* End of write_SCI() */
