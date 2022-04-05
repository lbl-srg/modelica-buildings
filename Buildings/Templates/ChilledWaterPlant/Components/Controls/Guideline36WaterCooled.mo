within Buildings.Templates.ChilledWaterPlant.Components.Controls;
block Guideline36WaterCooled
  "Guideline 36 controller for CHW plant with water-cooled chillers"
  extends Interfaces.PartialController(
    final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Controller.Guideline36);

  parameter Boolean closeCoupledPlant=false
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(tab="General"));

  // ---- General: Chiller configuration ----
  parameter Boolean have_ponyChiller=false
    "True: have pony chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean need_reduceChillerDemand=false
    "True: need limit chiller demand when chiller staging"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Integer chiTyp[nChi]={
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal}
    "Chiller type. Recommended staging order: positive displacement, variable speed centrifugal, constant speed centrifugal"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Real capChi_min[nChi](each final unit="W", each final min=0)=
    0.3 .* capChi_nominal
    "Chiller minimum cycling load"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  parameter Boolean have_ctrHeaPre = false
    "Set to true if head pressure control available from chiller controller"
    annotation(Dialog(tab="General", group="Chillers configuration",
      enable=not isAirCoo));

  final parameter Boolean anyVsdCen = Modelica.Math.BooleanVectors.anyTrue({
    chiTyp[i]==Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal
    for i in 1:nChi})
    "Set to true if the plant has at least one variable speed centrifugal chiller"
    annotation (Dialog(tab="General", group="Chillers configuration"));

  // ---- General: Chiller staging settings ----

  parameter Integer nSta = 2
    "Number of chiller stages, neither zero stage nor the stages with enabled waterside economizer is included"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Integer staMat[nSta, nChi] = {{1,0},{1,1}}
    "Staging matrix with chiller stage as row index and chiller as column index"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desChiNum[nSta+1]={0,1,2}
    "Design number of chiller that should be ON at each chiller stage, including the zero stage"
    annotation (Dialog(tab="General", group="Staging configuration", enable=have_fixSpeConWatPum));

  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="General", group="Staging configuration"));

  parameter Real desConWatPumSpe[totSta](
    final min=fill(0, totSta),
    final max=fill(1, totSta)) = {0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  parameter Real towCelOnSet[totSta]={0,2,2,4,4,4}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation(Dialog(tab="General", group="Staging configuration",
      enable=not isAirCoo));

  // ---- General: Cooling tower ----

  final parameter Modelica.Units.SI.Temperature dTAppTow_nominal(displayUnit="K", final min=0)=
    cooTowGro.dTApp_nominal
    "Design cooling tower approach"
    annotation(Evaluate=true, Dialog(tab="General", group="Cooling tower"));

  // ---- Plant enable ----

  parameter Real schTab[4,2] = [0,1; 6*3600,1; 19*3600,1; 24*3600,1]
    "Plant enabling schedule allowing operators to lock out the plant during off-hour"
    annotation(Dialog(tab="Plant enable"));

  // ---- Waterside economizer ----

  /*
  FIXME: Those parameters should be declared in the interface class
  Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialReturnSection
  and accessed with inner/outer reference.
  */
  parameter Modelica.Units.SI.Temperature dTAppWSE_nominal(displayUnit="K", final min=0)=2
    "Design heat exchanger approach"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_WSE));

  parameter Real VHeaExcDes_flow(unit="m3/s")=0.015
    "Desing heat exchanger chilled water volume flow rate"
    annotation(Evaluate=true, Dialog(tab="Waterside economizer", group="Design parameters", enable=have_WSE));

  parameter Integer nPum_nominal(final max=nPumPri, final min=1) = nPumPri
    "Total number of pumps that operate at design conditions"
    annotation (Dialog(tab="Chilled water pumps", group="Nominal conditions"));

  // ---- Staging setpoints ----

  parameter Real posDisMult(unit="1")=0.8
    "Positive displacement chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real conSpeCenMult(unit="1")=0.9
    "Constant speed centrifugal chiller type staging multiplier"
    annotation (Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real anyOutOfScoMult(unit="1")=0.9
    "Outside of G36 recommended staging order chiller type SPLR multiplier"
    annotation(Evaluate=true, __cdl(ValueInReference=False), Dialog(tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMin(unit="1")=0.45
    "Minimum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  parameter Real varSpeStaMax(unit="1")=0.9
    "Maximum stage up or down part load ratio for variable speed centrifugal stage types"
    annotation(Evaluate=true, Dialog(enable=anyVsdCen, tab="Staging", group="Staging part load ratio"));

  // ---- Staging up and down process ----

  parameter Real chiDemRedFac(unit="1")=0.75
    "Demand reducing factor of current operating chillers"
    annotation (Dialog(tab="Staging", group="Up and down process", enable=need_reduceChillerDemand));

  // ---- Cooling tower: Water level control ----
  parameter Real watLevMin(unit="1")=0.7
    "Minimum cooling tower water level recommended by manufacturer"
     annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  parameter Real watLevMax(unit="1")=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Cooling Towers", group="Makeup water"));

  Controller_debug ctrPla(
    final closeCoupledPlant=closeCoupledPlant,
    final nChi=nChi,
    final have_parChi=have_parChi,
    final have_ponyChiller=have_ponyChiller,
    final need_reduceChillerDemand=need_reduceChillerDemand,
    final desCap=cap_nominal,
    final chiTyp=chiTyp,
    final chiDesCap=capChi_nominal,
    final chiMinCap=capChi_min,
    final TChiWatSupMin=fill(TCHWSup_nominal, nChi),
    final minChiLif=dat.dTLif_min,
    final have_heaPreConSig=have_ctrHeaPre,
    final anyVsdCen=anyVsdCen,
    final have_WSE=have_WSE,
    final heaExcAppDes=dTAppWSE_nominal,
    final nChiWatPum=nPumPri,
    final have_heaChiWatPum=not have_CHWDedPum,
    final have_locSenChiWatPum=have_senDpCHWLoc,
    final nSenChiWatPum=nSenDpCHWRem,
    final nConWatPum=nPumCon,
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final have_heaConWatPum=not have_CWDedPum,
    final nSta=nSta,
    final totSta=totSta,
    final staMat=staMat,
    final desChiNum=desChiNum,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final towCelOnSet=towCelOnSet,
    final nTowCel=nCooTow,
    final cooTowAppDes=dTAppTow_nominal,
    final schTab=schTab,
    final TChiLocOut=dat.TAirOutLoc,
    final TOutWetDes=cooTowGro.TAirInWB_nominal,
    final VHeaExcDes_flow=VHeaExcDes_flow,
    final minConWatPumSpe=dat.yPumCW_min,
    final minHeaPreValPos=dat.yValIsoCon_min,
    final minFloSet=dat.mCHWChi_flow_min/1000,
    final maxFloSet=mCHWChi_flow_nominal/1000,
    final minChiWatPumSpe=dat.yPumCHW_min,
    final nPum_nominal=nPum_nominal,
    final VChiWat_flow_nominal=mCHWPri_flow_nominal/1000,
    final maxLocDp=dat.dpCHWLoc_max,
    final dpChiWatPumMax=dat.dpCHWRem_max,
    final posDisMult=posDisMult,
    final conSpeCenMult=conSpeCenMult,
    final anyOutOfScoMult=anyOutOfScoMult,
    final varSpeStaMin=varSpeStaMin,
    final varSpeStaMax=varSpeStaMax,
    final chiDemRedFac=chiDemRedFac,
    final fanSpeMin=dat.yFanTow_min,
    final LIFT_min=fill(dat.dTLif_min, nChi),
    final TConWatSup_nominal=fill(dat.TCWSup_nominal, nChi),
    final TConWatRet_nominal=fill(dat.TCWRet_nominal, nChi),
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
  "CHW plant controller"
  annotation (Placement(transformation(extent={{0,-40},{20,20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiConIsoVal[nChi](
      each k=true)
    "CH CW and CHW isolation valve open end switch status only used for FD + Should be DI or AI"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiWatReq[nChi](
      each k=true)
    "From built-in chiller controller: how should it be generated?"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uHeaPreCon[nChi](
      each k=0) "From built-in chiller controller: how should it be generated?"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uChiLoa[nChi](
      each k=1) "Should be computed internally, in J/s, not A."
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiAva[nChi](each
      k=true)
    "Instead 2 input points should be declared for each chiller: Chiller Fault Code and Chiller local/auto switch?"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uChiHeaCon[nChi](
      each k=true)
    "This signal should be internally computed by the stage up and down sequences"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uChiWatIsoVal[nChi](
      each k=1) "Should be optional and exclusive from `uChiIsoVal`"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME_TChiWatSupResReq(k=0)
    "That input should be conditional and another (conditional) array input is needed + Request not available from VAV controller"
    annotation (Placement(transformation(extent={{-140,-110},{-120,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME_chiPlaReq(k=0)
    "Request not available from VAV controller"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uConWatPumSpe[nPumCon](
    each k=1) "Should be computed internally"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uChiCooLoa[nChi](
    each k=1)
    "The chiller load (𝑄𝑟𝑒𝑞𝑢𝑖𝑟𝑒𝑑) shall be internally calculated by the controller based on §5.2.4.7"
    annotation (Placement(transformation(extent={{-100,-190},{-80,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uFanSpe(k=1)
    "This should be the commanded speed `ySpeSet` computed internally"
    annotation (Placement(transformation(extent={{-60,-190},{-40,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uIsoVal[nCooTow](
    each k=1) "Missing feedback position or switch status in system model"
    annotation (Placement(transformation(extent={{-60,-150},{-40,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_watLev(k=1)
    "How do we take that into account?"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uTowSta[nCooTow](
    each k=true) "Missing CT status in system model"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yHeaPreConVal[nChi](
      each k=true)
    "Various configurations not covered: modulating in controller, 2-position in system model."
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator FIXME_TChiWatSupSet(
      nout=nChi)
    "System model should be refactored to use the same set point for all units"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yTowCelIsoVal[nCooTow](
      each k=true) "Should be Boolean and conditional to a configuration parameter"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uLifMin(
    k=dat.dTLif_min)
    "Unconnected inside input connector"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uLifMax(
    k=dat.TCWRet_nominal - TCHWSup_nominal)
    "Unconnected inside input connector"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  /* Control point connection - start */

  connect(busCon.pumPri.uStaPumPri, ctrPla.uChiWatPum);
  connect(busCon.dpCHWLoc, ctrPla.dpChiWat_local);
  connect(busCon.dpCHWRem, ctrPla.dpChiWat_remote);
  connect(busCon.pumPri.V_flow, ctrPla.VChiWat_flow);
  connect(busCon.chi.sta, ctrPla.uChi);
  // FIXME: should be computed by controller.
  connect(busCon.TWetAirOut, ctrPla.TOutWet);
  connect(busCon.wse.TCHWRetLvgWSE, ctrPla.TChiWatRetDow);
  // FIXME: ctrPla.TChiWatRet should be conditional to have_WSE.
  // Another input is required for Plant CHW return temperature.
  if have_WSE then
    connect(busCon.wse.TCHWRetEntWSE, ctrPla.TChiWatRet);
  else
    connect(busCon.TCHWRetPla, ctrPla.TChiWatRet);
  end if;
  connect(busCon.TCWRet, ctrPla.TConWatRet);
  // FIXME: busCon.pumPri.TPCHWSup should be renamed.
  connect(busCon.pumPri.TPCHWSup, ctrPla.TChiWatSup);
  // FIXME: Rename uStaPumPri as "Pri" does not apply to CW pumps.
  connect(busCon.uStaPumPri, ctrPla.uConWatPum);
  connect(busCon.TAirOut, ctrPla.TOut);
  connect(busCon.TCWSup, ctrPla.TConWatSup);

  connect(FIXME_uChiWatReq.y, ctrPla.uChiWatReq);
  connect(FIXME_uHeaPreCon.y, ctrPla.uHeaPreCon);
  connect(FIXME_uChiLoa.y, ctrPla.uChiLoa);
  connect(FIXME_uChiAva.y, ctrPla.uChiAva);
  connect(FIXME_uChiHeaCon.y, ctrPla.uChiHeaCon);
  connect(FIXME_uChiWatIsoVal.y, ctrPla.uChiWatIsoVal);
  connect(FIXME_TChiWatSupResReq.y, ctrPla.TChiWatSupResReq);
  connect(FIXME_chiPlaReq.y, ctrPla.chiPlaReq);
  connect(FIXME_uConWatPumSpe.y, ctrPla.uConWatPumSpe);
  connect(FIXME_uChiCooLoa.y, ctrPla.uChiCooLoa);
  connect(FIXME_uFanSpe.y, ctrPla.uFanSpe);
  connect(FIXME_uIsoVal.y, ctrPla.uIsoVal);
  connect(FIXME_watLev.y, ctrPla.watLev);
  connect(FIXME_uTowSta.y, ctrPla.uTowSta);

  // Controller outputs
  connect(FIXME_TChiWatSupSet.y, busCon.chi.TSet);

  // FIXME: System model should be refactored to use the same set point for all units.
  // Same holds for the control block.
  connect(ctrPla.yChiPumSpe, busCon.pumPri.ySpe);

  // FIXME: System model does not have a variable for the CHW pump on/off command.
  // connect(ctrPla.yChiWatPum, busCon.pumPri.y);

  // FIXME: Incorrect quantity, should have unit="1".
  // connect(ctrPla.yChiDem, busCon.yChiDem);

  connect(ctrPla.yChi, busCon.chi.on);

  // FIXME: Should not be an output of ctrPla
  // connect(ctrPla.yHeaPreConValSta, busCon.yHeaPreConValSta);

  // FIXME: Missing configurations in controller and system model.
  connect(FIXME_yHeaPreConVal.y, busCon.valCWChi.y);

  // FIXME: Missing configurations in controller and system model.
  // For instance "a single common speed point is appropriate".
  connect(ctrPla.yConWatPumSpe, busCon.ySpe);

  // FIXME: This is not an output per §4. LIST OF POINTS. Should be deleted.
  // connect(ctrPla.yChiWatMinFloSet, busCon.yChiWatMinFloSet);

  // FIXME: No on/off command for CW pumps in systme model.
  // connect(ctrPla.yConWatPum, busCon.y);

  // FIXME: Only modulating valve supported by controller.
  connect(ctrPla.yChiWatIsoVal, busCon.valCHWChi.y);

  // FIXME: Controller output does not exist in real life.
  // connect(ctrPla.yReaChiDemLim, busCon.yReaChiDemLim);

  // FIXME: Missing configurations in controller.
  connect(ctrPla.yMinValPosSet, busCon.pumPri.valByp.y);

  // FIXME: This is not an output per §4. LIST OF POINTS. Should be deleted.
  // connect(ctrPla.yNumCel, busCon.yNumCel);

  connect(FIXME_yTowCelIsoVal.y, busCon.cooTow.yVal);

  connect(ctrPla.yTowFanSpe, busCon.cooTow.yFan);

  // FIXME: CT start signal not implemented in system model.
  // connect(ctrPla.yTowCel, busCon.cooTow.yFan);

  // FIXME: Left unconnected for now. Shall we compute water use?
  // connect(ctrPla.yMakUp, busCon.cooTow.yMakUp);

  /* Control point connection - stop */

  connect(FIXME_uChiConIsoVal.y, ctrPla.uChiConIsoVal) annotation (Line(points={{-118,
          180},{-10,180},{-10,19},{-2,19}},       color={255,0,255}));
  connect(FIXME_uChiWatReq.y, ctrPla.uChiWatReq) annotation (Line(points={{-118,
          140},{-20,140},{-20,17},{-2,17}},
                                          color={255,0,255}));
  connect(FIXME_uChiWatReq.y, ctrPla.uConWatReq) annotation (Line(points={{-118,
          140},{-20,140},{-20,15},{-2,15}},
                                          color={255,0,255}));
  connect(FIXME_uChiConIsoVal.y, ctrPla.uChiIsoVal) annotation (Line(points={{-118,
          180},{-10,180},{-10,11},{-2,11}}, color={255,0,255}));
  connect(ctrPla.TChiWatSupSet, FIXME_TChiWatSupSet.u) annotation (Line(points={
          {22,18},{40,18},{40,20},{58,20}}, color={0,0,127}));
end Guideline36WaterCooled;
