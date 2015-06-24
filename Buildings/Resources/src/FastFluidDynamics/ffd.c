///////////////////////////////////////////////////////////////////////////////
///
/// \file ffd.h
///
/// \brief Main routine of Fast Fluid Dynamics
///
/// \author Wangda Zuo
///         University of Miami
///         W.Zuo@miami.edu
///         Mingang Jin, Qingyan Chen
///         Purdue University
///         Jin55@purdue.edu, YanChen@purdue.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////

#include "ffd.h"

/* global variables */
REAL **var;
int  **BINDEX;
REAL *locmin,*locmax;
static PARA_DATA para;
static GEOM_DATA geom;
static PROB_DATA prob;
static TIME_DATA mytime;
static INPU_DATA inpu;
static OUTP_DATA outp1;
static BC_DATA bc;
static SOLV_DATA solv;
static SENSOR_DATA sens;
static INIT_DATA init;

clock_t start, end;

///////////////////////////////////////////////////////////////////////////////
/// Allcoate memory for variables
///
///\param para Pointer to FFD parameters
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
int allocate_memory (PARA_DATA *para) {

  int nb_var, i;
  int size = (geom.imax+2) * (geom.jmax+2) * (geom.kmax+2);

  /****************************************************************************
  | Allocate memory for variables
  ****************************************************************************/
  nb_var = C2BC+1;
  var       = (REAL **) malloc ( nb_var*sizeof(REAL*) );
  if(var==NULL) {
    ffd_log("allocate_memory(): Could not allocate memory for var.",
            FFD_ERROR);
    return 1;
  }

  for(i=0; i<nb_var; i++) {
    var[i] = (REAL *) calloc(size, sizeof(REAL));
    if(var[i]==NULL) {
      sprintf(msg,
              "allocate_memory(): Could not allocate memory for var[%d]", i);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
  }

  /****************************************************************************
  | Allocate memory for boundary cells
  | BINDEX[0]: i of global coordinate in IX(i,j,k)
  | BINDEX[1]: j of global coordinate in IX(i,j,k)
  | BINDEX[2]: k of global coordinate in IX(i,j,k)
  | BINDEX[3]: Fixed temperature or fixed heat flux
  | BINDEX[4]: Boundary ID to identify which boundary it belongs to
  ****************************************************************************/
  BINDEX = (int **)malloc(5*sizeof(int*));
  if(BINDEX==NULL) {
    ffd_log("allocate_memory(): Could not allocate memory for BINDEX.",
            FFD_ERROR);
    return 1;
  }

  for(i=0; i<5; i++) {
    BINDEX[i] = (int *) malloc(size*sizeof(int));
    if(BINDEX[i]==NULL) {
      sprintf(msg,
              "allocate_memory(): Could not allocate memory for BINDEX[%d]", i);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
  }
  return 0;
} // End of allocate_memory()

/*
///////////////////////////////////////////////////////////////////////////////
/// GLUT display callback routines
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
static void display_func(void) {
  ffd_display_func(&para, var);
} // End of display_func()

///////////////////////////////////////////////////////////////////////////////
/// GLUT keyboard callback routines
///
///\param key Character of the key
///\param x X-position
///\param y Y-Position
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////

static void key_func(unsigned char key, int x, int y) {
  ffd_key_func(&para, var, BINDEX, key);
} // End of key_func()

///////////////////////////////////////////////////////////////////////////////
/// GLUT idle callback routines
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
static void idle_func(void) {
  ffd_idle_func(&para, var, BINDEX);
} // End of idle_func()

///////////////////////////////////////////////////////////////////////////////
/// GLUT motion callback routines
///
///\param x X-position
///\param y Y-Position
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
static void motion_func(int x, int y) {
  ffd_motion_func(&para, x, y);
} // End of motion_func()

///////////////////////////////////////////////////////////////////////////////
/// GLUT mouse callback routines
///
///\param button Button of the mouse
///\param x X-position
///\param y Y-Position
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
static void mouse_func(int button, int state, int x, int y) {
  ffd_mouse_func(&para, button, state, x, y);
} // End of mouse_func()

///////////////////////////////////////////////////////////////////////////////
/// GLUT reshape callback routines
///
///\param width Width of the window
///\param height Height of the window
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
static void reshape_func(int width, int height) {
  ffd_reshape_func(&para, width, height);
} // End of reshape_func()
*/

///////////////////////////////////////////////////////////////////////////////
/// Open_glut_window --- open a glut compatible window and set callbacks
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
//static void open_glut_window() {
//  glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
//
//  /*---------------------------------------------------------------------------
//  | void glutInitWindowPosition(int x, int y);
//  | x: Window X location in pixels.
//  | y: Window Y location in pixels.
//  ---------------------------------------------------------------------------*/
//  glutInitWindowPosition(0, 0);
//
//  /*---------------------------------------------------------------------------
//  | Initialize the size of window
//  | void glutInitWindowSize(int width, int height);
//  | width: Width in pixels; height: Height in pixels
//  ---------------------------------------------------------------------------*/
//  glutInitWindowSize(para.outp->winx, para.outp->winy);
//
//
//  para.outp->win_id = glutCreateWindow("FFD");
//
//  /*---------------------------------------------------------------------------
//  |void glClearColor(GLclampf red, GLclampf green, GLclampf blue,
//  |                  GLclampf alpha)
//  |set the color when you clear the screen, alpha is not useful here
//  |white    :1.0, 1.0, 1.0, 0.0
//  |black    :0.0, 0.0, 0.0, 0.0
//  |most blue:0.0, 0.0, 1.0, 0.0
//  |most red :1.0, 0.0, 0.0, 0.0
//  ---------------------------------------------------------------------------*/
//  glClearColor(0.0, 0.0, 0.0, 1.0);
//
//  /*--------------------------------------------------------------------------
//  | clear buffers within the view port
//  ---------------------------------------------------------------------------*/
//  glClear(GL_COLOR_BUFFER_BIT);
//
//  /*---------------------------------------------------------------------------
//  | Performs a buffer swap on the layer in use for the current window
//  ---------------------------------------------------------------------------*/
//  glutSwapBuffers();
//
//  glClear(GL_COLOR_BUFFER_BIT);
//  glutSwapBuffers();
//
//  pre_2d_display(&para);
//
//  /*---------------------------------------------------------------------------
//  | void glutKeyboardFunc(void (*func)(unsigned char key, int x, int y));
//  | sets the keyboard callback for the current window.
//  | When a user types into the window, each key press generating an ASCII
//  | character will generate a keyboard callback.
//	---------------------------------------------------------------------------*/
//  glutKeyboardFunc(key_func);
//
//  /*---------------------------------------------------------------------------
//  | void glutMouseFunc(void (*func)(int button, int state, int x, int y));
//  | sets the mouse callback for the current window.
//  ---------------------------------------------------------------------------*/
//	glutMouseFunc(mouse_func);
//
//  /*---------------------------------------------------------------------------
//  | void glutMotionFunc(void (*func)(int x, int y));
//  | The motion callback for a window is called when the mouse moves within
//  | the window while one or more mouse buttons are pressed
//  ---------------------------------------------------------------------------*/
//  glutMotionFunc(motion_func);
//
//  /*---------------------------------------------------------------------------
//  | void glutReshapeFunc(void (*func)(int width, int height));
//  | The reshape callback is triggered when a window is reshaped
//  ---------------------------------------------------------------------------*/
//  glutReshapeFunc(reshape_func);
//
//  /*---------------------------------------------------------------------------
//  | void glutIdleFunc(void (*func)(void));
//  | sets the global idle callback to be func so a GLUT program can perform
//  | background processing tasks or continuous animation when window system
//  | events are not being received
//  ---------------------------------------------------------------------------*/
//  glutIdleFunc(idle_func);
//
//  /*---------------------------------------------------------------------------
//  | void glutDisplayFunc(void (*func)(void));
//  | sets the display callback for the current window
//  ---------------------------------------------------------------------------*/
//  glutDisplayFunc (display_func);
//} // End of open_glut_window()




///////////////////////////////////////////////////////////////////////////////
/// Assign the parameter for coupled simulation
///
///\para cosim Pointer to the coupled simulation parameters
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int ffd_cosimulation(CosimulationData *cosim) {
  para.cosim = (CosimulationData *) malloc(sizeof(CosimulationData));
  para.cosim = cosim;

  if(ffd(1)!=0) {
    cosim->para->ffdError = 1;
    return 1;
  }
  else
    return 0;
} // End of ffd_cosimulation()

///////////////////////////////////////////////////////////////////////////////
/// Main routine of FFD
///
///\para coupled simulation Integer to identify the simulation type
///
///\return 0 if no error occurred
///////////////////////////////////////////////////////////////////////////////
int ffd(int cosimulation) {
//#ifndef _MSC_VER //Linux
//  //Initialize glut library
//  char fakeParam[] = "fake";
//  char *fakeargv[] = { fakeParam, NULL };
//  int fakeargc = 1;
//  glutInit( &fakeargc, fakeargv );
//#endif

  // Initialize the parameters
  para.geom = &geom;
  para.inpu = &inpu;
  para.outp = &outp1;
  para.prob = &prob;
  para.mytime = &mytime;
  para.bc     = &bc;
  para.solv   = &solv;
  para.sens   = &sens;
  para.init   = &init;
  // Stand alone simulation: 0; Cosimulaiton: 1
  para.solv->cosimulation = cosimulation;

  if(initialize(&para)!=0) {
    ffd_log("ffd(): Could not initialize simulation parameters.", FFD_ERROR);
    return 1;
  }

  // Overwrite the mesh and simulation data using SCI generated file
  if(para.inpu->parameter_file_format == SCI) {
    if(read_sci_max(&para, var)!=0) {
      ffd_log("ffd(): Could not read SCI data.", FFD_ERROR);
      return 1;
    }
  }

  // Allocate memory for the variables
  if(allocate_memory(&para)!=0) {
    ffd_log("ffd(): Could not allocate memory for the simulation.", FFD_ERROR);
    return 1;
  }

  // Set the initial values for the simulation data
  if(set_initial_data(&para, var, BINDEX)) {
    ffd_log("ffd(): Could not set initial data.", FFD_ERROR);
    return 1;
  }

  // Read previous simulation data as initial values
  if(para.inpu->read_old_ffd_file==1) read_ffd_data(&para, var);

  ffd_log("ffd.c: Start FFD solver.", FFD_NORMAL);
  //write_tecplot_data(&para, var, "initial");

  // Solve the problem
  //if(para.outp->version==DEMO) {
  //  open_glut_window();
  //  glutMainLoop();
  //}
  //else
  if(FFD_solver(&para, var, BINDEX)!=0) {
    ffd_log("ffd(): FFD solver failed.", FFD_ERROR);
    return 1;
  }

  /*---------------------------------------------------------------------------
  | Post Process
  ---------------------------------------------------------------------------*/
  // Calculate mean value
  if(para.outp->cal_mean == 1)
    average_time(&para, var);

  if(write_unsteady(&para, var, "unsteady")!=0) {
    ffd_log("FFD_solver(): Could not write the file unsteady.plt.", FFD_ERROR);
    return 1;
  }

  if(write_tecplot_data(&para, var, "result")!=0) {
    ffd_log("FFD_solver(): Could not write the file result.plt.", FFD_ERROR);
    return 1;
  }

  if(para.outp->version == DEBUG)
    write_tecplot_all_data(&para, var, "result_all");

  // Write the data in SCI format
  write_SCI(&para, var, "output");

  // Free the memory
  free_data(var);
  free_index(BINDEX);

  // Inform Modelica the stopping command has been received
  if(para.solv->cosimulation==1) {
    para.cosim->para->flag = 2;
    ffd_log("ffd(): Sent stopping signal to Modelica", FFD_NORMAL);
  }

  return 0;
} // End of ffd( )

///////////////////////////////////////////////////////////////////////////////
/// Write error message to Modelica
///
///\para msg Pointer to message to be written.
///
///\return no return
///////////////////////////////////////////////////////////////////////////////
void modelicaError(char *msg) {
  strcpy(para.cosim->ffd->msg, msg);
  // Write the command to stop the cosimulation
  para.cosim->para->flag = 2;
  // Indicate there is an error
  para.cosim->para->ffdError = 1;
} // End of modelicaMsg
