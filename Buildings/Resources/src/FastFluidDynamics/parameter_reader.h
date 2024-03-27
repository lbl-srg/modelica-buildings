/****************************************************************************
|
|  \file   parameter_reader.h
|
|  \brief  Read the FFD parameter file
|
|  \author Wangda Zuo
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
****************************************************************************/

#ifndef _PARAMETER_READER_H
#define _PARAMETER_READER_H
#endif

#ifndef _DATA_STRUCTURE_H
#define _DATA_STRUCTURE_H
#include "data_structure.h"
#endif

#ifndef _UTILITY_H
#define _UTILITY_H
#include "utility.h"
#endif

FILE *file_para;
FILE *file_log;

/****************************************************************************
| Assign the FFD parameters
|
| \param para Pointer to FFD parameters
| \param string Pointer to data read from the parameter file
|
| \return 0 if no error occurred
****************************************************************************/
int assign_parameter(PARA_DATA* para, char* string);

/****************************************************************************
|  Read the FFD parameter file input.ffd
|
| \param para Pointer to FFD parameters
|
| \return 0 if no error occurred
****************************************************************************/
int read_parameter(PARA_DATA *para);


