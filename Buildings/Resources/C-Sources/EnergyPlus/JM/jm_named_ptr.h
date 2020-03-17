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

#ifndef JM_NAMED_PTR_H
#define JM_NAMED_PTR_H

#include "jm_vector.h"
#include "jm_callbacks.h"
#ifdef __cplusplus
extern "C" {
#endif

/** \file jm_named_ptr.h Definition of ::jm_named_ptr and supporting functions
	*
	* \addtogroup jm_utils
	* @{
		\addtogroup jm_named_ptr
	* @}
*/
/** \addtogroup jm_named_ptr Named objects
 @{
*/
/** \brief Name and object pointer pair */
typedef struct jm_named_ptr jm_named_ptr;

/** \brief Name and object pointer pair */
struct jm_named_ptr {
    jm_voidp ptr; /** \brief Object pointer */
    jm_string name; /** \brief Name string */
};

/**
\brief Allocate memory for the object and the name string and sets pointer to it packed together with the name pointer.
 \param name Name for the object.
 \param size Size of the data structure.
 \param nameoffset Offset of the name field within the data structure.
 \param c Callbacks to be used for memory allocation.

The function jm_named_alloc() is intended for types defined as:
\code
struct T { 
    < some data fields> 
    char name[1]; 
} 
\endcode
The "name" is copied into the allocated memory.
*/
jm_named_ptr jm_named_alloc(jm_string name, size_t size, size_t nameoffset, jm_callbacks* c);

/** \brief Same as jm_named_alloc() but name is given as a jm_vector(char) pointer */
jm_named_ptr jm_named_alloc_v(jm_vector(char)* name, size_t size, size_t nameoffset, jm_callbacks* c);

/** \brief Free the memory allocated for the object pointed by jm_named_ptr */
static void jm_named_free(jm_named_ptr np, jm_callbacks* c) { c->free(np.ptr); }

jm_vector_declare_template(jm_named_ptr)

/** \brief Helper to construct comparison operation */
#define jm_diff_named(a, b) strcmp(a.name,b.name)

jm_define_comp_f(jm_compare_named, jm_named_ptr, jm_diff_named)

/** \brief Release the data allocated by the items
  in a vector and then clears the memory used by the vector as well.

  This should be used for vectors initialized with jm_vector_init.
*/
static void jm_named_vector_free_data(jm_vector(jm_named_ptr)* v) {
    jm_vector_foreach_c(jm_named_ptr)(v, (void (*)(jm_named_ptr, void*))jm_named_free,v->callbacks);
    jm_vector_free_data(jm_named_ptr)(v);
}

/** \brief Release the data allocated by the items
  in a vector and then clears the memory used by the vector as well.

  This should be used for vectors created with jm_vector_alloc.
*/
static void jm_named_vector_free(jm_vector(jm_named_ptr)* v) {
    jm_vector_foreach_c(jm_named_ptr)(v,(void (*)(jm_named_ptr, void*))jm_named_free,v->callbacks);
    jm_vector_free(jm_named_ptr)(v);
}
/** @} */
#ifdef __cplusplus
}
#endif

/* JM_NAMED_PTR_H */
#endif
