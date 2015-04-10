///////////////////////////////////////////////////////////////////////////////
///
/// \file   geometry.h
///
/// \brief  Calculate the geometry related information
///
/// \author Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////
#ifndef _GEOMETRY_H
#define _GEOMETRY_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

///////////////////////////////////////////////////////////////////////////////
/// Calculate total fluid volume in the space
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///
///\return Volume weighted average
///////////////////////////////////////////////////////////////////////////////
REAL fluid_volume(PARA_DATA *para, REAL **var);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the volume of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///
///\return Volume
///////////////////////////////////////////////////////////////////////////////
REAL vol(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the XY area of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///
///\return Area of XY surface
///////////////////////////////////////////////////////////////////////////////
REAL area_xy(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the YZ area of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///
///\return Area of YZ surface
///////////////////////////////////////////////////////////////////////////////
REAL area_yz(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the ZX area of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///
///\return Area of ZX surface
///////////////////////////////////////////////////////////////////////////////
REAL area_zx(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the X-length of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///\param IMAX Value of imax+2
///\param IMAX Value of (imax+2)*(jmax+2)
///
///\return Length in X-direction
///////////////////////////////////////////////////////////////////////////////
REAL length_x(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the Y-length of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///
///\return Length in Y-direction
///////////////////////////////////////////////////////////////////////////////
REAL length_y(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the Z-length of control volume (i,j,k)
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param i I-index of the control volume
///\param j J-index of the control volume
///\param K K-index of the control volume
///
///\return Length in Z-direction
///////////////////////////////////////////////////////////////////////////////
REAL length_z(PARA_DATA *para, REAL **var, int i, int j, int k);

///////////////////////////////////////////////////////////////////////////////
/// Calculate the area of boundary surface
///
///\param para Pointer to FFD parameters
///\param var Pointer to FFD simulation variables
///\param BINDEX Pointer to boundary index
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int bounary_area(PARA_DATA *para, REAL **var, int **BINDEX);
