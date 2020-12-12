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

#ifndef JM_TYPES_H
#define JM_TYPES_H
#ifdef __cplusplus
extern "C" {
#endif
#include <fmilib_config.h>

/**
	@file jm_types.h Types used in the Utils module.

	*/
/** 
\defgroup jm_utils Utilities 
\addtogroup jm_utils
  * @{
*/
/** \brief A constant string.*/
typedef const char* jm_string;
/** \brief A void pointer.*/
typedef void* jm_voidp;

/** \brief Mapping between a string and an integer ID */
typedef struct jm_name_ID_map_t {
    jm_string name;
    unsigned int ID;
} jm_name_ID_map_t;

/** \brief Return status codes */
typedef enum {	
	jm_status_error = -1,
	jm_status_success = 0,
	jm_status_warning = 1
} jm_status_enu_t;

/** \brief Log levels supported via the logger functions in ::jm_callbacks */
typedef enum {	
	jm_log_level_nothing = 0, /** \brief Must be first in this enum. May be usefull in application relying solely on jm_get_last_error() */
	jm_log_level_fatal, /** \brief Unrecoverable errors */
	jm_log_level_error, /** \brief Errors that may be not critical for some FMUs. */
	jm_log_level_warning, /** \brief Non-critical issues */
	jm_log_level_info, /** \brief Informative messages */
	jm_log_level_verbose, /** \brief Verbose messages */
	jm_log_level_debug, /** \brief Debug messages. Only enabled if library is configured with FMILIB_ENABLE_LOG_LEVEL_DEBUG */
	jm_log_level_all /** \brief  Must be last in this enum. */
} jm_log_level_enu_t;

/** \brief Convert log level into a string */
FMILIB_EXPORT
const char* jm_log_level_to_string(jm_log_level_enu_t level);

/** @} */
#ifdef __cplusplus
}
#endif

/* JM_TYPES_H */
#endif
