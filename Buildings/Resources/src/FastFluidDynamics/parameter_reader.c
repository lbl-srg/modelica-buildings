/****************************************************************************
|
|  \file   parameter_reader.c
|
|  \brief  Read the FFD parameter file
|
|  \author Wangda Zuo
|          University of Miami, University of Colorado Boulder
|          W.Zuo@miami.edu, wangda.zuo@colorado.edu
|          Wei Tian
|          University of Miami, Schneider Electric
|          w.tian@umiami.edu, Wei.Tian@Schneider-Electric.com
|          Xu Han
|          University of Colorado Boulder
|          xuha3556@colorado.edu
|
|  \date   4/5/2020
|
****************************************************************************/

#include "parameter_reader.h"

/****************************************************************************
|  Assign the FFD parameters
|
| \param para Pointer to FFD parameters
| \param string Pointer to data read from the parameter file
|
| \return 0 if no error occurred
****************************************************************************/
int assign_parameter(PARA_DATA *para, char *string) {
  char tmp[400];
  char tmp_par[400];
  /* tmp2 needs to be initialized to avoid crash */
  /* when the input for tmp2 is empty */
  char tmp2[100] = "";
  int senId = -1;

  /****************************************************************************
  | sscanf() reads data from string and stores them according to parameter format
  | into the locations given by the additional arguments.
  | When sscanf() scans an empty line, it gets nothing and returns EOF.
  | Thus, when sscanf returns EOF, no need to compare the tmp with parameter.
  ****************************************************************************/
  if (EOF==sscanf(string, "%s", tmp)){
    return 0;
  }

  if (!strcmp(tmp, "geom.Lx")) {
	  if (ifDouble) {
		  sscanf(string, "%s%lf", tmp, &para->geom->Lx);
	  }
	  else {
		  sscanf(string, "%s%f", tmp, &para->geom->Lx);
	  }
	  sprintf(msg, "assign_parameter(): %s=%f", tmp, para->geom->Lx);
	  ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.Ly")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->geom->Ly);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->geom->Ly);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->geom->Ly);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.Lz")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->geom->Lz);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->geom->Lz);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->geom->Lz);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.imax")) {
    sscanf(string, "%s%d", tmp, &para->geom->imax);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->geom->imax);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.jmax")) {
    sscanf(string, "%s%d", tmp, &para->geom->jmax);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->geom->jmax);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.kmax")) {
    sscanf(string, "%s%d", tmp, &para->geom->kmax);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->geom->kmax);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.index")) {
    sscanf(string, "%s%d", tmp, &para->geom->index);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->geom->index);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.dx")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->geom->dx);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->geom->dx);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->geom->dx);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.dy")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->geom->dy);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->geom->dy);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->geom->dy);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.dz")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->geom->dz);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->geom->dz);
    }

    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->geom->dz);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "geom.uniform")) {
    sscanf(string, "%s%d", tmp, &para->geom->uniform);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->geom->uniform);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.cal_mean")) {
    sscanf(string, "%s%d", tmp, &para->outp->cal_mean);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->cal_mean);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.v_ref")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->outp->v_ref);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->outp->v_ref);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->outp->v_ref);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.Temp_ref")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->outp->Temp_ref);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->outp->Temp_ref);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->outp->Temp_ref);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.v_length")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->outp->v_length);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->outp->v_length);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->outp->v_length);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.i_N")) {
    sscanf(string, "%s%d", tmp, &para->outp->i_N);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->i_N);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.j_N")) {
    sscanf(string, "%s%d", tmp, &para->outp->j_N);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->j_N);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.winx")) {
    sscanf(string, "%s%d", tmp, &para->outp->winx);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->winx);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.winy")) {
    sscanf(string, "%s%d", tmp, &para->outp->winy);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->winy);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.tstep_display")) {
    sscanf(string, "%s%d", tmp, &para->outp->tstep_display);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->tstep_display);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.version")) {
    sscanf(string, "%s%s", tmp, tmp2);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, tmp2);
    if(!strcmp(tmp2, "DEMO"))
      para->outp->version = DEMO;
    else if(!strcmp(tmp2, "DEBUG"))
      para->outp->version = DEBUG;
    else if(!strcmp(tmp2, "RUN"))
      para->outp->version = RUN;
    else {
      sprintf(msg, "assign_parameter(): %s is not valid input for %s", tmp2, tmp);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "inpu.parameter_file_format")) {
    sscanf(string, "%s%s", tmp, tmp2);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, tmp2);
    if(!strcmp(tmp2, "SCI"))
      para->inpu->parameter_file_format = SCI;
    else {
      sprintf(msg, "assign_parameter(): %s is not valid input for %s", tmp2, tmp);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "inpu.parameter_file_name")) {
  #ifndef FFD_ISAT
    sscanf(string, "%s%s", tmp, tmp_par);
				sprintf(para->inpu->parameter_file_name, "%s%s", para->cosim->para->filePath, tmp_par);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, para->inpu->parameter_file_name);
    ffd_log(msg, FFD_NORMAL);
  #else
			sscanf(string, "%s%s", tmp, para->inpu->parameter_file_name);
			sprintf(msg, "assign_parameter(): %s=%s", tmp, para->inpu->parameter_file_name);
			ffd_log(msg, FFD_NORMAL);
  #endif
  }
  else if (!strcmp(tmp, "outp.OutputDynamicFile")) {
    sscanf(string, "%s%d", tmp, &para->outp->OutputDynamicFile);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->outp->OutputDynamicFile);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "inpu.block_file_name")) {
  #ifndef FFD_ISAT
    sscanf(string, "%s%s", tmp, tmp_par);
    sprintf(para->inpu->block_file_name, "%s%s", para->cosim->para->filePath, tmp_par);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, para->inpu->block_file_name);
    ffd_log(msg, FFD_NORMAL);
  #else
	sscanf(string, "%s%s", tmp, para->inpu->block_file_name);
	sprintf(msg, "assign_parameter(): %s=%s", tmp, para->inpu->block_file_name);
	ffd_log(msg, FFD_NORMAL);
  #endif
  }
  else if(!strcmp(tmp, "inpu.read_old_ffd_file")) {
    sscanf(string, "%s%d", tmp, &para->inpu->read_old_ffd_file);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->inpu->read_old_ffd_file);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "inpu.old_ffd_file_name")) {
    sscanf(string, "%s%s", tmp, para->inpu->old_ffd_file_name);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, para->inpu->old_ffd_file_name);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.nu")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->nu);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->nu);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->nu);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.rho")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->rho);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->rho);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->rho);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.beta")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->beta);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->beta);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->beta);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.diff")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->diff);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->diff);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->diff);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.coeff_h")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->coeff_h);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->coeff_h);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->coeff_h);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.gravx")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->gravx);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->gravx);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->gravx);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.gravy")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->gravy);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->gravy);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->gravy);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.gravz")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->gravz);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->gravz);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->gravz);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.cond")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->cond);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->cond);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->cond);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.force")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->force);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->force);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->force);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.source")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->source);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->source);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->source);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.Cp")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->Cp);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->Cp);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->Cp);
    ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "prob.alpha")) {
      if (ifDouble) {
          sscanf(string, "%s%lf", tmp, &para->prob->alpha);
      }
      else {
          sscanf(string, "%s%f", tmp, &para->prob->alpha);
      }
      sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->alpha);
      ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.movie")) {
    sscanf(string, "%s%d", tmp, &para->prob->movie);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->prob->movie);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.tur_model")) {
    sscanf(string, "%s%s", tmp, tmp2);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, tmp2);
    if(!strcmp(tmp2, "LAM"))
      para->prob->tur_model = LAM;
    else if(!strcmp(tmp2, "CHEN"))
      para->prob->tur_model = CHEN;
    else if(!strcmp(tmp2, "CONSTANT"))
      para->prob->tur_model = CONSTANT;
    else {
      sprintf(msg, "assign_parameter(): %s is not valid input for %s", tmp2, tmp);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.chen_a")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->chen_a);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->chen_a);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->chen_a);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.Prt")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->Prt);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->Prt);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->Prt);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "outp.result_file")) {
    sscanf(string, "%s%s", tmp, tmp2);
    if(!strcmp(tmp2, "VTK"))
      para->outp->result_file = VTK;
    if(!strcmp(tmp2, "PLT"))
      para->outp->result_file = PLT;
	if (!strcmp(tmp2, "NO"))
		para->outp->result_file = NO;
  }
  else if(!strcmp(tmp, "prob.Temp_Buoyancy")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->Temp_Buoyancy);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->Temp_Buoyancy);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->Temp_Buoyancy);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "prob.coef_stanchion")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->prob->coef_stanchion);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->prob->coef_stanchion);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->prob->coef_stanchion);
    ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "bc.outlet_bc")) {
	sscanf(string, "%s%s", tmp, tmp2);
	if (!strcmp(tmp2, "ZERO_GRADIENT"))
		para->bc->outlet_bc = ZERO_GRADIENT;
	if (!strcmp(tmp2, "PRESCRIBED_VALUE"))
		para->bc->outlet_bc = PRESCRIBED_VALUE;
  }
  else if (!strcmp(tmp, "bc.hasTile")) {
	sscanf(string, "%s%d", tmp, &para->bc->hasTile);
	sprintf(msg, "assign_parameter(): %s=%d", tmp, para->bc->hasTile);
	ffd_log(msg, FFD_NORMAL);
  }	
  else if(!strcmp(tmp, "mytime.t_steady")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->mytime->t_steady);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->mytime->t_steady);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->mytime->t_steady);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "solv.solver")) {
    sscanf(string, "%s%s", tmp, tmp2);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, tmp2);
    if(!strcmp(tmp2, "GS"))
      para->solv->solver = GS;
    else if(!strcmp(tmp2, "TDMA"))
      para->solv->solver = TDMA;
    else {
      sprintf(msg, "assign_parameter(): %s is not valid input for %s", tmp2, tmp);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
    ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "solv.swipe_adv")) {
      sscanf(string, "%s%d", tmp, &para->solv->swipe_adv);
      sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->swipe_adv);
      ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "solv.swipe_dif")) {
      sscanf(string, "%s%d", tmp, &para->solv->swipe_dif);
      sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->swipe_dif);
      ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "solv.swipe_pro")) {
      sscanf(string, "%s%d", tmp, &para->solv->swipe_pro);
      sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->swipe_pro);
      ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "solv.check_residual")) {
    sscanf(string, "%s%d", tmp, &para->solv->check_residual);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->check_residual);
    ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "solv.check_conservation")) {
      sscanf(string, "%s%d", tmp, &para->solv->check_conservation);
      sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->check_conservation);
      ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "solv.advection_solver")) {
    sscanf(string, "%s%s", tmp, tmp2);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, tmp2);
    if(!strcmp(tmp2, "SEMI"))
      para->solv->advection_solver = SEMI;
    else if(!strcmp(tmp2, "LAX"))
      para->solv->advection_solver = LAX;
    else if(!strcmp(tmp2, "UPWIND"))
      para->solv->advection_solver = UPWIND;
    else if(!strcmp(tmp2, "CENTRAL"))
      para->solv->advection_solver = CENTRAL;
    else {
      sprintf(msg, "assign_parameter(): %s is not valid input for %s", tmp2, tmp);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "solv.interpolation")) {
    sscanf(string, "%s%s", tmp, tmp2);
    sprintf(msg, "assign_parameter(): %s=%s", tmp, tmp2);
    if(!strcmp(tmp2, "BILINEAR"))
      para->solv->interpolation = BILINEAR;
    else if(!strcmp(tmp2, "FSJ"))
      para->solv->interpolation = FSJ;
    else if(!strcmp(tmp2, "HYBRID"))
      para->solv->interpolation = HYBRID;
    else {
      sprintf(msg, "assign_parameter(): %s is not valid input for %s", tmp2, tmp);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "solv.cosimulation")) {
    sscanf(string, "%s%d", tmp, &para->solv->cosimulation);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->cosimulation);
    ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "solv.mass_conservation_on")) {
	sscanf(string, "%s%d", tmp, &para->solv->mass_conservation_on);
	sprintf(msg, "assign_parameter(): %s=%d", tmp, para->solv->mass_conservation_on);
	ffd_log(msg, FFD_NORMAL);
  }
  else if (!strcmp(tmp, "solv.tile_flow_correct")) {
	sscanf(string, "%s%s", tmp, tmp2);
	if (!strcmp(tmp2, "PRESSURE_BASE"))
		para->solv->tile_flow_correct = PRESSURE_BASE;
	if (!strcmp(tmp2, "NS_SOURCE"))
		para->solv->tile_flow_correct = NS_SOURCE;
	/* Turn off mass balance if using pressure_base */
	if (para->solv->tile_flow_correct == PRESSURE_BASE && para->bc->hasTile > 0)
	para->solv->mass_conservation_on = 0;
  }	
  /****************************************************************************
  | get the initial condition
  ****************************************************************************/
  else if(!strcmp(tmp, "init.T")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->init->T);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->init->T);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->init->T);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "init.u")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->init->u);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->init->u);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->init->u);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "init.v")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->init->v);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->init->v);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->init->v);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "init.w")) {
    if (ifDouble) {
      sscanf(string, "%s%lf", tmp, &para->init->w);
    }
    else {
      sscanf(string, "%s%f", tmp, &para->init->w);
    }
    sprintf(msg, "assign_parameter(): %s=%f", tmp, para->init->w);
    ffd_log(msg, FFD_NORMAL);
  }
  /****************************************************************************
  | get the boundary conditions
  ****************************************************************************/
  else if(!strcmp(tmp, "bc.nb_Xi")) {
    sscanf(string, "%s%d", tmp, &para->bc->nb_Xi);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->bc->nb_Xi);
    ffd_log(msg, FFD_NORMAL);
  }
  else if(!strcmp(tmp, "bc.nb_C")) {
    sscanf(string, "%s%d", tmp, &para->bc->nb_C);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->bc->nb_C);
    ffd_log(msg, FFD_NORMAL);
  }
  /****************************************************************************
  | get the number of sensor
  ****************************************************************************/
  else if(!strcmp(tmp, "sensor.nb_sensor")) {
    sscanf(string, "%s%d", tmp, &para->sens->nb_sensor);
    sprintf(msg, "assign_parameter(): %s=%d", tmp, para->sens->nb_sensor);
    ffd_log(msg, FFD_NORMAL);
  }
  /****************************************************************************
  | get the sensor names
  ****************************************************************************/
  else if(!strcmp(tmp, "sensor.name")) {
    /*------------------------------------------------------------------------
    | if it is the first name, allocate memory for para->sens->sensorName
    ------------------------------------------------------------------------*/
    if(para->sens->sensorName==NULL) {
		/* The number of sensor must be defined before we allocate memory for */
		/* para->sens->sensorName */
		if (para->sens->nb_sensor == 0) {
			sprintf(msg, "assign_parameter(): Must define the number of sensors "
				"before giving the sensor names");
			ffd_log(msg, FFD_ERROR);
			return 1;
		} /* End of if(para->sens->nb_sensor==0) */
		else {
			para->sens->sensorName = (char**)malloc(para->sens->nb_sensor * sizeof(char*));
			if (para->sens->sensorName == NULL) {
				ffd_log("assign_parameter(): Could not allocate memory for "
					"para->sens->sensorName", FFD_ERROR);
				return 1;
			}
		} /* End of else */

	} /* End of if(para->sens->nb_sensor==0) */

	/*------------------------------------------------------------------------
	| Copy the sensor name
	------------------------------------------------------------------------*/
	sscanf(string, "%s%s", tmp, tmp2);
	senId++;
	para->sens->sensorName[senId] = (char*)malloc(sizeof(tmp2) * sizeof(char));
	if (para->sens->sensorName[senId] == NULL) {
		sprintf(msg, "assign_parameter(): Could not allocate memory for %s",
			tmp2);
		ffd_log(msg, FFD_ERROR);
		return 1;
	}
	else {
		strcpy(para->sens->sensorName[senId], tmp2);
		sprintf(msg, "assign_parameter(): %s=%s", tmp, para->sens->sensorName[senId]);
		ffd_log(msg, FFD_NORMAL);
	}
  }

  return 0;
} /* End of assign_parameter() */

#ifdef FFD_ISAT
extern char filepath[];
#endif

/****************************************************************************
|  Read the FFD parameter file input.ffd
|
| \param para Pointer to FFD parameters
|
| \return 0 if no error occurred
****************************************************************************/
int read_parameter(PARA_DATA *para) {
  char string[400];

  /****************************************************************************
  | Open the FFD parameter file
  ****************************************************************************/
  /*---------------------------------------------------------------------------
  | Stand alone simulation
  ---------------------------------------------------------------------------*/
  if (para->solv->cosimulation == 0) {
  #ifndef FFD_ISAT /*if no ISAT*/
	  if ((file_para = fopen("input.ffd", "r")) == NULL) {
		  sprintf(msg, "read_parameter(): "
			  "Could not open the default FFD parameter file input.ffd");
		  ffd_log(msg, FFD_ERROR);
		  return 1;
	  }
	  else {
		  sprintf(msg, "read_parameter(): Opened input.ffd for FFD parameters");
		  ffd_log(msg, FFD_NORMAL);
	  }
  #else /*if called by ISAT*/
	  char filenametmp[400] = { 0 };
	  snprintf(filenametmp, sizeof(filenametmp), "%s%s", filepath, "input.ffd");
	  if ((file_para = fopen(filenametmp, "r")) == NULL) {
		sprintf(msg, "read_parameter(): "
			"Could not open the default FFD parameter file %s", filenametmp);
		ffd_log(msg, FFD_ERROR);
		return 1;
	  }
	  else {
		sprintf(msg, "read_parameter(): Opened %s for FFD parameters", filenametmp);
		ffd_log(msg, FFD_NORMAL);
	  }
  #endif
  }
  /*---------------------------------------------------------------------------
  | Co-simulation
  ---------------------------------------------------------------------------*/
  else {
	  if ((file_para = fopen(para->cosim->para->fileName, "r")) == NULL) {
		  sprintf(msg, "read_parameter(): Could not open the FFD parameter file %s",
			  para->cosim->para->fileName);
		  ffd_log(msg, FFD_ERROR);
		  return 1;
	  }
	  else {
		  char* lastSlash = strrchr(para->cosim->para->fileName, '/');
		  int nPath = strlen(para->cosim->para->fileName) - (strlen(lastSlash) - 1);

		  para->cosim->para->filePath = (char*)calloc(nPath + 1, sizeof(char));
		  if (para->cosim->para->filePath == NULL) {
			  ffd_log("read_parameter(): Could not allocate memory for the path to the FFD files", FFD_ERROR);
			  return 1;
		  }
		  else {
			  strncpy(para->cosim->para->filePath, para->cosim->para->fileName, nPath);
			  sprintf(msg, "read_parameter(): Opened file %s for FFD parameters with base directory %s",
				  para->cosim->para->fileName, para->cosim->para->filePath);
			  ffd_log(msg, FFD_NORMAL);
		  }
	  }
  }

  /*Use fgets(...) as loop condition, it reutrns null when it fail to read more characters.*/
  while(fgets(string, 400, file_para) != NULL) {
    if(assign_parameter(para, string)) {
	  sprintf(msg, "read_parameter(): Could not read data from file %s",
			para->cosim->para->fileName);
      ffd_log(msg, FFD_ERROR);
      return 1;
    }
  }/* End of while */

  /*Check if it is end of file*/
  /*Use feof() to detect what went wrong after one of the main I/O functions failed*/
  /*Do not use feof() as condition of while loop. It will read one more time after last line.*/
  if (!feof(file_para)){
	  sprintf(msg, "read_parameter(): Could not read data from file %s",
		  para->cosim->para->fileName);
      ffd_log(msg, FFD_ERROR);
  }

  fclose(file_para);
  return 0;
} /* End of read_parameter() */
