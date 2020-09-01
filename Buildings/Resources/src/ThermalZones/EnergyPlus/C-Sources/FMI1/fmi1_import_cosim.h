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

#ifndef FMI1_IMPORT_COSIM_H
#define FMI1_IMPORT_COSIM_H

#include <FMI/fmi_import_context.h>

#ifdef __cplusplus
extern "C" {
#endif

	/**
		\file fmi1_import_cosim.h
		Functions to retrieve co-simulation related information.
	*/
	/**
	\addtogroup fmi1_import
	@{
	\addtogroup fmi1_import_cosim Functions to retrieve co-simulation related information.
	@}
	*/
	/**
	\addtogroup fmi1_import_cosim
	@{
	*/

	/** \brief Get the entry point.*/
FMILIB_EXPORT const char* fmi1_import_get_entry_point(fmi1_import_t* );
	/** \brief Get mime type. */
FMILIB_EXPORT const char* fmi1_import_get_mime_type(fmi1_import_t* );
	/** \brief Get manual start flag. */
FMILIB_EXPORT int fmi1_import_get_manual_start(fmi1_import_t* );

	/** \brief Get the number of additional models specified. */
FMILIB_EXPORT size_t fmi1_import_get_number_of_additional_models(fmi1_import_t* fmu);

	/** \brief Get the name of an additional model.
		@param fmu - the FMU processed
		@param index - the index of an additional model (must be less than the number returned by fmi1_import_get_number_of_additional_models().
	*/
FMILIB_EXPORT const char* fmi1_import_get_additional_model_name(fmi1_import_t* fmu, size_t index);

/**
@}
*/
#ifdef __cplusplus
}
#endif
#endif /* FMI1_IMPORT_COSIM_H */
