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

#ifndef jm_stack_h_
#define jm_stack_h_

#include "jm_vector.h"
#ifdef __cplusplus
extern "C" {
#endif

/** \file jm_named_ptr.h Definition of ::jm_named_ptr and supporting functions
	*
	* \addtogroup jm_utils
	* @{
	*    \defgroup jm_stack_grp  A basic stack
	* @}
	*/

	/** \addtogroup jm_stack_grp
	 @{
	*/
/** 
	\brief A basic stack of items.
	
	Stack is implemented on top of jm_vector right now. There is a couple of extra methonds that are convenient.

  */
#define jm_stack(T) jm_mangle(jm_stack, T)

/**
*  \brief  Allocates a stack with the given reserved memory
*  \code
*  jm_stack(T)* jm_stack_alloc(T)(size_t capacity,jm_callbacks*c );
*  \endcode
*  @param capacity - initial stack capacity, can be 0
*  @param c - jm_callbacks callbacks, can be zero
*  @return Newly allocated stack
*/
#define jm_stack_alloc(T) jm_mangle(jm_stack_alloc, T)

/** 
*  \brief Release memory allocated for a stack.
\code
extern void jm_stack_free(T)(jm_stack(T)* a); 
\endcode
*/
#define jm_stack_free(T) jm_mangle(jm_stack_free, T)

/**
*  \brief Initializes a #jm_stack allocated on stack.
*  \param a - pointer to the stack to be initialized;
*  \param c - ::jm_callbacks callbacks, can be zero
*
*  \code
void jm_stack_init(T)(jm_stack(T)* a, jm_callbacks* c)
  \endcode
*/
#define jm_stack_init(T) jm_mangle(jm_stack_init, T)

/**
*  \brief  Releases memory allocated for stack data.
*
*  This only needs to be called both for stack allocated #jm_stack structs.
*\code
inline void jm_stack_free_data(T)(jm_stack(T)* a)
\endcode
*\param a - pointer to the stack.
*
*/
#define jm_stack_free_data(T) jm_mangle(jm_stack_free_data, T)

/**
\brief  Get the number of elements in the stack.

\code
inline size_t jm_stack_get_size(T)(jm_stack(T)* a)
\endcode
*/
#define jm_stack_get_size(T) jm_mangle(jm_stack_get_size, T)

/**
*  \brief Preallocate memory for the stack (to speed up consequent push).
*
*  \return The actually reserved space. Can be smaller than "capacity" if memory allocation failed.
*  Can be larger than "capacity" if more memory was previously allocated.
*  size_t jm_stack_reserve(T)(jm_stack(T)* a, size_t capacity)
*/
#define jm_stack_reserve(T) jm_mangle(jm_stack_reserve, T)

/**
*  \brief Put an element on the stack.
*  \return A pointer to the inserted element or zero pointer if failed.
*
\code
T* jm_stack_push_back(jm_stack(T)* a, T item);
\endcode
*/
#define jm_stack_push(T) jm_mangle(jm_stack_push, T)

/**
  jm_stack_is_empty returns 1 if the stack is empty and 0 otherwize.
  int jm_stack_is_empty(jm_stack(T)*)
  */
#define jm_stack_is_empty(T) jm_mangle(jm_stack_is_empty, T)

/**
*  jm_stack_pop gets the stack head and moves to the next element. Popping an empty stack gives assertion failure.
*  T jm_stack_pop(jm_stack(T)* a)
*/
#define jm_stack_pop(T) jm_mangle(jm_stack_pop, T)

/**
*  jm_stack_top gets the stack top. Call on an empty stack gives assertion failure.
*  T jm_stack_top(jm_stack(T)* a)
*/
#define jm_stack_top(T) jm_mangle(jm_stack_top, T)

/**
*  jm_stack_foreach calls f for each element in the stack. "data" parameter
*  is forwarded to the function as the second argument.
*  void jm_stack_foreach(T)(jm_stack(T)* a, void (*f)(T, void*), void * data)
*/
#define jm_stack_foreach(T) jm_mangle(jm_stack_foreach, T)


/** minimal number of items always allocated for the stack */
#define JM_STACK_MINIMAL_CAPACITY JM_VECTOR_MINIMAL_CAPACITY

/** maximum memory chunk (in items) to be allocated in push. */
#define JM_STACK_MAX_MEMORY_CHUNK JM_VECTOR_MAX_MEMORY_CHUNK

/** Declare stack for the specific type. */
#define jm_stack_declare_template(T)		\
typedef jm_vector(T) jm_stack(T);					\
 \
static jm_stack(T)* jm_stack_alloc(T)(size_t capacity,jm_callbacks* c) { return jm_vector_alloc(T)(0, capacity, c); }	\
    \
static void jm_stack_free(T)(jm_stack(T) * a) { jm_vector_free(T)(a); } \
    \
static void jm_stack_init(T)(jm_stack(T)* a, jm_callbacks* c) { jm_vector_init(T)(a,0,c); }	\
\
static void jm_stack_free_data(T)(jm_stack(T)* a) { jm_vector_free_data(T)(a); } \
\
static size_t jm_stack_get_size(T)(jm_stack(T)* a) { return jm_vector_get_size(T)(a); } \
\
static size_t jm_stack_reserve(T)(jm_stack(T)* a, size_t capacity) { return jm_vector_reserve(T)(a, capacity);  } \
    \
static T* jm_stack_push(T)(jm_stack(T)* a, T item) { return jm_vector_push_back(T)(a, item); }\
    \
static int jm_stack_is_empty(T)(jm_stack(T)* a) { return ((jm_stack_get_size(T)(a) > 0)? 0:1); } \
    \
static T jm_stack_top(T)(jm_stack(T)* a) { \
    assert(!jm_stack_is_empty(T)(a)); \
    return jm_vector_get_item(T)(a,jm_vector_get_size(T)(a)-1) ; \
} \
            \
static T jm_stack_pop(T)(jm_stack(T)* a) { \
    T ret; \
    ret = jm_stack_top(T)(a); \
    jm_vector_resize(T)(a, jm_vector_get_size(T)(a) - 1); \
    return ret; \
} \
\
static void jm_stack_foreach(T)(jm_stack(T)* a, void (*f)(T, void*), void * data) { jm_vector_foreach_c(T)(a,f,data); }

/** @} */

jm_stack_declare_template(char)
jm_stack_declare_template(int)
jm_stack_declare_template(double)
jm_stack_declare_template(jm_voidp)
jm_stack_declare_template(size_t)
jm_stack_declare_template(jm_string)

#ifdef __cplusplus
}
#endif

#endif
