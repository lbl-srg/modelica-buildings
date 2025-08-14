within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  "Model of a five zone floor with fan coil units"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium for hot-water and chilled-water";

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 100000 + 3000,
    T=333.15,
    nPorts=5)
    "Source for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90, origin={-10,-70})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=100000,
    T=328.15,
    nPorts=5)
    "Sink for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90, origin={-50,-70})));

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=288.15,
    nPorts=5)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90, origin={30,-70})));

  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=5)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90, origin={70,-70})));

   Buildings.Examples.VAVReheat.BaseClasses.Floor flo(
     redeclare package Medium = MediumA,
     sampleModel=true)
     "Thermal zones model"
     annotation (Placement(transformation(extent={{102,56},{180,100}})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni[5](
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.1*2.5*0.21805,0.1*7.5*0.53883,0.5*0.33281,0.75*3.75*0.50946,0.5*1.5*0.33236}
        *0.25,
    dpAir_nominal=fill(100, 5),
    UAHeaCoi_nominal={2.25*146.06*2.5,2.25*146.06*2,2.25*146.06*1.5,2.25*146.06*
        3,2.25*146.06*1.75}*1.1,
    mChiWat_flow_nominal={0.23106*1.5,2*0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06*1.5,2.25*146.06,2.25*146.06,2.25*146.06},
    mAir_flow_nominal={0.9/1.5,0.222*2,0.1337*2,0.21303*2,0.137*2}*3,
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52})
    "Fan coil units"
    annotation (Placement(transformation(extent={{0,-12},{40,28}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU[5](
    final TiCoo=fill(200, 5),
    final heaConTyp=fill(Buildings.Controls.OBC.CDL.Types.SimpleController.PI,5),
    final kHea=fill(0.05, 5),
    final TiHea=fill(120, 5),
    final kCooCoi=fill(0.05, 5),
    final TiCooCoi=fill(200, 5),
    final kHeaCoi=fill(0.005, 5),
    final TiHeaCoi=fill(90, 5),
    final TSupSet_max=fill(308.15, 5),
    final TSupSet_min=fill(285.85, 5))
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-60,-32},{-20,40}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{100,130},{120,150}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant LimLev(
    final k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=5)
    "Scalar replicator for demand limit level"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccHeaSetPoi(final k=20 + 273.15)
    "Occupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-20},{-180,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(final k=30 + 273.15)
    "Unoccupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(final k=12 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[5](
    final t=fill(0.01,5),
    final h=fill(0.005, 5))
    "Check if fan speed is above threshold for proven on signal"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[5](
    final t=fill(120, 5))
    "Generate fan proven on signal"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(
    final nout=5)
    "Scalar replicator for temperature setpoint adjustment"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(
    final nout=5)
    "Scalar replicator for time to next occupancy"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep4(
    final nout=5)
    "Scalar replicator for occupied setpoint temperature"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep5(
    final nout=5)
    "Scalar replicator for unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep6(
    final nout=5)
    "Scalar replicator for unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetAdj(
    final k=0)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(final k=3600)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(
    final nout=5)
    "Scalar replicator for cool-down and warm-up time"
    annotation (Placement(transformation(extent={{-160,130},{-140,150}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=5)
    "Scalar replicator for occupancy"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccCooSetPoi(
    final k=24 + 273.15)
    "Occupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep7(
    final nout=5)
    "Scalar replicator for occupied setpoint temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));

equation
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{-18,20},{-10,
          20},{-10,14},{-2,14}},     color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{-18,4},{-6,
          4},{-6,8},{-2,8}},color={0,0,127}));
  connect(conFCU.yHeaCoi, fanCoiUni.uHea) annotation (Line(points={{-18,8},{-10,
          8},{-10,2},{-2,2}},           color={0,0,127}));
  connect(intScaRep.y, conFCU.uCooDemLimLev) annotation (Line(points={{-138,80},
          {-118,80},{-118,10},{-62,10}},
                                       color={255,127,0}));
  connect(intScaRep.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-138,80},
          {-118,80},{-118,6},{-62,6}},             color={255,127,0}));
  connect(cooWarTim.y, reaScaRep1.u) annotation (Line(points={{-178,140},{-162,140}},
          color={0,0,127}));
  connect(reaScaRep1.y, conFCU.warUpTim) annotation (Line(points={{-138,140},{
          -100,140},{-100,38},{-62,38}},      color={0,0,127}));
  connect(reaScaRep1.y, conFCU.cooDowTim) annotation (Line(points={{-138,140},{
          -100,140},{-100,34},{-62,34}},
                                    color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-178,-130},{-162,-130}},
               color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{42,0},{60,0},
          {60,60},{-114,60},{-114,2},{-62,2}},              color={0,0,127}));
  connect(reaScaRep2.y, conFCU.setAdj) annotation (Line(points={{-138,110},{
          -106,110},{-106,26},{-62,26}},     color={0,0,127}));
  connect(occSch.tNexOcc, reaScaRep3.u) annotation (Line(points={{-179,46},{-170,
          46},{-170,50},{-162,50}}, color={0,0,127}));
  connect(reaScaRep3.y, conFCU.tNexOcc) annotation (Line(points={{-138,50},{
          -112,50},{-112,30},{-62,30}},      color={0,0,127}));
  connect(occSch.occupied, booScaRep1.u) annotation (Line(points={{-179,34},{-170,
          34},{-170,20},{-162,20}},  color={255,0,255}));
  connect(booScaRep1.y, conFCU.u1Occ) annotation (Line(points={{-138,20},{-112,
          20},{-112,14.2},{-62,14.2}}, color={255,0,255}));
  connect(TOccHeaSetPoi.y, reaScaRep4.u)
    annotation (Line(points={{-178,-10},{-162,-10}}, color={0,0,127}));
  connect(reaScaRep4.y, conFCU.TOccHeaSet) annotation (Line(points={{-138,-10},
          {-120,-10},{-120,-6},{-62,-6}},                     color={0,0,127}));
  connect(TUnOccCooSet.y, reaScaRep5.u)
    annotation (Line(points={{-178,-70},{-162,-70}}, color={0,0,127}));
  connect(reaScaRep5.y, conFCU.TUnoCooSet) annotation (Line(points={{-138,-70},
          {-100,-70},{-100,-18},{-62,-18}},          color={0,0,127}));
  connect(TUnOccHeaSet.y, reaScaRep6.u) annotation (Line(points={{-178,-100},{-162,
          -100}}, color={0,0,127}));
  connect(reaScaRep6.y, conFCU.TUnoHeaSet) annotation (Line(points={{-138,-100},
          {-94,-100},{-94,-14},{-62,-14}},color={0,0,127}));
  connect(LimLev.y, intScaRep.u)
    annotation (Line(points={{-178,80},{-162,80}}, color={255,127,0}));
  connect(fanCoiUni[1].port_Air_a, flo.portsCor[1]) annotation (Line(points={{40,12},
          {94,12},{94,106},{131.335,106},{131.335,79.0154}},     color={0,127,255}));
  connect(fanCoiUni[1].port_Air_b, flo.portsCor[2]) annotation (Line(points={{40,4},{
          94,4},{94,106},{133.03,106},{133.03,79.0154}},     color={0,127,255}));
  connect(fanCoiUni[2].port_Air_a, flo.portsSou[1]) annotation (Line(points={{40,12},
          {94,12},{94,50},{131.335,50},{131.335,65.4769}},
                                               color={0,127,255}));
  connect(fanCoiUni[2].port_Air_b, flo.portsSou[2]) annotation (Line(points={{40,4},{
          94,4},{94,50},{133.03,50},{133.03,65.4769}},
                                           color={0,127,255}));
  connect(fanCoiUni[3].port_Air_a, flo.portsEas[1]) annotation (Line(points={{40,12},
          {94,12},{94,106},{148,106},{148,110},{188,110},{188,79.0154},{169.996,
          79.0154}},                                     color={0,127,255}));
  connect(fanCoiUni[3].port_Air_b, flo.portsEas[2]) annotation (Line(points={{40,4},{
          94,4},{94,106},{148,106},{148,110},{188,110},{188,79.0154},{171.691,
          79.0154}},                                   color={0,127,255}));
  connect(fanCoiUni[4].port_Air_a, flo.portsNor[1]) annotation (Line(points={{40,12},
          {94,12},{94,106},{134,106},{134,90.5231},{131.335,90.5231}},
                                                                 color={0,127,255}));
  connect(fanCoiUni[4].port_Air_b, flo.portsNor[2]) annotation (Line(points={{40,4},{
          94,4},{94,106},{133.03,106},{133.03,90.5231}},     color={0,127,255}));
  connect(fanCoiUni[5].port_Air_a, flo.portsWes[1]) annotation (Line(points={{40,12},
          {94,12},{94,79.0154},{110.309,79.0154}},     color={0,127,255}));
  connect(fanCoiUni[5].port_Air_b, flo.portsWes[2]) annotation (Line(points={{40,4},{
          94,4},{94,79.0154},{112.004,79.0154}},     color={0,127,255}));
  connect(flo.TRooAir[5], conFCU[1].TZon) annotation (Line(points={{181.696,
          78.6769},{210,78.6769},{210,116},{-90,116},{-90,-2},{-62,-2}},
                                                                color={0,0,127}));
  connect(conFCU[2].TZon, flo.TRooAir[1]) annotation (Line(points={{-62,-2},{
          -90,-2},{-90,116},{210,116},{210,78},{181.696,78},{181.696,77.3231}},
        color={0,0,127}));
  connect(conFCU[3].TZon, flo.TRooAir[2]) annotation (Line(points={{-62,-2},{
          -90,-2},{-90,116},{210,116},{210,78},{181.696,78},{181.696,77.6615}},
        color={0,0,127}));
  connect(conFCU[4].TZon, flo.TRooAir[3]) annotation (Line(points={{-62,-2},{
          -90,-2},{-90,116},{210,116},{210,78},{181.696,78}},
                                                          color={0,0,127}));
  connect(conFCU[5].TZon, flo.TRooAir[4]) annotation (Line(points={{-62,-2},{
          -90,-2},{-90,116},{210,116},{210,78.3385},{181.696,78.3385}},
                                                                    color={0,0,127}));
  connect(sinHea.ports, fanCoiUni.port_HW_b) annotation (Line(points={{-50,-60},
          {-50,-40},{6,-40},{6,-12}},
                                    color={0,127,255}));
  connect(fanCoiUni.port_HW_a, souHea.ports) annotation (Line(points={{16,-12},{
          16,-54},{-10,-54},{-10,-60}},
                                color={0,127,255}));
  connect(fanCoiUni.port_CHW_a, souCoo.ports) annotation (Line(points={{32,-12},
          {32,-54},{70,-54},{70,-60}},
                                   color={0,127,255}));
  connect(fanCoiUni.port_CHW_b, sinCoo.ports) annotation (Line(points={{22,-12},
          {22,-54},{30,-54},{30,-60}},
                                   color={0,127,255}));
  connect(tim.passed, conFCU.u1Fan) annotation (Line(points={{-138,-138},{-88,
          -138},{-88,-26},{-62,-26}},
                                color={255,0,255}));
  connect(fanCoiUni.yFan_actual, greThr.u) annotation (Line(points={{42,16},{48,
          16},{48,-4},{86,-4},{86,-146},{-210,-146},{-210,-130},{-202,-130}},
                                                              color={0,0,127}));
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{120,140},{151.174,140},{151.174,106.769}},
      color={255,204,51},
      thickness=0.5));
  connect(TSetAdj.y, reaScaRep2.u)
    annotation (Line(points={{-178,110},{-162,110}}, color={0,0,127}));
  connect(TOccCooSetPoi.y, reaScaRep7.u)
    annotation (Line(points={{-178,-40},{-162,-40}}, color={0,0,127}));
  connect(reaScaRep7.y, conFCU.TOccCooSet) annotation (Line(points={{-138,-40},
          {-114,-40},{-114,-10},{-62,-10}},          color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Text(
          extent={{-110,192},{110,156}},
          textColor={0,0,255},
          textString="%name")}),  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,160}})),
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
See the model <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FourPipe\">
Buildings.Fluid.ZoneEquipment.FourPipe</a> and 
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
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end FanCoilUnit;
