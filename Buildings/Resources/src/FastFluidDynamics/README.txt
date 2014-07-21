Dependencies
============

FFD requires external library freeGLUT:

freeGLUT header file
    #include <GL/glut.h>

Linux
-----
Install freeGLUT on Linux
1. Search the latest version of freeGLUT
    apt-cache search freeGLUT
2. The latest version of freeGLUT development package is freeglut3-dev, install 32bit version
    sudo apt-get install freeglut3-dev:i386

Windows
-------
Install freeGLUT on Windows with Visual Studio

Download freeGLUT form following link and copy to VC directory

Link: http://www.xmission.com/~nate/glut/glut-3.7.6-bin.zip
Web: http://www.xmission.com/~nate/glut.html

Note: "Program Files (x86)" for 64-bit Windows; The '*' matches your version of VS

Runtime library:
C:\Program Files\Microsoft Visual Studio *\VC\bin\glut32.dll

Header file:
C:\Program Files\Microsoft Visual Studio *\VC\include\GL\glut.h

Linker library:
C:\Program Files\Microsoft Visual Studio *\VC\lib\glut32.lib



















