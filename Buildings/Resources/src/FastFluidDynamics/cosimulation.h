/*
	*
	* @file   cosimulation.h
	*
	* @brief  Functions for cosimulation
	*
	* @author Wangda Zuo
	*         University of Miami
	*         W.Zuo@miami.edu
	*
	* @date   8/3/2013
	*
	* This file provides functions that are used for conducting the coupled simulation
	* with Modelica
	*
	*/
#ifndef _COSIMULATION_H
#define _COSIMULATION_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

#ifndef _GEOMETRY_H
#define _GEOMETRY_H
#include "geometry.h"
#endif

#ifndef _MSC_VER /*Linux*/
#define Sleep(x) sleep(x/1000)
#endif
/*
	* Read the coupled simulation parameters defined by Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int read_cosim_parameter(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Write the FFD data for Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	*
	* @return 0 if no error occurred
	*/
int write_cosim_data(PARA_DATA *para, REAL **var);

/*
	* Read the data from Modelica
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int read_cosim_data(PARA_DATA *para, REAL **var, int **BINDEX);

/*
* Compare the names of boundaries and store the relationship
*
* @param para Pointer to FFD parameters
*
* @return 0 if no error occurred
*/
int compare_boundary_names(PARA_DATA *para);

/*
	* Compare the area of boundaries
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to the FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int compare_boundary_area(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Assign the Modelica solid surface thermal boundary condition data to FFD
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to the FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int assign_thermal_bc(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Assign the Modelica inlet and outlet boundary condition data to FFD
	*
	* The inlet and outlet boundaries are not fixed and they can change during
	* the simulation. The reason is that the Modelica uses acausal modeling
	* and the flow direction can change during the simulation depending on the
	* pressure difference. As a result, the FFD has to change its inlet and outlet
	* boundary condition accordingly. The inlet or outlet boundary is decided
	* according to the flow rate para->cosim->modelica->mFloRarPor. The port is
	* inlet if mFloRarPor>0 and outlet if mFloRarPor<0. We will need to reset the
	* var[FLAGP][IX(i,j,k)] to apply the change of boundary conditions.
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to the FFD simulation variables
	* @param BINDEX Pointer to boundary index
	*
	* @return 0 if no error occurred
	*/
int assign_port_bc(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Integrate the coupled simulation exchange data over the surfaces
	*
	* Fluid port:
	*   - T/Xi/C: sum(u*T*dA)
	*   - m_dot:  sum(u*dA)
	*
	* Solid Surface Boundary:
	*   - T:      sum(T*dA)
	*   - Q_dot:  sum(q_dot*dA)
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD simulation variables
	* @param BINDEX Pointer to the boundary index
	*
	* @return 0 if no error occurred
	*/
int surface_integrate(PARA_DATA *para, REAL **var, int **BINDEX);

/*
	* Set sensor data
	*
	* @param para Pointer to FFD parameters
	* @param var Pointer to FFD data
	*
	* @return 0 if no error occurred
	*/
int set_sensor_data(PARA_DATA *para, REAL **var);
