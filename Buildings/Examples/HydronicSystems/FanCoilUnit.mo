within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  "Fan Coil Unit"

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium for hot-water and chilled-water";

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=333.15,
    nPorts=5)
    "Source for hot water"
    annotation (Placement(transformation(
      extent={{-9,-9},{9,9}},
      rotation=90,
      origin={11,-49})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=328.15,
    nPorts=5)
    "Sink for hot water"
    annotation (Placement(transformation(
      extent={{-9,-9},{9,9}},
      rotation=90,
      origin={-11,-49})));

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=288.15,
    nPorts=5)
    "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={31,-49})));

  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=5)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
      rotation=90,origin={51,-49})));

   Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor floor1(
     redeclare package Medium = MediumA)
     "Thermal zone model"
     annotation (Placement(transformation(extent={{62,76},{140,120}})));

  Buildings.Examples.HydronicSystems.BaseClasses.FourPipe fanCoiUni[5](
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.21805,5*0.53883,0.33281,5*0.50946,0.33236},
    dpAir_nominal=fill(100, 5),
    UAHeaCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06},
    mChiWat_flow_nominal={0.23106,0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06},
    mAir_flow_nominal=2*{0.9,0.222,0.1337,1.5*0.21303,1.5*0.137},
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52})
    "Fan coil units"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU[5](
    final TiCoo=fill(200, 5),
    final TiHea=fill(200, 5),
    kCooCoi=fill(0.05, 5),
    final TiCooCoi=fill(200, 5),
    kHeaCoi=fill(0.05, 5),
    final TiHeaCoi=fill(200, 5),
    each TSupSet_max=308.15,
    each TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-40,-6},{0,54}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    each filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant LimLev(
    final k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=5)
    "Scalar replicator for demand limit level"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccSetPoi(
    final k=23 + 273.15)
    "Occupied temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(
    final k=25 + 273.15)
    "Unoccupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(
    final k=21 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[5](final t=fill(0.01,
        5), final h=fill(0.005, 5))
    "Check if fan speed is above threshold for proven on signal"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[5](
    final t=fill(120, 5))
    "Generate fan proven on signal"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(
    final nout=5)
    "Scalar replicator for temperature setpoint adjustment"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(
    final nout=5)
    "Scalar replicator for time to next occupancy"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep4(
    final nout=5)
    "Scalar replicator for occupied setpoint temperature"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep5(
    final nout=5)
    "Scalar replicator for unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep6(
    final nout=5)
    "Scalar replicator for unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetAdj(
    final k=0)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(
    final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(
    final nout=5)
    "Scalar replicator for cool-down and warm-up time"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=5)
    "Scalar replicator for occupancy"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

equation
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{2,37.3333},{14,
          37.3333},{14,32},{19,32}},
                              color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{2,24},{12,
          24},{12,28},{19,28}},          color={0,0,127}));
  connect(conFCU.yHeaCoi, fanCoiUni.uHea) annotation (Line(points={{2,27.3333},
          {16,27.3333},{16,24},{19,24}},color={0,0,127}));
  connect(intScaRep.y, conFCU.uCooDemLimLev) annotation (Line(points={{-78,70},
          {-68,70},{-68,29},{-42,29}},                 color={255,127,0}));
  connect(intScaRep.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-78,70},
          {-68,70},{-68,24},{-50,24},{-50,25.6667},{-42,25.6667}},       color=
          {255,127,0}));
  connect(cooWarTim.y, reaScaRep1.u) annotation (Line(points={{-118,130},{-102,
          130}},                     color={0,0,127}));
  connect(reaScaRep1.y, conFCU.warUpTim) annotation (Line(points={{-78,130},{
          -70,130},{-70,96},{-62,96},{-62,52.3333},{-42,52.3333}},
                                      color={0,0,127}));
  connect(reaScaRep1.y, conFCU.cooDowTim) annotation (Line(points={{-78,130},{
          -70,130},{-70,96},{-62,96},{-62,54},{-50,54},{-50,49},{-42,49}},
                                      color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-118,-110},{-102,-110}},
               color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{41,25},{44,
          25},{44,64},{-66,64},{-66,22.3333},{-42,22.3333}},color={0,0,127}));
  connect(reaScaRep2.y, conFCU.setAdj) annotation (Line(points={{-78,100},{-64,
          100},{-64,38},{-50,38},{-50,42.3333},{-42,42.3333}},
                                  color={0,0,127}));
  connect(occSch.tNexOcc, reaScaRep3.u) annotation (Line(points={{-119,16},{
          -110,16},{-110,40},{-102,40}},      color={0,0,127}));
  connect(reaScaRep3.y, conFCU.tNexOcc) annotation (Line(points={{-78,40},{-52,
          40},{-52,45.6667},{-42,45.6667}},  color={0,0,127}));
  connect(occSch.occupied, booScaRep1.u) annotation (Line(points={{-119,4},{
          -112,4},{-112,10},{-102,10}},
                                     color={255,0,255}));
  connect(booScaRep1.y, conFCU.u1Occ) annotation (Line(points={{-78,10},{-68,10},
          {-68,12},{-58,12},{-58,32.5},{-42,32.5}},
                                       color={255,0,255}));
  connect(TOccSetPoi.y, reaScaRep4.u) annotation (Line(points={{-118,-20},{-102,
          -20}},                           color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccHeaSet) annotation (Line(points={{-78,-20},{
          -52,-20},{-52,15.6667},{-42,15.6667}},              color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccCooSet) annotation (Line(points={{-78,-20},{
          -52,-20},{-52,12.3333},{-42,12.3333}},
                                          color={0,0,127}));
  connect(TUnOccCooSet.y, reaScaRep5.u)
    annotation (Line(points={{-118,-50},{-102,-50}},    color={0,0,127}));
  connect(reaScaRep5.y, conFCU.TUnoCooSet) annotation (Line(points={{-78,-50},{
          -52,-50},{-52,-22},{-50,-22},{-50,5.66667},{-42,5.66667}},
                                          color={0,0,127}));
  connect(TUnOccHeaSet.y, reaScaRep6.u) annotation (Line(points={{-118,-80},{
          -102,-80}},              color={0,0,127}));
  connect(reaScaRep6.y, conFCU.TUnoHeaSet) annotation (Line(points={{-78,-80},{
          -70,-80},{-70,9},{-42,9}},      color={0,0,127}));

  connect(LimLev.y, intScaRep.u)
    annotation (Line(points={{-118,70},{-102,70}},     color={255,127,0}));
  connect(fanCoiUni[1].port_Air_a, floor1.portsCor[1]) annotation (Line(points={{40,32},
          {94,32},{94,72},{54,72},{54,100},{58,100},{58,124},{91.3348,124},{
          91.3348,99.0154}}, color={0,127,255}));
  connect(fanCoiUni[1].port_Air_b, floor1.portsCor[2]) annotation (Line(points={{40,28},
          {94,28},{94,72},{54,72},{54,100},{58,100},{58,124},{93.0304,124},{
          93.0304,99.0154}},                                         color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_a, floor1.portsSou[1]) annotation (Line(points={{40,32},
          {91.3348,32},{91.3348,85.4769}},                           color={0,
          127,255}));
  connect(fanCoiUni[2].port_Air_b, floor1.portsSou[2]) annotation (Line(points={{40,28},
          {93.0304,28},{93.0304,85.4769}},                             color={0,
          127,255}));
  connect(fanCoiUni[3].port_Air_a, floor1.portsEas[1]) annotation (Line(points={{40,32},
          {104,32},{104,68},{154,68},{154,99.0154},{129.996,99.0154}},
                     color={0,127,255}));
  connect(fanCoiUni[3].port_Air_b, floor1.portsEas[2]) annotation (Line(points={{40,28},
          {92,28},{92,20},{108,20},{108,72},{148,72},{148,99.0154},{131.691,
          99.0154}},         color={0,127,255}));
  connect(fanCoiUni[4].port_Air_a, floor1.portsNor[1]) annotation (Line(points={{40,32},
          {84,32},{84,68},{44,68},{44,96},{48,96},{48,120},{91.3348,120},{
          91.3348,110.523}}, color={0,127,255}));
  connect(fanCoiUni[4].port_Air_b, floor1.portsNor[2]) annotation (Line(points={{40,28},
          {100,28},{100,64},{54,64},{54,100},{58,100},{58,124},{93.0304,124},{
          93.0304,110.523}},               color={0,127,255}));
  connect(fanCoiUni[5].port_Air_a, floor1.portsWes[1]) annotation (Line(points={{40,32},
          {86,32},{86,60},{46,60},{46,90},{58,90},{58,99.0154},{70.3087,99.0154}},
        color={0,127,255}));
  connect(fanCoiUni[5].port_Air_b, floor1.portsWes[2]) annotation (Line(points={{40,28},
          {54,28},{54,30},{70,30},{70,74},{30,74},{30,99.0154},{72.0043,99.0154}},
                                       color={0,127,255}));
  connect(floor1.TRooAir[5], conFCU[1].TZon) annotation (Line(points={{141.696,
          98.6769},{144,98.6769},{144,136},{-66,136},{-66,94},{-70,94},{-70,22},
          {-68,22},{-68,19},{-42,19}},                  color={0,0,127}));
  connect(conFCU[2].TZon, floor1.TRooAir[1]) annotation (Line(points={{-42,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{141.696,136},
          {141.696,97.3231}},                                     color={0,0,127}));
  connect(conFCU[3].TZon, floor1.TRooAir[2]) annotation (Line(points={{-42,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{141.696,136},
          {141.696,97.6615}},                                     color={0,0,127}));
  connect(conFCU[4].TZon, floor1.TRooAir[3]) annotation (Line(points={{-42,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{144,136},{144,
          98},{141.696,98}},                                      color={0,0,127}));
  connect(conFCU[5].TZon, floor1.TRooAir[4]) annotation (Line(points={{-42,19},
          {-68,19},{-68,22},{-70,22},{-70,94},{-66,94},{-66,136},{144,136},{144,
          98.3385},{141.696,98.3385}},                            color={0,0,127}));
  connect(sinHea.ports, fanCoiUni.port_HW_b) annotation (Line(points={{-11,-40},
          {-12,-40},{-12,-20},{24,-20},{24,20}},                 color={0,127,
          255}));
  connect(fanCoiUni.port_HW_a, souHea.ports) annotation (Line(points={{27,20},{
          27,-36},{11,-36},{11,-40}}, color={0,127,255}));
  connect(fanCoiUni.port_CHW_a, souCoo.ports) annotation (Line(points={{36,20},
          {36,-36},{51,-36},{51,-40}}, color={0,127,255}));
  connect(fanCoiUni.port_CHW_b, sinCoo.ports) annotation (Line(points={{33,20},
          {33,-36},{31,-36},{31,-40}}, color={0,127,255}));
  connect(tim.passed, conFCU.u1Fan) annotation (Line(points={{-78,-118},{-68,
          -118},{-68,-1},{-42,-1}},   color={255,0,255}));
  connect(fanCoiUni.yFan_actual, greThr.u) annotation (Line(points={{40.5,38},{
          76,38},{76,-130},{-152,-130},{-152,-110},{-142,-110}}, color={0,0,127}));
  connect(weaDat.weaBus, floor1.weaBus) annotation (Line(
      points={{-40,110},{56,110},{56,132},{111.174,132},{111.174,126.769}},
      color={255,204,51},
      thickness=0.5));
  connect(TSetAdj.y, reaScaRep2.u)
    annotation (Line(points={{-118,100},{-102,100}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-110,192},{110,156}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,
            160}})),
Documentation(info="<html>
<p>
This model demonstrates the usage of
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a>,
a controller for four-pipe fan coil units based on the sequences defined
in ASHRAE Guideline 36, 2021.
</p>
<p>
This model consists of
</p>
<ul>
<li>
a 5-zone building thermal model with considerations for a building envelope model
and air flow through building leakage and through open doors.
</li>
<li>
a fan-coil unit that consists of a supply fan, an electric or hot-water heating
coil, and a chilled-water cooling coil.
</li>
<li>
The fan coil unit controller outputs the supply fan enable signal and speed signal,
the supply air temperature setpoint, the zone air heating and cooling setpoints,
and valve positions for heating and cooling coils.
</li>
</ul>
<p>
The HVAC system switches between occupied, unoccupied, unoccupied warm-up and
unoccupied pre-cool modes. The cooling coil and heating coil valves are modulated
to maintain the heating and cooling setpoints. The supply air temperature is modulated
based on the differential between the temperature setpoint and the zone temperature
to avoid unecessary heating and cooling use and avoid extreme temperature fluctuations.
</p>
<p>
See the model <a href=\"modelica://Buildings.Examples.HydronicSystems.BaseClasses.FourPipe\">
Buildings.Examples.HydronicSystems.BaseClasses.FourPipe</a> and 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a> for the 
description of the fan coil unit and the controller, and see the model 
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.BaseClasses.Floor</a>
for the description of the building envelope.
</p>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/HydronicSystems/FanCoilUnit.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end FanCoilUnit;
