/*
    Copyright (C) 2012 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/



/** \file fmi1_import_variable_list.h
*  \brief Public interface to the FMI XML C-library. Handling of variable lists.
*/

#ifndef FMI1_IMPORT_VARIABLELIST_H_
#define FMI1_IMPORT_VARIABLELIST_H_

 #include "fmi1_import_variable.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 \addtogroup  fmi1_import
 @{
	\defgroup  fmi1_import_varlist Handling of variable lists
 @}
*/

/** \addtogroup  fmi1_import_varlist
*  \brief Variable lists are provided to handle sets of variables.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
 @{ 
*/

/* Allocate an empty list */
fmi1_import_variable_list_t* fmi1_import_alloc_variable_list(fmi1_import_t* fmu, size_t size);

/**  \brief Free a variable list. Note that variable lists are allocated dynamically and must be freed when not needed any longer 
	\param vl A variable list.
*/
FMILIB_EXPORT void fmi1_import_free_variable_list(fmi1_import_variable_list_t* vl);

/** \brief Make a copy of the list.
	\param vl A variable list.
*/
FMILIB_EXPORT fmi1_import_variable_list_t* fmi1_import_clone_variable_list(fmi1_import_variable_list_t* vl);

/** \brief  Get number of variables in a list */
FMILIB_EXPORT size_t  fmi1_import_get_variable_list_size(fmi1_import_variable_list_t* vl);

/** \brief  Get a pointer to the list of the value references for all the variables */
FMILIB_EXPORT const fmi1_value_reference_t* fmi1_import_get_value_referece_list(fmi1_import_variable_list_t* vl);

/** \brief Get a single variable from the list*/
FMILIB_EXPORT fmi1_import_variable_t* fmi1_import_get_variable(fmi1_import_variable_list_t* vl, unsigned int  index);

/** \name Operations on variable lists. Every operation creates a new list. 
@{
*/
/** \brief Select sub-lists.
\param vl A variable list.
\param fromIndex Zero based start index, inclusive.
\param toIndex Zero based end index, inclusive.
\return A sublist. NULL is returned if toIndex is less than fromIndex or is larger than the list size or if memory allocation failed.
*/
FMILIB_EXPORT fmi1_import_variable_list_t* fmi1_import_get_sublist(fmi1_import_variable_list_t* vl, unsigned int  fromIndex, unsigned int  toIndex);

/** \brief Callback function typedef for the fmiFilterVariables. 

The function should return 0 to prevent a variable from coming to the output list. */
typedef int (*fmi1_import_variable_filter_function_ft)(fmi1_import_variable_t*vl, void * data);

/** \brief Call the provided 'filter' function on every variable in the list and create a new list.
  
\param vl A variable list.
\param filter A filter function according to ::fmi1_import_variable_filter_function_ft.
\param context A parameter to be forwarded to the filter function.
 @return A sub-list with the variables for which filter returned non-zero value. */
FMILIB_EXPORT fmi1_import_variable_list_t* fmi1_import_filter_variables(fmi1_import_variable_list_t* vl, fmi1_import_variable_filter_function_ft filter, void* context);

/** \brief Create a new variable list by concatenating two lists.
  
\param a A variable list.
\param b A variable list.
*/
FMILIB_EXPORT fmi1_import_variable_list_t* fmi1_import_join_var_list(fmi1_import_variable_list_t* a, fmi1_import_variable_list_t* b);


/** \brief Append a variable to the variable list.
  
\param vl A variable list.
\param v A variable.
*/
FMILIB_EXPORT fmi1_import_variable_list_t* fmi1_import_append_to_var_list(fmi1_import_variable_list_t* vl, fmi1_import_variable_t* v);

/** \brief Prepend a variable to the variable list.
  
\param vl A variable list.
\param v A variable.
*/
FMILIB_EXPORT fmi1_import_variable_list_t* fmi1_import_prepend_to_var_list(fmi1_import_variable_list_t* vl, fmi1_import_variable_t* v);

/** \brief Add a variable to a variable list.
  
\param vl A variable list.
\param v A variable.
*/
FMILIB_EXPORT jm_status_enu_t fmi1_import_var_list_push_back(fmi1_import_variable_list_t* vl, fmi1_import_variable_t* v);
/**
  @}
 */

/**
  @}
 */

#ifdef __cplusplus
}
#endif
#endif
