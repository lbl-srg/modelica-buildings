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

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone ashCliZon=
    Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified
    "ASHRAE climate zone"
    annotation (Dialog(group="Configuration",
    enable=stdEne==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016));

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone tit24CliZon=
    Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified
    "California Title 24 climate zone"
    annotation (Dialog(group="Configuration",
    enable=stdEne==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016));

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
    {namGro[i]==namGroZon[j]  for j in 1:nZon} for i in 1:nGro}
    "True if zone belongs to group"
    annotation(Evaluate=true);

  final parameter Integer isZonInGroInt[nGro, nZon]=
    {{if isZonInGro[i, j] then 1 else 0 for j in 1:nZon} for i in 1:nGro}
    "1 if zone belongs to group, 0 otherwise"
    annotation(Evaluate=true);

  final parameter Integer idxGro[nZon]=
    {Modelica.Math.BooleanVectors.firstTrueIndex({namGroZon[i]==namGro[j] for j in 1:nGro}) for i in 1:nZon}
    "Index of the group that each zone belongs to"
    annotation(Evaluate=true);

  final parameter Integer nZonPerGro[nGro](each final min=1) = {
    Modelica.Math.BooleanVectors.countTrue({
      namGroZon[j] == namGro[i] for j in 1:nZon})
    for i in 1:nGro}
    "Number of zones that each group contains"
    annotation(Evaluate=true);

  parameter Boolean have_perZonRehBox=false
    "Set to true if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="Configuration"));

  /*
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller
  */

  final parameter Modelica.Units.SI.VolumeFlowRate VOutUnc_flow_nominal=
    dat.VOutUnc_flow_nominal
    "Uncorrected design outdoor air flow rate, including diversity where applicable";
  final parameter Modelica.Units.SI.VolumeFlowRate VOutTot_flow_nominal=
    dat.VOutTot_flow_nominal
    "Design total outdoor air flow rate";
  final parameter Modelica.Units.SI.VolumeFlowRate VOutAbsMin_flow_nominal=
    dat.VOutAbsMin_flow_nominal
    "Design outdoor air flow rate when all zones with CO2 sensors or occupancy sensors are unpopulated";
  final parameter Modelica.Units.SI.VolumeFlowRate VOutMin_flow_nominal=
    dat.VOutMin_flow_nominal
    "Design minimum outdoor air flow rate when all zones are occupied at their design population, including diversity";

  final parameter Modelica.Units.SI.PressureDifference dpDamOutMinAbs=
    dat.dpDamOutMinAbs
    "Differential pressure across the minimum outdoor air damper that provides the absolute minimum outdoor airflow";
  final parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal=
    dat.dpDamOutMin_nominal
    "Differential pressure across the minimum outdoor air damper that provides the design minimum outdoor airflow";

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

  final parameter Modelica.Units.SI.Temperature TAirSupSet_min(
    displayUnit="degC")=dat.TAirSupSet_min
    "Lowest supply air temperature set point";

  final parameter Modelica.Units.SI.Temperature TAirSupSet_max(
    displayUnit="degC")=dat.TAirSupSet_max
    "Highest supply air temperature set point";

  final parameter Modelica.Units.SI.Temperature TOutRes_min(
    displayUnit="degC")=dat.TOutRes_min
    "Lowest value of the outdoor air temperature reset range";

  final parameter Modelica.Units.SI.Temperature TOutRes_max(
    displayUnit="degC")=dat.TOutRes_max
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

  final parameter Modelica.Units.SI.VolumeFlowRate dVFanRet_flow=
    dat.dVFanRet_flow
    "Airflow differential between supply and return fans to maintain building pressure at set point";

  /* FIXME #1913:
  minSpeRelFan=yFanRel_min
  disSpe_min=yFanRet_min
  maxSpeRetFan=0
  */
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller ctl(
    maxSpeRetFan=1,
    final eneSta=stdEne,
    final venSta=stdVen,
    final ashCliZon=ashCliZon,
    final tit24CliZon=tit24CliZon,
    final freSta=typFreSta,
    final minOADes=typSecOut,
    final buiPreCon=buiPreCon,
    final ecoHigLimCon=typCtlEco,
    final have_hotWatCoi=coiHeaPre.typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating or
      coiHeaReh.typ==Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
    final have_eleHeaCoi=coiHeaPre.typ==Buildings.Templates.Components.Types.Coil.ElectricHeating or
      coiHeaReh.typ==Buildings.Templates.Components.Types.Coil.ElectricHeating,
    final have_perZonRehBox=have_perZonRehBox,
    final VUncDesOutAir_flow=VOutUnc_flow_nominal,
    final VDesTotOutAir_flow=VOutTot_flow_nominal,
    final VAbsOutAir_flow=VOutAbsMin_flow_nominal,
    final VDesOutAir_flow=VOutAbsMin_flow_nominal,
    final pMaxSet=pAirSupSet_rel_max,
    final minSpeSupFan=yFanSup_min,
    final TSupCoo_min=TAirSupSet_min,
    final TSupCoo_max=TAirSupSet_max,
    final TOut_min=TOutRes_min,
    final TOut_max=TOutRes_max,
    final have_CO2Sen=have_CO2Sen,
    final dpAbsOutDam_min=dpDamOutMinAbs,
    final dpDesOutDam_min=dpDamOutMin_nominal,
    final dpBuiSet=pBuiSet_rel,
    final difFloSet=dVFanRet_flow,
    final minSpeRetFan=yFanRet_min,
    final dpDis_min=pAirRetSet_rel_min,
    final dpDis_max=pAirRetSet_rel_max)
    "AHU controller"
    annotation (Placement(transformation(extent={{-40,-72},{40,72}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone
    aggZonVen_A621(
    final nZon=nZon,
    final nZonGro=nGro,
    final zonGroMat=isZonInGroInt,
    final zonGroMatTra=transpose(isZonInGroInt))
    if stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016
    "Aggregate zone level ventilation signals - ASHRAE 62.1"
    annotation (Placement(transformation(extent={{-90,-20},{-70,0}})));

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.SumZone
    aggZonVen_T24(
    final nZon=nZon,
    final nZonGro=nGro,
    final zonGroMat=isZonInGroInt,
    final zonGroMatTra=transpose(isZonInGroInt),
    final have_CO2Sen=have_CO2Sen)
    if stdVen==Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.California_Title_24_2016
    "Aggregate zone level ventilation signals - California Title 24"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneStatusDuplicator repSigZon(
    final nZon=nZon,
    final nZonGro=nGro)
    "Replicate zone signals"
    annotation (Placement(transformation(extent={{-190,100},{-182,140}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus staGro[nGro](
    final nZon=fill(nZon, nGro),
    final nZonGro=nZonPerGro,
    final zonGroMsk=isZonInGro)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{-170,100},{-150,140}})));

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode opeModSel[nGro](
    final nZon=nZonPerGro)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{-130,104},{-110,136}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TAirSupSet(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{60,46},{80,66}})));
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uSupFanSpe_actual(k=1)
    "FIXME #1913: The commanded speed should be used"
    annotation (Placement(transformation(extent={{-280,90},{-260,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_u1FreSta(k=false)
    "FIXME #1913: How to deal with that?"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_u1SofSwiRes(k=false)
    "FIXME #1913: How to deal with that?"
    annotation (Placement(transformation(extent={{-280,10},{-260,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_uRelFanSpe(k=1)
    "FIXME #1913: The commanded speed should be used"
    annotation (Placement(transformation(extent={{-280,-50},{-260,-30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator y1FanSup_actual(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TAirSup(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
  Modelica.Blocks.Routing.RealPassThrough FIXME_TAirMix
    "Marked as optional in G36"
    annotation (Placement(transformation(extent={{-280,-150},{-260,-130}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_u1MinOutAirDam(
    k=true)
    "FIXME #1913: The commanded position should be used"
    annotation (Placement(transformation(extent={{-280,-90},{-260,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[nGro]
    "Convert to real"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger yOpeModZon[nZon]
    "Convert back to integer"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig[nZon](
    each final nin=nGro)
    "Assign group operating mode to each zone inside the group"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Buildings.Controls.OBC.CDL.Routing.RealVectorReplicator reaVecRep(
    final nin=nGro,
    final nout=nZon)
    "Replicate vector of group modes nZon times"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant idxGroCst[nZon](
    final k=idxGro) "Index of the group that each zone belongs to"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));

initial equation
  if stdEne==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.ASHRAE90_1_2016 then
    assert(ashCliZon<>Buildings.Controls.OBC.ASHRAE.G36.Types.ASHRAEClimateZone.Not_Specified,
      "In "+ getInstanceName() + ": "+
      "The ASHRAE climate zone cannot be unspecified.");
  end if;
  if stdEne==Buildings.Controls.OBC.ASHRAE.G36.Types.EnergyStandard.California_Title_24_2016 then
    assert(tit24CliZon<>Buildings.Controls.OBC.ASHRAE.G36.Types.Title24ClimateZone.Not_Specified,
      "In "+ getInstanceName() + ": "+
      "The Title 24 climate zone cannot be unspecified.");
  end if;

equation
  /* Control point connection - start */

  // Inputs from AHU bus
  connect(bus.pAirSup_rel, ctl.dpDuc);
  connect(bus.TOut, ctl.TOut);
  connect(bus.TAirSup, ctl.TAirSup);
  connect(bus.VOut_flow, ctl.VAirOut_flow);
  connect(bus.VOutMin_flow, ctl.VAirOut_flow);

  connect(bus.dpAirOutMin, ctl.dpMinOutDam);
  connect(bus.hAirOut, ctl.hAirOut);
  connect(bus.TAirRet, ctl.TAirRet);
  connect(bus.hAirRet, ctl.hAirRet);
  connect(bus.pBui_rel, ctl.dpBui);

  connect(bus.fanSup.y1_actual, ctl.u1SupFan);
  connect(bus.fanRel.y1_actual, ctl.u1RelFan);

  connect(bus.fanSup.V_flow, ctl.VAirSup_flow);
  connect(bus.fanRet.V_flow, ctl.VAirRet_flow);
  connect(bus.coiCoo.y_actual, ctl.uCooCoi_actual);
  connect(bus.coiHea.y_actual, ctl.uHeaCoi_actual);

  connect(bus.fanSup.y1_actual, y1FanSup_actual.u);
  connect(bus.TAirSup, TAirSup.u);

  // Inputs from terminal bus
  connect(busTer.yReqZonPreRes, reqZonPreRes.u);
  connect(busTer.yReqZonTemRes, reqZonTemRes.u);

  connect(busTer.VAdjPopBreZon_flow, aggZonVen_A621.VAdjPopBreZon_flow);
  connect(busTer.VAdjAreBreZon_flow, aggZonVen_A621.VAdjAreBreZon_flow);
  connect(busTer.VAirDis_flow, aggZonVen_A621.VZonPri_flow);
  connect(busTer.VMinOA_flow, aggZonVen_A621.VMinOA_flow);

  connect(busTer.VZonAbsMin_flow, aggZonVen_T24.VZonAbsMin_flow);
  connect(busTer.VZonDesMin_flow, aggZonVen_T24.VZonDesMin_flow);
  connect(busTer.yCO2, aggZonVen_T24.uCO2);

  connect(busTer.y1OveOccZon, repSigZon.zonOcc);
  connect(busTer.y1OccSch, repSigZon.uOcc);
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
  connect(busTer.TZon, repSigZon.TZon);
  connect(busTer.y1Win, repSigZon.uWin);

  // Outputs to AHU bus
  connect(ctl.yMinOutDam, bus.damOutMin.y);
  connect(ctl.y1MinOutDam, bus.damOutMin.y1);
  connect(ctl.yRetDam, bus.damRet.y);
  connect(ctl.yRelDam, bus.damRel.y);
  connect(ctl.yOutDam, bus.damOut.y);
  connect(ctl.y1EneCHWPum, bus.y1PumChiWat);
  connect(ctl.y1SupFan, bus.fanSup.y1);
  connect(ctl.ySupFan, bus.fanSup.y);
  connect(ctl.y1RetFan, bus.fanRet.y1);
  connect(ctl.yRetFan, bus.fanRet.y);
  connect(ctl.y1RelFan, bus.fanRel.y1);
  connect(ctl.yRelFan, bus.fanRel.y);
  connect(ctl.yCooCoi, bus.coiCoo.y);
  connect(ctl.yHeaCoi, bus.coiHea.y);

  connect(ctl.yAla, bus.ala);

  connect(ctl.yChiWatResReq, bus.reqChiWatRes);
  connect(ctl.yChiPlaReq, bus.reqChiWatPla);
  connect(ctl.yHotWatResReq, bus.reqHeaWatRes);
  connect(ctl.yHotWatPlaReq, bus.reqHeaWatPla);

  // Outputs to terminal unit bus
  connect(TAirSupSet.y, busTer.TAirSupSet);
  connect(TAirSup.y, busTer.TAirSup);
  connect(y1FanSup_actual.y, busTer.y1FanSup_actual);

  // FIXME #1913: connect statements to be updated when FIXME tags above are addressed.
  connect(FIXME_uSupFanSpe_actual.y, ctl.uSupFanSpe_actual);
  connect(FIXME_u1FreSta.y, ctl.u1FreSta);
  connect(FIXME_u1SofSwiRes.y, ctl.u1SofSwiRes);
  connect(FIXME_uRelFanSpe.y, ctl.uRelFan);
  connect(FIXME_u1MinOutAirDam.y, ctl.u1MinOutAirDam);

  /* Control point connection - stop */

  connect(staGro.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-148,139},{-134,
          139},{-134,134.4},{-132,134.4}},
                                        color={255,0,255}));
  connect(staGro.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-148,137},
          {-136,137},{-136,132.8},{-132,132.8}},
                                               color={0,0,127}));
  connect(staGro.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-148,
          133},{-138,133},{-138,131.2},{-132,131.2}},color={0,0,127}));
  connect(staGro.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-148,
          131},{-140,131},{-140,128},{-132,128}},
                                               color={0,0,127}));
  connect(staGro.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={{-148,
          127},{-136,127},{-136,126.4},{-132,126.4}},color={255,0,255}));
  connect(staGro.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={{-148,
          125},{-138,125},{-138,129.6},{-132,129.6}},color={255,0,255}));
  connect(staGro.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-148,
          118},{-140,118},{-140,116.8},{-132,116.8}},
                                                   color={255,0,255}));
  connect(staGro.TZonMax, opeModSel.TZonMax) annotation (Line(points={{-148,107},
          {-144,107},{-144,115.2},{-132,115.2}},
                                             color={0,0,127}));
  connect(staGro.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-148,105},
          {-140,105},{-140,113.6},{-132,113.6}},
                                             color={0,0,127}));
  connect(staGro.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-148,115},
          {-142,115},{-142,110.4},{-132,110.4}},
                                             color={255,127,0}));
  connect(staGro.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-148,113},{
          -146,113},{-146,107.2},{-132,107.2}},
                                            color={255,0,255}));
  connect(staGro.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-148,
          111},{-136,111},{-136,105.6},{-132,105.6}},
                                             color={255,0,255}));
  connect(staGro.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-148,101},
          {-134,101},{-134,123.2},{-132,123.2}},
                                               color={255,127,0}));
  connect(reqZonTemRes.y,ctl. uZonTemResReq) annotation (Line(points={{-118,20},
          {-60,20},{-60,54},{-44,54}},   color={255,127,0}));
  connect(reqZonPreRes.y,ctl. uZonPreResReq)
    annotation (Line(points={{-118,60},{-60,60},{-60,67.0909},{-44,67.0909}},
                                                  color={255,127,0}));

  connect(repSigZon.yzonOcc, staGro.zonOcc)
    annotation (Line(points={{-181.2,139},{-172,139}},
                                                     color={255,0,255}));
  connect(repSigZon.yOcc, staGro.uOcc)
    annotation (Line(points={{-181.2,137},{-172,137}},
                                                     color={255,0,255}));
  connect(repSigZon.ytNexOcc, staGro.tNexOcc)
    annotation (Line(points={{-181.2,135},{-172,135}},
                                                     color={0,0,127}));
  connect(repSigZon.yCooTim, staGro.uCooTim)
    annotation (Line(points={{-181.2,131},{-172,131}},
                                                     color={0,0,127}));
  connect(repSigZon.yWarTim, staGro.uWarTim)
    annotation (Line(points={{-181.2,129},{-172,129}},
                                                     color={0,0,127}));
  connect(repSigZon.yOccHeaHig, staGro.uOccHeaHig)
    annotation (Line(points={{-181.2,125},{-172,125}},
                                                     color={255,0,255}));
  connect(repSigZon.yHigOccCoo, staGro.uHigOccCoo) annotation (Line(points={{-181.2,
          123},{-172,123}},                        color={255,0,255}));
  connect(repSigZon.yUnoHeaHig, staGro.uUnoHeaHig)
    annotation (Line(points={{-181.2,119},{-172,119}},
                                                     color={255,0,255}));
  connect(repSigZon.yTHeaSetOff, staGro.THeaSetOff)
    annotation (Line(points={{-181.2,117},{-172,117}},
                                                     color={0,0,127}));
  connect(repSigZon.yEndSetBac, staGro.uEndSetBac)
    annotation (Line(points={{-181.2,115},{-172,115}},
                                                     color={255,0,255}));
  connect(repSigZon.yHigUnoCoo, staGro.uHigUnoCoo)
    annotation (Line(points={{-181.2,111},{-172,111}},
                                                     color={255,0,255}));
  connect(repSigZon.yTCooSetOff, staGro.TCooSetOff)
    annotation (Line(points={{-181.2,109},{-172,109}},
                                                     color={0,0,127}));
  connect(repSigZon.yEndSetUp, staGro.uEndSetUp)
    annotation (Line(points={{-181.2,107},{-172,107}},
                                                     color={255,0,255}));
  connect(repSigZon.yTZon, staGro.TZon)
    annotation (Line(points={{-181.2,103},{-172,103}},
                                                     color={0,0,127}));
  connect(repSigZon.yWin, staGro.uWin)
    annotation (Line(points={{-181.2,101},{-172,101}},
                                                     color={255,0,255}));
  connect(staGro.yColZon, opeModSel.totColZon) annotation (Line(points={{-148,122},
          {-136,122},{-136,121.6},{-132,121.6}},
                                             color={255,127,0}));
  connect(staGro.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-148,120},
          {-138,120},{-138,118.4},{-132,118.4}},
                                             color={255,0,255}));
  connect(aggZonVen_A621.VSumAdjPopBreZon_flow, ctl.VSumAdjPopBreZon_flow)
    annotation (Line(points={{-68,-6},{-58,-6},{-58,40.9091},{-44,40.9091}},
        color={0,0,127}));
  connect(aggZonVen_A621.VSumAdjAreBreZon_flow, ctl.VSumAdjAreBreZon_flow)
    annotation (Line(points={{-68,-10},{-56,-10},{-56,37.6364},{-44,37.6364}},
        color={0,0,127}));
  connect(aggZonVen_A621.VSumZonPri_flow, ctl.VSumZonPri_flow) annotation (Line(
        points={{-68,-14},{-54,-14},{-54,32.7273},{-44,32.7273}}, color={0,0,127}));
  connect(aggZonVen_A621.uOutAirFra_max, ctl.uOutAirFra_max) annotation (Line(
        points={{-68,-18},{-52,-18},{-52,27.8182},{-44,27.8182}}, color={0,0,127}));
  connect(aggZonVen_T24.VSumZonAbsMin_flow, ctl.VSumZonAbsMin_flow) annotation (
     Line(points={{-68,-37},{-50,-37},{-50,21.2727},{-44,21.2727}}, color={0,0,127}));
  connect(aggZonVen_T24.VSumZonDesMin_flow, ctl.VSumZonDesMin_flow) annotation (
     Line(points={{-68,-43},{-48,-43},{-48,18},{-44,18}}, color={0,0,127}));
  connect(aggZonVen_T24.yMaxCO2, ctl.uCO2Loo_max) annotation (Line(points={{-68,
          -48},{-46,-48},{-46,-3.27273},{-44,-3.27273}}, color={0,0,127}));
  connect(ctl.TAirSupSet, TAirSupSet.u) annotation (Line(points={{44,55.6364},{
          58,55.6364},{58,56}},      color={0,0,127}));
  connect(FIXME_TAirMix.y, ctl.TAirMix) annotation (Line(points={{-259,-140},{
          -60,-140},{-60,-45.8182},{-44,-45.8182}},
                                                color={0,0,127}));
  connect(bus.TAirMix, FIXME_TAirMix.u) annotation (Line(
      points={{-200,0},{-320,0},{-320,-140},{-282,-140}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(opeModSel.yOpeMod, intToRea.u)
    annotation (Line(points={{-108,120},{-92,120}}, color={255,127,0}));
  connect(extIndSig.y, yOpeModZon.u)
    annotation (Line(points={{-8,120},{-2,120}}, color={0,0,127}));
  connect(intToRea.y,reaVecRep. u) annotation (Line(points={{-68,120},{-64,120},
          {-64,120},{-62,120}}, color={0,0,127}));
  connect(reaVecRep.y, extIndSig.u)
    annotation (Line(points={{-38,120},{-32,120}}, color={0,0,127}));
  connect(idxGroCst.y, extIndSig.index)
    annotation (Line(points={{-38,90},{-20,90},{-20,108}}, color={255,127,0}));
  connect(yOpeModZon.y, busTer.yOpeMod) annotation (Line(points={{22,120},{200,120},
          {200,0},{220,0}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(opeModSel.yOpeMod, aggZonVen_A621.uOpeMod) annotation (Line(points={{-108,
          120},{-100,120},{-100,-1},{-92,-1}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, aggZonVen_T24.uOpeMod) annotation (Line(points={{-108,
          120},{-100,120},{-100,-32},{-92,-32}}, color={255,127,0}));
  connect(aggZonVen_A621.yAhuOpeMod, ctl.uAhuOpeMod) annotation (Line(points={{-68,-2},
          {-64,-2},{-64,70.3636},{-44,70.3636}},     color={255,127,0}));
  connect(aggZonVen_T24.yAhuOpeMod, ctl.uAhuOpeMod) annotation (Line(points={{-68,-32},
          {-64,-32},{-64,70.3636},{-44,70.3636}},      color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<h4>Description</h4>
<p>
This is an implementation of the control sequence specified in
<a href=\"#ASHRAE2018\">ASHRAE (2018)</a>
for multiple-zone VAV air handlers.
It contains the following components.
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller</a>:
Main controller for the air handler
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.GroupStatus</a>
and
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.OperationMode</a>:
Computation of the zone group operating mode out of zone-level signals
</li>
</ul>
<h4>Details</h4>
<p>
The AI point for the measured outdoor air flow rate <code>ctl.VOut_flow</code>
used for minimum outdoor airflow control is connected to both <code>bus.VOutMin_flow</code>
(dedicated minimum OA damper) and <code>bus.VOut_flow</code> (single common OA damper).
Those two variables are exclusive from one another.
In case of dedicated OA dampers, the total outdoor airflow is not measured,
hence no <code>bus.VOut_flow</code> signal is available for that configuration.
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2018\">
ASHRAE, 2018. Guideline 36-2018, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end G36VAVMultiZone;
