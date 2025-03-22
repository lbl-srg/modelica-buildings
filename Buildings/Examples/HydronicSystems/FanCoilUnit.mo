within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  extends Modelica.Icons.Example;
  replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium model for air";
 replaceable package MediumW = Buildings.Media.Water "Medium model";
   //replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    //"Medium model of air";
  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model of hot water";
  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model of chilled water";



  ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor floor1(
      redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{6,78},{84,122}})));

  Fluid.ZoneEquipment.FanCoilUnit.FourPipe fanCoiUni[5](
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.21805,0.53883,0.33281,0.50946,0.33236},
    dpAir_nominal=100,
    UAHeaCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06},
    mChiWat_flow_nominal={0.23106,0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06},
    mAirOut_flow_nominal=0.000000001,
    mAir_flow_nominal={0.09,0.222,0.1337,0.21303,0.137},
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52},
    each fanPer=fanPer)
    annotation (Placement(transformation(extent={{20,16},{40,36}})));

  Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU[5](each TSupSet_max=
        308.15, each TSupSet_min=285.85)
    annotation (Placement(transformation(extent={{-52,-34},{-2,54}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat[5](each filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=333.15,
    nPorts=5) "Source for heating coil" annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={11,-49})));
  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=328.15,
    nPorts=5) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={-11,-49})));
  Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=288.15,
    nPorts=5) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={31,-49})));
  Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=5) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={51,-49})));
  Controls.SetPoints.OccupancySchedule           occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-140,28},{-120,48}})));
  Modelica.Blocks.Sources.Constant SetAdj(k=0)
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Controls.OBC.CDL.Reals.Sources.Constant TOccSetPoi(k=23 + 273.15)
    annotation (Placement(transformation(extent={{-140,-2},{-120,18}})));
  Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(k=25 + 273.15)
    annotation (Placement(transformation(extent={{-138,-40},{-118,-20}})));
  Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(k=21 + 273.15)
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=5)
    annotation (Placement(transformation(extent={{-108,56},{-88,76}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(nout=5)
    annotation (Placement(transformation(extent={{-112,110},{-92,130}})));
  Controls.OBC.CDL.Reals.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{54,10},{74,30}})));
  Controls.OBC.CDL.Logical.Timer tim(t=120)
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=5)
    annotation (Placement(transformation(extent={{112,10},{132,30}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(nout=5)
    annotation (Placement(transformation(extent={{-110,84},{-90,104}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(nout=5)
    annotation (Placement(transformation(extent={{-108,30},{-88,50}})));
  Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=5)
    annotation (Placement(transformation(extent={{-108,4},{-88,24}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep4(nout=5)
    annotation (Placement(transformation(extent={{-110,-24},{-90,-4}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep5(nout=5)
    annotation (Placement(transformation(extent={{-100,-52},{-80,-32}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep6(nout=5)
    annotation (Placement(transformation(extent={{-108,-78},{-88,-58}})));
  Controls.OBC.CDL.Integers.Sources.Constant LimLev(k=0)
    annotation (Placement(transformation(extent={{-140,58},{-120,78}})));
  replaceable parameter Fluid.Movers.Data.Generic           fanPer
    constrainedby Fluid.Movers.Data.Generic
    "Record with performance data for supply fan"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-38,80},{-20,98}})),
      Dialog(group="Fan parameters"));
protected
  Controls.OBC.CDL.Reals.Sources.Constant           cooWarTim(final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
equation
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{0.5,27.6},{18,
          27.6},{18,28},{19,28}},
                              color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{0.5,10},{8,
          10},{8,24},{19,24}},           color={0,0,127}));
  connect(conFCU.yHeaCoi, fanCoiUni.uHea) annotation (Line(points={{0.5,14.4},{
          18,14.4},{18,20},{19,20}},    color={0,0,127}));
  connect(intScaRep.y, conFCU.uCooDemLimLev) annotation (Line(points={{-86,66},
          {-76,66},{-76,12},{-62,12},{-62,16.6},{-54.5,16.6}},
                                                       color={255,127,0}));
  connect(intScaRep.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-86,66},
          {-76,66},{-76,12.2},{-54.5,12.2}},                             color=
          {255,127,0}));
  connect(cooWarTim.y, reaScaRep1.u) annotation (Line(points={{-118,130},{-118,
          126},{-114,126},{-114,120}},
                                     color={0,0,127}));
  connect(reaScaRep1.y, conFCU.warUpTim) annotation (Line(points={{-90,120},{
          -66,120},{-66,96},{-62,96},{-62,49.6},{-54.5,49.6}},
                                      color={0,0,127}));
  connect(reaScaRep1.y, conFCU.cooDowTim) annotation (Line(points={{-90,120},{
          -66,120},{-66,96},{-62,96},{-62,45.2},{-54.5,45.2}},
                                      color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{76,20},{78,20}},
               color={255,0,255}));
  connect(fanCoiUni[1].yFan_actual, greThr.u) annotation (Line(points={{40.5,34},
          {44,34},{44,20},{52,20}},       color={0,0,127}));
  connect(tim.passed, booScaRep.u)
    annotation (Line(points={{102,12},{104,12},{104,20},{110,20}},
                                                        color={255,0,255}));
  connect(booScaRep.y, conFCU.u1Fan) annotation (Line(points={{134,20},{142,20},
          {142,-64},{-54,-64},{-54,-38},{-60,-38},{-60,-32},{-62,-32},{-62,-23},
          {-54.5,-23}},                 color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{41,21.2},{
          44,21.2},{44,-4},{66,-4},{66,-62},{-70,-62},{-70,7.8},{-54.5,7.8}},
                                                            color={0,0,127}));
  connect(SetAdj.y, reaScaRep2.u)
    annotation (Line(points={{-119,100},{-114,100},{-114,94},{-112,94}},
                                                     color={0,0,127}));
  connect(reaScaRep2.y, conFCU.setAdj) annotation (Line(points={{-88,94},{-64,
          94},{-64,34.2},{-54.75,34.2}},
                                  color={0,0,127}));
  connect(occSch.tNexOcc, reaScaRep3.u) annotation (Line(points={{-119,44},{
          -112,44},{-112,40},{-110,40}},      color={0,0,127}));
  connect(reaScaRep3.y, conFCU.tNexOcc) annotation (Line(points={{-86,40},{-84,
          40.8},{-54.5,40.8}},               color={0,0,127}));
  connect(occSch.occupied, booScaRep1.u) annotation (Line(points={{-119,32},{
          -116,32},{-116,14},{-110,14}},
                                     color={255,0,255}));
  connect(booScaRep1.y, conFCU.u1Occ) annotation (Line(points={{-86,14},{-64,14},
          {-64,21.22},{-54.5,21.22}},  color={255,0,255}));
  connect(TOccSetPoi.y, reaScaRep4.u) annotation (Line(points={{-118,8},{-118,
          -14},{-112,-14}},                color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccHeaSet) annotation (Line(points={{-88,-14},{
          -64,-14},{-64,-6},{-62,-6},{-62,-1},{-54.5,-1}},    color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccCooSet) annotation (Line(points={{-88,-14},{
          -64,-14},{-64,-5.4},{-54.5,-5.4}},
                                          color={0,0,127}));
  connect(TUnOccCooSet.y, reaScaRep5.u)
    annotation (Line(points={{-116,-30},{-108,-30},{-108,-42},{-102,-42}},
                                                        color={0,0,127}));
  connect(reaScaRep5.y, conFCU.TUnoCooSet) annotation (Line(points={{-78,-42},{
          -64,-42},{-64,-16},{-62,-16},{-62,-14.2},{-54.5,-14.2}},
                                          color={0,0,127}));
  connect(TUnOccHeaSet.y, reaScaRep6.u) annotation (Line(points={{-118,-70},{
          -112,-70},{-112,-68},{-110,-68}},
                                   color={0,0,127}));
  connect(reaScaRep6.y, conFCU.TUnoHeaSet) annotation (Line(points={{-86,-68},{
          -68,-68},{-68,-9.8},{-54.5,-9.8}},
                                          color={0,0,127}));
  connect(weaDat[1].weaBus, floor1.weaBus) annotation (Line(
      points={{-40,110},{0,110},{0,134},{55.1739,134},{55.1739,128.769}},
      color={255,204,51},
      thickness=0.5));

  connect(LimLev.y, intScaRep.u)
    annotation (Line(points={{-118,68},{-118,76},{-110,76},{-110,66}},
                                                       color={255,127,0}));
  connect(fanCoiUni[1].port_Air_a, floor1.portsCor[1]) annotation (Line(points={{40,28},
          {40,20},{46,20},{46,74},{-2,74},{-2,106},{2,106},{2,126},{35.3348,126},
          {35.3348,101.015}},color={0,127,255}));
  connect(fanCoiUni[1].port_Air_b, floor1.portsCor[2]) annotation (Line(points={{40,24},
          {40,22},{46,22},{46,74},{-2,74},{-2,106},{2,106},{2,126},{37.0304,126},
          {37.0304,101.015}},                                        color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_a, floor1.portsSou[1]) annotation (Line(points={{40,28},
          {40,20},{46,20},{46,74},{35.3348,74},{35.3348,87.4769}},   color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_b, floor1.portsSou[2]) annotation (Line(points={{40,24},
          {40,22},{46,22},{46,74},{37.0304,74},{37.0304,87.4769}},     color={0,
          127,255}));
  connect(fanCoiUni[3].port_Air_a, floor1.portsEas[1]) annotation (Line(points={{40,28},
          {40,20},{46,20},{46,70},{94,70},{94,101.015},{73.9957,101.015}},
                     color={0,127,255}));
  connect(fanCoiUni[3].port_Air_b, floor1.portsEas[2]) annotation (Line(points={{40,24},
          {40,22},{46,22},{46,70},{94,70},{94,101.015},{75.6913,101.015}},
                             color={0,127,255}));
  connect(fanCoiUni[4].port_Air_a, floor1.portsNor[1]) annotation (Line(points={{40,28},
          {40,20},{46,20},{46,74},{-2,74},{-2,106},{2,106},{2,126},{35.3348,126},
          {35.3348,112.523}},color={0,127,255}));
  connect(fanCoiUni[4].port_Air_b, floor1.portsNor[2]) annotation (Line(points={{40,24},
          {40,22},{46,22},{46,74},{-2,74},{-2,106},{2,106},{2,126},{37.0304,126},
          {37.0304,112.523}},              color={0,127,255}));
  connect(fanCoiUni[5].port_Air_a, floor1.portsWes[1]) annotation (Line(points={{40,28},
          {40,20},{46,20},{46,74},{-2,74},{-2,101.015},{14.3087,101.015}},
        color={0,127,255}));
  connect(fanCoiUni[5].port_Air_b, floor1.portsWes[2]) annotation (Line(points={{40,24},
          {40,22},{46,22},{46,74},{-2,74},{-2,101.015},{16.0043,101.015}},
                                       color={0,127,255}));
  connect(floor1.TRooAir[5], conFCU[1].TZon) annotation (Line(points={{85.6957,
          100.677},{88,100.677},{88,136},{-64,136},{-64,98},{-72,98},{-72,92},{
          -70,92},{-70,16},{-72,16},{-72,3.4},{-54.5,3.4}},
                                                        color={0,0,127}));
  connect(conFCU[2].TZon, floor1.TRooAir[1]) annotation (Line(points={{-54.5,
          3.4},{-72,3.4},{-72,38},{-70,38},{-70,92},{-72,92},{-72,98},{-64,98},
          {-64,136},{85.6957,136},{85.6957,99.3231}},             color={0,0,127}));
  connect(conFCU[3].TZon, floor1.TRooAir[2]) annotation (Line(points={{-54.5,
          3.4},{-72,3.4},{-72,38},{-70,38},{-70,92},{-72,92},{-72,98},{-64,98},
          {-64,136},{85.6957,136},{85.6957,99.6615}},             color={0,0,127}));
  connect(conFCU[4].TZon, floor1.TRooAir[3]) annotation (Line(points={{-54.5,
          3.4},{-72,3.4},{-72,38},{-70,38},{-70,92},{-72,92},{-72,98},{-64,98},
          {-64,136},{88,136},{88,100},{85.6957,100}},             color={0,0,127}));
  connect(conFCU[5].TZon, floor1.TRooAir[4]) annotation (Line(points={{-54.5,
          3.4},{-72,3.4},{-72,38},{-70,38},{-70,92},{-72,92},{-72,98},{-64,98},
          {-64,136},{88,136},{88,100.338},{85.6957,100.338}},     color={0,0,127}));
  connect(sinHea.ports, fanCoiUni.port_HW_b) annotation (Line(points={{-11,-40},
          {-24,-40},{-24,-66},{68,-66},{68,-2},{24,-2},{24,16}}, color={0,127,
          255}));
  connect(fanCoiUni.port_HW_a, souHea.ports) annotation (Line(points={{27,16},{
          27,-36},{11,-36},{11,-40}}, color={0,127,255}));
  connect(fanCoiUni.port_CHW_a, souCoo.ports) annotation (Line(points={{36,16},
          {36,-36},{51,-36},{51,-40}}, color={0,127,255}));
  connect(fanCoiUni.port_CHW_b, sinCoo.ports) annotation (Line(points={{33,16},
          {33,-36},{31,-36},{31,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{100,140}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,
            140}})),
    experiment(
      StartTime=259200,
      StopTime=345600,
      Interval=60,
      Tolerance=1e-07,
      __Dymola_Algorithm="Cvode"));
end FanCoilUnit;
