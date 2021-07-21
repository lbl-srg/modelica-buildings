within Buildings.Examples.VAVReheat;
model Guideline36
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  extends Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop(
    redeclare replaceable Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
      final lat=lat,
      final sampleModel=sampleModel),
    amb(nPorts=3),
    damOut(
      dpDamper_nominal=10,
      dpFixed_nominal=10),
    freSta(lockoutTime=3600));

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
<<<<<<< HEAD
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
=======
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VCorOA_flow_nominal, 0.15*mCor_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mCor_flow_nominal/1.2)
    "Controller for terminal unit corridor"
    annotation (Placement(transformation(extent={{530,84},{550,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVSou(
    V_flow_nominal=mSou_flow_nominal/1.2,
    AFlo=AFloSou,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VSouOA_flow_nominal, 0.15*mSou_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mSou_flow_nominal/1.2)
    "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{702,84},{722,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVEas(
    V_flow_nominal=mEas_flow_nominal/1.2,
    AFlo=AFloEas,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VEasOA_flow_nominal, 0.15*mEas_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mEas_flow_nominal/1.2)
    "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{880,84},{900,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVNor(
    V_flow_nominal=mNor_flow_nominal/1.2,
    AFlo=AFloNor,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VNorOA_flow_nominal, 0.15*mNor_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mNor_flow_nominal/1.2)
    "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{1038,84},{1058,104}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller conVAVWes(
    V_flow_nominal=mWes_flow_nominal/1.2,
    AFlo=AFloWes,
    final samplePeriod=samplePeriod,
    VDisSetMin_flow=max(1.5*VWesOA_flow_nominal, 0.15*mWes_flow_nominal/1.2),
    VDisHeaSetMax_flow=ratVFloHea*mWes_flow_nominal/1.2)
    "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1240,84},{1260,104}})));
>>>>>>> master
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
<<<<<<< HEAD
    annotation (Placement(transformation(extent={{300,330},{320,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yOutDam(k=1)
    "Outdoor air damper control signal"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
=======
    annotation (Placement(transformation(extent={{300,320},{320,340}})));
>>>>>>> master
  Buildings.Controls.OBC.CDL.Logical.Switch swiFreSta "Switch for freeze stat"
    annotation (Placement(transformation(extent={{60,-202},{80,-182}})));
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
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller conAHU(
    final pMaxSet=410,
    final yFanMin=yFanMin,
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=1.2*sum({0.05*AFlo[i] for i in 1:numZon})) "AHU controller"
    annotation (Placement(transformation(extent={{340,512},{420,640}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[numZon](
    final AFlo=AFlo,
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon),
    final desZonPop={0.05*AFlo[i] for i in 1:numZon},
    final minZonPriFlo=minZonPriFlo)
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{220,580},{240,600}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=numZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{280,570},{300,590}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(final nout=numZon)
    "Replicate design uncorrected minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{460,580},{480,600}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep1(final nout=numZon)
    "Replicate signal whether the outdoor airflow is required"
    annotation (Placement(transformation(extent={{460,550},{480,570}})));

equation
  connect(conVAVCor.TZon, TRooAir.y5[1]) annotation (Line(
<<<<<<< HEAD
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
  connect(conVAVCor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{552,38},
          {554,38},{554,220},{280,220},{280,375.6},{298,375.6}},         color=
=======
      points={{528,94},{520,94},{520,275},{480,275}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TZon, TRooAir.y1[1]) annotation (Line(
      points={{700,94},{656,94},{656,40},{680,40},{680,275},{496,275}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TZon) annotation (Line(
      points={{492,275},{868,275},{868,94},{878,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TZon) annotation (Line(
      points={{488,275},{1028,275},{1028,94},{1036,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TZon) annotation (Line(
      points={{484,275},{1220,275},{1220,94},{1238,94}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.TDis, cor.TSup) annotation (Line(points={{528,88},{466,88},{
          466,74},{620,74},{620,50},{612,50}},  color={0,0,127}));
  connect(sou.TSup, conVAVSou.TDis) annotation (Line(points={{792,48},{800,48},{
          800,72},{684,72},{684,88},{700,88}},
                              color={0,0,127}));
  connect(eas.TSup, conVAVEas.TDis) annotation (Line(points={{972,48},{980,48},{
          980,74},{870,74},{870,88},{878,88}},
                              color={0,0,127}));
  connect(nor.TSup, conVAVNor.TDis) annotation (Line(points={{1132,48},{1140,48},
          {1140,74},{1032,74},{1032,88},{1036,88}},
                                    color={0,0,127}));
  connect(wes.TSup, conVAVWes.TDis) annotation (Line(points={{1332,48},{1340,48},
          {1340,74},{1228,74},{1228,88},{1238,88}},
                                    color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,54},{556,54},{
          556,100},{552,100}},
                             color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{724,100},{730,100},
          {730,52},{746,52}},color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{902,100},{910,100},
          {910,52},{926,52}},color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1060,100},{1072.5,
          100},{1072.5,52},{1086,52}},color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,52},{1274,52},
          {1274,100},{1262,100}},
                                color={0,0,127}));
  connect(conVAVCor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{552,90},
          {554,90},{554,220},{280,220},{280,375.6},{298,375.6}},         color=
>>>>>>> master
          {255,127,0}));
  connect(conVAVSou.yZonTemResReq, TZonResReq.u[2]) annotation (Line(points={{724,90},
          {726,90},{726,220},{280,220},{280,372.8},{298,372.8}},         color=
          {255,127,0}));
  connect(conVAVEas.yZonTemResReq, TZonResReq.u[3]) annotation (Line(points={{902,90},
          {904,90},{904,220},{280,220},{280,370},{298,370}},         color={255,
          127,0}));
  connect(conVAVNor.yZonTemResReq, TZonResReq.u[4]) annotation (Line(points={{1060,90},
          {1064,90},{1064,220},{280,220},{280,367.2},{298,367.2}},
        color={255,127,0}));
  connect(conVAVWes.yZonTemResReq, TZonResReq.u[5]) annotation (Line(points={{1262,90},
          {1266,90},{1266,220},{280,220},{280,364.4},{298,364.4}},
        color={255,127,0}));
<<<<<<< HEAD
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
  connect(yOutDam.y, eco.yExh)
    annotation (Line(points={{-18,-10},{-3,-10},{-3,-34}}, color={0,0,127}));
=======
  connect(conVAVCor.yZonPreResReq, PZonResReq.u[1]) annotation (Line(points={{552,86},
          {558,86},{558,214},{288,214},{288,335.6},{298,335.6}},         color=
          {255,127,0}));
  connect(conVAVSou.yZonPreResReq, PZonResReq.u[2]) annotation (Line(points={{724,86},
          {728,86},{728,214},{288,214},{288,332.8},{298,332.8}},         color=
          {255,127,0}));
  connect(conVAVEas.yZonPreResReq, PZonResReq.u[3]) annotation (Line(points={{902,86},
          {906,86},{906,214},{288,214},{288,330},{298,330}},         color={255,
          127,0}));
  connect(conVAVNor.yZonPreResReq, PZonResReq.u[4]) annotation (Line(points={{1060,86},
          {1066,86},{1066,214},{288,214},{288,327.2},{298,327.2}},
        color={255,127,0}));
  connect(conVAVWes.yZonPreResReq, PZonResReq.u[5]) annotation (Line(points={{1262,86},
          {1268,86},{1268,214},{288,214},{288,324.4},{298,324.4}},
        color={255,127,0}));
  connect(cor.VSup_flow, VDis_flow.u1[1]) annotation (Line(points={{612,58},{620,
          58},{620,74},{472,74},{472,206},{180,206},{180,340},{218,340}},
                                                                   color={0,0,
          127}));
  connect(sou.VSup_flow, VDis_flow.u2[1]) annotation (Line(points={{792,56},{800,
          56},{800,72},{744,72},{744,216},{182,216},{182,335},{218,335}},
                                                                   color={0,0,
          127}));
  connect(eas.VSup_flow, VDis_flow.u3[1]) annotation (Line(points={{972,56},{980,
          56},{980,74},{914,74},{914,206},{180,206},{180,330},{218,330}},
                                                                   color={0,0,
          127}));
  connect(nor.VSup_flow, VDis_flow.u4[1]) annotation (Line(points={{1132,56},{1140,
          56},{1140,74},{1082,74},{1082,206},{180,206},{180,325},{218,325}},
                                                                     color={0,0,
          127}));
  connect(wes.VSup_flow, VDis_flow.u5[1]) annotation (Line(points={{1332,56},{1340,
          56},{1340,74},{1286,74},{1286,204},{164,204},{164,320},{218,320}},
                                                                     color={0,0,
          127}));
  connect(cor.TSup, TDis.u1[1]) annotation (Line(points={{612,50},{620,50},{620,
          74},{466,74},{466,230},{176,230},{176,380},{218,380}},
                                                   color={0,0,127}));
  connect(sou.TSup, TDis.u2[1]) annotation (Line(points={{792,48},{800,48},{800,
          72},{688,72},{688,210},{176,210},{176,375},{218,375}},     color={0,0,
          127}));
  connect(eas.TSup, TDis.u3[1]) annotation (Line(points={{972,48},{980,48},{980,
          74},{872,74},{872,210},{176,210},{176,370},{218,370}},
                                                   color={0,0,127}));
  connect(nor.TSup, TDis.u4[1]) annotation (Line(points={{1132,48},{1140,48},{1140,
          74},{1032,74},{1032,210},{176,210},{176,365},{218,365}},
                                                    color={0,0,127}));
  connect(wes.TSup, TDis.u5[1]) annotation (Line(points={{1332,48},{1340,48},{1340,
          74},{1228,74},{1228,210},{176,210},{176,360},{218,360}},
                                                    color={0,0,127}));
  connect(conVAVCor.VDis_flow, cor.VSup_flow) annotation (Line(points={{528,92},
          {522,92},{522,74},{620,74},{620,58},{612,58}},
                                         color={0,0,127}));
  connect(sou.VSup_flow, conVAVSou.VDis_flow) annotation (Line(points={{792,56},
          {800,56},{800,72},{690,72},{690,92},{700,92}},
                                             color={0,0,127}));
  connect(eas.VSup_flow, conVAVEas.VDis_flow) annotation (Line(points={{972,56},
          {980,56},{980,74},{874,74},{874,92},{878,92}},
                                             color={0,0,127}));
  connect(nor.VSup_flow, conVAVNor.VDis_flow) annotation (Line(points={{1132,56},
          {1140,56},{1140,74},{1034,74},{1034,92},{1036,92}},
                                                color={0,0,127}));
  connect(wes.VSup_flow, conVAVWes.VDis_flow) annotation (Line(points={{1332,56},
          {1340,56},{1340,74},{1230,74},{1230,92},{1238,92}},
                                                color={0,0,127}));
  connect(TSup.T, conVAVCor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {462,-20},{462,86},{528,86}}, color={0,0,127}));
  connect(TSup.T, conVAVSou.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {624,-20},{624,86},{700,86}}, color={0,0,127}));
  connect(TSup.T, conVAVEas.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {806,-20},{806,86},{878,86}}, color={0,0,127}));
  connect(TSup.T, conVAVNor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {986,-20},{986,86},{1036,86}},   color={0,0,127}));
  connect(TSup.T, conVAVWes.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {1168,-20},{1168,86},{1238,86}}, color={0,0,127}));
>>>>>>> master
  connect(swiFreSta.y, gaiHeaCoi.u) annotation (Line(points={{82,-192},{88,-192},
          {88,-184},{124,-184}},color={0,0,127}));
  connect(yFreHeaCoi.y, swiFreSta.u1) annotation (Line(points={{22,-182},{40,-182},
          {40,-184},{58,-184}}, color={0,0,127}));
  connect(TZonSet[1].yOpeMod, conVAVCor.uOpeMod) annotation (Line(points={{82,303},
          {130,303},{130,180},{420,180},{420,14},{520,14},{520,33},{528,33}},
        color={255,127,0}));
  connect(flo.TRooAir, TZonSet.TZon) annotation (Line(points={{1094.14,491.333},
          {1164,491.333},{1164,662},{46,662},{46,313},{58,313}}, color={0,0,127}));
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
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{302,589},
          {308,589},{308,609.778},{336,609.778}},           color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{302,586},{310,586},{310,604.444},{336,604.444}},
        color={0,0,127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{302,583},{312,583},{312,599.111},{336,599.111}},
        color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{302,580},
          {314,580},{314,593.778},{336,593.778}},           color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{302,577},{316,577},{316,588.444},{336,588.444}}, color={0,0,
          127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{302,571},{318,571},{318,583.111},{336,583.111}}, color={0,0,
          127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{302,574},{320,574},{320,577.778},{336,577.778}}, color={0,0,127}));
  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{242,599},{270,599},{270,588},{278,588}},     color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{242,596},{268,596},{268,586},{278,586}},
                                                     color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{242,593},{266,593},{266,584},{278,584}},
        color={0,0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{242,590},{264,590},{264,578},{278,578}},     color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{242,587},{262,587},{262,576},{278,576}},     color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{242,584},{260,584},{260,574},{278,574}},
                                                     color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{242,581},{258,581},{258,572},{278,572}},     color={0,0,127}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{424,586.667},{440,586.667},{440,468},{270,468},{270,582},{278,
          582}},
        color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, reaRep1.u) annotation (Line(points={{424,
          597.333},{440,597.333},{440,590},{458,590}},
                                              color={0,0,127}));
  connect(reaRep1.y, zonOutAirSet.VUncOut_flow_nominal) annotation (Line(points={{482,590},
          {490,590},{490,464},{210,464},{210,581},{218,581}},          color={0,
          0,127}));
  connect(conAHU.yReqOutAir, booRep1.u) annotation (Line(points={{424,565.333},
          {444,565.333},{444,560},{458,560}},color={255,0,255}));
  connect(booRep1.y, zonOutAirSet.uReqOutAir) annotation (Line(points={{482,560},
          {496,560},{496,460},{206,460},{206,593},{218,593}}, color={255,0,255}));
<<<<<<< HEAD
  connect(flo.TRooAir, zonOutAirSet.TZon) annotation (Line(points={{1094.14,
          491.333},{1164,491.333},{1164,660},{210,660},{210,590},{218,590}},
                                                                    color={0,0,127}));
  connect(TDis.y, zonOutAirSet.TDis) annotation (Line(points={{241,280},{252,280},
          {252,340},{200,340},{200,587},{218,587}}, color={0,0,127}));
  connect(VDis_flow.y, zonOutAirSet.VDis_flow) annotation (Line(points={{241,240},
          {260,240},{260,346},{194,346},{194,584},{218,584}}, color={0,0,127}));
  connect(TZonSet[1].yOpeMod, conAHU.uOpeMod) annotation (Line(points={{82,303},
          {140,303},{140,531.556},{336,531.556}}, color={255,127,0}));
=======
  connect(flo.TRooAir, zonOutAirSet.TZon) annotation (Line(points={{1107.13,506},
          {1164,506},{1164,660},{210,660},{210,590},{218,590}},     color={0,0,127}));
  connect(TDis.y, zonOutAirSet.TDis) annotation (Line(points={{241,370},{252,
          370},{252,414},{200,414},{200,587},{218,587}},
                                                    color={0,0,127}));
  connect(VDis_flow.y, zonOutAirSet.VDis_flow) annotation (Line(points={{241,330},
          {260,330},{260,420},{194,420},{194,584},{218,584}}, color={0,0,127}));
>>>>>>> master
  connect(TZonResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{322,370},
          {330,370},{330,526.222},{336,526.222}}, color={255,127,0}));
  connect(PZonResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{322,340},
          {326,340},{326,520.889},{336,520.889}}, color={255,127,0}));
  connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{82,310},
          {110,310},{110,636.444},{336,636.444}},      color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{82,317},
          {120,317},{120,631.111},{336,631.111}},      color={0,0,127}));
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-279,180},{-260,180},{
          -260,625.778},{336,625.778}},
                                   color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
          {160,0},{160,620.444},{336,620.444}}, color={0,0,127}));
  connect(TSup.T, conAHU.TSup) annotation (Line(points={{340,-29},{340,-20},{
          152,-20},{152,567.111},{336,567.111}},
                                             color={0,0,127}));
  connect(TRet.T, conAHU.TOutCut) annotation (Line(points={{100,151},{100,
          561.778},{336,561.778}},
                          color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-80,-29},{
          -80,-20},{-60,-20},{-60,546},{138,546},{138,545.778},{336,545.778}},
                                       color={0,0,127}));
  connect(TMix.T, conAHU.TMix) annotation (Line(points={{40,-29},{40,538.667},{
          336,538.667}},
                     color={0,0,127}));
  connect(conAHU.yOutDamPos, damOut.y) annotation (Line(points={{424,522.667},{
          448,522.667},{448,36},{-40,36},{-40,-28}},
                                                 color={0,0,127}));
  connect(conAHU.yRetDamPos, damRet.y) annotation (Line(points={{424,533.333},{
          442,533.333},{442,40},{-20,40},{-20,-10},{-12,-10}},
                                                     color={0,0,127}));
  connect(conAHU.yCoo, gaiCooCoi.u) annotation (Line(points={{424,544},{452,544},
          {452,-274},{222,-274},{222,-186}},         color={0,0,127}));
  connect(conAHU.yHea, swiFreSta.u3) annotation (Line(points={{424,554.667},{
          458,554.667},{458,-280},{40,-280},{40,-200},{58,-200}},
                                                              color={0,0,127}));
  connect(conAHU.ySupFanSpe, fanSup.y) annotation (Line(points={{424,618.667},{
          432,618.667},{432,-14},{310,-14},{310,-28}},
                                                   color={0,0,127}));
<<<<<<< HEAD
=======
  connect(cor.y_actual,conVAVCor.yDam_actual)  annotation (Line(points={{612,42},
          {620,42},{620,74},{518,74},{518,90},{528,90}}, color={0,0,127}));
  connect(sou.y_actual,conVAVSou.yDam_actual)  annotation (Line(points={{792,40},
          {800,40},{800,72},{684,72},{684,90},{700,90}}, color={0,0,127}));
  connect(eas.y_actual,conVAVEas.yDam_actual)  annotation (Line(points={{972,40},
          {980,40},{980,74},{864,74},{864,90},{878,90}}, color={0,0,127}));
  connect(nor.y_actual,conVAVNor.yDam_actual)  annotation (Line(points={{1132,40},
          {1140,40},{1140,74},{1024,74},{1024,90},{1036,90}},     color={0,0,
          127}));
  connect(wes.y_actual,conVAVWes.yDam_actual)  annotation (Line(points={{1332,40},
          {1340,40},{1340,74},{1224,74},{1224,90},{1238,90}},     color={0,0,
          127}));
  connect(warCooTim.y, zonSta.cooDowTim) annotation (Line(points={{-278,380},{-240,
          380},{-240,290},{-222,290}}, color={0,0,127}));
  connect(warCooTim.y, zonSta.warUpTim) annotation (Line(points={{-278,380},{-240,
          380},{-240,286},{-222,286}}, color={0,0,127}));
  connect(flo.TRooAir, zonSta.TZon) annotation (Line(points={{1107.13,506},{
          1164,506},{1164,660},{-250,660},{-250,274},{-222,274}},      color={0,
          0,127}));
  connect(zonSta.yCooTim, zonGroSta.uCooTim) annotation (Line(points={{-198,295},
          {-176,295},{-176,291},{-162,291}}, color={0,0,127}));
  connect(zonSta.yWarTim, zonGroSta.uWarTim) annotation (Line(points={{-198,293},
          {-178,293},{-178,289},{-162,289}}, color={0,0,127}));
  connect(zonSta.yOccHeaHig, zonGroSta.uOccHeaHig) annotation (Line(points={{-198,
          288},{-180,288},{-180,285},{-162,285}}, color={255,0,255}));
  connect(zonSta.yHigOccCoo, zonGroSta.uHigOccCoo)
    annotation (Line(points={{-198,283},{-162,283}}, color={255,0,255}));
  connect(zonSta.THeaSetOff, zonGroSta.THeaSetOff) annotation (Line(points={{-198,
          280},{-182,280},{-182,277},{-162,277}}, color={0,0,127}));
  connect(zonSta.yUnoHeaHig, zonGroSta.uUnoHeaHig) annotation (Line(points={{-198,
          278},{-188,278},{-188,279},{-162,279}}, color={255,0,255}));
  connect(zonSta.yEndSetBac, zonGroSta.uEndSetBac) annotation (Line(points={{-198,
          276},{-188,276},{-188,275},{-162,275}}, color={255,0,255}));
  connect(zonSta.TCooSetOff, zonGroSta.TCooSetOff) annotation (Line(points={{-198,
          273},{-190,273},{-190,269},{-162,269}}, color={0,0,127}));
  connect(zonSta.yHigUnoCoo, zonGroSta.uHigUnoCoo)
    annotation (Line(points={{-198,271},{-162,271}}, color={255,0,255}));
  connect(zonSta.yEndSetUp, zonGroSta.uEndSetUp) annotation (Line(points={{-198,
          269},{-192,269},{-192,267},{-162,267}}, color={255,0,255}));
  connect(flo.TRooAir, zonGroSta.TZon) annotation (Line(points={{1107.13,506},{
          1164,506},{1164,660},{-250,660},{-250,263},{-162,263}},
        color={0,0,127}));
  connect(falSta.y, zonGroSta.uWin) annotation (Line(points={{-278,340},{-172,
          340},{-172,261},{-162,261}}, color={255,0,255}));
  connect(occSch.tNexOcc, reaRep.u) annotation (Line(points={{-297,-204},{-236,
          -204},{-236,-180},{-202,-180}}, color={0,0,127}));
  connect(reaRep.y, zonGroSta.tNexOcc) annotation (Line(points={{-178,-180},{-164,
          -180},{-164,295},{-162,295}}, color={0,0,127}));
  connect(occSch.occupied, booRep.u) annotation (Line(points={{-297,-216},{-220,
          -216},{-220,-140},{-202,-140}}, color={255,0,255}));
  connect(booRep.y, zonGroSta.uOcc) annotation (Line(points={{-178,-140},{-166,
          -140},{-166,297},{-162,297}}, color={255,0,255}));
  connect(falSta.y, zonGroSta.zonOcc) annotation (Line(points={{-278,340},{-172,
          340},{-172,299},{-162,299}}, color={255,0,255}));
  connect(zonGroSta.uGroOcc, opeModSel.uOcc) annotation (Line(points={{-138,299},
          {-136,299},{-136,314},{-102,314}}, color={255,0,255}));
  connect(zonGroSta.nexOcc, opeModSel.tNexOcc) annotation (Line(points={{-138,
          297},{-134,297},{-134,312},{-102,312}}, color={0,0,127}));
  connect(zonGroSta.yCooTim, opeModSel.maxCooDowTim) annotation (Line(points={{
          -138,293},{-132,293},{-132,310},{-102,310}}, color={0,0,127}));
  connect(zonGroSta.yWarTim, opeModSel.maxWarUpTim) annotation (Line(points={{-138,
          291},{-128,291},{-128,306},{-102,306}}, color={0,0,127}));
  connect(zonGroSta.yOccHeaHig, opeModSel.uOccHeaHig) annotation (Line(points={
          {-138,287},{-126,287},{-126,304},{-102,304}}, color={255,0,255}));
  connect(zonGroSta.yHigOccCoo, opeModSel.uHigOccCoo) annotation (Line(points={
          {-138,285},{-130,285},{-130,308},{-102,308}}, color={255,0,255}));
  connect(zonGroSta.yColZon, opeModSel.totColZon) annotation (Line(points={{-138,
          282},{-122,282},{-122,300},{-102,300}}, color={255,127,0}));
  connect(zonGroSta.ySetBac, opeModSel.uSetBac) annotation (Line(points={{-138,280},
          {-120,280},{-120,298},{-102,298}},      color={255,0,255}));
  connect(zonGroSta.yEndSetBac, opeModSel.uEndSetBac) annotation (Line(points={{-138,
          278},{-118,278},{-118,296},{-102,296}},       color={255,0,255}));
  connect(zonGroSta.TZonMax, opeModSel.TZonMax) annotation (Line(points={{-138,267},
          {-116,267},{-116,294},{-102,294}},      color={0,0,127}));
  connect(zonGroSta.TZonMin, opeModSel.TZonMin) annotation (Line(points={{-138,265},
          {-114,265},{-114,292},{-102,292}},      color={0,0,127}));
  connect(zonGroSta.yHotZon, opeModSel.totHotZon) annotation (Line(points={{-138,
          275},{-112,275},{-112,290},{-102,290}}, color={255,127,0}));
  connect(zonGroSta.ySetUp, opeModSel.uSetUp) annotation (Line(points={{-138,273},
          {-110,273},{-110,288},{-102,288}},      color={255,0,255}));
  connect(zonGroSta.yEndSetUp, opeModSel.uEndSetUp) annotation (Line(points={{-138,
          271},{-108,271},{-108,286},{-102,286}}, color={255,0,255}));
  connect(zonSta.THeaSetOn, TZonSet.TZonHeaSetOcc) annotation (Line(points={{
          -198,290},{-186,290},{-186,198},{-102,198}}, color={0,0,127}));
  connect(zonSta.THeaSetOff, TZonSet.TZonHeaSetUno) annotation (Line(points={{
          -198,280},{-182,280},{-182,196},{-102,196}}, color={0,0,127}));
  connect(zonSta.TCooSetOn, TZonSet.TZonCooSetOcc) annotation (Line(points={{
          -198,285},{-184,285},{-184,203},{-102,203}}, color={0,0,127}));
  connect(zonSta.TCooSetOff, TZonSet.TZonCooSetUno) annotation (Line(points={{
          -198,273},{-190,273},{-190,201},{-102,201}}, color={0,0,127}));
  connect(demLimLev.y, TZonSet.uCooDemLimLev) annotation (Line(points={{-278,
          240},{-220,240},{-220,188},{-102,188}}, color={255,127,0}));
  connect(demLimLev.y, TZonSet.uHeaDemLimLev) annotation (Line(points={{-278,
          240},{-220,240},{-220,186},{-102,186}}, color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVCor.uOpeMod) annotation (Line(points={{-78,300},
          {-16,300},{-16,76},{506,76},{506,84},{528,84}},      color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVSou.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{676,76},{676,84},{700,84}},      color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVEas.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{860,76},{860,84},{878,84}},      color={255,127,0}));
  connect(opeModSel.yOpeMod, conVAVNor.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{1020,76},{1020,84},{1036,84}},      color={255,
          127,0}));
  connect(opeModSel.yOpeMod, conVAVWes.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,76},{1216,76},{1216,84},{1238,84}},      color={255,
          127,0}));
  connect(opeModSel.yOpeMod, conAHU.uOpeMod) annotation (Line(points={{-78,300},
          {-18,300},{-18,531.556},{336,531.556}}, color={255,127,0}));
  connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{-78,194},
          {-36,194},{-36,636.444},{336,636.444}},          color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{-78,202},
          {-26,202},{-26,631.111},{336,631.111}},          color={0,0,127}));
  connect(TZonSet[1].TZonHeaSet, conVAVCor.TZonHeaSet) annotation (Line(points={{-78,194},
          {482,194},{482,104},{528,104}},          color={0,0,127}));
  connect(TZonSet[2].TZonHeaSet, conVAVSou.TZonHeaSet) annotation (Line(points={{-78,194},
          {672,194},{672,104},{700,104}},          color={0,0,127}));
  connect(TZonSet[3].TZonHeaSet, conVAVEas.TZonHeaSet) annotation (Line(points={{-78,194},
          {852,194},{852,104},{878,104}},          color={0,0,127}));
  connect(TZonSet[4].TZonHeaSet, conVAVNor.TZonHeaSet) annotation (Line(points={{-78,194},
          {1016,194},{1016,104},{1036,104}},          color={0,0,127}));
  connect(TZonSet[5].TZonHeaSet, conVAVWes.TZonHeaSet) annotation (Line(points={{-78,194},
          {1186,194},{1186,104},{1238,104}},          color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conVAVCor.TZonCooSet) annotation (Line(points={{-78,202},
          {476,202},{476,102},{528,102}},          color={0,0,127}));
  connect(TZonSet[2].TZonCooSet, conVAVSou.TZonCooSet) annotation (Line(points={{-78,202},
          {666,202},{666,102},{700,102}},          color={0,0,127}));
  connect(TZonSet[3].TZonCooSet, conVAVEas.TZonCooSet) annotation (Line(points={{-78,202},
          {844,202},{844,102},{878,102}},          color={0,0,127}));
  connect(TZonSet[4].TZonCooSet, conVAVNor.TZonCooSet) annotation (Line(points={{-78,202},
          {1010,202},{1010,102},{1036,102}},          color={0,0,127}));
  connect(TZonSet[5].TZonCooSet, conVAVWes.TZonCooSet) annotation (Line(points={{-78,202},
          {1180,202},{1180,102},{1238,102}},          color={0,0,127}));
  connect(opeModSel.yOpeMod, intRep.u) annotation (Line(points={{-78,300},{-18,
          300},{-18,250},{-160,250},{-160,230},{-142,230}}, color={255,127,0}));
  connect(intRep.y, TZonSet.uOpeMod) annotation (Line(points={{-118,230},{-110,
          230},{-110,207},{-102,207}}, color={255,127,0}));
  connect(zonGroSta.yOpeWin, opeModSel.uOpeWin) annotation (Line(points={{-138,261},
          {-124,261},{-124,302},{-102,302}}, color={255,127,0}));
  connect(conVAVCor.yVal, gaiHeaCoiCor.u)
    annotation (Line(points={{552,95},{552,68},{478,68},{478,46},{492,46}},
                                                           color={0,0,127}));
  connect(conVAVSou.yVal, gaiHeaCoiSou.u) annotation (Line(points={{724,95},{724,
          68},{664,68},{664,44},{678,44}},
                                  color={0,0,127}));
  connect(conVAVEas.yVal, gaiHeaCoiEas.u) annotation (Line(points={{902,95},{902,
          80},{838,80},{838,44},{850,44}},
                                  color={0,0,127}));
  connect(conVAVNor.yVal, gaiHeaCoiNor.u) annotation (Line(points={{1060,95},{1060,
          80},{1008,80},{1008,44},{1016,44}},
                                    color={0,0,127}));
  connect(conVAVWes.yVal, gaiHeaCoiWes.u) annotation (Line(points={{1262,95},{1262,
          82},{1196,82},{1196,44},{1206,44}},
                                    color={0,0,127}));
  connect(amb.ports[3], TRet.port_b) annotation (Line(points={{-114,-45},{-100,
          -45},{-100,140},{90,140}}, color={0,127,255}));
  connect(freSta.y, swiFreSta.u2) annotation (Line(points={{-38,-90},{40,-90},{
          40,-192},{58,-192}}, color={255,0,255}));
>>>>>>> master
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1400,
            680}})),
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
<<<<<<< HEAD
=======
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.
<br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 15, 2021, by David Blum:<br/>
Change component name <code>yOutDam</code> to <code>yExhDam</code>
and update documentation graphic to include relief damper.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2399\">#2399</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed design and control parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
</li>
<li>
June 15, 2020, by Jianjun Hu:<br/>
Upgraded sequence of specifying operating mode according to G36 official release.
</li>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for terminal controller.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">issue #1873</a>
</li>
<li>
>>>>>>> master
March 20, 2020, by Jianjun Hu:<br/>
Replaced the AHU controller with reimplemented one. The new controller separates the
zone level calculation from the system level calculation and does not include
vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1829\">#1829</a>.
</li>
<li>
March 09, 2020, by Jianjun Hu:<br/>
Replaced the block that calculates operation mode and zone temperature setpoint,
with the new one that does not include vector-valued calculations.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1709\">#1709</a>.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
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
    experiment(StopTime=172800, Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Guideline36;
