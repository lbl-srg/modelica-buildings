@echo off
REM #######################################################
REM # WINDOWS OPERATING SYSTEMS
REM #######################################################
REM # Batch to compile Python interface
REM # Thierry S. Nouidui (TSNouidui@lbl.gov) March 16, 2016

REM ############## NOTES ###########################################
REM # To compile the libraries, we need to have visual studio 
REM # compilers installed. The script will try to detect whether 
REM # the target operating system and set the environment variables.
REM # Adapt the path to PYTHONInc and PYTHONLibs for your operating system
REM # This script has been tested with Microsoft Visual Studio 10.0 Professional
REM ############################################################################

SET SRCS=pythonInterpreter.c
SET LIBS=pythonInterpreter.lib

SET MOD_DLL=ModelicaBuildingsPython3.4.dll
SET MOD_LIB=ModelicaBuildingsPython3.4.lib

SET DUMMY_SRC=dummy.c
SET DUMMY_DLL=python3.4.dll

:: Check if we are on a 32 or 64 bit machine
::IF "%DevEnvDir%"=="" (
Set RegQry=HKLM\Hardware\Description\System\CentralProcessor\0
REG.exe Query %RegQry% > checkOS.txt
Find /i "x86" < CheckOS.txt > StringCheck.txt
IF %ERRORLEVEL% == 0 (
  REM Set path to the directory on 32 bit machine
  SET PYTHONInc="C:\Python34\include"
  SET PYTHONLibs="C:\Python34\libs\python34.lib"
  CALL "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"  >nul 2>&1
    IF ERRORLEVEL 1 (
      ECHO Problem configuring the Visual Studio tools for command-line use
      GOTO done
    )
  ECHO Windows 32 bit compilation activated.
  SET BINDIR=..\..\..\Library\win32 
)ELSE (
    REM Set path to the directory on 64 bit machine
    SET PYTHONInc="C:\Python34\64\include"
    SET PYTHONLibs="C:\Python34\64\libs/python34.lib"
    CALL "C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\bin\amd64\vcvars64.bat"  >nul 2>&1
      IF ERRORLEVEL 1 (
        ECHO Problem configuring the Visual Studio tools for command-line use
        GOTO done
    )
    ECHO Windows 64 bit compilation activated.
    SET BINDIR=..\..\..\Library\win64
)

:: Compiling the dummy Python dlls.
CL /LD %DUMMY_SRC% /link /out:%DUMMY_DLL%
 
:: Compiling the Python interpreter libraries 
CL /LD /MT /I%PYTHONInc% %SRCS% %PYTHONLibs% /link /out:%MOD_DLL%

:: Creating the import library
:: lib /def:%MOD_DEF%

:: Compiling the test Program
CL /I%PYTHONInc% testProgram.c %SRCS%  %PYTHONLibs%

:: Running the testProgram
ECHO Run the testProgram.exe
 start /WAIT testProgram.exe

ECHO Rename library file
ren %LIBS% %MOD_LIB%

ECHO Copy files to the Library
move %MOD_DLL% %BINDIR%
move %MOD_LIB% %BINDIR%
move %DUMMY_DLL% %BINDIR%

ECHO Delete temporary files
:: Delete object files
del *.obj

:: Delete temporary files
del "*.exp"

:: Delete lib files
del testProgram.lib

:: Delete check files
del CheckOS.txt
del StringCheck.txt

:: Delete exe files
del testProgram.exe
