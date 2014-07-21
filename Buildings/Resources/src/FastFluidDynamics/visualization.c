///////////////////////////////////////////////////////////////////////////////
///
/// \file   visualization.c
///
/// \brief  Visualization features
///
/// \author Wangda Zuo, Ana Cohen
///         University of Miami
///         W.Zuo@miami.edu
///
/// \date   8/3/2013
///
///////////////////////////////////////////////////////////////////////////////

#include "visualization.h"

///////////////////////////////////////////////////////////////////////////////
/// OpenGL specific drawing routines for a 2D plane
///
///\param para Pointer to FFD parameters
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void pre_2d_display(PARA_DATA *para) {
  int win_x=para->outp->winx, win_y=para->outp->winy;
  int Lx=para->geom->Lx, Ly = para->geom->Ly;

  glViewport(0, 0, win_x, win_y);
  glMatrixMode(GL_PROJECTION );
  glLoadIdentity();
  
  /*---------------------------------------------------------------------------
  |  Define the view domain
  |  gluOrtho2D  ( left , right , bottom , top ) ¡ú  None  
  ---------------------------------------------------------------------------*/
  gluOrtho2D(0.0, Lx, 0.0, Ly);

  glClearColor(0.0, 0.0, 0.0, 1.0);

  glClear(GL_COLOR_BUFFER_BIT);
} // End of pre_2d_display()

///////////////////////////////////////////////////////////////////////////////
/// Function after the display
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void post_display(void) {
  glutSwapBuffers();
} // End of post_display()

///////////////////////////////////////////////////////////////////////////////
/// FFD routines for GLUT display callback routines
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void ffd_display_func(PARA_DATA *para, REAL **var) {
  pre_2d_display(para);

  switch(para->outp->screen) {
    case 1:
      draw_velocity(para, var); 
      break;
    case 2:
      draw_density(para, var); 
      break;
    case 3: 
      draw_temperature(para, var); 
      break;
    default: 
      break;
  }

  post_display();
} // End of ffd_display_func()

///////////////////////////////////////////////////////////////////////////////
/// FFD routine for GLUT idle callback
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///\param BINDEX Pointer to boundary index
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void ffd_idle_func(PARA_DATA *para, REAL **var, int **BINDEX) {
  // Get the display in XY plane
  get_UI(para, var);

  vel_step(para, var, BINDEX);
  den_step(para, var, BINDEX);
  temp_step(para, var, BINDEX);

  if(para->outp->cal_mean == 1)
    average_time(para, var);

  // Update the visualization results after a few iteration steps 
  // to save the time for visualization
  if(para->mytime->step_current%para->outp->tstep_display==0) {
    glutSetWindow(para->outp->win_id);
    glutPostRedisplay( );
  } 
  
  timing(para);
} // End of ffd_idle_func()

///////////////////////////////////////////////////////////////////////////////
/// FFD routines for GLUT keyboard callback routines 
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///\param BINDEX Pointer to boundary index
///\param key Character of the key
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void ffd_key_func(PARA_DATA *para, REAL **var, int **BINDEX, 
                  unsigned char key) {

  /****************************************************************************
  | Set control variable according to key input
  ****************************************************************************/
  switch(key) {
    // Restart the simulation
    case '0':
      if(set_initial_data(para, var, BINDEX)) exit(1);
      break;
    // Quit
    case 'q':
    case 'Q':
      free_data(var);
      exit(0);
      break;
    // Draw velocity
    case '1':
      para->outp->screen = 1; 
      break;
    // Draw temperature
    case '2':
      para->outp->screen = 2; 
      break;
    // Draw contaminant concentration
    case '3':
      para->outp->screen = 3; 
      break;
    // Select YZ-plane
    case 'x':
    case 'X':
      para->geom->plane = YZ;
      para->geom->pindex = (int) para->geom->imax/2;
      break;
    // Select ZX-plane
    case 'y':
    case 'Y':
      para->geom->plane = ZX;
      para->geom->pindex = (int) para->geom->jmax/2;
      break;
    // Select XY-plane
    case 'z':
    case 'Z': 
      para->geom->plane = XY;
      para->geom->pindex = (int) para->geom->kmax/2;
      break;
    // Start to calculate mean value
    case 'm':
    case 'M':
      para->outp->cal_mean = 1;
      para->mytime->step_current = 0;
      printf("start to calculate mean properties.\n");
      break;
    // Save the results
    case 's':
    case 'S':
      if(para->outp->cal_mean == 1)
        average_time(para, var);
      write_tecplot_data(para, var, "result"); 
      break;
    // Reduce the drawn length of velocity
    case 'k':
    case 'K':
      para->outp->v_length = para->outp->v_length*0.5;
      break;
    // Increase the drawn length of velocity
    case 'l':
    case 'L':
      para->outp->v_length = para->outp->v_length*2;
      break;
    // Move the plane along the axis
    case '+':
      para->geom->pindex ++;
      check_pindex(para);
      break;
    case '-':
      para->geom->pindex --;
      check_pindex(para);
      break;
    default:
      // Ignore the wrong key input
      break;
  }
} // End of ffd_key_func()

///////////////////////////////////////////////////////////////////////////////
/// Ensure the pindex is within the valid range 
///
///\param para Pointer to FFD parameters
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void check_pindex(PARA_DATA *para) {
  int imax = para->geom->imax, jmax = para->geom->jmax,
      kmax = para->geom->kmax, *pindex = &para->geom->pindex;

  /****************************************************************************
  | Check the minimum value of index
  ****************************************************************************/
  if(*pindex<1) *pindex = 1;
  /****************************************************************************
  | Check the maximum value of index
  ****************************************************************************/
  else {
    switch(para->geom->plane) {
      case XY:
        if(*pindex > kmax) *pindex = kmax;
        break;
      case YZ:
        if(*pindex > imax) *pindex = imax;
        break;
      case ZX:
        if(*pindex > jmax) *pindex = jmax;
        break;
    }
  }
} // End of check_pindex()

///////////////////////////////////////////////////////////////////////////////
/// FFD routines for GLUT mouse callback routines 
///
///\param para Pointer to FFD parameters
///\param button Button of the mouse
///\param state State of the button
///\param x X-coordinate
///\param y Y-coordinate
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void ffd_mouse_func(PARA_DATA *para, int button, int state, int x, int y) {
  para->outp->omx = para->outp->mx = x;
  para->outp->omy = para->outp->my = y; 
  para->outp->mouse_down[button] = state == GLUT_DOWN;
} // End of ffd_mouse_func()

///////////////////////////////////////////////////////////////////////////////
/// FFD routines for setting the position
///
///\param para Pointer to FFD parameters
///\param x X-coordinate
///\param y Y-coordinate
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void ffd_motion_func(PARA_DATA *para, int x, int y) {
  para->outp->mx = x;
  para->outp->my = y;
} // End of ffd_motion_func()

///////////////////////////////////////////////////////////////////////////////
/// FFD routines for reshaping the window
///
///\param para Pointer to FFD parameters
///\param width Width of the window
///\param height Height of the window
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void ffd_reshape_func(PARA_DATA *para, int width, int height) {
  glutSetWindow(para->outp->win_id);
  glutReshapeWindow(width, height);

  para->outp->winx = width;
  para->outp->winy = height;
} // End of ffd_reshape_func()

///////////////////////////////////////////////////////////////////////////////
/// Relate mouse movements to forces & sources in 2D plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void get_UI(PARA_DATA *para, REAL **var) {
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int UIimax, UIjmax;
  REAL Lx, Ly;
  int i, j, k, i0, j0;
  int pindex = para->geom->pindex;
  REAL *d_s = var[Xi1S], *T_s = var[TEMPS];
  REAL *x, *y, *u_s, *v_s;
  REAL x0, y0, x_click, y_click;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int winx, winy;
  int mx = para->outp->mx, my = para->outp->my;
  int *mouse_down = para->outp->mouse_down;
  
  // If no mouse action, return
  if(!mouse_down[0] && !mouse_down[2] ) return;

  /****************************************************************************
  | Set the parameter according to the plane
  ****************************************************************************/
  switch(para->geom->plane) {
    case XY:
      x = var[X], y = var[Y];
      u_s = var[VXS], v_s = var[VYS];
      UIimax = imax, UIjmax = jmax;
      winx = para->outp->winx, winy = para->outp->winy;
      x0 = x[IX(0,0,pindex)];
      y0 = y[IX(0,0,pindex)];
      Lx = para->geom->Lx;
      Ly = para->geom->Ly;
      break;
    case YZ:
      x = var[Y], y =var[Z];
      u_s = var[VYS], v_s = var[VZS];
      UIimax = jmax, UIjmax = kmax;
      winx = para->outp->winy, winy = para->outp->winz;
      x0 = x[IX(pindex,0,0)], y0 = y[IX(pindex,0,0)];
      Lx = para->geom->Ly;
      Ly = para->geom->Lz;
      break;
    case ZX:
      x = var[X], y = var[Z];
      u_s = var[VXS], v_s = var[VZS];
      UIimax = imax, UIjmax = kmax;
      winx = para->outp->winx, winy = para->outp->winz;
      x0 = x[IX(0,pindex,0)], y0 = y[IX(0,pindex,0)];
      Lx = para->geom->Lx, Ly = para->geom->Lz;
      break;
    default:
      break;
  }

  // Set initial value of source to 0
  FOR_EACH_CELL
    u_s[IX(i,j,k)] = v_s[IX(i,j,k)] = d_s[IX(i,j,k)] = T_s[IX(i,j,k)] = 0.0;
  END_FOR

  x_click = (mx/(REAL)winx) * Lx;
  y_click = (1.0f - my/(REAL)winy) * Ly;

  i0 = (int)( (mx/(REAL)winx) * imax + 1);
  j0 = (int)((1.0f - my/(REAL)winy) * jmax + 1);

  /****************************************************************************
  | Identify the index of cell to add the source
  ****************************************************************************/
  switch(para->geom->plane) {
    /*-------------------------------------------------------------------------
    | XY Plane: x->X, y->Y
    -------------------------------------------------------------------------*/
    case XY:
      i = i0, j = j0, k = pindex;
      if(x[IX(i,j,k)] - x0 > x_click )
        while(x[IX(i,j,k)] - x0 > x_click) i--;        
      else
        while(x[IX(i,j,k)] - x0 < x_click) i++;
      if(y[IX(i,j,k)]-y0 > y_click)
        while(y[IX(i,j,k)]-y0 > y_click) j--;        
      else
        while(y[IX(i,j,k)]-y0 < y_click) j++;
      break;
    /*-------------------------------------------------------------------------
    | YZ Plane: x->Y; y->Z
    -------------------------------------------------------------------------*/
    case YZ:
      i = pindex; j = i0, k = j0;
      if(x[IX(i,j,k)] - x0 > x_click )
        while(x[IX(i,j,k)] - x0 > x_click) j--;
      else
        while(x[IX(i,j,k)] - x0 < x_click) j++;
      if(y[IX(pindex,i,j)]-y0 > y_click)
        while(y[IX(i,j,k)]-y0 > y_click) k--;
      else
        while(y[IX(i,j,k)]-y0 < y_click) k++;
      break;
    /*-------------------------------------------------------------------------
    | ZX Plane: x->X; y->Z
    -------------------------------------------------------------------------*/
    case ZX:
      i = i0; j = pindex, k = j0;
      if(x[IX(i,j,k)]-x0 > x_click)
        while(x[IX(i,j,k)]-x0 > x_click) i--;
      else
        while(x[IX(i,j,k)]-x0 < x_click) i++;
      if(y[IX(i,pindex,j)]-y0 > y_click)
        while(y[IX(i,j,k)]-y0 > y_click) k--;
      else
        while(y[IX(i,j,k)]-y0 < y_click) k++;
      break;
    default:
      break;
  }
  if(i<1 || i>UIimax || j<1 || j>UIjmax) return;

  /****************************************************************************
  | Add force
  ****************************************************************************/
  if(mouse_down[0]) {
    u_s[IX(i,j,k)] = para->prob->force;
    v_s[IX(i,j,k)] = para->prob->force;
  }
  /****************************************************************************
  | Add heat
  ****************************************************************************/
  if(mouse_down[1]) {
    T_s[IX(i,j,k)] = para->prob->heat;
  }
  /****************************************************************************
  | Add source in contaminant
  ****************************************************************************/
  if(mouse_down[2]) 
    d_s[IX(i,j,k)] = para->prob->source;

  para->outp->omx = mx;
  para->outp->omy = my;

  return;
}

///////////////////////////////////////////////////////////////////////////////
/// Select density distribution according to the plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_density(PARA_DATA *para, REAL **var) {
  switch (para->geom->plane) {
    case XY:
      draw_xy_density(para, var);
      break;
    case YZ: 
      draw_yz_density(para, var);
      break;
    case ZX: 
      draw_zx_density(para, var);
      break;
    default:
      ffd_log("draw_density(): Wrong plane index", FFD_ERROR);
      break;
  }
}

///////////////////////////////////////////////////////////////////////////////
/// Draw density distribution in XY plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///\param k K-index of the plane
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_xy_density(PARA_DATA *para, REAL **var) {
  int i, j;
  REAL d00, d01, d10, d11;
  REAL *x = var[X], *y = var[Y], *dens = var[Xi1];
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  glBegin(GL_QUADS);

  for(i=0; i<=imax; i++) 
    for(j=0; j<=jmax; j++) {
      d00 = dens[IX(i  ,j  ,pindex)];
      d01 = dens[IX(i  ,j+1,pindex)];
      d10 = dens[IX(i+1,j  ,pindex)];
      d11 = dens[IX(i+1,j+1,pindex)];

      glColor3f(d00,d00,d00); 
      glVertex2f(x[IX(i  ,j,pindex)], y[IX(i,j  ,pindex)]);
      glColor3f(d10,d10,d10); 
      glVertex2f(x[IX(i+1,j,pindex)], y[IX(i,j  ,pindex)]);
      glColor3f(d11,d11,d11); 
      glVertex2f(x[IX(i+1,j,pindex)], y[IX(i,j+1,pindex)]);
      glColor3f(d01,d01,d01);
      glVertex2f(x[IX(i  ,j,pindex)], y[IX(i,j+1,pindex)]);
  }

  glEnd();
} // End of draw_xy_density()

///////////////////////////////////////////////////////////////////////////////
/// Draw density distribution in YZ plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_yz_density(PARA_DATA *para, REAL **var) {
  int j, k;
  REAL d00, d01, d10, d11;
  REAL *y = var[Y], *z = var[Z], *dens = var[Xi1];
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  glBegin(GL_QUADS);

  for(j=0; j<=jmax; j++) 
    for(k=0; k<=kmax; k++) {
      d00 = dens[IX(pindex,j  ,k  )];
      d01 = dens[IX(pindex,j  ,k+1)];
      d10 = dens[IX(pindex,j+1,k  )];
      d11 = dens[IX(pindex,j+1,k+1)];

      glColor3f(d00,d00,d00); 
      glVertex2f(y[IX(pindex,j  ,k)], z[IX(pindex,j,k  )]);
      glColor3f(d10,d10,d10); 
      glVertex2f(y[IX(pindex,j+1,k)], z[IX(pindex,j,k  )]);
      glColor3f(d11,d11,d11); 
      glVertex2f(y[IX(pindex,j+1,k)], z[IX(pindex,j,k+1)]);
      glColor3f(d01,d01,d01); 
      glVertex2f(y[IX(pindex,j  ,k)], z[IX(pindex,j,k+1)]);
  }
  glEnd();
} // End of draw_yz_density()

///////////////////////////////////////////////////////////////////////////////
/// Draw density distribution in ZX plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_zx_density(PARA_DATA *para, REAL **var) {
  int i, k;
  REAL d00, d01, d10, d11;
  REAL *x = var[X], *z = var[Z], *dens = var[Xi1];
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  glBegin(GL_QUADS);

  for(i=0; i<=imax; i++) 
    for(k=0; k<=kmax; k++) {
      d00 = dens[IX(i  ,pindex,k  )];
      d01 = dens[IX(i  ,pindex,k+1)];
      d10 = dens[IX(i+1,pindex,k  )];
      d11 = dens[IX(i+1,pindex,k+1)];

      glColor3f(d00,d00,d00);
      glVertex2f(x[IX(i  ,pindex,k)], z[IX(i,pindex,k  )]);
      glColor3f(d10,d10,d10);
      glVertex2f(x[IX(i+1,pindex,k)], z[IX(i,pindex,k  )]);
      glColor3f(d11,d11,d11);
      glVertex2f(x[IX(i+1,pindex,k)], z[IX(i,pindex,k+1)]);
      glColor3f(d01,d01,d01);
      glVertex2f(x[IX(i  ,pindex,k)], z[IX(i,pindex,k+1)]);
    }
  glEnd();
} // End of draw_zx_density()

///////////////////////////////////////////////////////////////////////////////
/// Define the contour color according to the input value
///
///\param color Contour value
///
///\return no return needed
///////////////////////////////////////////////////////////////////////////////
void draw_contour(int color) {
  // void glColor3b(GLbyte red, GLbyte green, GLbyte blue)
  switch(color) {
    case 10: 
      glColor3f(1.000000f, 0.250000f, 0.250000f); break;
    case 9:
      glColor3f(0.951368f, 0.460596f, 0.088036f); break;
    case 8:
      glColor3f(0.811394f, 0.683088f, 0.005518f); break;
    case 7:
      glColor3f(0.608390f, 0.868521f, 0.023089f); break;
    case 6:
      glColor3f(0.383447f, 0.979360f, 0.137193f); break;
    case 5:
      glColor3f(0.182096f, 0.993172f, 0.324733f); break;
    case 4:
      glColor3f(0.045092f, 0.907159f, 0.547749f); break;
    case 3:
      glColor3f(0.000167f, 0.738733f, 0.761100f); break;
    case 2:
      glColor3f(0.060675f, 0.512914f, 0.926411f); break;
    case 1:
      glColor3f(0.198814f, 0.304956f, 0.996230f); break;
    default:
      glColor3f(0.404253f, 0.122874f, 0.972873f); break;
  } 
} // End of draw_contour()

///////////////////////////////////////////////////////////////////////////////
/// Select temperature according to the plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_temperature(PARA_DATA *para, REAL **var) {

  para->outp->Tmax = scalar_global_max(para, var[TEMP]);
  para->outp->Tmin = scalar_global_min(para, var[TEMP]);
  switch (para->geom->plane) {
    case XY:
      draw_xy_temperature(para, var);
      break;
    case YZ: 
      draw_yz_temperature(para, var);
      break;
    case ZX: 
      draw_zx_temperature(para, var);
      break;
    default:
      ffd_log("draw_temperature(): Wrong plane index", FFD_ERROR);
      break;
  }
} // End of draw_temperature


///////////////////////////////////////////////////////////////////////////////
/// Draw temperature contour in XY plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_xy_temperature(PARA_DATA *para, REAL **var) {
  int i, j;
  REAL *x = var[X], *y = var[Y], *temp = var[TEMP];
  int mycolor;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  glBegin(GL_QUADS);

  for(i=0; i<=imax; i++) {
    for(j=0; j<=jmax; j++) {
      // Automatically define the temperature contour
      // Add 0.001 to avoid divided by 0 if Tmax = Tmin
      mycolor = (int) 10 * ((temp[IX(i,j,pindex)]-para->outp->Tmin)
              /(para->outp->Tmax - para->outp->Tmin+0.001));
      mycolor = mycolor>10 ? 10: mycolor;

      draw_contour(mycolor);

      glVertex2f(x[IX(i  ,j,pindex)], y[IX(i,j  ,pindex)]);
      glVertex2f(x[IX(i+1,j,pindex)], y[IX(i,j  ,pindex)]);
      glVertex2f(x[IX(i+1,j,pindex)], y[IX(i,j+1,pindex)]);
      glVertex2f(x[IX(i  ,j,pindex)], y[IX(i,j+1,pindex)]);
    }
  }

  glEnd();
} // End of draw_xy_temperature()

///////////////////////////////////////////////////////////////////////////////
/// Draw temperature contour in YZ plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_yz_temperature(PARA_DATA *para, REAL **var) {
  int j, k;
  REAL *y = var[Y], *z = var[Z], *temp = var[TEMP];
  int mycolor;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  glBegin(GL_QUADS);

  for(j=0; j<=jmax; j++) {
    for(k=0; k<=kmax; k++) {
      // Automatically define the temperature contour
      // Add 0.001 to avoid divided by 0 if Tmax = Tmin
      mycolor = (int) 10 * ((temp[IX(pindex,j,k)]-para->outp->Tmin)
              / (para->outp->Tmax-para->outp->Tmin+0.001));
      mycolor = mycolor>10 ? 10: mycolor;

      draw_contour(mycolor);

      glVertex2f(y[IX(pindex,j  ,k)], z[IX(pindex,j,k  )]);
      glVertex2f(y[IX(pindex,j+1,k)], z[IX(pindex,j,k  )]);
      glVertex2f(y[IX(pindex,j+1,k)], z[IX(pindex,j,k+1)]);
      glVertex2f(y[IX(pindex,j  ,k)], z[IX(pindex,j,k+1)]);
    }
  }

  glEnd();
} // End of draw_yz_temperature()

///////////////////////////////////////////////////////////////////////////////
/// Draw temperature contour in ZX plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_zx_temperature(PARA_DATA *para, REAL **var) {
  int i, k;
  REAL *x = var[X], *z = var[Z], *temp = var[TEMP];
  int mycolor;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  glBegin(GL_QUADS);

  for(i=0; i<=imax; i++) {
    for(k=0; k<=kmax; k++) {
      // Automatically define the temperature contour
      // Add 0.001 to avoid divided by 0 if Tmax = Tmin
      mycolor = (int) 10 * ((temp[IX(i,pindex,k)]-para->outp->Tmin)
                /(para->outp->Tmax-para->outp->Tmin+0.001));
      mycolor = mycolor>10 ? 10: mycolor;

      draw_contour(mycolor);

      glVertex2f(x[IX(i  ,pindex,k)], z[IX(i,pindex,k  )]);
      glVertex2f(x[IX(i+1,pindex,k)], z[IX(i,pindex,k  )]);
      glVertex2f(x[IX(i+1,pindex,k)], z[IX(i,pindex,k+1)]);
      glVertex2f(x[IX(i  ,pindex,k)], z[IX(i,pindex,k+1)]);
    }
  }

  glEnd();
} // End of draw_zx_temperature()

///////////////////////////////////////////////////////////////////////////////
/// Select velocity according to the plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_velocity(PARA_DATA *para, REAL **var) {
  para->outp->v_max = V_global_max(para, var);

  switch (para->geom->plane) {
    case XY:
      draw_xy_velocity(para, var);
      break;
    case YZ: 
      draw_yz_velocity(para, var);
      break;
    case ZX: 
      draw_zx_velocity(para, var);
      break;
    default:
      printf("Could not find plane.\n");
      getchar();
      ffd_log("draw_velocity(): Wrong plane index", FFD_ERROR);
      break;
  }
} // End of draw_velocity()

///////////////////////////////////////////////////////////////////////////////
/// Draw velocity in XY plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_xy_velocity(PARA_DATA *para, REAL **var) {
  int i, j;
  REAL x0, y0;
  REAL *x = var[X], *y = var[Y];
  REAL *u = var[VX], *v = var[VY];
  int mycolor;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  /*---------------------------------------------------------------------------
  | specify the width of rasterized lines 
  ---------------------------------------------------------------------------*/
  glLineWidth(1.0);
  glBegin(GL_LINES);

  j = 1;
  for(i=1; i<=imax; i+=para->outp->i_N) {
    x0 = x[IX(i,j,pindex)];

    for(j=1; j<=jmax; j+=para->outp->j_N) {
      y0 = y[IX(i,j,pindex)];
      mycolor = (int) 10 * fabs(u[IX(i,j,pindex)]) / 
                fabs(para->outp->v_max);
      mycolor = mycolor>10 ? 10: mycolor;

      draw_contour(mycolor);

      glVertex2f(x0, y0);
      glVertex2f(x0 + para->outp->v_length*u[IX(i,j,pindex)], 
                 y0 + para->outp->v_length*v[IX(i,j,pindex)]);
    }
  }
  glEnd ();
} // End of draw_xy_velocity()

///////////////////////////////////////////////////////////////////////////////
/// Draw velocity in YZ plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_yz_velocity(PARA_DATA *para, REAL **var) {
  int j, k;
  REAL y0, z0;
  REAL *y = var[Y], *z = var[Z]; 
  REAL *v = var[VY], *w = var[VZ];
  int mycolor;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  /*---------------------------------------------------------------------------
  | specify the width of rasterized lines 
  ---------------------------------------------------------------------------*/
  glLineWidth(1.0);
  glBegin(GL_LINES);

  k = 1;
  for(j=1; j<=jmax; j+=para->outp->j_N) {
    y0 = y[IX(pindex,j,k)];

    for(k=1; k<=kmax; k+=para->outp->k_N) {
      z0 = z[IX(pindex,j,k)];
      mycolor = (int) 10 * fabs(v[IX(pindex,j,k)]) / 
                fabs(para->outp->v_max);
      mycolor = mycolor>10 ? 10: mycolor;

      draw_contour(mycolor);

      glVertex2f(y0, z0);
      glVertex2f(y0 + para->outp->v_length*v[IX(pindex,j,k)], 
                 z0 + para->outp->v_length*w[IX(pindex,j,k)]);
    }
  }
  glEnd ();
} // End of draw_yz_velocity()

///////////////////////////////////////////////////////////////////////////////
/// Draw velocity in ZX plane
///
///\param para Pointer to FFD parameters
///\param var Pointer to all variables
///
///\return No return needed
///////////////////////////////////////////////////////////////////////////////
void draw_zx_velocity(PARA_DATA *para, REAL **var) {
  int i, k;
  REAL x0, z0;
  REAL *x = var[X], *z = var[Z]; 
  REAL *u = var[VX], *w = var[VZ];
  int mycolor;
  int imax = para->geom->imax, jmax = para->geom->jmax;
  int kmax = para->geom->kmax;
  int IMAX = imax+2, IJMAX = (imax+2)*(jmax+2);
  int pindex = para->geom->pindex;

  /*---------------------------------------------------------------------------
  | specify the width of rasterized lines 
  ---------------------------------------------------------------------------*/
  glLineWidth(1.0);
  glBegin(GL_LINES);

  k = 1;
  for(i=1; i<=imax; i+=para->outp->i_N) {
    x0 = x[IX(i,pindex,k)];

    for(k=1; k<=kmax; k+=para->outp->k_N) {
      z0 = z[IX(i,pindex,k)];
      mycolor = (int) 10 * fabs(u[IX(i,pindex,k)]) / 
                fabs(para->outp->v_max);
      mycolor = mycolor>10 ? 10: mycolor;

      draw_contour(mycolor);

      glVertex2f(x0, z0);
      glVertex2f(x0 + para->outp->v_length*u[IX(i,pindex,k)], 
                 z0 + para->outp->v_length*w[IX(i,pindex,k)]);
    }
  }
  glEnd ();
} // End of draw_zx_velocity()