/*
    Copyright (C) 2022 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

#ifndef FMI_IMPORT_OPTIONS_H
#define FMI_IMPORT_OPTIONS_H

#include "fmilib_config.h"

#include "JM/jm_portability.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * \brief FMI Library options object.
 */
typedef struct fmi_util_options_t fmi_import_options_t;

/**
 * \brief Sets the flag for the platform dependent function that loads the shared library.
 *
 * See the platform dependent function ('dlopen' or 'LoadLibraryEx') for valid values.
 *
 * An example value for 'dlopen' would be RTLD_NOW|RTLD_LOCAL|RTLD_DEEPBIND, granted the
 * system supports the 'RTLD_DEEPBIND' flag.
 *
 * @param options fmi_import_options_t:: opaque object pointer
 * @param flag jm_portability_loadlibrary_flag_t:: flag value to be set
 */
FMILIB_EXPORT void fmi_import_set_option_loadlibrary_flag(fmi_import_options_t* options, jm_portability_loadlibrary_flag_t flag);

#ifdef __cplusplus
}
#endif

#endif /* FMI_IMPORT_OPTIONS_H */
