within Buildings.Templates.AirHandlersFans.Components.Controls;
block Guideline36 "Guideline 36 VAV single duct controller"
  extends
    Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.PartialSingleDuct(
      final typ=Types.Controller.Guideline36);

  // See FIXME below for those parameters.
  parameter String namGroZon[nZon] = fill(namGro[1], nZon)
    "Name of group which each zone belongs to"
    annotation(Evaluate=true);

  parameter Boolean have_perZonRehBox = true
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"));

  /* FIXME: Evaluate function call at compile time, FE ExternData.

  parameter String namGroZon[nZon] = {
    dat.getString(varName=idTerArr[i] + ".identification.namGro.value")
    for i in 1:nZon}
    "Name of group which each zone belongs to"
    annotation(Evaluate=true);

  parameter Boolean have_perZonRehBox = Modelica.Math.BooleanVectors.anyTrue({
      dat.getBoolean(varName=idTerArr[i] + ".control.Perimeter zone with reheat.value")
      for i in 1:nZon})
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation (Dialog(group="System and building parameters"), Evaluate=true);
  */

  final parameter Boolean isZonInGro[nGro, nZon] = {
    {namGroZon[i] == namGro[j] for i in 1:nZon} for j in 1:nGro}
    "True if zone belongs to group"
    annotation(Evaluate=true);

  final parameter Integer nZonGro[nGro] = {
    Modelica.Math.BooleanVectors.countTrue({
      namGroZon[j] == namGro[i] for j in 1:nZon})
    for i in 1:nGro}
    "Number of zones that each group contains"
    annotation(Evaluate=true);

  /*
  *  Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller
  */

  final parameter Boolean have_duaDucBox = Modelica.Math.BooleanVectors.anyTrue({
      Modelica.Utilities.Strings.find(
        dat.getString(varName=idTerArr[i] + ".identification.subtype.value"),
        "dual",
        caseSensitive=false) <> 0
      for i in 1:nZon})
    "Check if the AHU serves dual duct boxes"
    annotation (Dialog(group="System and building parameters"));

  final parameter Boolean have_airFloMeaSta=
    typCtrFanSup==Buildings.Templates.AirHandlersFans.Types.ControlFanSupply.Airflow
    "Check if the AHU has supply airflow measuring station"
    annotation (Dialog(group="System and building parameters"));

  // ----------- Parameters for economizer control -----------

  parameter Boolean use_G36FrePro = false
    "Set to true to use G36 freeze protection"
    annotation(Dialog(group="Economizer freeze protection"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

  parameter Real kFre(final unit="1/K") = 0.1
    "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
     annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));


  // ----------- parameters for fan speed control  -----------

  parameter Real pMaxSet(
    final unit="Pa",
    final displayUnit="Pa",
    final quantity="PressureDifference")=
    dat.getReal(varName=id + ".control.airflow.pMaxSet.value")
    "Maximum pressure setpoint for fan speed control"
    annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

  parameter Real yFanSupMax=
    dat.getReal(varName=id + ".control.airflow.yFanSupMax.value")
    "Maximum allowed fan speed"
    annotation (Dialog(group="Fan speed PID controller"));

  parameter Real yFanSupMin=
    dat.getReal(varName=id + ".control.airflow.yFanSupMin.value")
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Fan speed PID controller"));

  // ----------- parameters for minimum outdoor airflow setting  -----------

  parameter Real VPriSysMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=
    dat.getReal(varName=id + ".control.ventilation.VPriSysMax_flow.value")
    "Maximum expected system primary airflow at design stage"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  parameter Real peaSysPop=
    dat.getReal(varName=id + ".control.ventilation.peaSysPop.value")
    "Peak system population"
    annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

  // ----------- parameters for supply air temperature control  -----------

  parameter Real TSupSetMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TSup.TSupSetMin.value")
    "Lowest cooling supply air temperature setpoint"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TSupSetMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TSup.TSupSetMax.value")
    "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  // FIXME: what is that?
  parameter Real TSupSetDes(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=286.15
    "Nominal supply air temperature setpoint"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TOutMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TSup.TOutMin.value")
    "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  parameter Real TOutMax(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=
    dat.getReal(varName=id + ".control.TSup.TOutMax.value")
    "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
    annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

  /*
  * Parameters for Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
  */

  // Those are assumed identical for all zone groups.

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller ctr(
    final have_perZonRehBox=have_perZonRehBox,
    final have_duaDucBox=have_duaDucBox,
    final have_airFloMeaSta=have_airFloMeaSta,
    final use_enthalpy=use_enthalpy,
    final use_TMix=use_TMix,
    final use_G36FrePro=use_G36FrePro,
    final pMaxSet=pMaxSet,
    final yFanMax=yFanSupMax,
    final yFanMin=yFanSupMin,
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=peaSysPop,
    final TSupSetMin=TSupSetMin,
    final TSupSetMax=TSupSetMax,
    final TSupSetDes=TSupSetDes,
    final TOutMin=TOutMin,
    final TOutMax=TOutMax)
    "AHU controller"
    annotation (Placement(transformation(extent={{-40,8},{40,152}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=nZon)
    "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{20,-60},{0,-40}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.ZoneStatusDuplicator repSigZon(
    final nZon=nZon,
    final nGro=nGro)
    "Replicate zone signals"
    annotation (Placement(transformation(extent={{-18,-188},{-26,-148}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.GroupStatus staGro[nGro](
    final numZon=fill(nZon, nGro),
    final numZonGro=nZonGro,
    final zonGroMsk=isZonInGro)
    "Evaluate zone group status"
    annotation (Placement(transformation(extent={{-40,-188},{-60,-148}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode opeModSel[nGro](
    final numZon=nZonGro)
    "Operation mode selection for each zone group"
    annotation (Placement(transformation(extent={{-60,-136},{-40,-104}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator TSupSet(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,-30},{180,-10}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator VDesUncOutAir_flow(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,94},{180,114}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator yReqOutAir(
    final nout=nZon)
    "Pass signal to terminal unit bus"
    annotation (Placement(transformation(extent={{160,58},{180,78}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonTemRes(
    final k=fill(1, nZon),
    final nin=nZon)
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum reqZonPreRes(
    final k=fill(1, nZon),
    final nin=nZon)
    "Sum up signals"
    annotation (Placement(transformation(extent={{-140,8},{-120,28}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TSet(k=24 + 273.15)
    "Where is the use of the average zone set point described?"
    annotation (Placement(transformation(extent={{280,138},{260,158}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_TOutCut(k=24 + 273.15)
    "To be determined determined by the control sequence based on energy standard, climate zone, and economizer high-limit-control device type"
    annotation (Placement(transformation(extent={{280,178},{260,198}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_yDamRel(k=1)
    "Various economizer configurations not handled: yDamRel (or exhaust), yDamOutMin"
    annotation (Placement(transformation(extent={{280,58},{260,78}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant FIXME_yFanRetRea(k=1)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{280,98},{260,118}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant FIXME_yFanRetBoo(k=true)
    "Various fan configurations not handled: yFanRet (or relief)"
    annotation (Placement(transformation(extent={{280,18},{260,38}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant FIXME_modSys(k=1)
    "Convert zone group mode into AHU system mode per 5.15"
    annotation (Placement(transformation(extent={{280,-20},{260,0}})));

equation

  /* Control point connection - start */
  connect(ctr.yHea, bus.coiHea.y);
  connect(ctr.yCoo, bus.coiCoo.y);
  connect(ctr.yRetDamPos, bus.damRet.y);
  connect(ctr.yOutDamPos, bus.damOut.y);

  connect(ctr.ySupFan, bus.fanSup.y);
  connect(ctr.ySupFanSpe, bus.fanSup.ySpe);
  connect(FIXME_yFanRetBoo.y, bus.fanRet.y);
  connect(FIXME_yFanRetRea.y, bus.fanRet.ySpe);
  connect(FIXME_yDamRel.y, bus.damRel.y);

  connect(FIXME_TSet.y,ctr. TZonHeaSet);
  connect(FIXME_TSet.y,ctr. TZonCooSet);

  connect(FIXME_TOutCut.y,ctr. TOutCut);
  connect(FIXME_TOutCut.y,ctr. hOutCut);
  connect(FIXME_modSys.y,ctr. uOpeMod);

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
  /* Control point connection - stop */

  connect(ctr.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{44,92},{200,92},{200,-48},{22,-48}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop,ctr. sumDesZonPop) annotation (Line(points={{-2,
          -41},{-52,-41},{-52,118},{-44,118}}, color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow,ctr. VSumDesPopBreZon_flow)
    annotation (Line(points={{-2,-44},{-56,-44},{-56,112},{-44,112}}, color={0,0,
          27}));
  connect(zonToSys.VSumDesAreBreZon_flow,ctr. VSumDesAreBreZon_flow)
    annotation (Line(points={{-2,-47},{-60,-47},{-60,106},{-44,106}}, color={0,0,
          127}));
  connect(zonToSys.yDesSysVenEff,ctr. uDesSysVenEff) annotation (Line(points={{-2,
          -50},{-64,-50},{-64,100},{-44,100}}, color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow,ctr. VSumUncOutAir_flow) annotation (Line(
        points={{-2,-53},{-68,-53},{-68,94},{-44,94}}, color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow,ctr. VSumSysPriAir_flow) annotation (Line(
        points={{-2,-59},{-76,-59},{-76,88},{-44,88}}, color={0,0,127}));
  connect(zonToSys.uOutAirFra_max,ctr. uOutAirFra_max) annotation (Line(points={
          {-2,-56},{-72,-56},{-72,82},{-44,82}}, color={0,0,127}));
  connect(bus.TAirSup,ctr. TSup) annotation (Line(
      points={{-200,0},{-180,0},{-180,80},{-100,80},{-100,70},{-44,70}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TAirOut,ctr. TOut) annotation (Line(
      points={{-200,0},{-180,0},{-180,136},{-44,136}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.pAirSup_rel,ctr. ducStaPre) annotation (Line(
      points={{-200,0},{-180,0},{-180,130},{-44,130}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.VOut_flow,ctr. VOut_flow) annotation (Line(
      points={{-200,0},{-180,0},{-180,46},{-44,46}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.TAirMix,ctr. TMix) annotation (Line(
      points={{-200,0},{-180,0},{-180,38},{-44,38}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.hAirOut,ctr. hOut) annotation (Line(
      points={{-200,0},{-180,0},{-180,80},{-100,80},{-100,58},{-44,58}},
      color={255,204,51},
      thickness=0.5));
  connect(staGro.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-62,-149},{
          -72,-149},{-72,-106},{-62,-106}},
                                        color={255,0,255}));
  connect(staGro.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-62,-151},
          {-88,-151},{-88,-108},{-62,-108}},   color={0,0,127}));
  connect(staGro.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{-62,
          -155},{-98,-155},{-98,-110},{-62,-110}},   color={0,0,127}));
  connect(staGro.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-62,
          -157},{-94,-157},{-94,-114},{-62,-114}},
                                               color={0,0,127}));
  connect(staGro.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={{-62,
          -161},{-88,-161},{-88,-116},{-62,-116}},   color={255,0,255}));
  connect(staGro.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={{-62,
          -163},{-88,-163},{-88,-112},{-62,-112}},   color={255,0,255}));
  connect(staGro.yColZon, opeModSel.totColZon) annotation (Line(points={{-62,
          -166},{-88,-166},{-88,-120},{-62,-120}},
                                               color={255,127,0}));
  connect(staGro.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-62,-168},
          {-86,-168},{-86,-122},{-62,-122}},   color={255,0,255}));
  connect(staGro.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-62,
          -170},{-84,-170},{-84,-124},{-62,-124}}, color={255,0,255}));
  connect(staGro.TZonMax, opeModSel.TZonMax) annotation (Line(points={{-62,-181},
          {-82,-181},{-82,-126},{-62,-126}}, color={0,0,127}));
  connect(staGro.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-62,-183},
          {-80,-183},{-80,-128},{-62,-128}}, color={0,0,127}));
  connect(staGro.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-62,
          -173},{-76,-173},{-76,-130},{-62,-130}},
                                             color={255,127,0}));
  connect(staGro.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-62,-175},
          {-76,-175},{-76,-132},{-62,-132}},color={255,0,255}));
  connect(staGro.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-62,
          -177},{-74,-177},{-74,-134},{-62,-134}},
                                             color={255,0,255}));
  connect(staGro.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-62,-187},
          {-90,-187},{-90,-118},{-62,-118}},   color={255,127,0}));
  connect(ctr.VDesUncOutAir_flow, VDesUncOutAir_flow.u)
    annotation (Line(points={{44,104},{158,104}}, color={0,0,127}));
  connect(ctr.yReqOutAir, yReqOutAir.u)
    annotation (Line(points={{44,68},{158,68}}, color={255,0,255}));
  connect(bus.TSupSet, TSupSet.u)
    annotation (Line(
      points={{-200,0},{-180,0},{-180,-20},{158,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(reqZonTemRes.y,ctr. uZonTemResReq) annotation (Line(points={{-118,60},
          {-108,60},{-108,24},{-44,24}}, color={255,127,0}));
  connect(reqZonPreRes.y,ctr. uZonPreResReq)
    annotation (Line(points={{-118,18},{-44,18}}, color={255,127,0}));
  connect(busTer.yReqZonPreRes, reqZonPreRes.u) annotation (Line(
      points={{220,0},{22,0},{22,0},{-160,0},{-160,18},{-142,18}},
      color={255,204,51},
      thickness=0.5));
  connect(busTer.yReqZonTemRes, reqZonTemRes.u) annotation (Line(
      points={{220,0},{-160,0},{-160,60},{-142,60}},
      color={255,204,51},
      thickness=0.5));

  connect(TSupSet.y, busTer.TSupSet)
    annotation (Line(points={{182,-20},{200,-20},{200,0},{220,0}},         color={0,0,127}));
  connect(yReqOutAir.y, busTer.yReqOutAir)
    annotation (Line(points={{182,68},{200,68},{200,0},{220,0}},       color={255,0,255}));
  connect(VDesUncOutAir_flow.y, busTer.VDesUncOutAir_flow)
    annotation (Line(points={{182,104},{200,104},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.uDesZonPeaOcc, busTer.yDesZonPeaOcc)
    annotation (Line(points={{22,-42},{200,-42},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VDesPopBreZon_flow, busTer.VDesPopBreZon_flow)
    annotation (Line(points={{22,-44},{200,-44},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VDesAreBreZon_flow, busTer.VDesAreBreZon_flow)
    annotation (Line(points={{22,-46},{200,-46},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.uDesPriOutAirFra, busTer.yDesPriOutAirFra)
    annotation (Line(points={{22,-52},{200,-52},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VUncOutAir_flow, busTer.VUncOutAir_flow)
    annotation (Line(points={{22,-54},{200,-54},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.uPriOutAirFra, busTer.yPriOutAirFra)
    annotation (Line(points={{22,-56},{200,-56},{200,0},{220,0}},       color={0,0,127}));
  connect(zonToSys.VPriAir_flow, busTer.VPriAir_flow)
    annotation (Line(points={{22,-58},{200,-58},{200,0},{220,0}},       color={0,0,127}));
  connect(ctr.TSupSet, bus.TSupSet) annotation (Line(points={{44,116},{60,116},{
          60,0},{-200,0}}, color={0,0,127}));
  connect(repSigZon.yzonOcc, staGro.zonOcc)
    annotation (Line(points={{-28,-149},{-38,-149}}, color={255,0,255}));
  connect(repSigZon.yOcc, staGro.uOcc)
    annotation (Line(points={{-28,-151},{-38,-151}}, color={255,0,255}));
  connect(repSigZon.ytNexOcc, staGro.tNexOcc)
    annotation (Line(points={{-28,-153},{-38,-153}}, color={0,0,127}));
  connect(repSigZon.yCooTim, staGro.uCooTim)
    annotation (Line(points={{-28,-157},{-38,-157}}, color={0,0,127}));
  connect(repSigZon.yWarTim, staGro.uWarTim)
    annotation (Line(points={{-28,-159},{-38,-159}}, color={0,0,127}));
  connect(repSigZon.yOccHeaHig, staGro.uOccHeaHig)
    annotation (Line(points={{-28,-163},{-38,-163}}, color={255,0,255}));
  connect(repSigZon.yHigOccCoo, staGro.uHigOccCoo) annotation (Line(points={{-28,
          -165},{-38,-165}},                       color={255,0,255}));
  connect(repSigZon.yUnoHeaHig, staGro.uUnoHeaHig)
    annotation (Line(points={{-28,-169},{-38,-169}}, color={255,0,255}));
  connect(repSigZon.yTHeaSetOff, staGro.THeaSetOff)
    annotation (Line(points={{-28,-171},{-38,-171}}, color={0,0,127}));
  connect(repSigZon.yEndSetBac, staGro.uEndSetBac)
    annotation (Line(points={{-28,-173},{-38,-173}}, color={255,0,255}));
  connect(repSigZon.yHigUnoCoo, staGro.uHigUnoCoo)
    annotation (Line(points={{-28,-177},{-38,-177}}, color={255,0,255}));
  connect(repSigZon.yTCooSetOff, staGro.TCooSetOff)
    annotation (Line(points={{-28,-179},{-38,-179}}, color={0,0,127}));
  connect(repSigZon.yEndSetUp, staGro.uEndSetUp)
    annotation (Line(points={{-28,-181},{-38,-181}}, color={255,0,255}));
  connect(repSigZon.yTZon, staGro.TZon)
    annotation (Line(points={{-28,-185},{-38,-185}}, color={0,0,127}));
  connect(repSigZon.yWin, staGro.uWin)
    annotation (Line(points={{-28,-187},{-38,-187}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false), graphics={Text(
          extent={{-20,-88},{186,-142}},
          lineColor={238,46,47},
          textString=
              "TODO: subset indices for different Boolean values (such as have_occSen)")}),
    Documentation(info="<html>
<p>
WARNING: Do not use. Not configured and connected yet!
</p>
</html>"));
end Guideline36;
