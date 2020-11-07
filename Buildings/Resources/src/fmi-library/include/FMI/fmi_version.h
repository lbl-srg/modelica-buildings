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

#ifndef FMI_VERSION_H
#define FMI_VERSION_H
#include <fmilib_config.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
	@file fmi_version.h 
	\brief Enum defining supported FMI versions.

	*/
/** \addtogroup jm_utils
  * @{
*/

/** \brief Suported versions of FMI standard */
typedef enum
{ 
	fmi_version_unknown_enu = 0,
	fmi_version_1_enu,
	fmi_version_2_0_enu,
	fmi_version_unsupported_enu
} fmi_version_enu_t;

/** Convert version enum into string */
FMILIB_EXPORT
const char * fmi_version_to_string(fmi_version_enu_t v);

/** @} */
#ifdef __cplusplus
}
#endif

/* JM_TYPES_H */
#endif
