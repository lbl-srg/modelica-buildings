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

/** \file fmi2_import_unit.h
*  \brief Public interface to the FMI import C-library. Handling of variable units.
*/

#ifndef FMI2_IMPORT_UNIT_H_
#define FMI2_IMPORT_UNIT_H_

#include <fmilib_config.h>

#ifdef __cplusplus
extern "C" {
#endif

		/**
	\addtogroup fmi2_import
	@{
	\addtogroup fmi2_import_units Functions for handling unit definitions.
	@}
	\addtogroup fmi2_import_units Functions for handling unit definitions.
	@{
	*/

/**\name Structures encapsulating unit information */
/**@{ */
/** \brief A variable unit defined with a unit defition */
typedef struct fmi2_xml_unit_t fmi2_import_unit_t;
/** \brief A display unit. */
typedef struct fmi2_xml_display_unit_t fmi2_import_display_unit_t;
/** \brief The list of all the unit definitions in the model */
typedef struct fmi2_xml_unit_definitions_t fmi2_import_unit_definitions_t;
/**@} */

/** \brief Get the number of unit definitions. */
FMILIB_EXPORT unsigned int  fmi2_import_get_unit_definitions_number(fmi2_import_unit_definitions_t*);

/** \brief Get a unit definition */
FMILIB_EXPORT fmi2_import_unit_t* fmi2_import_get_unit(fmi2_import_unit_definitions_t*, unsigned int  index);

/** \brief Get a unit name */
FMILIB_EXPORT const char* fmi2_import_get_unit_name(fmi2_import_unit_t*);

/** \brief Get the number of display units associated with this unit */
FMILIB_EXPORT unsigned int fmi2_import_get_unit_display_unit_number(fmi2_import_unit_t*);

/**
	\brief Get fmi2_SI_base_units_Num SI base units exponents associated with the unit.
*/
FMILIB_EXPORT const int* fmi2_import_get_SI_unit_exponents(fmi2_import_unit_t*);

/**
	\brief Get factor to the corresponding SI base units.
*/
FMILIB_EXPORT double fmi2_import_get_SI_unit_factor(fmi2_import_unit_t*);

/**
	\brief Get offset to the corresponding SI base units.
*/
FMILIB_EXPORT double fmi2_import_get_SI_unit_offset(fmi2_import_unit_t*);

/**
	\brief Convert a value with respect to the unit to the
	value with respect to the SI base unit.
*/
FMILIB_EXPORT double fmi2_import_convert_to_SI_base_unit(double, fmi2_import_unit_t*);

/**
	\brief Convert a value with respect to the SI base unit to the
	value with respect to the unit.
*/
FMILIB_EXPORT double fmi2_import_convert_from_SI_base_unit(double, fmi2_import_unit_t*);

/** \brief Get a display unit object by index.
	@param index The index of display unit to be returned. Must be less than the number returned by fmi2_import_get_unit_display_unit_number()
*/
FMILIB_EXPORT fmi2_import_display_unit_t* fmi2_import_get_unit_display_unit(fmi2_import_unit_t*, size_t index);

/**
	\brief Get unit defition for a display unit.
*/
FMILIB_EXPORT fmi2_import_unit_t* fmi2_import_get_base_unit(fmi2_import_display_unit_t*);
/**
	\brief Get display unit name
*/
FMILIB_EXPORT const char* fmi2_import_get_display_unit_name(fmi2_import_display_unit_t*);

/**
	\brief Get the "factor" associated with the display unit.
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_get_display_unit_factor(fmi2_import_display_unit_t*);
/**
	\brief Get the "offset" associated with the display unit.
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_get_display_unit_offset(fmi2_import_display_unit_t*);

/**
	\brief Convert a value measured in "units" to a value measured with "display units"
	@param value The value to be converted.
	@param du The display unit object
	@param isRelativeQuantity specifies if "offset" should be incorporated into conversion
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_convert_to_display_unit(fmi2_real_t value , fmi2_import_display_unit_t* du, int isRelativeQuantity);


/**
	\brief Convert a value measured in "display units" to a value measured with "units"
	@param value The value to be converted.
	@param du The display unit object
	@param isRelativeQuantity specifies if "offset" should be incorporated into conversion
*/
FMILIB_EXPORT fmi2_real_t fmi2_import_convert_from_display_unit(fmi2_real_t value, fmi2_import_display_unit_t* du, int isRelativeQuantity);
/** @} */
#ifdef __cplusplus
}
#endif
#endif
