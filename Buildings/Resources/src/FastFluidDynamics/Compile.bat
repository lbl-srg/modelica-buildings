@echo off

::*******************************************************************
::Set the Output Directory, Compile Mode and MSbuild File Name
::*******************************************************************
set DIR=..\..\Library\win32
set MSbuildName=ffd
set BuildConfiguration=Release
set Platform=Win32
::Note: Two build mode, Debug or Release

::*******************************************************************
::Delete the existing ffd.dll
::*******************************************************************
if exist "%DIR%\%MSbuildName%.dll" (
  echo Going to delete %MSbuildName%.dll
  del "%DIR%\%MSbuildName%.dll"
  )

if exist "%DIR%\%MSbuildName%.lib" (
  echo Going to delete %MSbuildName%.lib
  del "%DIR%\%MSbuildName%.lib"
  )

::*******************************************************************
::Set Compiler Environment Variable
::*******************************************************************

::-------------------------------------------------------------------
::Set User Defined Compiler Directory and Toolset
::-------------------------------------------------------------------
::Example:
::set VCDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC
::set Toolset=v100
::if exist "%VCDIR%\vcvarsall.bat" (
::  call "%VCDIR%\vcvarsall.bat"
::  goto MSbuildSetting
::  )

::-------------------------------------------------------------------
::Set Default Compiler Version and Toolset (edited by user)
::-------------------------------------------------------------------
::Note: Toolset: V100 for VC10.0, v110 for VC11.0
::      Toolset: V160 for VC 2019
::set VCVersion=14.0
::set Toolset=v140
set VCVersion=2019
set Toolset=v142

::-------------------------------------------------------------------
::Call vcvarsall.bat (Not user editable)
::-------------------------------------------------------------------
::Check Processor Architecture
if %PROCESSOR_ARCHITECTURE%==x86 set VCDIR=C:\Program Files\Microsoft Visual Studio
if %PROCESSOR_ARCHITECTURE%==AMD64 set VCDIR=C:\Program Files (x86)\Microsoft Visual Studio
::Note: IA64 is not supported

::Set Environment Variable
if %Platform%==Win32 (
  set Conf=x86
  set Conf_Platform=Win32
  )
if %Platform%==Win64 (
  set conf=x64
  set Conf_Platform=x64
  )

::if exist "%VCDIR% %VCVersion%\VC\vcvarsall.bat" (
::  call "%VCDIR% %VCVersion%\VC\vcvarsall.bat" %Conf%
::  goto MSbuildSetting
::  )
if exist "%VCDIR%\%VCVersion%\Community\VC\Auxiliary\Build\vcvarsall.bat" (
  call "%VCDIR%\%VCVersion%\Community\VC\Auxiliary\Build\vcvarsall.bat" %Conf%
  goto MSbuildSetting
  )


goto missing

:MSbuildSetting
::*******************************************************************
::MSbuild Setting
::*******************************************************************

::-------------------------------------------------------------------
::Common PropertyGroup for Debug Mode and Release Mode
::-------------------------------------------------------------------
::Configuration Type setting
  set ConfigurationTypeSetValue=DynamicLibrary

::Source Files and Header Files setting

  set SourceFile=advection.c;boundary.c;chen_zero_equ_model.c;cosimulation.c;data_writer.c;diffusion.c;ffd.c;ffd_data_reader.c;ffd_dll.c;geometry.c;initialization.c;interpolation.c;parameter_reader.c;projection.c;sci_reader.c;solver.c;solver_gs.c;solver_tdma.c;timing.c;utility.c;
  set HeaderFile=advection.h;boundary.h;chen_zero_equ_model.h;cosimulation.h;data_structure.h;data_writer.h;diffusion.h;ffd.h;ffd_data_reader.h;ffd_dll.h;geometry.h;initialization.h;interpolation.h;modelica_ffd_common.h;parameter_reader.h;projection.h;sci_reader.h;solver.h;solver_gs.h;solver_tdma.h;timing.h;utility.h

::-------------------------------------------------------------------
::Conditional PropertyGroup for Debug Mode and Release Mode
::-------------------------------------------------------------------

::Note: Two configurations, Debug and Release.
::      Debug mode emitted symbolic debug information,and the code execution is not optimized.
::      Release mode does not emitted debug information,and the code execution is optimized.
::Note: WIN32 in Preprocessor Definitions: Defined for applications for Win32 and Win64. Always defined.
if /i %BuildConfiguration%_%Conf_Platform%==Debug_Win32 (
  set UseDebugLibrariesSetValue=true
  set WholeProgramOptimizationSetValue=false
  set CharacterSetSetValue=Unicode
  set LinkIncrementalSetValue=true

  set WarningLevelSetValue=Level3
  set OptimizationSetValue=Disabled
  set FunctionLevelLinkingSetValue=false
  set IntrinsicFunctionsSetValue=false
  set PreprocessorDefinitionsSetValue=Win32;_DEBUG;_WINDOWS;_USRDLL;_CRT_SECURE_NO_WARNINGS;

  set SubSystemSetValue=Windows
  set GenerateDebugInformationSetValue=true
  set EnableCOMDATFoldingSetValue=false
  set OptimizeReferencesSetValue=false

  goto compile
  )

if /i %BuildConfiguration%_%Conf_Platform%==Debug_x64 (
  set UseDebugLibrariesSetValue=true
  set WholeProgramOptimizationSetValue=false
  set CharacterSetSetValue=Unicode
  set LinkIncrementalSetValue=true

  set WarningLevelSetValue=Level3
  set OptimizationSetValue=Disabled
  set FunctionLevelLinkingSetValue=false
  set IntrinsicFunctionsSetValue=false
  set PreprocessorDefinitionsSetValue=Win64;_DEBUG;_WINDOWS;_USRDLL;_CRT_SECURE_NO_WARNINGS;

  set SubSystemSetValue=Windows
  set GenerateDebugInformationSetValue=true
  set EnableCOMDATFoldingSetValue=false
  set OptimizeReferencesSetValue=false

  goto compile
  )

echo BuildingConfig is %BuildConfiguration% and the platform is %Platform%
::Note: To better understand code optimization, recommend to read "Optimization Best Practices"  http://msdn.microsoft.com/en-us/library/ms235601.aspx
if /i %BuildConfiguration%_%Conf_Platform%==Release_Win32 (
  set UseDebugLibrariesSetValue=false
  set WholeProgramOptimizationSetValue=true
  set CharacterSetSetValue=Unicode
  set LinkIncrementalSetValue=false

  set WarningLevelSetValue=Level3
  set OptimizationSetValue=MaxSpeed
  set FunctionLevelLinkingSetValue=true
  set IntrinsicFunctionsSetValue=true
  set PreprocessorDefinitionsSetValue=Win32;NDEBUG;_WINDOWS;_USRDLL;_CRT_SECURE_NO_WARNINGS;

  set SubSystemSetValue=Windows
  set GenerateDebugInformationSetValue=true
  set EnableCOMDATFoldingSetValue=true
  set OptimizeReferencesSetValue=true

  goto compile
  )

if /i %BuildConfiguration%_%Conf_Platform%==Release_x64 (
  set UseDebugLibrariesSetValue=false
  set WholeProgramOptimizationSetValue=true
  set CharacterSetSetValue=Unicode
  set LinkIncrementalSetValue=false

  set WarningLevelSetValue=Level3
  set OptimizationSetValue=MaxSpeed
  set FunctionLevelLinkingSetValue=true
  set IntrinsicFunctionsSetValue=true
  set PreprocessorDefinitionsSetValue=Win64;NDEBUG;_WINDOWS;_USRDLL;_CRT_SECURE_NO_WARNINGS;

  set SubSystemSetValue=Windows
  set GenerateDebugInformationSetValue=true
  set EnableCOMDATFoldingSetValue=true
  set OptimizeReferencesSetValue=true

  goto compile
  )

goto missingBuildConfiguration

:compile
::*******************************************************************
:: Build DLL
::*******************************************************************
msbuild %MSbuildName%.vcxproj /t:rebuild /p:PlatformToolset=%Toolset%;Configuration=%BuildConfiguration%;Platform=%Platform%;ConfigurationTypeSetValue=%ConfigurationTypeSetValue%;SourceFile="%SourceFile%";HeaderFile="%HeaderFile%";Configuration=%BuildConfiguration%;UseDebugLibrariesSetValue=%UseDebugLibrariesSetValue%;WholeProgramOptimizationSetValue=%WholeProgramOptimizationSetValue%;CharacterSetSetValue=%CharacterSetSetValue%;LinkIncrementalSetValue=%LinkIncrementalSetValue%;WarningLevelSetValue=%WarningLevelSetValue%;OptimizationSetValue=%OptimizationSetValue%;FunctionLevelLinkingSetValue=%FunctionLevelLinkingSetValue%;IntrinsicFunctionsSetValue=%IntrinsicFunctionsSetValue%;PreprocessorDefinitionsSetValue="%PreprocessorDefinitionsSetValue%";SubSystemSetValue=%SubSystemSetValue%;GenerateDebugInformationSetValue=%GenerateDebugInformationSetValue%;EnableCOMDATFoldingSetValue=%EnableCOMDATFoldingSetValue%;OptimizeReferencesSetValue=%OptimizeReferencesSetValue%
::Note: /p:PlatformToolset  Set toolset for compiling(V100 for VC10.0, v110 for VC11.0)
::Note: /t:rebuild          Force to rebuild
::Note: /p:Configuration    Set compile configuration
::Note: "/p:" is equivalent to "/property:", Set or override the specified project-level properties. Use a semicolon or comma to separate multiple properties. If the property value contains semicolon";", then use double quotes for property value, like SourceFile="%SourceFile%".

::*******************************************************************
::Copy ffd.dll to Output Directory
::*******************************************************************
echo Copy %MSbuildName%.dll and %MSbuildName%.lib to %DIR%
echo %Platform%
pause
if %Platform%==x86 (
  copy "%BuildConfiguration%\%MSbuildName%.dll" "%DIR%" /Y
  copy "%BuildConfiguration%\%MSbuildName%.lib" "%DIR%" /Y
  )
if %Platform%==x64 (
  copy "X64\%BuildConfiguration%\%MSbuildName%.dll" "%DIR%" /Y
  copy "X64\%BuildConfiguration%\%MSbuildName%.lib" "%DIR%" /Y
  )
::Note: /y: Suppresses prompting to confirm that you want to overwrite an existing destination file.

::*******************************************************************
::Clean Build Folder
::*******************************************************************
echo Clean %BuildConfiguration% Build Folder
if %Platform%==x86 (
  rmdir %BuildConfiguration% /s /q
  )
if %Platform%==x64 (
  rmdir X64 /s /q
  )
goto :eof
::Note: /s: Removes the specified directory and all subdirectories including any files.

:missing
echo Can not find VC %VCVersion% compiler in default path.
echo Please change default compiler version and toolset or set user defined value into this batch script.
pause
goto :eof

:missingBuildConfiguration
echo BuildConfiguration value is not matched. Please reset BuildConfiguration.
pause
goto :eof
