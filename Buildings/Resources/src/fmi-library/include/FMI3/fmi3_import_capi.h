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

#ifndef FMI3_IMPORT_CAPI_H_
#define FMI3_IMPORT_CAPI_H_

#ifdef __cplusplus
extern "C" {
#endif

#include <JM/jm_callbacks.h>
#include <FMI/fmi_import_util.h>
#include <FMI/fmi_import_context.h>


#include <FMI3/fmi3_types.h>
#include <FMI3/fmi3_function_types.h>
#include <FMI3/fmi3_enums.h>

/**
\file fmi3_import_capi.h
Wrapper functions for the FMI 3.0 functions
*/

/**
 * \addtogroup fmi3_import_capi
 * @{
 */

/**    \addtogroup fmi3_import_capi_const_destroy FMI 3.0 Constructor and Destructor
 * \brief Functions for instantiating and freeing the container of the struct that is responsible for the FMI functions.
 *
 *    Before any of the FMI functions may be called, the construction function must instantiate a fmi_import_t module.
 *    After the fmi_import_t module has been succesfully instantiated, all the FMI functions can be called. To unload
 *    the FMI functions, the destroy functions shall be called.
 *
 *    \addtogroup fmi3_import_capi_me FMI 3.0 (ME) Model Exchange functions
 * \brief List of Model Exchange wrapper functions. Common functions are not listed.
 *    \addtogroup fmi3_import_capi_cs FMI 3.0 (CS) Co-Simulation functions
 * \brief List of Co-Simulation wrapper functions. Common functions are not listed.
 *    \addtogroup fmi3_import_capi_common FMI 3.0 (ME & CS) Common functions
 * \brief List of wrapper functions that are in common for both Model Exchange and Co-Simulation.
 */

/**
 * \addtogroup fmi3_import_capi_const_destroy
 * @{
 */

/**
 * \brief Create a C-API struct. The C-API struct is a placeholder for the FMI DLL functions.
 *
 * This function may only be called once if it returned succesfully. fmi3_import_destroy_dllfmu
 * must be called before this function can be called again.
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml().
 * @param fmuKind Specifies if ModelExchange or CoSimulation binary should be loaded.
 * @param instanceEnvironment The instance environment that is used during callbacks. If NULL, and 'logMessage' is also
          NULL, then fmi3_log_forwarding is utitlized to provide logging.
 * @param logMessage The logging function the FMU will use. If NULL, and 'instanceEnvironment' is also
          NULL, then fmi3_log_forwarding is utitlized to provide logging.
 * @return Error status. If the function returns with an error, it is not allowed to call any of the other C-API functions.
 */
FMILIB_EXPORT jm_status_enu_t fmi3_import_create_dllfmu(fmi3_import_t* fmu, fmi3_fmu_kind_enu_t fmuKind, const fmi3_instance_environment_t instanceEnvironment, const fmi3_log_message_callback_ft logMessage);

/** \brief Free a C-API struct. All memory allocated since the struct was created is freed.
 *
 * @param fmu A model description object returned from fmi3_import_parse_xml().
 */
FMILIB_EXPORT void fmi3_import_destroy_dllfmu(fmi3_import_t* fmu);

/**
 * \brief Set CAPI debug mode flag. Setting to non-zero prevents DLL unloading in fmi3_import_destroy_dllfmu
 *  while all the memory is deallocated. This is to support valgrind debugging.
 *
 * @param fmu C-API struct that has succesfully loaded the FMI function.
 * @param mode The debug mode to set.
 */
FMILIB_EXPORT void fmi3_import_set_debug_mode(fmi3_import_t* fmu, int mode);
/**@} */

/**
 * \addtogroup fmi3_import_capi_common
 * @{
 */

/**
 * \brief Wrapper for the FMI function fmiGetVersion()
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI version.
 */
FMILIB_EXPORT const char* fmi3_import_get_version(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetDebugLogging(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param loggingOn Enable or disable the debug logger.
 * @param nCategories Number of categories to log.
 * @param categories Which categories to log.
* @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_debug_logging(fmi3_import_t* fmu, fmi3_boolean_t loggingOn, size_t nCategories, fmi3_string_t categories[]);

/**
 * \brief Wrapper for the FMI function fmi3InstantiateModelExchange(...)
 *
 * Arguments 'instanceEnvironment' and 'logMessage' are reused from #fmi3_import_create_dllfmu.
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see
 *   fmi3_import_create_dllfmu().
 * @param instanceName The name of the instance.
 * @param resourcePath Absolute path URI to the FMU archive resources. If this is NULL pointer the FMU will get the
 *   path to the unzipped location.
 * @param visible Indicates whether or not the simulator application window shoule be visible.
 * @param loggingOn Enable or disable the debug logger.
 * @return Error status. Returnes jm_status_error if FMI function returned NULL, otherwise jm_status_success.
 */
FMILIB_EXPORT jm_status_enu_t fmi3_import_instantiate_model_exchange(
        fmi3_import_t* fmu,
        fmi3_string_t  instanceName,
        fmi3_string_t  resourcePath,
        fmi3_boolean_t visible,
        fmi3_boolean_t loggingOn);

/**
 * \brief Wrapper for the FMI function fmi3InstantiateCoSimulation(...)
 *
 * Arguments 'instanceEnvironment' and 'logMessage' are reused from #fmi3_import_create_dllfmu.
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see
 *   fmi3_import_create_dllfmu().
 * @param instanceName The name of the instance.
 * @param resourcePath Absolute path URI to the FMU archive resources. If this is NULL pointer the FMU will get the
 *   path to the unzipped location.
 * @param visible Indicates whether or not the simulator application window shoule be visible.
 * @param loggingOn Enable or disable the debug logger.
 * @param eventModeUsed Indicates whether or not 'Event Mode' is supported.
 * @param earlyReturnAllowed Indicates whether early return is allowed.
 * @param requiredIntermediateVariables Array of value references of all input/output variables
 *        that the simulation algorithm intends to set/get during intermediate updates.
 * @param nRequiredIntermediateVariables Specifies the number of entries in array
 *        'requiredIntermediateVariables'.
 * @param intermediateUpdate Callback for performing intermediate updates.
 * @return Error status. Returnes jm_status_error if FMI function returned NULL, otherwise jm_status_success.
 */
FMILIB_EXPORT jm_status_enu_t fmi3_import_instantiate_co_simulation(
        fmi3_import_t*                       fmu,
        fmi3_string_t                        instanceName,
        fmi3_string_t                        resourcePath,
        fmi3_boolean_t                       visible,
        fmi3_boolean_t                       loggingOn,
        fmi3_boolean_t                       eventModeUsed,
        fmi3_boolean_t                       earlyReturnAllowed,
        const fmi3_value_reference_t         requiredIntermediateVariables[],
        size_t                               nRequiredIntermediateVariables,
        fmi3_intermediate_update_callback_ft intermediateUpdate);

/**
 * \brief Wrapper for the FMI function fmi3InstantiateScheduledExecution(...)
 *
 * Arguments 'instanceEnvironment' and 'logMessage' are reused from #fmi3_import_create_dllfmu.
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see
 *   fmi3_import_create_dllfmu().
 * @param instanceName The name of the instance.
 * @param resourcePath Absolute path URI to the FMU archive resources. If this is NULL pointer the FMU will get the
 *   path to the unzipped location.
 * @param visible Indicates whether or not the simulator application window shoule be visible.
 * @param loggingOn Enable or disable the debug logger.
 * @param clockUpdate Callback for clock update.
 * @param lockPreemption Callback for locking preemption.
 * @param unlockPreemption Callback for unlocking preemption.
 * @return Error status. Returnes jm_status_error if FMI function returned NULL, otherwise jm_status_success.
 */
FMILIB_EXPORT jm_status_enu_t fmi3_import_instantiate_scheduled_execution(
        fmi3_import_t*                       fmu,
        fmi3_string_t                        instanceName,
        fmi3_string_t                        resourcePath,
        fmi3_boolean_t                       visible,
        fmi3_boolean_t                       loggingOn,
        fmi3_clock_update_callback_ft        clockUpdate,
        fmi3_lock_preemption_callback_ft     lockPreemption,
        fmi3_unlock_preemption_callback_ft   unlockPreemption);

/**
 * \brief Wrapper for the FMI function fmiFreeInstance(...)
 *
 * @param fmu An fmu description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 */
FMILIB_EXPORT void fmi3_import_free_instance(fmi3_import_t* fmu);

/**
 * \brief Calls the FMI function fmiEnterInitializationMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param toleranceDefined True if the @p tolerance argument is to be used
 * @param tolerance Solvers internal to the FMU should use this tolerance or finer, if @p toleranceDefined is true
 * @param startTime Start time of the experiment
 * @param stopTimeDefined True if the @p stopTime argument is to be used
 * @param stopTime Stop time of the experiment, if @p stopTimeDefined is true
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_enter_initialization_mode(
        fmi3_import_t* fmu,
        fmi3_boolean_t toleranceDefined,
        fmi3_float64_t tolerance,
        fmi3_float64_t startTime,
        fmi3_boolean_t stopTimeDefined,
        fmi3_float64_t stopTime);

/**
 * \brief Calls the FMI function fmiExitInitializationMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_exit_initialization_mode(fmi3_import_t* fmu);

/**
 * \brief Calls the FMI function fmiEnterEventMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_enter_event_mode(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiTerminate(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_terminate(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiReset(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_reset(fmi3_import_t* fmu);


/**
 * \brief Wrapper for the FMI function fmiSetFloat64(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_float64(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_float64_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetFloat32(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_float32(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_float32_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetInt64(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_int64(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_int64_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetInt32(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_int32(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_int32_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetInt16(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_int16(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_int16_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetInt8(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_int8(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_int8_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetUInt64(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_uint64(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_uint64_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetUInt32(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_uint32(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_uint32_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetUInt16(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_uint16(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_uint16_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetUInt8(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_uint8(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, const fmi3_uint8_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetBoolean(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_boolean(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr,
        const fmi3_boolean_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetString(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_string(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr,
        const fmi3_string_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiSetBinary(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param sizes Array with the actual sizes of the values for binary variables.
 * @param value Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_binary(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr,
        const size_t sizes[], const fmi3_binary_t value[], size_t nValues);

/**
 * \brief Calls the FMI function fmiGetFloat64(...)
 *
 * @param fmu C-API struct that has succesfully loaded the FMI function.
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_float64(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_float64_t value[], size_t nValues);

/**
 * \brief Calls the FMI function fmiGetFloat32(...)
 *
 * @param fmu C-API struct that has succesfully loaded the FMI function.
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_float32(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_float32_t value[], size_t nValues);


/**
 * \brief Wrapper for the FMI function fmiGetInt64(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_int64(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_int64_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetInt32(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_int32(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_int32_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetInt16(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_int16(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_int16_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetInt8(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_int8(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_int8_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetUInt64(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_uint64(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_uint64_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetUInt32(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_uint32(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_uint32_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetUInt16(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_uint16(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_uint16_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetUInt8(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_uint8(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr, fmi3_uint8_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetBoolean(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_boolean(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr,
        fmi3_boolean_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetString(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_string(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr,
        fmi3_string_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiGetBinary(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr Array of value references.
 * @param nvr Number of array elements.
 * @param[out] sizes  Array with the actual sizes of the values for binary variables.
 * @param[out] value  Array of variable values.
 * @param nValues Total number of variable values, i.e. the number of elements in each array + the number of scalar variables.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_binary(fmi3_import_t* fmu, const fmi3_value_reference_t vr[], size_t nvr,
        size_t sizes[], fmi3_binary_t value[], size_t nValues);

/**
 * \brief Wrapper for the FMI function fmi3GetNumberOfVariableDependencies(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param vr The value reference of a variable.
 * @param nDeps Return argument that will hold the number of dependencies.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_number_of_variable_dependencies(
        fmi3_import_t*         fmu,
        fmi3_value_reference_t vr,
        size_t*                nDeps);

/**
 * \brief Wrapper for the FMI function fmi3GetVariableDependencies(...)
 *  For arrays the meaning is (for scalars: ignore the element_indicies_...):
 *    dependent[element_indicies_of_dependent[i]] depends on independents[i][element_indices_of_independents[i]], kind: dependency_kinds[i]
 *  element_indicies_... are index 1 based and sorted by order of dimension for higher dimension arrays (2D: row first).
 *  element_indicies_... == 0 means dependency on all indices.
 *  Output arrays must be allocated by the user.
 *
 * @param[in] fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[in] dependent The value reference of a variable for which we want to get dependencies.
 * @param[in,out] elementIndicesOfDependent Return argument that will hold an array of indices in the array 'dependent'.
 * @param[in,out] independents Return argument that will hold an array of value references to variables there is a dependency to.
 * @param[in,out] elementIndicesOfIndependent Return argument that will hold an array of indices in 'independents' array.
 * @param[in,out] dependencyKinds Return argument that will hold an array of the dependency kinds.
 * @param[in] nDeps Specifies the allocated size for the return arguments. Should equal the size retrieved with #fmi3_import_get_number_of_variable_dependencies.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_variable_dependencies(
        fmi3_import_t*          fmu,
        fmi3_value_reference_t  dependent,
        size_t                  elementIndicesOfDependent[],
        fmi3_value_reference_t  independents[],
        size_t                  elementIndicesOfIndependent[],
        fmi3_dependency_kind_t  dependencyKinds[],
        size_t                  nDeps);


/**
 * \brief Wrapper for the FMI function fmiGetFMUState(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param s The state object to be set by the FMU
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_fmu_state(fmi3_import_t* fmu, fmi3_FMU_state_t* s);

/**
 * \brief Wrapper for the FMI function fmiSetFMUState(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param s The FMU state object
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_fmu_state(fmi3_import_t* fmu, fmi3_FMU_state_t s);

/**
 * \brief Wrapper for the FMI function fmiFreeFMUState(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param s The FMU state object
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_free_fmu_state(fmi3_import_t* fmu, fmi3_FMU_state_t* s);

/**
 * \brief Wrapper for the FMI function fmiSerializedFMUStateSize(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param s The FMU state object
 * @param sz The size of the serialized state in bytes
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_serialized_fmu_state_size(fmi3_import_t* fmu, fmi3_FMU_state_t s, size_t* sz);

/**
 * \brief Wrapper for the FMI function fmiSerializeFMUState(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param s The FMU state object
 * @param data The buffer that will receive serialized FMU state
 * @param sz The size of the data buffer
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_serialize_fmu_state(fmi3_import_t* fmu, fmi3_FMU_state_t s, fmi3_byte_t data[], size_t sz);

/**
 * \brief Wrapper for the FMI function fmiSerializeFMUState(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param data The buffer that contains serialized FMU state
 * @param sz The size of the data buffer
 * @param s The FMU state object to be created
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_de_serialize_fmu_state(fmi3_import_t* fmu, const fmi3_byte_t data[], size_t sz, fmi3_FMU_state_t* s);

/**
 * \brief Wrapper for the FMI function fmiGetDirectionalDerivative(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param unknowns Value references for the derivatives/outputs to be processed
 * @param nUnknowns Size of 'nUnknowns'.
 * @param knowns Value references for the seed vector.
 * @param nKnowns Size of 'knowns'.
 * @param seed The seed vector.
 * @param nSeed Size of 'seed'.
 * @param sensitivity Calculated directional derivative on output.
 * @param nSensitivity Size of 'sensitivity'.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_directional_derivative(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t unknowns[],
        size_t nUnknowns,
        const fmi3_value_reference_t knowns[],
        size_t nKnowns,
        const fmi3_float64_t seed[],
        size_t nSeed,
        fmi3_float64_t sensitivity[],
        size_t nSensitivity);

/**
 * \brief Wrapper for the FMI function fmiGetAdjointDerivative(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param unknowns Value references for the derivatives/outputs to be processed
 * @param nUnknowns Size of 'nUnknowns'.
 * @param knowns Value references for the seed vector.
 * @param nKnowns Size of 'knowns'.
 * @param seed The seed vector.
 * @param nSeed Size of 'seed'.
 * @param sensitivity Calculated directional derivative on output.
 * @param nSensitivity Size of 'sensitivity'.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_adjoint_derivative(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t unknowns[],
        size_t nUnknowns,
        const fmi3_value_reference_t knowns[],
        size_t nKnowns,
        const fmi3_float64_t seed[],
        size_t nSeed,
        fmi3_float64_t sensitivity[],
        size_t nSensitivity);

/**
 * \brief Wrapper for the FMI function fmiEnterConfigurationMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_enter_configuration_mode(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiExitConfigurationMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_exit_configuration_mode(fmi3_import_t* fmu);

/* Clock related functions */

/**
 * \brief Wrapper for the FMI function fmiGetClock(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param values Output argument containing the values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_clock(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_clock_t values[]);

/**
 * \brief Wrapper for the FMI function fmiSetClock(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param values Output argument containing the values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_clock(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_clock_t values[]);

/**
 * \brief Wrapper for the FMI function fmiGetIntervalDecimal(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param intervals Array of size nValueReferences to retrieve the Clock intervals.
 * @param qualifiers Array of size nValueReferences to retrieve the Clock qualifiers.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_interval_decimal(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_float64_t intervals[],
        fmi3_interval_qualifier_t qualifiers[]);

/**
 * \brief Wrapper for the FMI function fmiGetIntervalFraction(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param counters Array of size nValueReferences to retrieve the Clock intervals as fraction counters.
 * @param resolutions Array of size nValueReferences to retrieve the Clock intervals as fraction resolutions.
 * @param qualifiers Array of size nValueReferences to retrieve the Clock qualifiers.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_interval_fraction(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_uint64_t counters[],
        fmi3_uint64_t resolutions[],
        fmi3_interval_qualifier_t qualifiers[]);

/**
 * \brief Wrapper for the FMI function fmi3GetShiftDecimal(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param shifts Array of size nValueReferences to retrieve the Clock shifts.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_shift_decimal(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_float64_t shifts[]);

/**
 * \brief Wrapper for the FMI function fmi3GetShiftFraction(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param counters Array of size nValueReferences to retrieve the Clock shifts as fraction counters.
 * @param resolutions Array of size nValueReferences to retrieve the Clock shifts as fraction resolutions.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_shift_fraction(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_uint64_t counters[],
        fmi3_uint64_t resolutions[]);

/**
 * \brief Wrapper for the FMI function fmiSetIntervalDecimal(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param intervals Array of size nValueReferences holding the Clock intervals to be set.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_interval_decimal(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_float64_t intervals[]);

/**
 * \brief Wrapper for the FMI function fmiSetIntervalFraction(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param counters Array of size nValueReferences that holds the Clock counters to be set.
 * @param resolutions Array of size nValueReferences that holds the Clock resolutions to be set.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_interval_fraction(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_uint64_t counters[],
        const fmi3_uint64_t resolutions[]);

/**
 * \brief Wrapper for the FMI function fmiSetShiftDecimal(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param shifts Array of size nValueReferences holding the Clock shifts to be set.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_shift_decimal(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_float64_t shifts[]);

/**
 * \brief Wrapper for the FMI function fmiSetShiftFraction(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references to clock variables.
 * @param nValueReferences Number of elements in 'valueReferences' array.
 * @param counters Array of size nValueReferences that holds the Clock shift counters to be set.
 * @param resolutions Array of size nValueReferences that holds the Clock shift resolutions to be set.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_shift_fraction(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_uint64_t counters[],
        const fmi3_uint64_t resolutions[]);

/**
 * \brief Wrapper for the FMI function fmiEvaluateDiscreteStates(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
*/
FMILIB_EXPORT fmi3_status_t fmi3_import_evaluate_discrete_states(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiUpdateDiscreteStates(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param discreteStatesNeedUpdate Return arg: if the FMU needs to update the discrete states.
 * @param terminateSimulation Return arg: if the FMU wants to terminate the simulation.
 * @param nominalsOfContinuousStatesChanged Return arg: if the nominals of continuous states changed.
 * @param valuesOfContinuousStatesChanged Return arg: if the values of continuous states changed.
 * @param nextEventTimeDefined Return arg: if the value of the next time event (arg 'nextEventTime') is defined.
 * @param nextEventTime Return arg: time for next time event.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_update_discrete_states(
        fmi3_import_t*  fmu,
        fmi3_boolean_t *discreteStatesNeedUpdate,
        fmi3_boolean_t *terminateSimulation,
        fmi3_boolean_t *nominalsOfContinuousStatesChanged,
        fmi3_boolean_t *valuesOfContinuousStatesChanged,
        fmi3_boolean_t *nextEventTimeDefined,
        fmi3_float64_t *nextEventTime);

/**@} */

/**
 * \addtogroup fmi3_import_capi_me
 * @{
 */

/**
 * \brief Calls the FMI function fmiEnterContinuousTimeMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_enter_continuous_time_mode(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiSetTime(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param time Set the current time.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_time(fmi3_import_t* fmu, fmi3_float64_t time);

/**
 * \brief Wrapper for the FMI function fmiSetContinuousStates(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param x Array of state values.
 * @param nx Number of states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_set_continuous_states(fmi3_import_t* fmu, const fmi3_float64_t x[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiCompletedIntegratorStep(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param noSetFMUStatePriorToCurrentPoint True if fmiSetFMUState will no
          longer be called for time instants prior to current time in this
          simulation run.
 * @param[out] enterEventMode  Call fmiEnterEventMode indicator.
 * @param[out] terminateSimulation  Terminate simulation indicator.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_completed_integrator_step(fmi3_import_t* fmu,
    fmi3_boolean_t noSetFMUStatePriorToCurrentPoint,
    fmi3_boolean_t* enterEventMode, fmi3_boolean_t* terminateSimulation);

/**
 * \brief Wrapper for the FMI function fmiGetDerivatives(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[out] derivatives  Array of the derivatives.
 * @param nx Number of derivatives.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_derivatives(fmi3_import_t* fmu, fmi3_float64_t derivatives[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetEventIndicators(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[out] eventIndicators  The event indicators.
 * @param ni Number of event indicators.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_event_indicators(fmi3_import_t* fmu, fmi3_float64_t eventIndicators[], size_t ni);

/**
 * \brief Wrapper for the FMI function fmiGetContinuousStates(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[out] x  Array of state values.
 * @param nx Number of states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_continuous_states(fmi3_import_t* fmu, fmi3_float64_t x[], size_t nx);

/**
 * \brief Wrapper for the FMI function fmiGetNominalsOfContinuousStates(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[out] nominals  The nominal values.
 * @param nx Number of nominal values.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_nominals_of_continuous_states(fmi3_import_t* fmu, fmi3_float64_t nominals[], size_t nx);


/**
 * \brief Wrapper for the FMI function fmi3GetNumberOfEventIndicators(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[out] nz  Number of event indicators.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_number_of_event_indicators(fmi3_import_t* fmu, size_t* nz);

/**
 * \brief Wrapper for the FMI function fmi3GetNumberOfContinuousStates(...)
 * if the FMU has been instantiated. Before instantiation the XML is instead
 * examined. The returned value is expected to be the same.
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param[out] nx  Number of continuous states.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_number_of_continuous_states(fmi3_import_t* fmu, size_t* nx);

/**@} */

/**
 * \addtogroup fmi3_import_capi_cs
 * @{
 */

/**
 * \brief Wrapper for the FMI function fmiEnterStepMode(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_enter_step_mode(fmi3_import_t* fmu);

/**
 * \brief Wrapper for the FMI function fmiGetOutputDerivatives(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param valueReferences Array of value references.
 * @param nValueReferences Number of array elements.
 * @param orders Array of derivative orders (same size as 'valueReferences').
 * @param values Array of variable values.
 * @param nValues Number of array elements.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_get_output_derivatives(
        fmi3_import_t* fmu,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_int32_t orders[],
        fmi3_float64_t values[],
        size_t nValues);

/**
 * \brief Wrapper for the FMI function fmiDoStep(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param currentCommunicationPoint Current communication point of the master.
 * @param communicationStepSize Communication step size.
 * @param noSetFMUStatePriorToCurrentPoint Indicates that the master will not cal SetFMUState to a time prior to
 *        currentCommunicationPoint.
 * @param eventHandlingNeeded Indicates that an event was encountered by the FMU at lastSuccessfulTime.
 * @param[out] terminate  If the FMU requests the simulation to be terminated (since the FMU reached end of
 *        simulation time - not due to internal error).
 * @param[out] earlyReturn  If the FMU returns early.
 * @param[out] lastSuccessfulTime  The internal FMU time when this function returned.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_do_step(
        fmi3_import_t* fmu,
        fmi3_float64_t currentCommunicationPoint,
        fmi3_float64_t communicationStepSize,
        fmi3_boolean_t noSetFMUStatePriorToCurrentPoint,
        fmi3_boolean_t* eventHandlingNeeded,
        fmi3_boolean_t* terminate,
        fmi3_boolean_t* earlyReturn,
        fmi3_float64_t* lastSuccessfulTime);

/**
 * \brief Wrapper for the FMI function fmiActivateModelPartition(...)
 *
 * @param fmu A model description object returned by fmi3_import_parse_xml() that has loaded the FMI functions, see fmi3_import_create_dllfmu().
 * @param clockReference Value reference of an inputClock that will be activated.
 * @param activationTime Simulation (virtual) time of the clock tick.
 * @return FMI status.
 */
FMILIB_EXPORT fmi3_status_t fmi3_import_activate_model_partition(
        fmi3_import_t* fmu,
        fmi3_value_reference_t clockReference,
        fmi3_float64_t activationTime);

/**@} */

/**@} */

#ifdef __cplusplus
}
#endif
#endif /* End of header FMI3_IMPORT_CAPI_H_ */
