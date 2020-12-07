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



/** \file fmi2_import_convenience.h
*  \brief Public interface to the FMI import C-library. Convenience functions.
*
*  The functions in this file are provided for convenience. The functionality
*  is already available via other lower level functions.
*/

#ifndef FMI2_IMPORT_CONVENIENCE_H_
#define FMI2_IMPORT_CONVENIENCE_H_

#include <FMI/fmi_import_context.h>
#include <FMI2/fmi2_functions.h>

#ifdef __cplusplus
extern "C" {
#endif
		/**
	\addtogroup fmi2_import
	@{
	\addtogroup fmi2_import_convenience Convenience functions.
	@}
	\addtogroup fmi2_import_convenience Convenience functions.
	\brief The functions in this module are provided for convenience. The functionality
	*  is already available via other lower level functions.

	@{
	*/	
/** 
\brief Collection of counters providing model information.
	*/
typedef struct {
	/** \brief Number of constants */
	unsigned int num_constants;
	/** \brief  Number of fixed */
	unsigned int num_fixed;
	/** \brief  Number of tunable */
	unsigned int num_tunable;
	/** \brief  Number of discrete variables */
	unsigned int num_discrete;
	/** \brief  Number of continuous variables */
	unsigned int num_continuous;

	/** \brief  Number of parameters*/
	unsigned int num_parameters;
	/** \brief  Number of calculated parameters*/
	unsigned int num_calculated_parameters;
	/** \brief  Number of inputs */
	unsigned int num_inputs;
	/** \brief  Number of outputs */
	unsigned int num_outputs;
	/** \brief  Number of local variables */
	unsigned int num_local;
	/** \brief  Number of independent variables */
	unsigned int num_independent;

	/** \brief  Number of real variables*/
	unsigned int num_real_vars; 
	/** \brief  Number of integer variables*/
	unsigned int num_integer_vars; 
	/** \brief  Number of enumeration variables*/
	unsigned int num_enum_vars; 
	/** \brief  Number of boolean variables*/
	unsigned int num_bool_vars; 
	/** \brief  Number of string variables*/
	unsigned int num_string_vars; 
} fmi2_import_model_counts_t;

/**
	\brief Collect model information by counting the number of variables with specific properties and fillinf in fmi2_import_model_counts_t struct.
	\param fmu - An fmu object as returned by fmi2_import_parse_xml().
	\param counts - a pointer to a preallocated struct.
*/
FMILIB_EXPORT 
void fmi2_import_collect_model_counts(fmi2_import_t* fmu, fmi2_import_model_counts_t* counts);

/**
  \brief Print msgIn into msgOut by expanding variable references of the form #\<Type\>\<VR\># into variable names
  and replacing '##' with a single #.
   \param fmu - An fmu object as returned by fmi2_import_parse_xml().
   \param msgIn - Log message as produced by an FMU.
   \param msgOut - Output message buffer. 
   \param maxMsgSize - maximum message size
   */
FMILIB_EXPORT 
void fmi2_import_expand_variable_references(fmi2_import_t* fmu, const char* msgIn, char* msgOut, size_t maxMsgSize);


/**
	\brief An implementation of FMI 2.0 logger that forwards the messages to logger function inside ::jm_callbacks structure.
	
	The function is using a global array of active FMUs to find out which FMU is sending the log messege. It then
	forwards the message to the logger connected to the particular ::fmi2_import_t struct. The function is called by the FMU.
	The FMU must be loaded with non-zero registerGlobally parameter of fmi2_import_create_dllfmu() in order to work. 
	If no matching ::fmi2_import_t struct is found on the global list then jm_get_default_callbacks() is used to get the default logger.
	Note that this function is not thread safe due to the use of the global list.
*/
FMILIB_EXPORT 
void  fmi2_log_forwarding(fmi2_component_t c, fmi2_string_t instanceName, fmi2_status_t status, fmi2_string_t category, fmi2_string_t message, ...);

/**
	\brief An implementation of FMI 2.0 logger that forwards the messages to logger function inside ::jm_callbacks structure.
	
	See fmi2_log_forwarding() for more information.
*/
FMILIB_EXPORT 
void  fmi2_log_forwarding_v(fmi2_component_t c, fmi2_string_t instanceName, fmi2_status_t status, fmi2_string_t category, fmi2_string_t message, va_list args);


/** \brief  Default FMI 2.0 logger may be used when instantiating FMUs */
FMILIB_EXPORT
void  fmi2_default_callback_logger(fmi2_component_t c, fmi2_string_t instanceName, fmi2_status_t status, fmi2_string_t category, fmi2_string_t message, ...);

/** \brief  Given ::fmi2_callback_functions_t logger (fmi2_logger), the ::jm_callbacks logger may be setup to redirect the messages to the fmi2_logger.

    The functions sets up the redirection. Note that the context field in ::jm_callbacks is set to point to the provided ::fmi2_callback_functions_t.
	\param cb FMI Library callbacks
	\param fmiCallbacks FMI 2.0 standard callbacks
*/
FMILIB_EXPORT
void fmi2_import_init_logger(jm_callbacks* cb, fmi2_callback_functions_t* fmiCallbacks);
/**	@}
*/


/** @} */

#ifdef __cplusplus
}
#endif
#endif /* FMI2_IMPORT_CONVENIENCE_H_ */
