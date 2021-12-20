% FMILIB_Readme.txt
% Readme file for the FMI Library
%  
% Content of this file is used verbatim in doxygen generated documentation.
% The documentation can be downloaded as HTML at
% https://github.com/modelon-community/fmi-library/releases
%

\mainpage FMI Library

\version     2.2
\date        11 March 2020
\section Summary
FMI library is intended as a foundation for applications interfacing FMUs 
(Functional Mockup Units) that follow FMI Standard. This version of the library supports FMI 1.0 and FMI2.0.
See <http://www.fmi-standard.org/> 

The test codes provided with the library can serve as starting point for the 
development of custom applications. See Section \ref testing for details.

FMI library is an open-source project and can be found at GitHub: <https://github.com/modelon-community/fmi-library/>

\section config Configuring and building
CMake (see <http://www.cmake.org/>) is used to generate the native build scripts
for the library. It is recommended to use "cmake-gui" on Windows or 
"ccmake <FMIL source dir>" to configure the build. All the required third party
libraries are included into the distribution.

CMake 2.8.6 is required since this is the version used in development both on 
Windows and Linux. The build script is KNOWN NOT TO WORK WITH CMake 2.8.3 and 
below (due to ExternalProject interface changes). CMake 2.8.4 and 2.8.5 are not 
tested.

To build from a terminal command line on Linux or Mac with default settings use:
\code
	mkdir build-fmil; cd build-fmil
	cmake -DFMILIB_INSTALL_PREFIX=<prefix> <path to FMIL source>
	make install test
\endcode
To build in MSYS terminal with g++/gcc on Windows:
\code
	mkdir build-fmil; cd build-fmil
	cmake -DFMILIB_INSTALL_PREFIX=<prefix> -G "MSYS Makefiles" <path to FMIL source>
	make install test
\endcode
To build from command line with Microsoft Visual Studio compilers on Windows:
\code
	mkdir build-fmil; cd build-fmil
	cmake -DFMILIB_INSTALL_PREFIX=<prefix> -G "Visual Studio 10" <path to FMIL source>
	cmake --build . --config MinSizeRel --target install
\endcode

The primary targets of the library build script are:
- <prefix>/include/fmilib.h \n
  The include file to be used in client applications.
- Library files under <prefix>/lib/ \n
  Static library is named 'fmilib' and shared library 'fmilib_shared'. The 
  prefix/suffix of the library files differ depending on the platform. Note 
  that if you have configure and built both static and shared library on 
  Windows but want to link with the static library compile time define 
  "FMILIB_BUILDING_LIBRARY" must be set.
- Doxygen generated documentation under <prefix>/doc/. Note that 
  documentation is not generated as part   of install target and you need to 
  build the 'doc' target separately, i.e., run 'make doc' or explicitly   build 
  the project in Visual Studio. 
  
The following build configuration options are provided:
- \b FMILIB_INSTALL_PREFIX - prefix prepended to install directories.\n
   Default: "../install" \n
   This is the main install directory name. Include files will be located in 
   the "include" subdirectory and library files in the "lib" subdirectory. 
   Client applications should only include "fmilib.h"

- \b FMILIB_THIRDPARTYLIBS - thirdparty libaries are currently shipped with 
   the library. 

- \b FMILIB_FMI_STANDARD_HEADERS - Path to the FMI standard headers 
  directory. Header for specific standards files are expected in 
  subdirectories FMI1, FMI2, etc.\n
  Default: "ThirdParty/FMI/default"

- \b FMILIB_DEFAULT_BUILD_TYPE_RELEASE - Controls build-type used for 
  Makefile generation.\n  
  Default: ON\n
  If this option is on then 'Release' mode compile flags are used. Otherwize, 
  'Debug' mode flags are generated into the Makefile. The option may be 
  overwritten by explicitly setting CMAKE_BUILD_TYPE.

- \b FMILIB_BUILD_WITH_STATIC_RTLIB Use static run-time libraries (/MT or 
  /MTd code generation flags).\n
  Default: OFF\n
  This is only used when generating Microsoft Visual Studio solutions. If the 
  options is on then the library will be built against static runtime, 
  otherwise - dynamic runtime (/MD or /MDd). Make sure the client code is 
  using matching runtime.

- \b FMILIB_BUILD_STATIC_LIB Build the library as static.\n
  Default: ON\n
  'fmilib' may be used for static linking.
  
- \b FMILIB_BUILD_SHARED_LIB Build the library as shared (dll/so/dylib).\n
  Default: ON\n
  '\e fmilib_shared' may be used for dynamic linking.

- \b FMILIB_FMI_PLATFORM - FMI platform defines the subdirectory within FMU 
  where binary is located.\n
  The build system will automatically detect win32, win64, linux32, linux64, 
  darwin32, darwin64.

- \b FMILIB_BUILD_FOR_SHARED_LIBS  The static library 'fmilib' can be linked 
  into shared libraries.\n
  Default: ON\n
  On LINUX position independent code (-fPIC) must be used on all files to be 
  linked into a shared library (.so file). On other systems this is not 
  needed (either is default or relocation is done).
  Set this option to OFF if you are building an application on Linux and use 
  static library only.

- \b FMILIB_ENABLE_LOG_LEVEL_DEBUG Enable log level \e 'debug'. \n
  Default: OFF\n
  If the option is OFF then the debug level messages are not compiled in.

- \b FMILIB_GENERATE_DOXYGEN_DOC Enable doxygen target.\n
  Default: ON\n
  You need Doxygen to be installed on the system for this option to have an
  effect.

- \b FMILIB_BUILD_TESTS Enable build of the tests supplied with the library.\n
  Default: ON\n
  \c RUN_TESTS - target will be provided in Visual Studio. 'make test' will 
  run tests on Makefile based platforms.
  
- \b FMILIB_BUILD_BEFORE_TESTS Force build before testing, i.e., building the 
  FMI library becomes the first test.\n
  Default: ON

- \b FMILIB_LINK_TEST_TO_SHAREDLIB Link the tests to fmilib_shared (if built) 
  instead of static fmilib.\n
  Default: ON

- \b FMILIB_GENERATE_BUILD_STAMP Generate a build time stamp and include in 
  into the library. \n
  Default: OFF\n
  The function \e fmilib_get_build_stamp() may be used to retrieve the time 
  stamp. \code const char* fmilib_get_build_stamp(void); \endcode

- \b FMILIB_BUILD_LEX_AND_PARSER_FILES Generate scanner and parser for variable
  name syntax checking. Requiers Flex and Bison commands to be specified. Please
  read src/XML/NOTE if using this option. Can only be used on windows. Only
  tested with versions 2.4.3/2.5.3.

- \b BISON_COMMAND Specifies the path to the Bison executable. Only visible if
  FMILIB_BUILD_LEX_AND_PARSER_FILES is checked.

- \b FLEX_COMMAND Specifies the path to the Flex executable. Only visible if
  FMILIB_BUILD_LEX_AND_PARSER_FILES is checked.

\section testing Automatic tests
The FMI library comes with a number of automatic tests. Building of the test 
is controlled by \a FMILIB_BUILD_TESTS configuration option. The test 
porgrams are also intended as examples of library usage.\n
 The tests can be run in Visual Studio by building project \e RUN_TESTS. For 
Makefile based configurations (MSYS, Linux, Mac OSx) run 'make test'.\n 
Output from the test programs and test logs can be found in the \e Testing 
folder in the build directory.

The supplied tests are:
- \b ctest_build_all \n
Build the library. This test is controlled by \a FMILIB_BUILD_BEFORE_TESTS 
configuration option.
- \b ctest_fmi_zip_unzip_test \n
Basic unzip functionality test. Test executable is \e fmi_zip_unzip_test.
- \b ctest_fmi_zip_zip_test \n
Basic zip functionality test. Test executable is \e fmi_zip_zip_test.
- \b ctest_fmi1_check_variable_naming_conventions_test \n
Tests the name checker functionality to follow the variable naming conventions. 
Test executable is \e ctest_fmi1_check_variable_naming_conventions_test, main
source file is \ref ctest_fmi1_check_variable_naming_conventions_test.c.
\e fmi_import_me_test, main source file is \ref fmi_import_me_test.c.
- \b ctest_fmi_import_me_test \n
Load a basic model exchange FMU and simulate it. Test executable is 
\e fmi_import_me_test, main source file is \ref fmi_import_me_test.c.
- \b ctest_fmi_import_cs_test \n
Load a basic co-simulation FMU and simulate it. Test executable is 
\e fmi_import_cs_test, main source file is \ref fmi_import_cs_test.c.
- \b ctest_fmi_import_cs_tc_test \n
Load a basic co-simulation tools coupling FMU and simulate it. Test executable is 
\e fmi_import_cs_test, main source file is \ref fmi_import_cs_test.c.
- \b ctest_fmi_import_xml_test, \b ctest_fmi_import_xml_test_empty, 
\b ctest_fmi_import_xml_test_mf \n
Load a small model description XML file and print out detailed information on 
it. Test executable is \e fmi_import_xml_text, main source file is 
\ref fmi_import_xml_test.cc. The test is run on three different XML files.
This test depends on the success of the \e ctest_fmi_import_cs_test. 
- \b ctest_fmi1_capi_cs_test \n
Low level test of FMI CAPI functionality for co-simulation. Test executable 
is \e fmi1_capi_cs_test.
- \b ctest_fmi1_capi_me_test \n
Low level test of FMI CAPI functionality for model exchange. Test executable 
is \e fmi1_capi_me_test.
- \b ctest_fmi1_logger_test_run \n
Run logger test generating output fmi1_logger_test_output.txt. Test 
executable is \e fmi1_logger_test.
- \b ctest_fmi1_logger_test_check \n
Check that the logger test output generated by \b ctest_fmi1_logger_test_run 
is identical with the reference file found in the \b Test subdirectory.
- \b ctest_fmi2_check_variable_naming_conventions_test \n
Tests the name checker functionality to follow the variable naming conventions. 
Test executable is \e ctest_fmi2_check_variable_naming_conventions_test, main
source file is \ref ctest_fmi2_check_variable_naming_conventions_test.c.
- \b ctest_fmi2_import_xml_test_empty, \b ctest_fmi2_import_xml_test_me,
\b ctest_fmi2_import_xml_test_cs, \b ctest_fmi2_import_xml_test_mf \n
Same as \b ctest_fmi_import_xml_test for FMI 2.0 modules. Test executable
is \e fmi2_import_xml_test.exe, main source file \ref fmi2_import_xml_test.cc.
- \b ctest_fmi2_import_test_me \n
Load a basic FMI 2.0 model exchange FMU and simulate it. Test executable is 
\e fmi2_import_me_test, main source file is \ref fmi2_import_me_test.c.
- \b ctest_fmi2_import_test_cs \
Load a basic FMI 2.0 co-simulation FMU and simulate it. Test executable is 
\e fmi2_import_cs_test, main source file is \ref fmi2_import_me_test.c.
- \b ctest_fmi_import_test_no_xml, \b ctest_fmi_import_test_me_1,
\b ctest_fmi_import_test_cs_1, \b ctest_fmi_import_test_me_2, 
\b ctest_fmi_import_test_cs_2 \n
Test library functionality of handling FMUs with different standard interfaces
within a single application. Test executable is \e fmi_import_test.exe. Main
source file is \ref fmi_import_test.c

\section logging Using logs
In the text below we consider an FMU importing application (referenced as an 
'application') that uses the FMIL. The library is designed to send log 
messages to a logger callback function ::jm_logger_f provided as a part of 
::jm_callbacks structure in the call to fmi_import_allocate_context(). The 
logging/error reporting functions within FMIL support following modes: 
-# An importing application relies on default logging functions provided by 
FMIL and only chooses the log-level 
	- FMIL provides default jm logger callback (See jm_callbacks.h 
		jm_default_logger())
	- FMIL provides default fmi logger callback for each standard version.
    See fmi1_import_convenience.h fmi1_default_callback_logger() and
	fmi2_import_convenience.h fmi2_default_callback_logger().
-# An application provides a callback for reporting error messages according 
	to jm_callbacks.h (::jm_logger_f) 
   - Only errors from FMIL can be propagated to this callback in a 
	thread-safe manner for FMI1. 
	Imported FMUs may still use the default callback provided by the library. 
	This is since logger function in FMI 1.0 standard is context 
	independent. The non-thread safe implementation on the FMI1 callback can 
	be found in fmi1_import_convenience.h fmi1_log_forwarding().\n
	In FMI 2 the fmiComponentEnvironment can be utilized to forward 
	messages from the default fmi2 logger function as provided by the library 
	to the user defined ::jm_logger_f function. The fmi2_log_forwarding() 
	function expects the context to be set to ::fmi2_import_t.
-# An importing application provides logging function according to the specific
   FMI standard version.
   - Errors from FMIL may be forwarded to this callback. There is a function 
	that translates calls according to jm_callbacks.h ::jm_logger_f into calls 
	according to fmi_functions.h fmi_callbacks_logger_ft (see 
	fmi1_import_init_logger() or fmi2_import_init_logger() that are used to setup 
	'forwarding').\n
    Setting of the callback can only be done at the stage where FMU standard 
	is known.
-# An importing application may choose not to use logging function but rely on 
    return codes and jm_get_last_error() 
    - jm_logger function should be set to NULL
    - Errors from a FMI 1.0 fmu1 cannot be handled this way in a thread-safe 
	way (see point 2 above). It works fine with FMI 2.0.
 
