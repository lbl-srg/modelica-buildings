within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  extends Modelica.Icons.Example;
  ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor floor1
    annotation (Placement(transformation(extent={{8,38},{86,82}})));
  Fluid.ZoneEquipment.FanCoilUnit.FourPipe fanCoiUni[5]
    annotation (Placement(transformation(extent={{-10,-10},{8,8}})));
  Controls.OBC.ASHRAE.G36.FanCoilUnit.Controller conFCU[5]
    annotation (Placement(transformation(extent={{-62,-26},{-42,14}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-66,56},{-46,76}})));
  Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THeaWatInl_nominal,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-3,-31})));
  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=THeaWatInl_nominal,
    nPorts=5) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={-17,-31})));
  Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=279.15,
    nPorts=2) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={9,-31})));
  Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=2) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-5,-5},{5,5}},
        rotation=90,
        origin={21,-31})));
  Controls.SetPoints.OccupancySchedule           occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-116,-32},{-102,-18}})));
  Modelica.Blocks.Sources.Constant SetAdj(k=0)
    annotation (Placement(transformation(extent={{-110,8},{-100,18}})));
  Controls.OBC.CDL.Reals.Sources.Constant TOccSetPoi(k=72 + 273.15)
    annotation (Placement(transformation(extent={{-116,-54},{-102,-40}})));
  Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(k=78 + 273.15)
    annotation (Placement(transformation(extent={{-114,-78},{-102,-66}})));
  Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(k=65 + 273.15)
    annotation (Placement(transformation(extent={{-114,-100},{-100,-86}})));
  Modelica.Blocks.Sources.Constant EcoMod(k=0) "Econ Mode control signal"
    annotation (Placement(transformation(extent={{-38,8},{-32,14}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=5)
    annotation (Placement(transformation(extent={{-28,8},{-22,14}})));
  Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-114,-6},{-106,2}})));
  Modelica.Blocks.Sources.Constant LimLev(k=0)
    annotation (Placement(transformation(extent={{-130,-6},{-120,4}})));
  Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=5)
    annotation (Placement(transformation(extent={{-102,-6},{-94,2}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(nout=5)
    annotation (Placement(transformation(extent={{-96,22},{-90,28}})));
  Controls.OBC.CDL.Reals.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{46,-2},{58,10}})));
  Controls.OBC.CDL.Logical.Timer tim(t=120)
    annotation (Placement(transformation(extent={{64,0},{74,10}})));
  Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(nout=5)
    annotation (Placement(transformation(extent={{80,-2},{92,10}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(nout=5)
    annotation (Placement(transformation(extent={{-94,10},{-88,16}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(nout=5)
    annotation (Placement(transformation(extent={{-92,-16},{-86,-10}})));
  Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(nout=5)
    annotation (Placement(transformation(extent={{-92,-32},{-86,-26}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep4(nout=5)
    annotation (Placement(transformation(extent={{-92,-52},{-84,-44}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep5(nout=5)
    annotation (Placement(transformation(extent={{-92,-76},{-84,-68}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep6(nout=5)
    annotation (Placement(transformation(extent={{-92,-98},{-84,-90}})));
protected
  Controls.OBC.CDL.Reals.Sources.Constant           cooWarTim(final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-114,24},{-106,32}})));
equation
  connect(weaDat.weaBus, floor1.weaBus) annotation (Line(
      points={{-46,66},{-30,66},{-30,92},{57.1739,92},{57.1739,88.7692}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, fanCoiUni.weaBus) annotation (Line(
      points={{-46,66},{-16,66},{-16,6.92},{-8.74,6.92}},
      color={255,204,51},
      thickness=0.5));
  connect(souHea.ports[1], fanCoiUni.port_HW_a) annotation (Line(points={{-3,-26},
          {-3,-14},{-3.7,-14},{-3.7,-10}},  color={0,127,255}));
  connect(sinCoo.ports[1], fanCoiUni.port_CHW_b) annotation (Line(points={{9.5,-26},
          {9.5,-22},{1.7,-22},{1.7,-10}},   color={0,127,255}));
  connect(souCoo.ports[1], fanCoiUni.port_CHW_a) annotation (Line(points={{21.5,
          -26},{21.5,-16},{4.4,-16},{4.4,-10}},      color={0,127,255}));
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{-41,2},{-14,2},
          {-14,0.8},{-10.9,0.8}},
                              color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{-41,-6},{
          -41,-4},{-12,-4},{-12,-2.8},{-10.9,-2.8}},
                                         color={0,0,127}));
  connect(conFCU.yHeaCoi, fanCoiUni.uHea) annotation (Line(points={{-41,-4},{
          -41,-6.4},{-10.9,-6.4}},      color={0,0,127}));
  connect(souCoo.ports[2], sinCoo.ports[2])
    annotation (Line(points={{20.5,-26},{8.5,-26}}, color={0,127,255}));
  connect(reaScaRep.y, fanCoiUni.uEco) annotation (Line(points={{-21.4,11},{-18,
          11},{-18,4.4},{-10.9,4.4}}, color={0,0,127}));
  connect(EcoMod.y, reaScaRep.u)
    annotation (Line(points={{-31.7,11},{-28.6,11}}, color={0,0,127}));
  connect(LimLev.y, reaToInt.u) annotation (Line(points={{-119.5,-1},{-119.5,-2},
          {-114.8,-2}}, color={0,0,127}));
  connect(reaToInt.y, intScaRep.u)
    annotation (Line(points={{-105.2,-2},{-102.8,-2}}, color={255,127,0}));
  connect(intScaRep.y, conFCU.uCooDemLimLev) annotation (Line(points={{-93.2,-2},
          {-86,-2},{-86,8},{-74,8},{-74,-3},{-63,-3}}, color={255,127,0}));
  connect(intScaRep.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-93.2,-2},
          {-86,-2},{-86,8},{-74,8},{-74,-4},{-68,-4},{-68,-5},{-63,-5}}, color=
          {255,127,0}));
  connect(cooWarTim.y, reaScaRep1.u) annotation (Line(points={{-105.2,28},{-100,
          28},{-100,25},{-96.6,25}}, color={0,0,127}));
  connect(reaScaRep1.y, conFCU.warUpTim) annotation (Line(points={{-89.4,25},{
          -68,25},{-68,12},{-63,12}}, color={0,0,127}));
  connect(reaScaRep1.y, conFCU.cooDowTim) annotation (Line(points={{-89.4,25},{
          -68,25},{-68,10},{-63,10}}, color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{59.2,4},{62,4},{62,5},{63,
          5}}, color={255,0,255}));
  connect(fanCoiUni[1].yFan_actual, greThr.u) annotation (Line(points={{8.45,
          6.2},{38,6.2},{38,4},{44.8,4}}, color={0,0,127}));
  connect(tim.passed, booScaRep.u)
    annotation (Line(points={{75,1},{78.8,1},{78.8,4}}, color={255,0,255}));
  connect(booScaRep.y, conFCU.u1Fan) annotation (Line(points={{93.2,4},{94,4},{
          94,-44},{-63,-44},{-63,-21}}, color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{8.9,-5.32},
          {36,-5.32},{36,-58},{-76,-58},{-76,-7},{-63,-7}}, color={0,0,127}));
  connect(fanCoiUni[1].port_Air_a, floor1.portsCor[1]) annotation (Line(points=
          {{8,0.8},{14,0.8},{14,34},{0,34},{0,88},{37.3348,88},{37.3348,61.0154}},
        color={0,127,255}));
  connect(fanCoiUni[1].port_Air_b, floor1.portsCor[2]) annotation (Line(points=
          {{8,-2.8},{22,-2.8},{22,2},{30,2},{30,28},{56,28},{56,58},{39.0304,58},
          {39.0304,61.0154}}, color={0,127,255}));
  connect(fanCoiUni[2].port_Air_a, floor1.portsSou[1]) annotation (Line(points=
          {{8,0.8},{14,0.8},{14,34},{37.3348,34},{37.3348,47.4769}}, color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_b, floor1.portsSou[2]) annotation (Line(points=
          {{8,-2.8},{22,-2.8},{22,-2},{39.0304,-2},{39.0304,47.4769}}, color={0,
          127,255}));
  connect(fanCoiUni[3].port_Air_a, floor1.portsWes[1]) annotation (Line(points=
          {{8,0.8},{14,0.8},{14,34},{0,34},{0,61.0154},{16.3087,61.0154}},
        color={0,127,255}));
  connect(fanCoiUni[3].port_Air_b, floor1.portsWes[2]) annotation (Line(points=
          {{8,-2.8},{16,-2.8},{16,4},{18.0043,4},{18.0043,61.0154}}, color={0,
          127,255}));
  connect(fanCoiUni[4].port_Air_a, floor1.portsNor[1]) annotation (Line(points=
          {{8,0.8},{32,0.8},{32,72.5231},{37.3348,72.5231}}, color={0,127,255}));
  connect(fanCoiUni[4].port_Air_b, floor1.portsNor[2]) annotation (Line(points=
          {{8,-2.8},{26,-2.8},{26,-4},{46,-4},{46,34},{60,34},{60,72.5231},{
          39.0304,72.5231}}, color={0,127,255}));
  connect(fanCoiUni[5].port_Air_b, floor1.portsEas[1]) annotation (Line(points=
          {{8,-2.8},{54,-2.8},{54,-10},{98,-10},{98,61.0154},{75.9957,61.0154}},
        color={0,127,255}));
  connect(fanCoiUni[5].port_Air_a, floor1.portsEas[2]) annotation (Line(points=
          {{8,0.8},{12,0.8},{12,24},{70,24},{70,61.0154},{77.6913,61.0154}},
        color={0,127,255}));
  connect(SetAdj.y, reaScaRep2.u)
    annotation (Line(points={{-99.5,13},{-94.6,13}}, color={0,0,127}));
  connect(reaScaRep2.y, conFCU.setAdj) annotation (Line(points={{-87.4,13},{-70,
          13},{-70,5},{-63.1,5}}, color={0,0,127}));
  connect(occSch.tNexOcc, reaScaRep3.u) annotation (Line(points={{-101.3,-20.8},
          {-96,-20.8},{-96,-13},{-92.6,-13}}, color={0,0,127}));
  connect(reaScaRep3.y, conFCU.tNexOcc) annotation (Line(points={{-85.4,-13},{
          -85.4,2},{-68,2},{-68,8},{-63,8}}, color={0,0,127}));
  connect(occSch.occupied, booScaRep1.u) annotation (Line(points={{-101.3,-29.2},
          {-101.3,-29},{-92.6,-29}}, color={255,0,255}));
  connect(booScaRep1.y, conFCU.u1Occ) annotation (Line(points={{-85.4,-29},{-80,
          -29},{-80,-0.9},{-63,-0.9}}, color={255,0,255}));
  connect(floor1.TRooAir, conFCU.TZon) annotation (Line(points={{87.6957,60},{
          92,60},{92,72},{82,72},{82,88},{-68,88},{-68,-9},{-63,-9}}, color={0,
          0,127}));
  connect(TOccSetPoi.y, reaScaRep4.u) annotation (Line(points={{-100.6,-47},{
          -98,-47},{-98,-48},{-92.8,-48}}, color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccHeaSet) annotation (Line(points={{-83.2,-48},
          {-76,-48},{-76,-46},{-68,-46},{-68,-11},{-63,-11}}, color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccCooSet) annotation (Line(points={{-83.2,-48},
          {-66,-48},{-66,-13},{-63,-13}}, color={0,0,127}));
  connect(TUnOccCooSet.y, reaScaRep5.u)
    annotation (Line(points={{-100.8,-72},{-92.8,-72}}, color={0,0,127}));
  connect(reaScaRep5.y, conFCU.TUnoCooSet) annotation (Line(points={{-83.2,-72},
          {-70,-72},{-70,-17},{-63,-17}}, color={0,0,127}));
  connect(TUnOccHeaSet.y, reaScaRep6.u) annotation (Line(points={{-98.6,-93},{
          -98.6,-94},{-92.8,-94}}, color={0,0,127}));
  connect(reaScaRep6.y, conFCU.TUnoHeaSet) annotation (Line(points={{-83.2,-94},
          {-74,-94},{-74,-15},{-63,-15}}, color={0,0,127}));
  connect(sinHea.ports, fanCoiUni.port_HW_b) annotation (Line(points={{-17,-26},
          {-16,-26},{-16,-16},{-14,-16},{-14,-12},{-6.4,-12},{-6.4,-10}}, color
        ={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end FanCoilUnit;
