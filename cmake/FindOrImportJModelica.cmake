get_directory_property(HAS_PARENT PARENT_DIRECTORY)
if( HAS_PARENT )
  # If there is a parent directory that means modelica-buildings
  # is being built within another project, such as spawn.
  # Expect MODELICA_HOME to be set, and also expect modelica
  # libs to be built by a cmake external project with target named JModelica
  add_library( ModelicaExternalC STATIC IMPORTED )
  add_library( ModelicaIO STATIC IMPORTED )
  add_library( ModelicaMatIO STATIC IMPORTED )
  add_library( ModelicaStandardTables STATIC IMPORTED )
  add_library( Blas STATIC IMPORTED )
  add_library( Fmi1_cs STATIC IMPORTED )
  add_library( Fmi1_me STATIC IMPORTED )
  add_library( Fmi2 STATIC IMPORTED )
  add_library( Jmi STATIC IMPORTED )
  add_library( Jmi_block_solver STATIC IMPORTED )
  add_library( Jmi_get_set_default STATIC IMPORTED )
  add_library( Lapack STATIC IMPORTED )
  add_library( Zlib STATIC IMPORTED )

  set_target_properties( ModelicaExternalC PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libModelicaExternalC.a" )
  set_target_properties( ModelicaIO PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libModelicaIO.a" )
  set_target_properties( ModelicaMatIO PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libModelicaMatIO.a" )
  set_target_properties( ModelicaStandardTables PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libModelicaStandardTables.a" )
  set_target_properties( Blas PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libblas.a" )
  set_target_properties( Fmi1_cs PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libfmi1_cs.a" )
  set_target_properties( Fmi1_me PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libfmi1_me.a" )
  set_target_properties( Fmi2 PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libfmi2.a" )
  set_target_properties( Jmi PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libjmi.a" )
  set_target_properties( Jmi_block_solver PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libjmi_block_solver.a" )
  set_target_properties( Jmi_get_set_default PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libjmi_get_set_default.a" )
  set_target_properties( Lapack PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/liblapack.a" )
  set_target_properties( Zlib PROPERTIES IMPORTED_LOCATION "${MODELICA_HOME}/lib/RuntimeLibrary/libzlib.a" )

  add_dependencies( ModelicaExternalC JModelica )
  add_dependencies( ModelicaIO JModelica )
  add_dependencies( ModelicaMatIO JModelica )
  add_dependencies( ModelicaStandardTables JModelica )
  add_dependencies( Blas JModelica )
  add_dependencies( Fmi1_cs JModelica )
  add_dependencies( Fmi1_me JModelica )
  add_dependencies( Fmi2 JModelica )
  add_dependencies( Jmi JModelica )
  add_dependencies( Jmi_block_solver JModelica )
  add_dependencies( Jmi_get_set_default JModelica )
  add_dependencies( Lapack JModelica )
  add_dependencies( Zlib JModelica )

  list( APPEND MODELICA_LIBS
    ModelicaExternalC
    ModelicaIO
    ModelicaMatIO
    ModelicaStandardTables
    Blas
    Fmi1_cs
    Fmi1_me
    Fmi2
    Jmi
    Jmi_block_solver
    Jmi_get_set_default
    Lapack
    Zlib
  )
else()
  # If the project is being built as a standalone project, then 
  # require MODELICA_HOME to be set at configure time as a cache variable
  set( MODELICA_HOME CACHE PATH "Modelica Home" )
  find_library( ModelicaExternalC_LIB ModelicaExternalC HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( ModelicaIO_LIB ModelicaIO HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( ModelicaMatIO_LIB ModelicaMatIO HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( ModelicaStandardTables_LIB ModelicaStandardTables HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Blas_LIB blas HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Fmi1_cs_LIB fmi1_cs HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Fmi1_me_LIB fmi1_me HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Fmi2_LIB fmi2 HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Jmi_LIB jmi HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Jmi_block_solver_LIB jmi_block_solver HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Jmi_get_set_default_LIB jmi_get_set_default HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Lapack_LIB lapack HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )
  find_library( Zlib_LIB zlib HINTS "${MODELICA_HOME}/lib/RuntimeLibrary/" )

  list( APPEND MODELICA_LIBS
    ${ModelicaExternalC_LIB}
    ${ModelicaIO_LIB}
    ${ModelicaMatIO_LIB}
    ${ModelicaStandardTables_LIB}
    ${Blas_LIB}
    ${Fmi1_cs_LIB}
    ${Fmi1_me_LIB}
    ${Fmi2_LIB}
    ${Jmi_LIB}
    ${Jmi_block_solver_LIB}
    ${Jmi_get_set_default_LIB}
    ${Lapack_LIB}
    ${Zlib_LIB}
  )
endif()

