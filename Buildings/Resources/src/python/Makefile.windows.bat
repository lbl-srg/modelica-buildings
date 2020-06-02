@echo off
REM #######################################################
REM # WINDOWS OPERATING SYSTEMS
REM #######################################################
REM # Batch to compile Python interface
REM # Thierry S. Nouidui (TSNouidui@lbl.gov) March 16, 2016

REM ############## NOTES #################################################
REM # To compile the libraries, we need to have visual studio
REM # compilers installed. The user must provide the system
REM # architecture (x86 or x64) as first argument. Also the architecture
REM # related paths must be properly set up in the batch file (see below).
REM ######################################################################

SET /A errno=0

SET SRCS=pythonInterpreter.c
SET LIBS=pythonInterpreter.lib

REM SET MOD_DLL=ModelicaBuildingsPython2.7.dll
REM SET MOD_LIB=ModelicaBuildingsPython2.7.lib
SET MOD_DLL=ModelicaBuildingsPython3.6.dll
SET MOD_LIB=ModelicaBuildingsPython3.6.lib

SET DUMMY_SRC=dummy.c
REM SET DUMMY_DLL=python2.7.dll
SET DUMMY_DLL=python3.6.dll

REM The first parameter is the architecture flag (x86 or x64).
REM + Architecture related paths must be specified before running the batch file:
REM   PYTHONHOME and CLPATH (compiler path).
REM + For compiling on Win32: need to properly set up Python environment first.
REM So for instance (from the command line in CMD.EXE):
REM x86
REM   set CONDA_FORCE_32BIT=1
REM   activate {name of Python 32-bit environment}
REM   set PYTHONHOME=%HOME%\Miniconda2\envs\{name of Python 32-bit environment}
REM   set CLPATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
REM x64
REM   set CONDA_FORCE_32BIT=
REM   activate {name of Python 64-bit environment}
REM   set PYTHONHOME=%HOME%\Miniconda2\envs\{name of Python 64-bit environment}
REM   set CLPATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"

SET PYTHONHOME="C:\Miniconda3-4-3-31"
SET CLPATH="C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\bin\amd64\vcvars64.bat"

IF NOT -%1-==-- (
  IF "%~1"=="x86" SET ARCH=%~1
  IF "%~1"=="x64" SET ARCH=%~1
)

SET ARCH=x64

VERIFY OTHER 2>nul
SETLOCAL ENABLEEXTENSIONS
IF ERRORLEVEL 1 ECHO Unable to enable extensions.

IF NOT DEFINED ARCH (
  ECHO Unknown system architecture: specify either x86 or x64.
  EXIT /B 1
)
IF DEFINED PYTHONHOME (
  ECHO PYTHONHOME is: %PYTHONHOME%
) ELSE (
  ECHO PYTHONHOME is not set: compilation aborted.
  EXIT /B 1
)
IF DEFINED CLPATH (
  ECHO CLPATH ^(compiler path^) is: %CLPATH%
) ELSE (
  ECHO CLPATH ^(compiler path^) is not set: compilation aborted.
  EXIT /B 1
)

ENDLOCAL

IF %ARCH%==x86 (
  SET BINDIR=..\..\Library\win32
  ECHO Windows 32 bit compilation activated.
)
IF %ARCH%==x64 (
  SET BINDIR=..\..\Library\win64
  ECHO Windows 64 bit compilation activated.
)
ECHO DLL will be saved in: %BINDIR%.

SET PYTHONInc=%PYTHONHOME%\include
REM SET PYTHONLibs=%PYTHONHOME%\libs\python27.lib
SET PYTHONLibs=%PYTHONHOME%\libs\python36.lib

CALL %CLPATH%
IF %ERRORLEVEL% neq 0 (
  ECHO Problem configuring the Visual Studio tools for command-line use.
  SET /A errno=%ERRORLEVEL%
  GOTO done
)

:: Compiling the dummy Python dlls.
CL /LD %DUMMY_SRC% /link /out:%DUMMY_DLL%
IF %ERRORLEVEL% neq 0 (
  ECHO Error when compiling the dummy Python dlls.
  SET /A errno=%ERRORLEVEL%
  GOTO done
)

:: Compiling the Python interpreter libraries
CL /LD /MT /I%PYTHONInc% %SRCS% %PYTHONLibs% /link /out:%MOD_DLL%
IF %ERRORLEVEL% neq 0 (
  ECHO Error when compiling the Python interpreter libraries.
  SET /A errno=%ERRORLEVEL%
  GOTO done
)

:: Creating the import library
:: lib /def:%MOD_DEF%

:: Compiling the test Program
CL /I%PYTHONInc% testProgram.c %SRCS%  %PYTHONLibs%
IF %ERRORLEVEL% neq 0 (
  ECHO Error when compiling the test Program.
  SET /A errno=%ERRORLEVEL%
  GOTO done
)

:: Running the testProgram
ECHO Run the testProgram.exe
CALL testProgram.exe
IF %ERRORLEVEL% neq 0 (
  ECHO Test program failed.
  ECHO Are environment variables PYTHONHOME and PYTHONPATH properly defined?
  SET /A errno=%ERRORLEVEL%
  GOTO done
) ELSE (
  ECHO Test program succeeded.
)

ECHO Rename library file.
ren %LIBS% %MOD_LIB%

ECHO Move files to the Library.
move /Y %MOD_DLL% %BINDIR%
move /Y %MOD_LIB% %BINDIR%
move /Y %DUMMY_DLL% %BINDIR%
IF %ERRORLEVEL% neq 0 (
    ECHO Error while trying to move the binaries.
    SET /A errno=%ERRORLEVEL%
    GOTO done
)

: done
ECHO Delete temporary files.

:: Delete object files
del *.obj

:: Delete temporary files
del "*.exp"

:: Delete lib files
del testProgram.lib

:: Delete exe files
del testProgram.exe

EXIT /B %errno%
