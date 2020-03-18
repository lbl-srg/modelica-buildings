within Buildings.Examples.VAVReheat;
model Guideline36
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop;

  parameter Modelica.SIunits.VolumeFlowRate VPriSysMax_flow=m_flow_nominal/1.2
    "Maximum expected system primary airflow rate at design stage";
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]={
      mCor_flow_nominal,mSou_flow_nominal,mEas_flow_nominal,mNor_flow_nominal,
      mWes_flow_nominal}/1.2 "Minimum expected zone primary flow rate";
  parameter Modelica.SIunits.Time samplePeriod=120
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.SIunits.PressureDifference dpDisRetMax=40
    "Maximum return fan discharge static pressure setpoint";

  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVCor(
    V_flow_nominal=mCor_flow_nominal/1.2,
    AFlo=AFloCor,
    final samplePeriod=samplePeriod) "Controller for terminal unit corridor"
    annotation (Placement(transformation(extent={{530,32},{550,52}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVSou(
    V_flow_nominal=mSou_flow_nominal/1.2,
    AFlo=AFloSou,
    final samplePeriod=samplePeriod) "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{700,30},{720,50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVEas(
    V_flow_nominal=mEas_flow_nominal/1.2,
    AFlo=AFloEas,
    final samplePeriod=samplePeriod) "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{880,30},{900,50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVNor(
    V_flow_nominal=mNor_flow_nominal/1.2,
    AFlo=AFloNor,
    final samplePeriod=samplePeriod) "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{1040,30},{1060,50}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVWes(
    V_flow_nominal=mWes_flow_nominal/1.2,
    AFlo=AFloWes,
    final samplePeriod=samplePeriod) "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1240,28},{1260,48}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    numZon=numZon,
    VPriSysMax_flow=VPriSysMax_flow,
    minZonPriFlo=minZonPriFlo,
    AFlo=AFlo,
    yFanMin=yFanMin,
    pMaxSet=410) "AHU controller"
    annotation (Placement(transformation(extent={{384,362},{424,470}})));
  Modelica.Blocks.Routing.Multiplex5 TDis "Discharge air temperatures"
    annotation (Placement(transformation(extent={{220,270},{240,290}})));
  Modelica.Blocks.Routing.Multiplex5 VDis_flow
    "Air flow rate at the terminal boxes"
    annotation (Placement(transformation(extent={{220,230},{240,250}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum TZonResReq(nin=5)
    "Number of zone temperature requests"
    annotation (Placement(transformation(extent={{300,360},{320,380}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum PZonResReq(nin=5)
    "Number of zone pressure requests"
    annotation (Placement(transformation(extent={{300,330},{320,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yOutDam(k=1)
    "Outdoor air damper control signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiFreSta "Switch for freeze stat"
    annotation (Placement(transformation(extent={{60,-202},{80,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant freStaSetPoi1(
    final k=273.15 + 3) "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-40,-96},{-20,-76}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFreHeaCoi(final k=1)
    "Flow rate signal for heating coil when freeze stat is on"
    annotation (Placement(transformation(extent={{0,-192},{20,-172}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints TZonSet[
    numZon](
    final TZonHeaOn=fill(THeaOn, numZon),
    final TZonHeaOff=fill(THeaOff, numZon),
    final TZonCooOff=fill(TCooOff, numZon)) "Zone setpoint temperature"
    annotation (Placement(transformation(extent={{60,300},{80,320}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=numZon)
    "Replicate boolean input"
    annotation (Placement(transformation(extent={{-120,280},{-100,300}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=numZon)
    "Replicate real input"
    annotation (Placement(transformation(extent={{-120,320},{-100,340}})));

equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{320,-40},{320,0},{320,-10},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(conVAVCor.TZon, TRooAir.y5[1]) annotation (Line(
      points={{528,41},{520,41},{520,162},{511,162}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TZon, TRooAir.y1[1]) annotation (Line(
      points={{698,39},{690,39},{690,40},{680,40},{680,178},{511,178}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TZon) annotation (Line(
      points={{511,174},{868,174},{868,39},{878,39}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TZon) annotation (Line(
      points={{511,170},{1028,170},{1028,39},{1038,39}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TZon) annotation (Line(
      points={{511,166},{1220,166},{1220,37},{1238,37}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.TDis, TSupCor.T) annotation (Line(points={{528,37},{522,37},
          {522,40},{514,40},{514,92},{569,92}}, color={0,0,127}));
  connect(TSupSou.T, conVAVSou.TDis) annotation (Line(points={{749,92},{688,92},
          {688,35},{698,35}}, color={0,0,127}));
  connect(TSupEas.T, conVAVEas.TDis) annotation (Line(points={{929,90},{872,90},
          {872,35},{878,35}}, color={0,0,127}));
  connect(TSupNor.T, conVAVNor.TDis) annotation (Line(points={{1089,94},{1032,94},
          {1032,35},{1038,35}},     color={0,0,127}));
  connect(TSupWes.T, conVAVWes.TDis) annotation (Line(points={{1289,90},{1228,90},
          {1228,33},{1238,33}},     color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,50},{556,50},{
          556,48},{552,48}}, color={0,0,127}));
  connect(cor.yVal, conVAVCor.yVal) annotation (Line(points={{566,34},{560,34},{
          560,43},{552,43}}, color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{722,46},{730,46},{
          730,48},{746,48}}, color={0,0,127}));
  connect(conVAVSou.yVal, sou.yVal) annotation (Line(points={{722,41},{732.5,41},
          {732.5,32},{746,32}}, color={0,0,127}));
  connect(conVAVEas.yVal, eas.yVal) annotation (Line(points={{902,41},{912.5,41},
          {912.5,32},{926,32}}, color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{902,46},{910,46},{
          910,48},{926,48}}, color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1062,46},{1072.5,46},
          {1072.5,48},{1086,48}},     color={0,0,127}));
  connect(conVAVNor.yVal, nor.yVal) annotation (Line(points={{1062,41},{1072.5,41},
          {1072.5,32},{1086,32}},     color={0,0,127}));

  connect(conVAVWes.yVal, wes.yVal) annotation (Line(points={{1262,39},{1272.5,39},
          {1272.5,32},{1286,32}},     color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,48},{1274,48},
          {1274,44},{1262,44}}, color={0,0,127}));
  connect(conAHU.TZon, flo.TRooAir) annotation (Line(points={{382,429.5},{280,
          429.5},{280,622},{1164,622},{1164,491.333},{1094.14,491.333}},
        color={0,0,127}));
  connect(conAHU.TOut, TOut.y) annotation (Line(points={{382,450.714},{-266,
          450.714},{-266,180},{-279,180}}, color={0,0,127}));
  connect(TRet.T, conAHU.TOutCut) annotation (Line(points={{100,151},{100,
          414.071},{382,414.071}},     color={0,0,127}));
  connect(conAHU.TSup, TSup.T) annotation (Line(points={{382,419.857},{152,
          419.857},{152,-20},{340,-20},{340,-29}}, color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
          {160,0},{160,439.143},{382,439.143}},     color={0,0,127}));
  connect(conAHU.TDis, TDis.y) annotation (Line(points={{382,425.643},{252,
          425.643},{252,280},{241,280}}, color={0,0,127}));
  connect(conAHU.VDis_flow, VDis_flow.y) annotation (Line(points={{382,444.929},
          {260,444.929},{260,240},{241,240}},          color={0,0,127}));
  connect(conAHU.uZonTemResReq, TZonResReq.y) annotation (Line(points={{382,
          379.357},{352,379.357},{352,370},{322,370}},   color={255,127,0}));
  connect(conVAVCor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{552,38},
          {554,38},{554,220},{280,220},{280,375.6},{298,375.6}},         color=
          {255,127,0}));
  connect(conVAVSou.yZonTemResReq, TZonResReq.u[2]) annotation (Line(points={{722,36},
          {726,36},{726,220},{280,220},{280,372.8},{298,372.8}},         color=
          {255,127,0}));
  connect(conVAVEas.yZonTemResReq, TZonResReq.u[3]) annotation (Line(points={{902,36},
          {904,36},{904,220},{280,220},{280,370},{298,370}},         color={255,
          127,0}));
  connect(conVAVNor.yZonTemResReq, TZonResReq.u[4]) annotation (Line(points={{1062,36},
          {1064,36},{1064,220},{280,220},{280,367.2},{298,367.2}},
        color={255,127,0}));
  connect(conVAVWes.yZonTemResReq, TZonResReq.u[5]) annotation (Line(points={{1262,34},
          {1266,34},{1266,220},{280,220},{280,364.4},{298,364.4}},
        color={255,127,0}));
  connect(conVAVCor.yZonPreResReq, PZonResReq.u[1]) annotation (Line(points={{552,34},
          {558,34},{558,214},{288,214},{288,345.6},{298,345.6}},         color=
          {255,127,0}));
  connect(conVAVSou.yZonPreResReq, PZonResReq.u[2]) annotation (Line(points={{722,32},
          {728,32},{728,214},{288,214},{288,342.8},{298,342.8}},         color=
          {255,127,0}));
  connect(conVAVEas.yZonPreResReq, PZonResReq.u[3]) annotation (Line(points={{902,32},
          {906,32},{906,214},{288,214},{288,340},{298,340}},         color={255,
          127,0}));
  connect(conVAVNor.yZonPreResReq, PZonResReq.u[4]) annotation (Line(points={{1062,32},
          {1066,32},{1066,214},{288,214},{288,337.2},{298,337.2}},
        color={255,127,0}));
  connect(conVAVWes.yZonPreResReq, PZonResReq.u[5]) annotation (Line(points={{1262,30},
          {1268,30},{1268,214},{288,214},{288,334.4},{298,334.4}},
        color={255,127,0}));
  connect(conAHU.uZonPreResReq, PZonResReq.y) annotation (Line(points={{382,
          373.571},{360,373.571},{360,340},{322,340}},   color={255,127,0}));
  connect(VSupCor_flow.V_flow, VDis_flow.u1[1]) annotation (Line(points={{569,130},
          {472,130},{472,206},{180,206},{180,250},{218,250}},      color={0,0,
          127}));
  connect(VSupSou_flow.V_flow, VDis_flow.u2[1]) annotation (Line(points={{749,130},
          {742,130},{742,206},{180,206},{180,245},{218,245}},      color={0,0,
          127}));
  connect(VSupEas_flow.V_flow, VDis_flow.u3[1]) annotation (Line(points={{929,128},
          {914,128},{914,206},{180,206},{180,240},{218,240}},      color={0,0,
          127}));
  connect(VSupNor_flow.V_flow, VDis_flow.u4[1]) annotation (Line(points={{1089,132},
          {1080,132},{1080,206},{180,206},{180,235},{218,235}},      color={0,0,
          127}));
  connect(VSupWes_flow.V_flow, VDis_flow.u5[1]) annotation (Line(points={{1289,128},
          {1284,128},{1284,206},{180,206},{180,230},{218,230}},      color={0,0,
          127}));
  connect(TSupCor.T, TDis.u1[1]) annotation (Line(points={{569,92},{466,92},{466,
          210},{176,210},{176,290},{218,290}},     color={0,0,127}));
  connect(TSupSou.T, TDis.u2[1]) annotation (Line(points={{749,92},{688,92},{688,
          210},{176,210},{176,285},{218,285}},                       color={0,0,
          127}));
  connect(TSupEas.T, TDis.u3[1]) annotation (Line(points={{929,90},{872,90},{872,
          210},{176,210},{176,280},{218,280}},     color={0,0,127}));
  connect(TSupNor.T, TDis.u4[1]) annotation (Line(points={{1089,94},{1032,94},{1032,
          210},{176,210},{176,275},{218,275}},      color={0,0,127}));
  connect(TSupWes.T, TDis.u5[1]) annotation (Line(points={{1289,90},{1228,90},{1228,
          210},{176,210},{176,270},{218,270}},      color={0,0,127}));
  connect(conAHU.yOutDamPos, eco.yOut) annotation (Line(points={{426,389},{450,389},
          {450,36},{-10,36},{-10,-34}},                        color={0,0,127}));
  connect(conVAVCor.VDis_flow, VSupCor_flow.V_flow) annotation (Line(points={{528,39},
          {522,39},{522,130},{569,130}}, color={0,0,127}));
  connect(VSupSou_flow.V_flow, conVAVSou.VDis_flow) annotation (Line(points={{749,130},
          {690,130},{690,37},{698,37}},      color={0,0,127}));
  connect(VSupEas_flow.V_flow, conVAVEas.VDis_flow) annotation (Line(points={{929,128},
          {874,128},{874,37},{878,37}},      color={0,0,127}));
  connect(VSupNor_flow.V_flow, conVAVNor.VDis_flow) annotation (Line(points={{1089,
          132},{1034,132},{1034,37},{1038,37}}, color={0,0,127}));
  connect(VSupWes_flow.V_flow, conVAVWes.VDis_flow) annotation (Line(points={{1289,
          128},{1230,128},{1230,35},{1238,35}}, color={0,0,127}));
  connect(TSup.T, conVAVCor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {514,-20},{514,35},{528,35}}, color={0,0,127}));
  connect(TSup.T, conVAVSou.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {686,-20},{686,33},{698,33}}, color={0,0,127}));
  connect(TSup.T, conVAVEas.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {864,-20},{864,33},{878,33}}, color={0,0,127}));
  connect(TSup.T, conVAVNor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {1028,-20},{1028,33},{1038,33}}, color={0,0,127}));
  connect(TSup.T, conVAVWes.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {1224,-20},{1224,31},{1238,31}}, color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-61,-20.9},
          {-61,396.714},{382,396.714}},    color={0,0,127}));
  connect(fanSup.y, conAHU.ySupFanSpe) annotation (Line(points={{310,-28},{310,
          -14},{460,-14},{460,441.071},{426,441.071}},     color={0,0,127}));
  connect(conAHU.yCoo, gaiCooCoi.u) annotation (Line(points={{426,416},{446,416},
          {446,-274},{88,-274},{88,-248},{98,-248}},              color={0,0,
          127}));
  connect(conAHU.TMix, TMix.T) annotation (Line(points={{382,390.929},{40,
          390.929},{40,-29}},
                    color={0,0,127}));
  connect(conAHU.yRetDamPos, eco.yRet) annotation (Line(points={{426,408.286},{
          436,408.286},{436,40},{-16.8,40},{-16.8,-34}},           color={0,0,
          127}));
  connect(yOutDam.y, eco.yExh)
    annotation (Line(points={{-18,-10},{-3,-10},{-3,-34}}, color={0,0,127}));
  connect(conAHU.yHea, swiFreSta.u3) annotation (Line(points={{426,425.643},{
          458,425.643},{458,-280},{48,-280},{48,-200},{58,-200}},  color={0,0,
          127}));
  connect(swiFreSta.y, gaiHeaCoi.u) annotation (Line(points={{82,-192},{88,-192},
          {88,-210},{98,-210}}, color={0,0,127}));
  connect(freSta.y, swiFreSta.u2) annotation (Line(points={{22,-92},{40,-92},{40,
          -192},{58,-192}},    color={255,0,255}));
  connect(yFreHeaCoi.y, swiFreSta.u1) annotation (Line(points={{22,-182},{40,-182},
          {40,-184},{58,-184}}, color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{82,317},
          {120,317},{120,462.286},{382,462.286}},      color={0,0,127}));
  connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{82,310},
          {110,310},{110,468.071},{382,468.071}},      color={0,0,127}));
  connect(TZonSet[1].yOpeMod, conVAVCor.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,180},{420,180},{420,14},{520,14},{520,33},{528,33}},
        color={255,127,0}));
  connect(flo.TRooAir, TZonSet.TZon) annotation (Line(points={{1094.14,491.333},
          {1164,491.333},{1164,628},{46,628},{46,313},{58,313}}, color={0,0,127}));
  connect(occSch.occupied, booRep.u) annotation (Line(points={{-297,-216},{-160,
          -216},{-160,290},{-122,290}}, color={255,0,255}));
  connect(occSch.tNexOcc, reaRep.u) annotation (Line(points={{-297,-204},{-180,-204},
          {-180,330},{-122,330}}, color={0,0,127}));
  connect(reaRep.y, TZonSet.tNexOcc) annotation (Line(points={{-98,330},{-20,330},
          {-20,319},{58,319}}, color={0,0,127}));
  connect(booRep.y, TZonSet.uOcc) annotation (Line(points={{-98,290},{-20,290},{
          -20,316.025},{58,316.025}}, color={255,0,255}));
  connect(TZonSet[1].TZonHeaSet, conVAVCor.TZonHeaSet) annotation (Line(points={
          {82,310},{524,310},{524,51},{528,51}}, color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conVAVCor.TZonCooSet) annotation (Line(points={
          {82,317},{524,317},{524,49},{528,49}}, color={0,0,127}));
  connect(TZonSet[2].TZonHeaSet, conVAVSou.TZonHeaSet) annotation (Line(points={
          {82,310},{694,310},{694,49},{698,49}}, color={0,0,127}));
  connect(TZonSet[2].TZonCooSet, conVAVSou.TZonCooSet) annotation (Line(points={
          {82,317},{694,317},{694,47},{698,47}}, color={0,0,127}));
  connect(TZonSet[3].TZonHeaSet, conVAVEas.TZonHeaSet) annotation (Line(points={
          {82,310},{860,310},{860,49},{878,49}}, color={0,0,127}));
  connect(TZonSet[3].TZonCooSet, conVAVEas.TZonCooSet) annotation (Line(points={
          {82,317},{860,317},{860,47},{878,47}}, color={0,0,127}));
  connect(TZonSet[4].TZonCooSet, conVAVNor.TZonCooSet) annotation (Line(points={
          {82,317},{1020,317},{1020,47},{1038,47}}, color={0,0,127}));
  connect(TZonSet[4].TZonHeaSet, conVAVNor.TZonHeaSet) annotation (Line(points={
          {82,310},{1020,310},{1020,49},{1038,49}}, color={0,0,127}));
  connect(TZonSet[5].TZonCooSet, conVAVWes.TZonCooSet) annotation (Line(points={
          {82,317},{1200,317},{1200,45},{1238,45}}, color={0,0,127}));
  connect(TZonSet[5].TZonHeaSet, conVAVWes.TZonHeaSet) annotation (Line(points={
          {82,310},{1200,310},{1200,47},{1238,47}}, color={0,0,127}));
  connect(TZonSet[1].yOpeMod, conAHU.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,385.143},{382,385.143}}, color={255,127,0}));
  connect(TZonSet[1].yOpeMod, conVAVSou.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,180},{420,180},{420,14},{680,14},{680,31},{698,31}},
        color={255,127,0}));
  connect(TZonSet[1].yOpeMod, conVAVEas.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,180},{420,180},{420,14},{860,14},{860,31},{878,31}},
        color={255,127,0}));
  connect(TZonSet[1].yOpeMod, conVAVNor.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,180},{420,180},{420,14},{1020,14},{1020,31},{1038,31}},
        color={255,127,0}));
  connect(TZonSet[1].yOpeMod, conVAVWes.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,180},{420,180},{420,14},{1220,14},{1220,29},{1238,29}},
        color={255,127,0}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1400,
            640}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>", revisions="<html>
<ul>
<li>
March 09, 2020, by Jianjun Hu:<br/>
Replaced the block that calculates operation mode and zone temperature setpoint,
with the new one that does not include vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1709\">#1709</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&circ;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(StopTime=172800, Tolerance=1e-06));
end Guideline36;
