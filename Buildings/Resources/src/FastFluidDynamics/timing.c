/****************************************************************************
| 
|  \file   timing.c
| 
|  \brief  Subroutines for timing
| 
|  \author Mingang Jin, Qingyan Chen
|          Purdue University
|          Jin55@purdue.edu, YanChen@purdue.edu
|          Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
| 
|  \date   6/15/2017
| 
****************************************************************************/

#include "timing.h"

/****************************************************************************
|  Calculate the simulation time and time ratio
| 
| \param para Pointer to FFD parameters
| 
| \return No return needed
****************************************************************************/
void timing(PARA_DATA *para) {
  double cputime;
  para->mytime->t += para->mytime->dt;
  para->mytime->step_current += 1;
  para->mytime->t_end = clock();

  cputime= ((double) (clock() - para->mytime->t_start) / CLOCKS_PER_SEC);

  sprintf(msg, "Physical time=%.4f s, CPU time=%.4f s, Time Ratio=%.4f",
         para->mytime->t, cputime, para->mytime->t/cputime);
  ffd_log(msg, FFD_NORMAL);

} /* End of timing( ) */
