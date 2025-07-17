/*
    Copyright (C) 2023 Modelon AB

    This program is free software: you can redistribute it and/or modify
    it under the terms of the BSD style license.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    FMILIB_License.txt file for more details.

    You should have received a copy of the FMILIB_License.txt file
    along with this program. If not, contact Modelon AB <http://www.modelon.com>.
*/

/** \file fmi3_import.h
*  \brief Public interface to the FMI import C-library.
*/

#ifndef FMI3_IMPORT_H_
#define FMI3_IMPORT_H_

#include <stddef.h>
#include <fmilib_config.h>
#include <JM/jm_callbacks.h>
#include <FMI/fmi_import_util.h>
#include <FMI/fmi_import_context.h>
#include "FMI/fmi_import_options.h"

#include <FMI3/fmi3_types.h>
#include <FMI3/fmi3_function_types.h>
#include <FMI3/fmi3_enums.h>

#include "fmi3_import_type.h"
#include "fmi3_import_unit.h"
#include "fmi3_import_variable.h"
#include "fmi3_import_variable_list.h"
#include <FMI/fmi_import_terminals_and_icons.h>

#include "fmi3_import_capi.h"
#include "fmi3_import_convenience.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * \addtogroup fmi3_import FMI 3.0 import interface
 *  All the structures used in the interfaces are intended to
 *  be treated as opaque objects by the client code.
 * @{
 *      \addtogroup fmi3_import_init Constuction, destruction and error handling
 *      \addtogroup fmi3_import_gen General information retrieval
 *      \addtogroup fmi3_import_capi Interface to the standard FMI 3.0 "C" API
 *      @{
 *           \brief Convenient functions for calling the FMI functions. This interface wraps the "C" API.
 *      @}
 *      \addtogroup fmi3_import_options Functions for handling FMI Library options
 * @}
 */

/**
 * \addtogroup fmi3_import_init
 * @{
 */

/** \brief Given directory name fmu_unzipped_path and model identifier consturct Dll/so name
    @return Pointer to a string with the file name. Caller is responsible for freeing the memory.
*/
FMILIB_EXPORT char* fmi3_import_get_dll_path(const char* fmu_unzipped_path, const char* model_identifier, jm_callbacks* callBackFunctions);

/**
* \brief Retrieve the last error message.
*
* Error handling:
*
*  Many functions in the library return pointers to struct. An error is indicated by returning NULL/0-pointer.
*  If error is returned than fmi3_import_get_last_error() functions can be used to retrieve the error message.
*  If logging callbacks were specified then the same information is reported via logger.
*  Memory for the error string is allocated and deallocated in the module.
*  Client code should not store the pointer to the string since it can become invalid.
*    @param fmu An FMU object as returned by fmi3_import_parse_xml().
*    @return NULL-terminated string with an error message.
*/
FMILIB_EXPORT const char* fmi3_import_get_last_error(fmi3_import_t* fmu);

/**
\brief Clear the error message.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @return 0 if further processing is possible. If it returns 1 then the
*    error was not recoverable. The \p fmu object should then be freed and recreated.
*/
FMILIB_EXPORT int fmi3_import_clear_last_error(fmi3_import_t* fmu);

/**
    \brief Release the memory allocated
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT void fmi3_import_free(fmi3_import_t* fmu);
/** @}
\addtogroup fmi3_import_gen
 * \brief Functions for retrieving general model information. Memory for the strings is allocated and deallocated in the module.
 *   All the functions take an FMU object as returned by fmi3_import_parse_xml() as a parameter.
 *   The information is retrieved from the XML file.
 * @{
*/
/**
    \brief Get model name.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_model_name(fmi3_import_t* fmu);

/** \brief Retrieve capability flags by ID. */
FMILIB_EXPORT unsigned int fmi3_import_get_capability(fmi3_import_t* fmu, fmi3_capabilities_enu_t id);

/**
    \brief Get model identifier for ModelExchange.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_model_identifier_ME(fmi3_import_t* fmu);

/**
    \brief Get model identifier for CoSimulation.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_model_identifier_CS(fmi3_import_t* fmu);

/**
    \brief Get model identifier for ScheduledExecution.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_model_identifier_SE(fmi3_import_t* fmu);

/**
    \brief Get FMU instantiationToken.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_instantiation_token(fmi3_import_t* fmu);

/**
    \brief Get FMU description.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_description(fmi3_import_t* fmu);

/**
    \brief Get FMU author.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_author(fmi3_import_t* fmu);

/**
    \brief Get FMU copyright information.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_copyright(fmi3_import_t* fmu);

/**
    \brief Get FMU license information.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_license(fmi3_import_t* fmu);

/** \brief Get FMU version.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_model_version(fmi3_import_t* fmu);

/** \brief Get FMI standard version (always 3.0).
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_model_standard_version(fmi3_import_t* fmu);

/** \brief Get FMU generation tool.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_generation_tool(fmi3_import_t* fmu);

/** \brief Get FMU generation date and time.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT const char* fmi3_import_get_generation_date_and_time(fmi3_import_t* fmu);

/** \brief Get variable naming convention used.
    @param fmu An fmu object as returned by fmi3_import_parse_xml().
*/
FMILIB_EXPORT fmi3_variable_naming_convension_enu_t fmi3_import_get_naming_convention(fmi3_import_t* fmu);

/** \brief Check if the start time for default experiment is specified in the XML file. */
FMILIB_EXPORT int fmi3_import_get_default_experiment_has_start(fmi3_import_t* fmu);

/** \brief Check if the stop time for default experiment is specified in the XML file. */
FMILIB_EXPORT int fmi3_import_get_default_experiment_has_stop(fmi3_import_t* fmu);

/** \brief Check if the tolerance for default experiment is specified in the XML file. */
FMILIB_EXPORT int fmi3_import_get_default_experiment_has_tolerance(fmi3_import_t* fmu);

/** \brief Check if the step size time for default experiment is specified in the XML file. */
FMILIB_EXPORT int fmi3_import_get_default_experiment_has_step_size(fmi3_import_t* fmu);

/** \brief Get the start time for default experiment as specified in the XML file.
    If it is not specified, a default value of 0.0 is returned.
    To determine if it is specified, use the following function: #fmi3_import_get_default_experiment_has_start
*/
FMILIB_EXPORT double fmi3_import_get_default_experiment_start(fmi3_import_t* fmu);

/** \brief Get the stop time for default experiment as specified in the XML file.
    If it is not specified, a default value of 1.0 is returned.
    To determine if it is specified, use the following function: #fmi3_import_get_default_experiment_has_stop
*/
FMILIB_EXPORT double fmi3_import_get_default_experiment_stop(fmi3_import_t* fmu);

/** \brief Get the tolerance for default experiment as specified in the XML file.
    If it is not specified, a default value of 1e-4 is returned.
    To determine if it is specified, use the following function: #fmi3_import_get_default_experiment_has_tolerance
*/
FMILIB_EXPORT double fmi3_import_get_default_experiment_tolerance(fmi3_import_t* fmu);

/** \brief Get the step size for default experiment as specified in the XML file.
    If it is not specified, a default value of 1e-2 is returned.
    To determine if it is specified, use the following function: #fmi3_import_get_default_experiment_has_step_size
*/
FMILIB_EXPORT double fmi3_import_get_default_experiment_step_size(fmi3_import_t* fmu);

/** \brief Get the type of the FMU. For multi-kind FMUs. Returned value might not be one of #fmi3_fmu_kind_enu_t
    if it's a multi-kind FMU. See #fmi3_fmu_kind_enu_t for more info. */
FMILIB_EXPORT fmi3_fmu_kind_enu_t fmi3_import_get_fmu_kind(fmi3_import_t* fmu);

/**
 * \brief Returns non-zero if the fixedInternalStepSize attribute is defined on the CoSimulation element
 */
FMILIB_EXPORT int fmi3_import_get_cs_has_fixed_internal_step_size(fmi3_import_t* fmu);

/**
 * \brief Returns the fixedInternalStepSize attribute if it's defined on the CoSimulation element.
 */
FMILIB_EXPORT double fmi3_import_get_cs_fixed_internal_step_size(fmi3_import_t* fmu);

/**
 * \brief Returns the recommendedIntermediateInputSmoothness attribute value (defined or default) on
 * the CoSimulation element.
 */
FMILIB_EXPORT int fmi3_import_get_cs_recommended_intermediate_input_smoothness(fmi3_import_t* fmu);

/** \brief Get the list of all the type definitions in the model*/
FMILIB_EXPORT fmi3_import_type_definition_list_t* fmi3_import_get_type_definition_list(fmi3_import_t* fmu);

/** \brief Get a list of all the unit definitions in the model. */
FMILIB_EXPORT fmi3_import_unit_definition_list_t* fmi3_import_get_unit_definition_list(fmi3_import_t* fmu);

/** \brief Get the list of all the variables in the model.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @param sortOrder Specifies the order of the variables in the list:
        0 - original order as found in the XML file; 1 - sorted alfabetically by variable name; 2 sorted by types/value references.
* @return a variable list with all the variables in the model.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_variable_list(fmi3_import_t* fmu, int sortOrder);

/** \brief Create a variable list with a single variable.

    @param fmu An FMU object that this variable list will reference.
    @param v A variable.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_create_var_list(fmi3_import_t* fmu, fmi3_import_variable_t* v);

/** \brief Get the number of vendors that had annotations in the XML*/
FMILIB_EXPORT size_t fmi3_import_get_vendors_num(fmi3_import_t* fmu);

/** \brief Get the name of the vendor with that had annotations in the XML by index */
FMILIB_EXPORT const char* fmi3_import_get_vendor_name(fmi3_import_t* fmu, size_t index);

/** \brief Get the number of log categories defined in the XML */
FMILIB_EXPORT size_t fmi3_import_get_log_categories_num(fmi3_import_t* fmu);

/** \brief Get the log category by index */
FMILIB_EXPORT const char* fmi3_import_get_log_category(fmi3_import_t* fmu, size_t index);

/** \brief Get the log category description by index */
FMILIB_EXPORT const char* fmi3_import_get_log_category_description(fmi3_import_t* fmu, size_t index);

/** \brief Get the number of source files for ME defined in the XML */
FMILIB_EXPORT size_t fmi3_import_get_source_files_me_num(fmi3_import_t* fmu);

/** \brief Get the ME source file by index */
FMILIB_EXPORT const char* fmi3_import_get_source_file_me(fmi3_import_t* fmu, size_t index);

/** \brief Get the number of source files for CS defined in the XML */
FMILIB_EXPORT size_t fmi3_import_get_source_files_cs_num(fmi3_import_t* fmu);

/** \brief Get the CS source file by index */
FMILIB_EXPORT const char* fmi3_import_get_source_file_cs(fmi3_import_t* fmu, size_t index);

/**
    \brief Get variable by variable name. Alias variable names result in their base variable.
    @param fmu - An fmu object as returned by fmi3_import_parse_xml().
    @param name - variable name
    @return variable pointer.
*/
FMILIB_EXPORT fmi3_import_variable_t* fmi3_import_get_variable_by_name(fmi3_import_t* fmu, const char* name);

/**
    \brief Get variable by value reference.
    @param fmu - An fmu object as returned by fmi3_import_parse_xml().
    @param vr - value reference
    @return variable pointer.
*/
FMILIB_EXPORT fmi3_import_variable_t* fmi3_import_get_variable_by_vr(fmi3_import_t* fmu, fmi3_value_reference_t vr);

/** \brief Get the list of all the output variables in the model.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @return a variable list with all the output variables in the model.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_outputs_list(fmi3_import_t* fmu);

/** \brief Get the list of all the continuous state derivative variables in the model.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @return a variable list with all the continuous state derivatives in the model.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_continuous_state_derivatives_list(fmi3_import_t* fmu);

/** \brief Get the list of all the clocked state variables in the model.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @return a variable list with all the clocked states in the model.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_clocked_states_list(fmi3_import_t* fmu);

/** \brief Get the list of all the initial unknown variables in the model.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @return a variable list with all the initial unknowns in the model.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_initial_unknowns_list(fmi3_import_t* fmu);

/** \brief Get the list of all the event indicator variables in the model.
* @param fmu An FMU object as returned by fmi3_import_parse_xml().
* @return a variable list with all the event indicators in the model.
*
* Note that variable lists are allocated dynamically and must be freed when not needed any longer.
*/
FMILIB_EXPORT fmi3_import_variable_list_t* fmi3_import_get_event_indicators_list(fmi3_import_t* fmu);

/** \brief Get dependency information for an Output.
 * @param fmu              - An FMU object as returned by fmi3_import_parse_xml().
 * @param variable         - A model variable in fmi3_import_get_outputs_list(...)
 * @param numDependencies  - outputs number of dependencies; 0 for no dependencies and depends on all, check 'dependsOnAll' output
 * @param dependsOnAll     - outputs 1 if a variable depends on all variables, else 0. Only relevant if numDependencies == 0
 * @param dependencies     - outputs a pointer to the dependencies (valueReferences), NULL if numDependencies == 0
 * @param dependenciesKind - outputs a pointer to the dependencieskind data. The values can be converted to ::fmi3_dependencies_kind_enu_t 
 *                           NULL if numDependencies == 0
 * @return                 - non-zero if variable cannot be found (e.g., not an Output), invalid inputs or unexpected failures
 */
FMILIB_EXPORT int fmi3_import_get_output_dependencies(fmi3_import_t* fmu, fmi3_import_variable_t* variable,
        size_t* numDependencies, int* dependsOnAll, size_t** dependencies, char** dependenciesKind);

/** \brief Get dependency information for a ContinuousStateDerivative.
 * @param fmu              - An FMU object as returned by fmi3_import_parse_xml().
 * @param variable         - A model variable in fmi3_import_get_continuous_state_derivatives_list(...)
 * @param numDependencies  - outputs number of dependencies; 0 for no dependencies and depends on all, check 'dependsOnAll' output
 * @param dependsOnAll     - outputs 1 if a variable depends on all variables, else 0. Only relevant if numDependencies == 0
 * @param dependencies     - outputs a pointer to the dependencies (valueReferences), NULL if numDependencies == 0
 * @param dependenciesKind - outputs a pointer to the dependencieskind data. The values can be converted to ::fmi3_dependencies_kind_enu_t 
 *                           NULL if numDependencies == 0
 * @return                 - non-zero if variable cannot be found (e.g., not a ContinuousStateDerivative), invalid inputs or unexpected failures
 */
FMILIB_EXPORT int fmi3_import_get_continuous_state_derivative_dependencies(fmi3_import_t* fmu, fmi3_import_variable_t* variable,
        size_t* numDependencies, int* dependsOnAll, size_t** dependencies, char** dependenciesKind);

/** \brief Get dependency information for a ClockedState.
 * @param fmu              - An FMU object as returned by fmi3_import_parse_xml().
 * @param variable         - A model variable in fmi3_import_get_clocked_states_list(...)
 * @param numDependencies  - outputs number of dependencies; 0 for no dependencies and depends on all, check 'dependsOnAll' output
 * @param dependsOnAll     - outputs 1 if a variable depends on all variables, else 0. Only relevant if numDependencies == 0
 * @param dependencies     - outputs a pointer to the dependencies (valueReferences), NULL if numDependencies == 0
 * @param dependenciesKind - outputs a pointer to the dependencieskind data. The values can be converted to ::fmi3_dependencies_kind_enu_t 
 *                           NULL if numDependencies == 0
 * @return                 - non-zero if variable cannot be found (e.g., not a ClockedState), invalid inputs or unexpected failures
 */
FMILIB_EXPORT int fmi3_import_get_clocked_state_dependencies(fmi3_import_t* fmu, fmi3_import_variable_t* variable,
        size_t* numDependencies, int* dependsOnAll, size_t** dependencies, char** dependenciesKind);

/** \brief Get dependency information for an InitialUnknown.
 * @param fmu              - An FMU object as returned by fmi3_import_parse_xml().
 * @param variable         - A model variable in fmi3_import_get_initial_unknowns_list(...)
 * @param numDependencies  - outputs number of dependencies; 0 for no dependencies and depends on all, check 'dependsOnAll' output
 * @param dependsOnAll     - outputs 1 if a variable depends on all variables, else 0. Only relevant if numDependencies == 0
 * @param dependencies     - outputs a pointer to the dependencies (valueReferences), NULL if numDependencies == 0
 * @param dependenciesKind - outputs a pointer to the dependencieskind data. The values can be converted to ::fmi3_dependencies_kind_enu_t 
 *                           NULL if numDependencies == 0
 * @return                 - non-zero if variable cannot be found (e.g., not an InitialUnknown), invalid inputs or unexpected failures
 */
FMILIB_EXPORT int fmi3_import_get_initial_unknown_dependencies(fmi3_import_t* fmu, fmi3_import_variable_t* variable,
        size_t* numDependencies, int* dependsOnAll, size_t** dependencies, char** dependenciesKind);

/** \brief Get dependency information for an EventIndicator.
 * @param fmu              - An FMU object as returned by fmi3_import_parse_xml().
 * @param variable         - A model variable in fmi3_import_get_event_indicators_list(...)
 * @param numDependencies  - outputs number of dependencies; 0 for no dependencies and depends on all, check 'dependsOnAll' output
 * @param dependsOnAll     - outputs 1 if a variable depends on all variables, else 0. Only relevant if numDependencies == 0
 * @param dependencies     - outputs a pointer to the dependencies (valueReferences), NULL if numDependencies == 0
 * @param dependenciesKind - outputs a pointer to the dependencieskind data. The values can be converted to ::fmi3_dependencies_kind_enu_t 
 *                           NULL if numDependencies == 0
 * @return                 - non-zero if variable cannot be found (e.g., not an EventIndicator), invalid inputs or unexpected failures
 */
FMILIB_EXPORT int fmi3_import_get_event_indicator_dependencies(fmi3_import_t* fmu, fmi3_import_variable_t* variable,
        size_t* numDependencies, int* dependsOnAll, size_t** dependencies, char** dependenciesKind);

/**@} */

/**
 * \addtogroup fmi3_import_options
 * @{
 */

/**
 * Returns the fmi_import_options_t:: object.
 *
 * \param fmu - an fmu object as returned by fmi3_import_parse_xml().
 * \return fmi_import_options_t:: opaque object pointer
 */
FMILIB_EXPORT fmi_import_options_t* fmi3_import_get_options(fmi3_import_t* fmu);

/**
 * @}
 */

#ifdef __cplusplus
}
#endif

#endif
