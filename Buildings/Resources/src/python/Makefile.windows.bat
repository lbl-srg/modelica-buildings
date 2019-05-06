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

SET MOD_DLL=ModelicaBuildingsPython2.7.dll
SET MOD_LIB=ModelicaBuildingsPython2.7.lib

SET DUMMY_SRC=dummy.c
SET DUMMY_DLL=python2.7.dll

:: The first parameter is the architecture flag (x86 or x64).
IF NOT -%1-==-- (
  IF "%~1"=="x86" SET ARCH=%~1
  IF "%~1"=="x64" SET ARCH=%~1
) 
IF "%ARCH%"=="" (
  SET /A errno=1
  ECHO Unknown system architecture: specify either x86 or x64.
  EXIT /B 1
) 

:: Specify architecture related paths.
REM For testing on Win32: need to run the following commands before batch to properly set up Python environment.
REM set CONDA_FORCE_32BIT=1
REM activate py27_32
REM PYTHONHOME is set here for testing purposes as well.
IF %ARCH%==x86 (
  ECHO Windows 32 bit compilation activated.
  SET PYTHONHOME=C:\Users\agautier\Miniconda2\envs\py27_32
  SET PYTHONInc=C:\Users\agautier\Miniconda2\envs\py27_32\include
  SET PYTHONLibs=C:\Users\agautier\Miniconda2\envs\py27_32\libs\python27.lib
  SET BINDIR=..\..\Library\win32
  SET CLPATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
)
IF %ARCH%==x64 (
  ECHO Windows 64 bit compilation activated.
  SET PYTHONHOME=C:\Users\agautier\Miniconda2
  SET PYTHONInc=C:\Users\agautier\Miniconda2\include
  SET PYTHONLibs=C:\Users\agautier\Miniconda2\libs\python27.lib
  SET BINDIR=..\..\Library\win64
  SET CLPATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
)

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

ECHO Rename library file
ren %LIBS% %MOD_LIB%

ECHO Copy files to the Library
move %MOD_DLL% %BINDIR%
move %MOD_LIB% %BINDIR%
move %DUMMY_DLL% %BINDIR%
IF %ERRORLEVEL% neq 0 (
    ECHO Error while trying to move the binaries.
    SET /A errno=%ERRORLEVEL%
    GOTO done
)

: done
ECHO Delete temporary files
:: Delete object files
del *.obj

:: Delete temporary files
del "*.exp"

:: Delete lib files
del testProgram.lib

:: Delete exe files
del testProgram.exe

EXIT /B %errno%

