@echo off
cd /d "%~dp0"

::*******************************************************************
::Set Compiler Directory
::*******************************************************************

::-------------------------------------------------------------------
::Set User Defined Compiler Directory
::-------------------------------------------------------------------
::Example: 
::set VCDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC
::if not exist "%VCDIR%\" goto missing
::goto InstallGlut2

::-------------------------------------------------------------------
::Set Default Compiler Version
::-------------------------------------------------------------------
set VCVersion=10.0

::-------------------------------------------------------------------
::Set VC and SYS Directory
::Note that SysWOW64 is for 32-bits files in 64 bits system, 
::which is supported by current Dymola
::-------------------------------------------------------------------
::Check Processor Architecture
if %PROCESSOR_ARCHITECTURE%==x86 set VCDIR=C:\Program Files\Microsoft Visual Studio
if %PROCESSOR_ARCHITECTURE%==x86 set SYSDIR=C:\Windows\System32
if %PROCESSOR_ARCHITECTURE%==AMD64 set VCDIR=C:\Program Files (x86)\Microsoft Visual Studio
if %PROCESSOR_ARCHITECTURE%==AMD64 set SYSDIR=C:\Windows\SysWOW64
::Note: IA64 is not supported

:: Check VC and system folder Directory
if not exist "%VCDIR% %VCVersion%\VC\" goto missing
if not exist "%SYSDIR%" goto missing1

::*******************************************************************
::Install Glut
::*******************************************************************
echo copy glut32.dll, glut32.lib, and glut.h to VC directory
copy "..\..\bin\glut32.dll" "%VCDIR% %VCVersion%\VC\bin" /-y
copy "..\..\bin\glut32.lib" "%VCDIR% %VCVersion%\VC\lib" /-y
xcopy "glut.h" "%VCDIR% %VCVersion%\VC\include\GL\*" /-y


:InstallGlut2
echo copy glut32.dll, glut32.lib, and glut.h to VC directory
copy "..\..\bin\glut32.dll" "%VCDIR%\VC\bin" /-y
copy "..\..\bin\glut32.lib" "%VCDIR%\VC\lib" /-y
xcopy "glut.h" "%VCDIR%\VC\include\GL\*" /-y


:copy glut32.dll into system folder
echo copy glut.32 to system folder
copy "..\..\bin\glut32.dll" "%SYSDIR%" /-y
goto :eof

:missing
echo Can not find VC %VCVersion% compiler in default path.
echo Please change default compiler version or set user defined value into this batch script.
pause
goto :eof

:missing1
echo Can not find %SYSDIR% in default path.
echo Please check your computer.
pause
goto :eof