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

#ifndef jm_vector_h_
#define jm_vector_h_
#include <assert.h>
#include <string.h>

#include "jm_callbacks.h"
#ifdef __cplusplus
extern "C" {
#endif

/** 
\file jm_vector.h Definition of ::jm_vector and supporting functions
*/
/**
\addtogroup jm_utils
 @{
   \addtogroup jm_vector
 @}
*/

/** 
\addtogroup jm_vector A vector of items (dynamic array)
@{
*/

/** \brief jm_mange macro is used to construct names for the template instances
   Extra level (jm_mange_ex) is needed to force argument expansion (pre-scan)
*/
#define jm_mangle_ex(name, type)  name## _ ##type
#define jm_mangle(name, type)  jm_mangle_ex(name,type)

/** \brief jm_vector(T) is the type name (i.e., to be used as jm_vector(int) vi;) */
#define jm_vector(T) jm_mangle(jm_vector, T)

/**
* \name  Vector handling functions.
*
* \brief Allocates a vector on heap with the specified size and specified number of preallocated items (can be larger than size).

*  extern jm_vector(T)* jm_vector_alloc(T)(size_t size, size_t capacity, jm_callbacks*c );
*  Note that there is no need to call jm_vector_init for a vector allocated with this function.
*  @param  size - initial size of the vector, can be 0
*  @param  capacity - initial capacity of the vector, can be 0. At least initSize elements are allocated.
*  @param  c - jm_callbacks callbacks, can be zero
*  @return Newly allocated vector
*/
#define jm_vector_alloc(T) jm_mangle(jm_vector_alloc, T)

/**
  jm_vector_free releases the memory allocated by jm_vector_alloc.
extern void jm_vector_free(T)(jm_vector(T)* a);
*/
#define jm_vector_free(T) jm_mangle(jm_vector_free, T)

/**
*  \brief jm_vector_init initializes a vector allocated on stack.
*
*  Input:
*    a - pointer to the vector to be initialized;
*    size - initial size of the vector, can be 0
*    c - jm_callbacks callbacks, can be zero
*  Returns:
*    size of the vector (can be zero for non-zero size if memory allocation failed)
*    Note that for initSize < JM_VECTOR_MINIMAL_CAPACITY no heap memory allocation is needed
*  size_t jm_vector_init(T)(jm_vector(T)* a, size_t initSize, jm_callbacks* c)
*/
#define jm_vector_init(T) jm_mangle(jm_vector_init, T)

/**
*  jm_vector_free_data releases memory allocated for vector data
*  This only needs to be called for stack allocated vectors
*  (jm_vector_free does the job for heap vectors automatically)
* inline void jm_vector_free_data(T)(jm_vector(T)* a)
*/
#define jm_vector_free_data(T) jm_mangle(jm_vector_free_data, T)

/**
  jm_vector_get_size get the vector size
inline size_t jm_vector_get_size(T)(jm_vector(T)* a)
*/
#define jm_vector_get_size(T) jm_mangle(jm_vector_get_size, T)

/**
  jm_vector_get_item returns the specified item. Range checking is done with an assert.
inline T jm_vector_get_item(jm_vector(T)* a, size_t index)
*/
#define jm_vector_get_item(T) jm_mangle(jm_vector_get_item, T)

/**
  jm_vector_get_itemp returns a pointer to the specified item. Range checking is done with an assert.
inline T* jm_vector_get_itemp(jm_vector(T)* a, size_t index)
*/
#define jm_vector_get_itemp(T) jm_mangle(jm_vector_get_itemp, T)


/**
  jm_vector_get_lastp returns a pointer to the last item in the vector. It is an error to call this if size=0
inline T jm_vector_get_last(jm_vector(T)* a)
*/
#define jm_vector_get_last(T) jm_mangle(jm_vector_get_last, T)

/**
  jm_vector_get_lastp returns a pointer to the last item in the vector. Zero pointer is returned if size=0
inline T* jm_vector_get_lastp(jm_vector(T)* a)
*/
#define jm_vector_get_lastp(T) jm_mangle(jm_vector_get_lastp, T)

/**
\brief Function type for item comparison. Can be generated with jm_define_comp_f.

*/
typedef int (*jm_compare_ft) (const void* , const void*);

/**
\brief  A conveniece macro for comparison function definition

#define jm_define_comp_f(F, T, COMPAR_OP) is a conveniece macro for comparison function definition to be used in sort/search operations.
Here F - is the defined function name;
     T - type of the argument;
     COMPAR_OP(A,B) is a macro that returns an integer less than, equal to, or greater than zero if the first argument
is considered to be respectively less than, equal to, or greater than the second.  If two  members  compare  as
equal, their order in the sorted array is undefined.
Default definition below is jm_diff and is implemented as (int)(first-second)
*/
#define jm_define_comp_f(F, T, COMPAR_OP) \
    static int F (const void* first, const void* second) { \
        return COMPAR_OP(  (*(T*)first), (*(T*)second)); \
    } \

#define jm_diff(first, second) (int)(first-second)

/**
  \brief jm_vector_find functions use linear search to find items in a vector. JM_COMPAR_OP is used for comparison.

  T* jm_vector_find(T)(jm_vector(T)* a, T item, jm_compare_ft f)

  size_t jm_vector_find_index(T)(jm_vector(T)* a, T item, jm_compare_ft f)

  @param a - the vector;
  @param item - the searched item;

  Return:
    T* jm_vector_find(T)(jm_vector(T)* a, T item, jm_compare_ft f)  returns a pointer to the found item or NULL if not found
    size_t jm_vector_find_index(T)(jm_vector(T)* a, T item, jm_compare_ft f) return the index of the found item or size of the vector if not found.
*/
#define jm_vector_find(T) jm_mangle(jm_vector_find, T)
#define jm_vector_find_index(T) jm_mangle(jm_vector_find_index, T)

/*
    jm_vector_qsort uses standard quick sort to sort the vector contents.
    JM_COMPAR_OP is used for comparison.

    void jm_vector_qsort(T)(jm_vector(T)* v, jm_compare_ft f);
*/
#define jm_vector_qsort(T) jm_mangle(jm_vector_qsort, T)

/**
  jm_vector_bsearch uses standard binary search (bsearch) to find elements in a sorted vector.
  It returns the index of an item in the vector or vector's size if not found.
    JM_COMPAR_OP is used for comparison.

  T* jm_vector_bsearch(T)(jm_vector(T)* v, T* key, jm_compare_ft f)
  size_t jm_vector_bsearch_index(T)(jm_vector(T)* v, T* key, jm_compare_ft f)
*/
#define jm_vector_bsearch(T) jm_mangle(jm_vector_bsearch, T)
#define jm_vector_bsearch_index(T) jm_mangle(jm_vector_bsearch_index, T)

/**
  jm_vector_set_item sets the specified item. Range checking is done with an assert.
 void jm_vector_set_item(T)(jm_vector(T)* a, size_t index, T item)
*/
#define jm_vector_set_item(T) jm_mangle(jm_vector_set_item, T)

/**
  jm_vector_zero sets all elements in the vector to zero
  void jm_vector_zero(T)(jm_vector(T)* a);
  */
#define jm_vector_zero(T) jm_mangle(jm_vector_zero, T)

/**
*  jm_vector_resize resizes the vector
*   Input:
*     a - the vector
*     size - new size
*   Return:
*     size of the vector after operation. Can be less than size if memory allocation failed.
*     Note: resizing to smaller vector does not release memory.
*  size_t jm_vector_resize(T)(jm_vector(T)* a, size_t size)
*/
#define jm_vector_resize(T) jm_mangle(jm_vector_resize, T)

/**
*  jm_vector_reserve preallocates memory for the vector (to speed up consequent push_back)
*  Returns: the actually reserved space. Can be smaller than requested "capacity" if memory allocation failed.
*  Can be larger than "capacity" if more memory was previously allocated.
*  size_t jm_vector_reserve(T)(jm_vector(T)* a, size_t capacity)
*/
#define jm_vector_reserve(T) jm_mangle(jm_vector_reserve, T)

/**
*  jm_vector_copy copies source vector into destination.
*  Returns the number of elements actually copied (may be less than the source size if allocation failed).
*  size_t jm_vector_copy(T)(jm_vector(T)* destination, jm_vector(T)* source)
*/
#define jm_vector_copy(T) jm_mangle(jm_vector_copy, T)

/**
*  jm_vector_clone creates a copy of the provided vector on heap and returns it.
*  Allocated capacity matches the size of the given vector. Returns the vector pointer or zero if memory allocation failed.
*  jm_vector(T)* jm_vector_clone(T)(jm_vector(T)* source)
*/
#define jm_vector_clone(T) jm_mangle(jm_vector_clone, T)

/**
*  jm_vector_append appends source vector into destination.
*  Returns the number of elements actually appended (may be less than the source size if allocation failed).
*  size_t jm_vector_append(T)(jm_vector(T)* destination, jm_vector(T)* source)
*/
#define jm_vector_append(T) jm_mangle(jm_vector_append, T)

/**
*  jm_vector_insert inserts an element at a given location.
*  Returns a pointer to the inserted element or zero pointer if failed
*  T* jm_vector_insert(T)(jm_vector(T)* a, size_t index, T item)
*/
#define jm_vector_insert(T) jm_mangle(jm_vector_insert, T)

/**
* jm_vector_remove_item removes an item from the vector.
* Vector size is reduced by 1. Supplying index > size gives assertion fault.
* void jm_vector_remove_item(T)(jm_vector(T)* v, size_t index)
*/
#define jm_vector_remove_item(T) jm_mangle(jm_vector_remove_item, T)

/**
* T* jm_vector_resize1(jm_vector(T)* a)
* Increase the size of the vector by 1 and return a pointer to the last item. 
* Return 0 if memory allocation failed.
*/
#define jm_vector_resize1(T)  jm_mangle(jm_vector_resize1, T)

/**
*  jm_vector_push_back
*  Returns a pointer to the inserted element or zero pointer if failed.
*  T* jm_vector_push_back(jm_vector(T)* a, T item)
*/
#define jm_vector_push_back(T) jm_mangle(jm_vector_push_back, T)

/**
*  jm_vector_foreach calls f for each element in the vector. "contect" parameter
*  is passed directly to the function as the second argument for the second version.
*  void jm_vector_foreach(T)(jm_vector(T)* a, void (*f)(T))
*  void jm_vector_foreach_c(T)(jm_vector(T)* a, void (*f)(T, void*), void * context)
*/
#define jm_vector_foreach(T) jm_mangle(jm_vector_foreach, T)
#define jm_vector_foreach_c(T) jm_mangle(jm_vector_foreach_c, T)

/** @} */

/** number of items always allocated on the stack */
#define JM_VECTOR_MINIMAL_CAPACITY 16

/** maximum memory chunk (in items) to be allocated in push_back. */
#define JM_VECTOR_MAX_MEMORY_CHUNK 1024

/** Declare the struct and functions for the specified type. */
#define jm_vector_declare_template(T)		\
typedef struct  jm_vector(T) {                \
        jm_callbacks* callbacks; 			\
        T  *items;     				\
	size_t size;  				 \
        size_t capacity; 			\
        T preallocated[JM_VECTOR_MINIMAL_CAPACITY];			\
} jm_vector(T);					\
 \
extern jm_vector(T)* jm_vector_alloc(T)(size_t size,size_t capacity, jm_callbacks*);	\
    \
extern size_t jm_vector_copy(T)(jm_vector(T)* destination, jm_vector(T)* source); \
static jm_vector(T)* jm_vector_clone(T)(jm_vector(T)* v) {	\
    jm_vector(T)* ret = jm_vector_alloc(T)(v->size, v->size, v->callbacks);\
    if(ret) jm_vector_copy(T)(ret, v) ; \
    return ret; \
}\
        \
extern void jm_vector_free(T)(jm_vector(T) * a); \
    \
extern size_t jm_vector_init(T)(jm_vector(T)* a, size_t size,jm_callbacks*);	\
\
static void jm_vector_free_data(T)(jm_vector(T)* a) { \
    if(a) { \
        if(a->items != a->preallocated) { \
          a->callbacks->free((void*)(a->items)); \
          a->items = a->preallocated; \
          a->capacity=JM_VECTOR_MINIMAL_CAPACITY;\
        } \
        a->size=0; \
    } \
} \
   \
static size_t jm_vector_get_size(T)(jm_vector(T)* a) { return a->size; } \
\
static T jm_vector_get_item(T)(jm_vector(T)* a, size_t index) { \
           assert(index < a->size); \
           return a->items[index]; \
}\
static T* jm_vector_get_itemp(T)(jm_vector(T)* a, size_t index) { \
           assert(index < a->size); \
           return (a->items+index); \
}\
 static T jm_vector_get_last(T)(jm_vector(T)* a) { \
        assert(a->size); \
        return (a->items[a->size-1]); \
} \
static T* jm_vector_get_lastp(T)(jm_vector(T)* a) { \
    if(a->size) return (a->items+(a->size-1)); \
    else return 0; \
} \
 static void jm_vector_set_item(T)(jm_vector(T)* a, size_t index, T item) {\
    *(jm_vector_get_itemp(T)(a, index)) = item; \
} \
extern size_t jm_vector_resize(T)(jm_vector(T)* a, size_t size); \
extern size_t jm_vector_reserve(T)(jm_vector(T)* a, size_t capacity); \
extern size_t jm_vector_append(T)(jm_vector(T)* destination, jm_vector(T)* source); \
extern T* jm_vector_insert(T)(jm_vector(T)* a, size_t index, T item);\
extern T* jm_vector_push_back(T)(jm_vector(T)* a, T item);\
extern T* jm_vector_resize1(T)(jm_vector(T)* a);\
extern void jm_vector_remove_item(T)(jm_vector(T)* v, size_t index); \
extern size_t jm_vector_find_index(T)(jm_vector(T)* a,  T *itemp, jm_compare_ft f); \
extern T* jm_vector_find(T)(jm_vector(T)* a,  T *itemp, jm_compare_ft f); \
extern void jm_vector_qsort(T)(jm_vector(T)* v, jm_compare_ft f); \
extern size_t jm_vector_bsearch_index(T)(jm_vector(T)* v, T* key, jm_compare_ft f); \
extern T* jm_vector_bsearch(T)(jm_vector(T)* v, T* key, jm_compare_ft f); \
extern void jm_vector_foreach(T)(jm_vector(T)* a, void (*f)(T)); \
extern void jm_vector_foreach_c(T)(jm_vector(T)* a, void (*f)(T, void*), void * data); \
extern void jm_vector_zero(T)(jm_vector(T)* a);    

jm_vector_declare_template(char)
static jm_string jm_vector_char2string(jm_vector(char)* v) {
    jm_string str = "";
    if(v->size) return v->items;
    return str;
}

jm_vector_declare_template(int)
jm_vector_declare_template(double)
jm_vector_declare_template(jm_voidp)
jm_vector_declare_template(size_t)
jm_vector_declare_template(jm_string)
jm_vector_declare_template(jm_name_ID_map_t)


jm_define_comp_f(jm_compare_voidp, int*, jm_diff)
jm_define_comp_f(jm_compare_int, int, jm_diff)
jm_define_comp_f(jm_compare_char, char, jm_diff)
jm_define_comp_f(jm_compare_double, double, jm_diff)
jm_define_comp_f(jm_compare_size_t, size_t, jm_diff)
jm_define_comp_f(jm_compare_string, jm_string, strcmp)

#define jm_diff_name(a, b) strcmp(a.name,b.name)
jm_define_comp_f(jm_compare_name, jm_name_ID_map_t, jm_diff_name)

/** 
@}
*/

#ifdef __cplusplus
}
#endif

#endif
