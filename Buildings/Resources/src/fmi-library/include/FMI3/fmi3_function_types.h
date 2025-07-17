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

/**
 * This file is used instead of fmi3FunctionsTypes.h. FMIL has no dependency
 * (except tests) to that file, so make sure to keep the files synched (or
 * or there will be a mismatch when trying to assign the functions loaded
 * from the FMU to FMIL's CAPI FMU struct).
 *
 * This file just copies the function types to the FMIL namespace, that is,
 * so we can use the FMIL naming conventions.
 */

#ifndef _FMI3_FUNCTION_TYPES_H_
#define _FMI3_FUNCTION_TYPES_H_

#include <string.h>
#include <fmilib_config.h>

#include "fmi3_types.h"
/**    \file fmi3_function_types.h
    Mapping for the standard FMI 3.0 functions into fmi3_ namespace.

    \addtogroup fmi3_utils
    @{
*/

#ifdef __cplusplus
extern "C" {
#endif

/* Include stddef.h, in order that size_t etc. is defined */
#include <stddef.h>

/** FMI 3.0 status codes */
typedef enum {
    fmi3_status_ok,
    fmi3_status_warning,
    fmi3_status_discard,
    fmi3_status_error,
    fmi3_status_fatal
} fmi3_status_t;

typedef enum {
    fmi3_interval_not_yet_known,
    fmi3_interval_unchanged,
    fmi3_interval_changed
} fmi3_interval_qualifier_t;

typedef enum {
    /* fmi3_independent = 0, not needed but reserved for future use */
    fmi3_constant  = 1,
    fmi3_fixed     = 2,
    fmi3_tunable   = 3,
    fmi3_discrete  = 4,
    fmi3_dependent = 5
} fmi3_dependency_kind_t;

typedef void  (*fmi3_log_message_callback_ft)  (fmi3_instance_environment_t instanceEnvironment,
                                                fmi3_status_t status,
                                                fmi3_string_t category,
                                                fmi3_string_t message);

typedef void (*fmi3_intermediate_update_callback_ft) (
        fmi3_instance_environment_t instanceEnvironment,
        fmi3_float64_t intermediateUpdateTime,
        fmi3_boolean_t intermediateVariableSetRequested,
        fmi3_boolean_t intermediateVariableGetAllowed,
        fmi3_boolean_t intermediateStepFinished,
        fmi3_boolean_t canReturnEarly,
        fmi3_boolean_t* earlyReturnRequested,
        fmi3_float64_t* earlyReturnTime);

typedef void (*fmi3_clock_update_callback_ft) (
        fmi3_instance_environment_t instanceEnvironment
);
typedef void (*fmi3_lock_preemption_callback_ft)   ();
typedef void (*fmi3_unlock_preemption_callback_ft) ();

/* Define fmi3 function pointer types to simplify dynamic loading */

/***************************************************
Types for Common Functions
****************************************************/

/* Inquire version numbers of header files and setting logging status */
typedef const char* (*fmi3_get_version_ft)(void);

typedef fmi3_status_t (*fmi3_set_debug_logging_ft)(fmi3_instance_t instance,
                                                   fmi3_boolean_t loggingOn,
                                                   size_t nCategories,
                                                   const fmi3_string_t categories[]);

/* Creation and destruction of FMU instances and setting debug status */
typedef fmi3_instance_t (*fmi3_instantiate_model_exchange_ft)(
    fmi3_string_t                 instanceName,
    fmi3_string_t                 instantiationToken,
    fmi3_string_t                 resourcePath,
    fmi3_boolean_t                visible,
    fmi3_boolean_t                loggingOn,
    fmi3_instance_environment_t   instanceEnvironment,
    fmi3_log_message_callback_ft  logMessage);

typedef fmi3_instance_t (*fmi3_instantiate_co_simulation_ft)(
    fmi3_string_t                        instanceName,
    fmi3_string_t                        instantiationToken,
    fmi3_string_t                        resourcePath,
    fmi3_boolean_t                       visible,
    fmi3_boolean_t                       loggingOn,
    fmi3_boolean_t                       eventModeUsed,
    fmi3_boolean_t                       earlyReturnAllowed,
    const fmi3_value_reference_t         requiredIntermediateVariables[],
    size_t                               nRequiredIntermediateVariables,
    fmi3_instance_environment_t          instanceEnvironment,
    fmi3_log_message_callback_ft         logMessage,
    fmi3_intermediate_update_callback_ft intermediateUpdate);

typedef fmi3_instance_t (*fmi3_instantiate_scheduled_execution_ft)(
    fmi3_string_t                        instanceName,
    fmi3_string_t                        instantiationToken,
    fmi3_string_t                        resourcePath,
    fmi3_boolean_t                       visible,
    fmi3_boolean_t                       loggingOn,
    fmi3_instance_environment_t          instanceEnvironment,
    fmi3_log_message_callback_ft         logMessage,
    fmi3_clock_update_callback_ft        clockUpdate,
    fmi3_lock_preemption_callback_ft     lockPreemption,
    fmi3_unlock_preemption_callback_ft   unlockPreemption);

typedef void (*fmi3_free_instance_ft)(fmi3_instance_t instance);

/* Enter and exit initialization mode, terminate and reset */
typedef fmi3_status_t (*fmi3_enter_initialization_mode_ft) (fmi3_instance_t instance,
                                                            fmi3_boolean_t  toleranceDefined,
                                                            fmi3_float64_t  tolerance,
                                                            fmi3_float64_t  startTime,
                                                            fmi3_boolean_t  stopTimeDefined,
                                                            fmi3_float64_t  stopTime);

typedef fmi3_status_t (*fmi3_exit_initialization_mode_ft)(fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_enter_event_mode_ft)(fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_terminate_ft) (fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_reset_ft) (fmi3_instance_t instance);

/* Getting and setting variable values */
typedef fmi3_status_t (*fmi3_get_float32_ft)(fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_float32_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_float64_ft)(fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_float64_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_int8_ft)   (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_int8_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_uint8_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_uint8_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_int16_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_int16_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_uint16_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_uint16_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_int32_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_int32_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_uint32_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_uint32_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_int64_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_int64_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_uint64_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_uint64_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_boolean_ft)(fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_boolean_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_string_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             fmi3_string_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_get_binary_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             size_t sizes[],
                                             fmi3_binary_t values[],
                                             size_t nValues);

/* Setters */
typedef fmi3_status_t (*fmi3_set_float32_ft)(fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_float32_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_float64_ft)(fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_float64_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_int8_ft)   (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_int8_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_uint8_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_uint8_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_int16_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_int16_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_uint16_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_uint16_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_int32_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_int32_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_uint32_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_uint32_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_int64_ft)  (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_int64_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_uint64_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_uint64_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_boolean_ft)(fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_boolean_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_string_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const fmi3_string_t values[],
                                             size_t nValues);

typedef fmi3_status_t (*fmi3_set_binary_ft) (fmi3_instance_t instance,
                                             const fmi3_value_reference_t valueReferences[],
                                             size_t nValueReferences,
                                             const size_t sizes[],
                                             const fmi3_binary_t values[],
                                             size_t nValues);

/* Getting Variable Dependency Information */
typedef fmi3_status_t (*fmi3_get_number_of_variable_dependencies_ft)(
        fmi3_instance_t        instance,
        fmi3_value_reference_t value_reference,
        size_t*                n_dependencies);

typedef fmi3_status_t (*fmi3_get_variable_dependencies_ft)(
        fmi3_instance_t        instance,
        fmi3_value_reference_t dependent,
        size_t                 element_indices_of_dependent[],
        fmi3_value_reference_t independents[],
        size_t                 element_indices_of_independents[],
        fmi3_dependency_kind_t dependency_kinds[],
        size_t                 n_dependencies);

/* Getting and setting the internal FMU state */
typedef fmi3_status_t (*fmi3_get_fmu_state_ft)(fmi3_instance_t instance, fmi3_FMU_state_t* FMUState);

typedef fmi3_status_t (*fmi3_set_fmu_state_ft)(fmi3_instance_t instance, fmi3_FMU_state_t  FMUState);

typedef fmi3_status_t (*fmi3_free_fmu_state_ft)(fmi3_instance_t instance, fmi3_FMU_state_t* FMUState);

typedef fmi3_status_t (*fmi3_serialized_fmu_state_size_ft)(
        fmi3_instance_t instance,
        fmi3_FMU_state_t FMUState,
        size_t* size);

typedef fmi3_status_t (*fmi3_serialize_fmu_state_ft)(
        fmi3_instance_t instance,
        fmi3_FMU_state_t FMUState,
        fmi3_byte_t serializedState[],
        size_t size);

typedef fmi3_status_t (*fmi3_de_serialize_fmu_state_ft)(
        fmi3_instance_t instance,
        const fmi3_byte_t serializedState[],
        size_t size,
        fmi3_FMU_state_t* FMUState);

/* Getting directional derivatives */
typedef fmi3_status_t (*fmi3_get_directional_derivative_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t unknowns[],
        size_t nUnknowns,
        const fmi3_value_reference_t knowns[],
        size_t nKnowns,
        const fmi3_float64_t seed[],
        size_t nSeed,
        fmi3_float64_t sensitivity[],
        size_t nSensitivity);

typedef fmi3_status_t (*fmi3_get_adjoint_derivative_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t unknowns[],
        size_t nUnknowns,
        const fmi3_value_reference_t knowns[],
        size_t nKnowns,
        const fmi3_float64_t seed[],
        size_t nSeed,
        fmi3_float64_t sensitivity[],
        size_t nSensitivity);

/* Entering and exiting the Configuration or Reconfiguration Mode */
typedef fmi3_status_t (*fmi3_enter_configuration_mode_ft)(fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_exit_configuration_mode_ft)(fmi3_instance_t instance);

/* Clock related functions */
typedef fmi3_status_t (*fmi3_get_clock_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_clock_t values[]);

typedef fmi3_status_t (*fmi3_set_clock_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_clock_t values[]);

typedef fmi3_status_t (*fmi3_get_interval_decimal_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_float64_t intervals[],
        fmi3_interval_qualifier_t qualifiers[]);

typedef fmi3_status_t (*fmi3_set_shift_decimal_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_float64_t shifts[]);

typedef fmi3_status_t (*fmi3_get_shift_decimal_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_float64_t shifts[]);

typedef fmi3_status_t (*fmi3_set_shift_fraction_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_uint64_t counters[],
        const fmi3_uint64_t resolutions[]);

typedef fmi3_status_t (*fmi3_get_shift_fraction_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_uint64_t counters[],
        fmi3_uint64_t resolutions[]);

typedef fmi3_status_t (*fmi3_get_interval_fraction_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        fmi3_uint64_t counters[],
        fmi3_uint64_t resolutions[],
        fmi3_interval_qualifier_t qualifiers[]);

typedef fmi3_status_t (*fmi3_set_interval_decimal_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_float64_t intervals[]);

typedef fmi3_status_t (*fmi3_set_interval_fraction_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_uint64_t counters[],
        const fmi3_uint64_t resolutions[]);

typedef fmi3_status_t (*fmi3_evaluate_discrete_states_ft)(
        fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_update_discrete_states_ft)(
        fmi3_instance_t instance,
        fmi3_boolean_t *discreteStatesNeedUpdate,
        fmi3_boolean_t *terminateSimulation,
        fmi3_boolean_t *nominalsOfContinuousStatesChanged,
        fmi3_boolean_t *valuesOfContinuousStatesChanged,
        fmi3_boolean_t *nextEventTimeDefined,
        fmi3_float64_t *nextEventTime);

/***************************************************
Types for Functions for FMI for Model Exchange
****************************************************/

/* Enter and exit the different modes */
typedef fmi3_status_t (*fmi3_enter_continuous_time_mode_ft)(fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_completed_integrator_step_ft) (
        fmi3_instance_t instance,
        fmi3_boolean_t  noSetFMUStatePriorToCurrentPoint,
        fmi3_boolean_t* enterEventMode,
        fmi3_boolean_t* terminateSimulation);

/* Providing independent variables and re-initialization of caching */
typedef fmi3_status_t (*fmi3_set_time_ft)(fmi3_instance_t instance, fmi3_float64_t time);

typedef fmi3_status_t (*fmi3_set_continuous_states_ft)(
        fmi3_instance_t instance,
        const fmi3_float64_t x[],
        size_t nx);

/* Evaluation of the model equations */
typedef fmi3_status_t (*fmi3_get_derivatives_ft)(
        fmi3_instance_t instance,
        fmi3_float64_t derivatives[],
        size_t nx);

typedef fmi3_status_t (*fmi3_get_event_indicators_ft)(
        fmi3_instance_t instance,
        const fmi3_float64_t eventIndicators[],
        size_t nx);

typedef fmi3_status_t (*fmi3_get_continuous_states_ft)(
        fmi3_instance_t instance,
        const fmi3_float64_t x[],
        size_t nx);

typedef fmi3_status_t (*fmi3_get_nominals_of_continuous_states_ft)(
        fmi3_instance_t instance,
        const fmi3_float64_t nominals[],
        size_t nx);

typedef fmi3_status_t (*fmi3_get_number_of_event_indicators_ft)(fmi3_instance_t instance, size_t* nz);

typedef fmi3_status_t (*fmi3_get_number_of_continuous_states_ft)(fmi3_instance_t instance, size_t* nx);

/***************************************************
Types for Functions for Co-Simulation
****************************************************/

/* Simulating the slave */
typedef fmi3_status_t (*fmi3_enter_step_mode_ft)(fmi3_instance_t instance);

typedef fmi3_status_t (*fmi3_get_output_derivatives_ft)(
        fmi3_instance_t instance,
        const fmi3_value_reference_t valueReferences[],
        size_t nValueReferences,
        const fmi3_int32_t orders[],
        fmi3_float64_t values[],
        size_t nValues);

typedef fmi3_status_t (*fmi3_do_step_ft)(fmi3_instance_t instance,
                                         fmi3_float64_t currentCommunicationPoint,
                                         fmi3_float64_t communicationStepSize,
                                         fmi3_boolean_t noSetFMUStatePriorToCurrentPoint,
                                         fmi3_boolean_t* eventHandlingNeeded,
                                         fmi3_boolean_t* terminate,
                                         fmi3_boolean_t* earlyReturn,
                                         fmi3_float64_t* lastSuccessfulTime);

typedef fmi3_status_t (*fmi3_activate_model_partition_ft)(
        fmi3_instance_t instance,
        fmi3_value_reference_t clockReference,
        fmi3_float64_t activationTime);

/**    @}
*/

#ifdef __cplusplus
}  /* end of extern "C" { */
#endif

#endif /* fmi3_function_types_h */
