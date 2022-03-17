within Buildings.Templates.AirHandlersFans.Components.Controls;
block G36VAVMultiZone
  "Guideline 36 controller"
  extends
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialVAVMultizone(
      final typ=Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone);

  parameter String idZon[nZon]
    "Zone (or terminal unit) names"
    annotation(Evaluate=true,
    Dialog(group="Configuration"));

  parameter String namGroZon[nZon]
    "Name of group which each zone belongs to"
    annotation(Evaluate=true,
    Dialog(group="Configuration"));

  final parameter Integer nGro(final min=1)=
    Buildings.Templates.BaseClasses.countUniqueStrings(namGroZon)
    "Number of zone groups"
    annotation (
    Evaluate=true,
    Dialog(group="Configuration"));

  final parameter String namGro[nGro]=
    Buildings.Templates.BaseClasses.getUniqueStrings(namGroZon)
    "Group names"
    annotation(Evaluate=true);

  final parameter Boolean isZonInGro[nGro, nZon] = {
    {namGroZon[i] == namGro[j] for i in 1:nZon} for j in 1:nGro}
    "True if zone belongs to group"
    annotation(Evaluate=true);

  final parameter Integer nZonGro[nGro](each final min=1) = {
    Modelica.Math.BooleanVectors.countTrue({
      namGroZon[j] == namGro[i] for j in 1:nZon})
    for i in 1:nGro}
    "Number of zones that each group contains"
    annotation(Evaluate=true);

  parameter Boolean have_perZonRehBox=false
    "Set to true if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));

  /*
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller
  */

  parameter Boolean have_duaDucBox=false
    "Set to true if the AHU serves dual duct boxes"
    annotation (Dialog(group="System and building parameters"));

  parameter Boolean have_freSta=false
    "Set to true if the system is equipped with freeze stat"
    annotation (Dialog(group="System and building parameters"));

  // FIXME #1913: not used, not clear.
  /*
  final parameter Boolean have_airFloMeaSta=
    typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowTracking
    "Check if the AHU has supply airflow measuring station"
    annotation (Dialog(group="System and building parameters"));
  */

  final parameter Modelica.Units.SI.PressureDifference pAirSupSet_rel_max=
    dat.pAirSupSet_rel_max
    "Maximum supply duct static pressure set point";

  final parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_min=
    dat.pAirRetSet_rel_min
    "Return fan minimum discharge static pressure set point";

  final parameter Modelica.Units.SI.PressureDifference pAirRetSet_rel_max=
    dat.pAirRetSet_rel_max
    "Return fan maximum discharge static pressure set point";

  final parameter Real yFanSup_min=
    dat.yFanSup_min
    "Lowest allowed fan speed if fan is on";

  // FIXME #1913: the definition of that parameter is unclear.
  final parameter Modelica.Units.SI.VolumeFlowRate VPriSysMax_flow=
    secOutRel.mAirSup_flow_nominal / 1.2
    "Maximum expected system primary airflow at design stage";

  final parameter Real nPeaSys_nominal=
    dat.nPeaSys_nominal
    "Design system population (including diversity)";

  final parameter Modelica.Units.SI.Temperature TAirSupSet_min(
    displayUnit="degC")=dat.TAirSupSet_min
    "Lowest supply air temperature set point";

  final parameter Modelica.Units.SI.Temperature TAirSupSet_max(
    displayUnit="degC")=dat.TAirSupSet_max
    "Highest supply air temperature set point";

  final parameter Modelica.Units.SI.Temperature TAirOutRes_min(
    displayUnit="degC")=dat.TAirOutRes_min
    "Lowest value of the outdoor air temperature reset range";

  final parameter Modelica.Units.SI.Temperature TAirOutRes_max(
    displayUnit="degC")=dat.TAirOutRes_max
    "Highest value of the outdoor air temperature reset range";

  final parameter Modelica.Units.SI.PressureDifference pBuiSet_rel=
    dat.pBuiSet_rel
    "Building static pressure set point";

  final parameter Real yFanRel_min=
    dat.yFanRel_min
    "Minimum relief fan speed";

  final parameter Real yFanRet_min=
    dat.yFanRet_min
    "Minimum return fan speed";

  final parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal=
    dat.dpDamOutMin_nominal
    "Design minimum outdoor air damper differential pressure";

  final parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow=
    dat.dVFanRet_flow
    "Airflow differential between supply and return fans to maintain building pressure at set point";

  // FIXME #1913: incorrect parameter propagation in controller.
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller ctl(
    retFanDpCon(final disMinSpe=yFanRet_min, disMaxSpe=1),
    final minOADes=minOADes,
    final buiPreCon=buiPreCon,
    final nZonGro=nGro,
    final have_heaCoi=coiHeaPre.typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
      coiHeaReh.typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_freSta=have_freSta,
    final use_enthalpy=use_enthalpy,
    final pMaxSet=pAirSupSet_rel_max,
    final yFanMin=yFanSup_min,
    final minSpe=yFanSup_min,
    final minSpeRelFan=yFanRel_min,
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=nPeaSys_nominal,
    final TSupCooMin=TAirSupSet_min,
    final TSupCooMax=TAirSupSet_max,
    final TOutMin=TAirOutRes_min,
    final TOutMax=TAirOutRes_max,
    final dpDesOutDam_min=dpDamOutMin_nominal,
    final dpBuiSet=pBuiSet_rel,
    final difFloSet=dVFanRet_flow,
    final dpDisMin=pAirRetSet_rel_min,
    final dpDisMax=pAirRetSet_rel_max)
    "AHU controller"
    annotation (Placement(transformation(extent={{-40,-72},{40,72}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=nZon)
    "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{-140,-32},{-120,-12}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator repSigZon(
    final nZon=nZon,
    final nGro=nGro)
    "Replicate zone signals"
    annotation (Placement(transformation(extent={{-160,100},{-152,140}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus staGro[nGro](
    final numZon=fill(nZon, nGro),
    final numZonGro=nZonGro,
    final zonGroMsk=isZonInGro)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{-140,100},{-120,140}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode opeModSel[nGro](
    final numZon=nZonGro)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{-100,104},{-80,136}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TAirSupSet(final nout=
       nZon) "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator VDesUncOutAir_flow(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator yReqOutAir(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonTemRes(
    final nin=nZon,
    final k=fill(1, nZon))
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonPreRes(
    final nin=nZon,
    final k=fill(1, nZon))
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TOutCut(k=24 + 273.15)
    "FIXME #1913: To be determined by the control sequence based on energy standard, climate zone, and economizer high-limit-control type"
    annotation (Placement(transformation(extent={{-280,170},{-260,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uOutDamPos(k=1)
    "FIXME #1913: The commanded position or open/close command should be used"
    annotation (Placement(transformation(extent={{-280,130},{-260,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uSupFanSpe(k=1)
    "FIXME #1913: The commanded speed should be used"
    annotation (Placement(transformation(extent={{-280,90},{-260,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uFreSta(k=false)
    "FIXME #1913: Should we model that?"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uFreStaRes(k=false)
    "FIXME #1913: There should be no input point for freeze stat reset"
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uSofSwiRes(k=false)
    "FIXME #1913: How to deal with that?"
    annotation (Placement(transformation(extent={{-280,-30},{-260,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uRelFanSpe(k=1)
    "FIXME #1913: The commanded speed should be used"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TAirSupSet(k=288.15)
    "FIXME #1913: Output should be reintroduced as it is needed by the terminal unit control sequence"
    annotation (Placement(transformation(extent={{-280,-130},{-260,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yMinOutDamPos(k=false)
    if secOutRel.typSecOut == Buildings.Templates.AirHandlersFans.Types.OutdoorSection.DedicatedDampersPressure
    "FIXME #1913: If `minOADes==...SeparateDamper_DP` a Boolean output is required"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yRelDamPos(k=false)
    if secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan
    "FIXME #1913: If `buiPreCon==...ReliefFan` a Boolean output is required"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold FIXME_yFanRel(
     t=1e-2, h=0.5e-2)
    if buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefFan
    "FIXME #1913: On/off command for relief fan is required"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator y1FanSup_actual(final
      nout=nZon) "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TAirSup(final nout=
        nZon) "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{-10,-160},{10,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_uMinOutAirDam(k=true)
    "FIXME #1913: Not an input point"
    annotation (Placement(transformation(extent={{-280,-100},{-260,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold FIXME_yFanRet(
    t=1e-2, h=0.5e-2)
    if (buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanAir
        or buiPreCon == Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReturnFanDp)
    "FIXME #1913: On/off command for return fan is required"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
initial equation
  if minOADes==Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns.CommonDamper then
    assert(secOutRel.typSecOut==Buildings.Templates.AirHandlersFans.Types.OutdoorSection.SingleDamper,
      "In "+ getInstanceName() + ": "+
      "The system configuration is incompatible with the options for minimum outdoor air control.");
  end if;
  if buiPreCon==Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes.ReliefDamper then
    assert(secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper,
     "In "+ getInstanceName() + ": "+
     "The system configuration is incompatible with the options for building pressure control.");
  end if;

equation
  /* Control point connection - start */

  // Inputs from AHU bus
  connect(bus.pAirSup_rel, ctl.ducStaPre);
  connect(bus.TAirOut, ctl.TOut);
  connect(bus.fanSup.y1_actual, ctl.uSupFan);
  connect(bus.TAirSup, ctl.TSup);
  connect(bus.VAirOut_flow, ctl.VOut_flow);
  connect(bus.VAirOutMin_flow, ctl.VOut_flow);
  connect(bus.dpAirOutMin, ctl.dpMinOutDam);
  connect(bus.hAirOut, ctl.hOut);
  connect(bus.TAirMix, ctl.TMix);
  connect(bus.pBui_rel, ctl.dpBui);
  connect(bus.fanSup.V_flow, ctl.VSup_flow);
  connect(bus.fanRet.V_flow, ctl.VRet_flow);
  connect(bus.coiCoo.y_actual, ctl.uCooCoi);
  connect(bus.coiHea.y_actual, ctl.uHeaCoi);

  connect(bus.fanSup.y1_actual, y1FanSup_actual.u);
  connect(bus.TAirSup, TAirSup.u);

  // Inputs from terminal bus
  connect(busTer.yReqZonPreRes, reqZonPreRes.u);
  connect(busTer.yReqZonTemRes, reqZonTemRes.u);

  connect(busTer.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc);
  connect(busTer.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow);
  connect(busTer.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow);
  connect(busTer.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra);
  connect(busTer.VUncOutAir_flow, zonToSys.VUncOutAir_flow);
  connect(busTer.yPriOutAirFra, zonToSys.uPriOutAirFra);
  connect(busTer.VPriAir_flow, zonToSys.VPriAir_flow);

  connect(busTer.uOveZon, repSigZon.zonOcc);
  connect(busTer.uOcc, repSigZon.uOcc);
  connect(busTer.tNexOcc, repSigZon.tNexOcc);
  connect(busTer.yCooTim, repSigZon.uCooTim);
  connect(busTer.yWarTim, repSigZon.uWarTim);
  connect(busTer.yOccHeaHig, repSigZon.uOccHeaHig);
  connect(busTer.yHigOccCoo, repSigZon.uHigOccCoo);
  connect(busTer.yUnoHeaHig, repSigZon.uUnoHeaHig);
  connect(busTer.THeaSetOff, repSigZon.THeaSetOff);
  connect(busTer.yEndSetBac, repSigZon.uEndSetBac);
  connect(busTer.yHigUnoCoo, repSigZon.uHigUnoCoo);
  connect(busTer.TCooSetOff, repSigZon.TCooSetOff);
  connect(busTer.yEndSetUp, repSigZon.uEndSetUp);
  connect(busTer.TAirZon, repSigZon.TZon);
  connect(busTer.uWin, repSigZon.uWin);

  // Outputs to AHU bus
  connect(ctl.ySupFan, bus.fanSup.y1);
  connect(ctl.yMinOutDamPos, bus.damOutMin.y);
  connect(ctl.yRetDamPos, bus.damRet.y);
  connect(ctl.yRelDamPos, bus.damRel.y);
  connect(ctl.yOutDamPos, bus.damOut.y);
  connect(ctl.yEneCHWPum, bus.y1PumCHW);
  connect(ctl.ySupFanSpe, bus.fanSup.y);
  connect(ctl.yRetFanSpe, bus.fanRet.y);
  connect(ctl.yRelFanSpe, bus.fanRel.y);
  connect(ctl.yCooCoi, bus.coiCoo.y);
  connect(ctl.yHeaCoi, bus.coiHea.y);
  connect(ctl.yAla, bus.ala);
  connect(ctl.yExhDam, bus.damRel.y);

  connect(ctl.yChiWatResReq, bus.reqCHWRes);
  connect(ctl.yChiPlaReq, bus.reqCHWPla);
  connect(ctl.yHotWatResReq, bus.reqHHWRes);
  connect(ctl.yHotWatPlaReq, bus.reqHHWPla);

  // Outputs to terminal unit bus
  connect(VDesUncOutAir_flow.y, busTer.VDesUncOutAir_flow);
  connect(yReqOutAir.y, busTer.yReqOutAir);
  connect(TAirSupSet.y, busTer.TAirSupSet);
  connect(TAirSup.y, busTer.TAirSup);
  connect(y1FanSup_actual.y, busTer.y1FanSup_actual);

  // FIXME #1913: connect statements to be updated when FIXME tags above are addressed.
  connect(FIXME_TOutCut.y, ctl.TOutCut);
  connect(FIXME_TOutCut.y, ctl.hOutCut);
  connect(FIXME_uOutDamPos.y, ctl.uOutDamPos);
  connect(FIXME_uSupFanSpe.y, ctl.uSupFanSpe);
  connect(FIXME_uFreSta.y, ctl.uFreSta);
  connect(FIXME_uFreStaRes.y, ctl.uFreStaRes);
  connect(FIXME_uSofSwiRes.y, ctl.uSofSwiRes);
  connect(FIXME_uRelFanSpe.y, ctl.uRelFanSpe);
  connect(FIXME_yMinOutDamPos.y, bus.damOutMin.y1);
  connect(FIXME_yRelDamPos.y, bus.damRel.y1);
  connect(FIXME_yFanRel.y, bus.fanRel.y1);
  connect(FIXME_yFanRet.y, bus.fanRet.y1);
  connect(FIXME_uMinOutAirDam.y, ctl.uMinOutAirDam);

  /* Control point connection - stop */

  connect(zonToSys.ySumDesZonPop,ctl. sumDesZonPop) annotation (Line(points={{-118,
          -13},{-60,-13},{-60,40.9091},{-44,40.9091}},
                                               color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow,ctl. VSumDesPopBreZon_flow)
    annotation (Line(points={{-118,-16},{-58,-16},{-58,34.3636},{-44,34.3636}},
                                                                      color={0,0,
          27}));
  connect(zonToSys.VSumDesAreBreZon_flow,ctl. VSumDesAreBreZon_flow)
    annotation (Line(points={{-118,-19},{-56,-19},{-56,31.0909},{-44,31.0909}},
                                                                      color={0,0,
          127}));
  connect(zonToSys.yDesSysVenEff,ctl. uDesSysVenEff) annotation (Line(points={{-118,
          -22},{-54,-22},{-54,26.1818},{-44,26.1818}},
                                               color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow,ctl. VSumUncOutAir_flow) annotation (Line(
        points={{-118,-25},{-52,-25},{-52,21.2727},{-44,21.2727}},
                                                       color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow,ctl. VSumSysPriAir_flow) annotation (Line(
        points={{-118,-31},{-48,-31},{-48,18},{-44,18}},
                                                       color={0,0,127}));
  connect(zonToSys.uOutAirFra_max,ctl. uOutAirFra_max) annotation (Line(points={{-118,
          -28},{-50,-28},{-50,13.0909},{-44,13.0909}},
                                                 color={0,0,127}));
  connect(staGro.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-118,139},{-104,
          139},{-104,134.4},{-102,134.4}},
                                        color={255,0,255}));
  connect(staGro.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-118,137},
          {-106,137},{-106,132.8},{-102,132.8}},
                                               color={0,0,127}));
  connect(staGro.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-118,
          133},{-108,133},{-108,131.2},{-102,131.2}},color={0,0,127}));
  connect(staGro.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-118,
          131},{-110,131},{-110,128},{-102,128}},
                                               color={0,0,127}));
  connect(staGro.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={{-118,
          127},{-106,127},{-106,126.4},{-102,126.4}},color={255,0,255}));
  connect(staGro.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={{-118,
          125},{-108,125},{-108,129.6},{-102,129.6}},color={255,0,255}));
  connect(staGro.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-118,
          118},{-110,118},{-110,116.8},{-102,116.8}},
                                                   color={255,0,255}));
  connect(staGro.TZonMax, opeModSel.TZonMax) annotation (Line(points={{-118,107},
          {-114,107},{-114,115.2},{-102,115.2}},
                                             color={0,0,127}));
  connect(staGro.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-118,105},
          {-110,105},{-110,113.6},{-102,113.6}},
                                             color={0,0,127}));
  connect(staGro.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-118,115},
          {-112,115},{-112,110.4},{-102,110.4}},
                                             color={255,127,0}));
  connect(staGro.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-118,113},{
          -116,113},{-116,107.2},{-102,107.2}},
                                            color={255,0,255}));
  connect(staGro.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-118,
          111},{-106,111},{-106,105.6},{-102,105.6}},
                                             color={255,0,255}));
  connect(staGro.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-118,101},
          {-104,101},{-104,123.2},{-102,123.2}},
                                               color={255,127,0}));
  connect(ctl.VDesUncOutAir_flow, VDesUncOutAir_flow.u)
    annotation (Line(points={{44,47.4545},{70,47.4545},{70,60},{78,60}},
                                                  color={0,0,127}));
  connect(ctl.yReqOutAir, yReqOutAir.u)
    annotation (Line(points={{44,32.7273},{70,32.7273},{70,30},{78,30}},
                                                color={255,0,255}));
  connect(reqZonTemRes.y,ctl. uZonTemResReq) annotation (Line(points={{-118,20},
          {-62,20},{-62,54},{-44,54}},   color={255,127,0}));
  connect(reqZonPreRes.y,ctl. uZonPreResReq)
    annotation (Line(points={{-118,60},{-60,60},{-60,67.0909},{-44,67.0909}},
                                                  color={255,127,0}));

  connect(repSigZon.yzonOcc, staGro.zonOcc)
    annotation (Line(points={{-150,139},{-142,139}}, color={255,0,255}));
  connect(repSigZon.yOcc, staGro.uOcc)
    annotation (Line(points={{-150,137},{-142,137}}, color={255,0,255}));
  connect(repSigZon.ytNexOcc, staGro.tNexOcc)
    annotation (Line(points={{-150,135},{-142,135}}, color={0,0,127}));
  connect(repSigZon.yCooTim, staGro.uCooTim)
    annotation (Line(points={{-150,131},{-142,131}}, color={0,0,127}));
  connect(repSigZon.yWarTim, staGro.uWarTim)
    annotation (Line(points={{-150,129},{-142,129}}, color={0,0,127}));
  connect(repSigZon.yOccHeaHig, staGro.uOccHeaHig)
    annotation (Line(points={{-150,125},{-142,125}}, color={255,0,255}));
  connect(repSigZon.yHigOccCoo, staGro.uHigOccCoo) annotation (Line(points={{-150,
          123},{-142,123}},                        color={255,0,255}));
  connect(repSigZon.yUnoHeaHig, staGro.uUnoHeaHig)
    annotation (Line(points={{-150,119},{-142,119}}, color={255,0,255}));
  connect(repSigZon.yTHeaSetOff, staGro.THeaSetOff)
    annotation (Line(points={{-150,117},{-142,117}}, color={0,0,127}));
  connect(repSigZon.yEndSetBac, staGro.uEndSetBac)
    annotation (Line(points={{-150,115},{-142,115}}, color={255,0,255}));
  connect(repSigZon.yHigUnoCoo, staGro.uHigUnoCoo)
    annotation (Line(points={{-150,111},{-142,111}}, color={255,0,255}));
  connect(repSigZon.yTCooSetOff, staGro.TCooSetOff)
    annotation (Line(points={{-150,109},{-142,109}}, color={0,0,127}));
  connect(repSigZon.yEndSetUp, staGro.uEndSetUp)
    annotation (Line(points={{-150,107},{-142,107}}, color={255,0,255}));
  connect(repSigZon.yTZon, staGro.TZon)
    annotation (Line(points={{-150,103},{-142,103}}, color={0,0,127}));
  connect(repSigZon.yWin, staGro.uWin)
    annotation (Line(points={{-150,101},{-142,101}}, color={255,0,255}));
  connect(ctl.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,42.5455},{60,42.5455},{60,-80},{-160,-80},{-160,-20},{-142,
          -20}},
        color={0,0,127}));
  connect(opeModSel.yOpeMod, ctl.uOpeMod) annotation (Line(points={{-78,120},{
          -60,120},{-60,70.3636},{-44,70.3636}},
                                             color={255,127,0}));
  connect(staGro.yColZon, opeModSel.totColZon) annotation (Line(points={{-118,122},
          {-106,122},{-106,121.6},{-102,121.6}},
                                             color={255,127,0}));
  connect(staGro.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-118,120},
          {-108,120},{-108,118.4},{-102,118.4}},
                                             color={255,0,255}));
  connect(FIXME_TAirSupSet.y, TAirSupSet.u)
    annotation (Line(points={{-258,-120},{-12,-120}},color={0,0,127}));
  connect(ctl.yRelFanSpe,FIXME_yFanRel. u) annotation (Line(points={{44,-13.0909},
          {52,-13.0909},{52,-30},{78,-30}}, color={0,0,127}));
  connect(ctl.yRetFanSpe, FIXME_yFanRet.u) annotation (Line(points={{44,-8.18182},
          {68,-8.18182},{68,-60},{78,-60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
The measured outdoor air flow rate (VOut_flow) used for minimum outdoor air flow control
is connected to either bus.VAirOutMin_flow (dedicated damper) or bus.VAirOut_flow (single damper).
In case of a dedicated damper, the total OA flow rate is not measured, hence no bus.VAirOut_flow
signal is available.
</p>
</html>"));
end G36VAVMultiZone;
