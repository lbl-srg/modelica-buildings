within Buildings.Fluid.Storage.Ice.Examples;
model WaterLoopDistrictCooling
  "Example that tests the ice tank model for a simplified district cooling application"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air "Fluid medium";
  package MediumWater = Buildings.Media.Water "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal = QWatChi/(dTHex_nominal*cpAir)
    "Nominal mass flow rate of air through the chiller condenser coil";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal = QDisCoi/(dTHex_nominal*cpWater)
    "Nominal mass flow rate of water through the water circuit";

  parameter Modelica.Units.SI.SpecificHeatCapacity cpWater = 4184 "Isobaric specific heat at STP";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpAir = 1006 "Isobaric specific heat at STP";
  parameter Modelica.Units.SI.TemperatureDifference dTHex_nominal = 10 "Nominal temperature change across heat exchanger";

  parameter Modelica.Units.SI.Temperature TSetWatChi = 273.15 + 6 "Water chiller setpoint temperature";
  parameter Modelica.Units.SI.Temperature TSetDisCooSup = 273.15 + 7 "Inlet temperature setpoint of district cooling coil supply";
  parameter Modelica.Units.SI.Temperature TCooStart = 273.15 + 11 "Outlet temperature of district coil to start cooling service";
  parameter Modelica.Units.SI.Temperature TCooStop = 273.15 + 7 "Outlet temperature of district coil to stop cooling service";
  parameter Modelica.Units.SI.Temperature THexCooCall = 273.15 + 5 "Outlet water temperature of heat exchanger to call for cooling";
  parameter Modelica.Units.SI.Temperature THexStandby = 273.15 + 3 "Outlet water temperature of heat exchanger in standby operation";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal = 6000 "Nominal pressure drop across valve";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal = 10000 "Nominal pressure drop across heat exchanger";
  parameter Modelica.Units.SI.PressureDifference dpPump_nominal = 20000 "Nominal pressure drop across pump";
  parameter Modelica.Units.SI.Volume volHex = 15 "Equivalent heat exchanger fluid mixing volume";
  parameter Modelica.Units.SI.HeatFlowRate QDisCoi = 422000 "District cooling coil cooling load, assumed 120 ton design day peak load";

  parameter Real kCon = 1000 "Gain of PI controller";
  parameter Real TiCon = 10 "Integral time constant of PI controller";
  parameter Real rCon = 1000 "Typical range of controller error used for scaling";

  parameter Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled perWatChi annotation (Placement(transformation(extent={{134,76},{154,96}})));

  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries bui(
    have_heaWat = false,
    redeclare package Medium2 = MediumAir,
    filNam = "Fluid/Storage/Ice/Examples/SampleDistrictCoolingLoads.txt",
    QHea_flow_nominal = 1e-15,
    nPorts_aHeaWat = 1,
    nPorts_bHeaWat = 1,
    nPorts_bChiWat = 1,
    nPorts_aChiWat = 1) "Building model with district loads"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={134,-22})));

  Buildings.Fluid.Chillers.ElectricEIR chiWat(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal = mCon_flow_nominal,
    m2_flow_nominal = mWat_flow_nominal,
    dp2_nominal = dpHex_nominal,
    dp1_nominal = dpHex_nominal,
    per = perWatChi,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-33})));

  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Source of air for the water chiller" annotation (Placement(
        transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={78,-4})));

  Buildings.Fluid.Sources.Boundary_pT sinAir(redeclare package Medium = MediumAir, nPorts=1)
    "Sink for air from the water chiller" annotation (Placement(transformation(extent={{5,-5},{-5,5}},
          origin={79,-55})));

  Buildings.Fluid.Sources.Boundary_pT preSouWat(redeclare package Medium =
        MediumWater,                                                                    nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{102,-30},{90,-18}})));

  Modelica.Blocks.Sources.Sine iceTanCoo(
    amplitude=0.66*QDisCoi/2,
    f=1/(2*86400),
    offset=-0.66*QDisCoi/2,
    startTime=0)
    annotation (Placement(transformation(extent={{-82,-88},{-70,-76}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow fixHeaFloIce
    "Fixed heat flow rate to the ice storage"
    annotation (Placement(transformation(extent={{-52,-92},{-32,-72}})));

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumWater,
    m_flow_nominal = mWat_flow_nominal,
    V = volHex, nPorts = 2) "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={4,-35})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k = TSetWatChi) "Water chiller constant set point"
    annotation (Placement(transformation(extent={{-8,-88},{4,-76}})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumWater,
    m_flow_nominal = mWat_flow_nominal,
    dpValve_nominal = dpValve_nominal,
    dpFixed_nominal = 0,
    y_start = 0,
    use_inputFilter = false)
    "Control valve 1 for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={14,16})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumWater,
    m_flow_nominal = mWat_flow_nominal,
    dpValve_nominal = dpValve_nominal,
    dpFixed_nominal = 0,
    y_start = 0,
    use_inputFilter = false)
    "Control valve 2 for water loop" annotation (
      Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={34,-24})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumWater,
    m_flow_nominal = mWat_flow_nominal,
    dpValve_nominal = dpValve_nominal,
    dpFixed_nominal = 0,
    y_start = 0,
    use_inputFilter = false)
    "Control valve 3 for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={54,16})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val8(
    redeclare package Medium = MediumWater,
    m_flow_nominal = mWat_flow_nominal,
    dpValve_nominal = dpValve_nominal,
    dpFixed_nominal = 0,
    y_start = 0,
    use_inputFilter = false) "Control valve 8 for water loop" annotation (
      Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={134,0})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal1(realTrue = 1, realFalse = 0.1) "Valve 1 signal"
    annotation (Placement(transformation(extent={{2,30},{14,42}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal2(realTrue = 1, realFalse = 0.1) "Valve 2 signal"
    annotation (Placement(transformation(extent={{2,48},{14,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiVal3 "Switch for Valve 3"
    annotation (Placement(transformation(extent={{94,40},{82,52}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant val3On(k = 1) "Valve 3 on position"
    annotation (Placement(transformation(extent={{112,42},{100,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant val3Off(k = 0.1) "Valve 3 off position"
    annotation (Placement(transformation(extent={{112,50},{100,62}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conPIVal8(
    final k(min=0) = kCon,
    final Ti = TiCon,
    final r = rCon,
    final controllerType = Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final yMin = 0.1,
    final yMax = 1,
    final reverseActing=false) "Controller for Valve 8"
    annotation (Placement(transformation(extent={{154,16},{142,28}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetVal8(k=TSetDisCooSup)
    "District cooling temperature setpoint"
    annotation (Placement(transformation(extent={{170,16},{158,28}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumWater,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal = mWat_flow_nominal) "Pump 2" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={14,-54})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumWater,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal = mWat_flow_nominal) "Pump 3" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={54,-64})));

  Buildings.Fluid.Movers.FlowControlled_dp pum4(
    redeclare package Medium = MediumWater,
    energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal = mWat_flow_nominal,
    dp_start = dpPump_nominal,
    dp_nominal = dpPump_nominal) "Pump 4" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={122,26})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum2(realTrue=
        mWat_flow_nominal, realFalse = mWat_flow_nominal/10) "Pump 2 signal"
    annotation (Placement(transformation(extent={{-16,-60},{-4,-48}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum3(realTrue=
        mWat_flow_nominal, realFalse = mWat_flow_nominal/10) "Pump 3 signal"
    annotation (Placement(transformation(extent={{78,-92},{66,-80}})));
  Buildings.Fluid.Sensors.RelativePressure relPrePum4(redeclare package Medium =
        MediumWater)                                                                          "Pump 4 relative pressure measurement"
    annotation (Placement(transformation(
        extent={{-8,-6},{8,6}},
        origin={112,-24},
        rotation=-90)));

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen1(redeclare package Medium =
        MediumWater,
      m_flow_nominal = mWat_flow_nominal) "Water temperature sensor 1" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={14,-4})));

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen2(redeclare package Medium =
        MediumWater,
      m_flow_nominal = mWat_flow_nominal) "Water temperature sensor 2" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={54,-4})));

  Buildings.Fluid.Sensors.TemperatureTwoPort temSen3(redeclare package Medium =
        MediumWater,
      m_flow_nominal = mWat_flow_nominal) "Water temperature sensor 3" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={134,-46})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot "Root of the state graph"
    annotation (Placement(transformation(extent={{-98,76},{-84,90}})));
  Modelica.StateGraph.Parallel parallel "Split for parallel execution paths"
    annotation (Placement(transformation(extent={{-154,-36},{-56,44}})));
  Modelica.StateGraph.InitialStep standby(nOut = 1, nIn = 1) "Initial Step"
    annotation (Placement(transformation(extent={{-178,-2},{-166,10}})));
  Modelica.StateGraph.Step ste1(nIn = 1, nOut = 1) "Step 1"
    annotation (Placement(transformation(extent={{-138,22},{-126,34}})));
  Modelica.StateGraph.Step ste2(nIn = 1, nOut = 1) "Step 2"
    annotation (Placement(transformation(extent={{-84,22},{-72,34}})));
  Modelica.StateGraph.StepWithSignal iceOnly(nIn=1, nOut=1)
    "Serve district loads with ice only"
    annotation (Placement(transformation(extent={{-72,-58},{-84,-46}})));
  Modelica.StateGraph.StepWithSignal dualCool(nIn=1, nOut=1)
    "Serve district loads with ice and chiller"
    annotation (Placement(transformation(extent={{-110,34},{-98,22}})));
  Modelica.StateGraph.StepWithSignal chiOnly(nIn=1, nOut=1)
    "Serve district loads with chiller only"
    annotation (Placement(transformation(extent={{-110,-34},{-98,-22}})));
  Modelica.StateGraph.TransitionWithSignal T0
    "Transition to turn on pump 3 and water chiller"
    annotation (Placement(transformation(extent={{-170,-6},{-150,14}})));
  Modelica.StateGraph.TransitionWithSignal T13
    "Transition to turn on pump 2, open valve 1, open valve 2, and close valve 3"
    annotation (Placement(transformation(extent={{-128,18},{-108,38}})));
  Modelica.StateGraph.TransitionWithSignal T24
    "Transition to turn off pump 2, close valve 1, close valve 2, and open valve 3"
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.StateGraph.TransitionWithSignal T5
    "Transition to turn on pump 2, turn off pump 3, water chiller, open valve 1, and close valve 3"
    annotation (Placement(transformation(extent={{-56,-6},{-36,14}})));
  Modelica.StateGraph.TransitionWithSignal T6
    "Transition to turn off pump 2, close valve 1, and open valve 3"
    annotation (Placement(transformation(extent={{-124,-62},{-144,-42}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOrPum2(nin=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-42,-64})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOrT5(nin=2) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-46,-24})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOrT6(nin=3) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-134,-78})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrT1(t = THexStandby)
    "Threshold for heat exchanger water outlet temperature"
    annotation (Placement(transformation(extent={{-4,-20},{-16,-8}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrT1(t = THexCooCall)
    "Threshold for heeat exchanger water outlet temperature"
    annotation (Placement(transformation(extent={{-4,14},{-16,26}})));
  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThrT3(t = TCooStop)
    "Threshold for district cooling coil outlet temperature"
    annotation (Placement(transformation(extent={{152,-66},{164,-54}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrT3(t = TCooStart)
    "Threshold for district cooling coil outlet temperature"
    annotation (Placement(transformation(extent={{152,-44},{164,-32}})));

equation
  connect(pum3.port_b, chiWat.port_a2)
    annotation (Line(points={{54,-58},{54,-43}}, color={0,127,255}));
  connect(chiWat.port_b2, temSen2.port_a)
    annotation (Line(points={{54,-23},{54,-10}},
                                              color={0,127,255}));
  connect(temSen2.port_b, val2.port_a) annotation (Line(points={{54,2},{54,6},{34,
          6},{34,-20}},    color={0,127,255}));
  connect(temSen2.port_b, val3.port_a)
    annotation (Line(points={{54,2},{54,12}},  color={0,127,255}));
  connect(temSen1.port_b, val1.port_a)
    annotation (Line(points={{14,2},{14,12}},  color={0,127,255}));
  connect(val1.port_b, val3.port_b) annotation (Line(points={{14,20},{14,26},{54,
          26},{54,20}},    color={0,127,255}));
  connect(pum4.port_a, val3.port_b)
    annotation (Line(points={{116,26},{54,26},{54,20}}, color={0,127,255}));
  connect(temSen3.port_b, pum3.port_a) annotation (Line(points={{134,-52},{134,
          -76},{54,-76},{54,-70}}, color={0,127,255}));
  connect(pum2.port_a, pum3.port_a) annotation (Line(points={{14,-60},{14,-76},{
          54,-76},{54,-70}},  color={0,127,255}));
  connect(val3.port_b, pum3.port_a) annotation (Line(points={{54,20},{54,26},{
          88,26},{88,-76},{54,-76},{54,-70}},   color={0,127,255}));
  connect(val2.port_b, pum2.port_a) annotation (Line(points={{34,-28},{34,-66},{
          14,-66},{14,-60}}, color={0,127,255}));
  connect(souAir.ports[1], chiWat.port_a1)
    annotation (Line(points={{72,-4},{66,-4},{66,-23}}, color={0,127,255}));
  connect(chiWat.port_b1, sinAir.ports[1])
    annotation (Line(points={{66,-43},{66,-55},{74,-55}}, color={0,127,255}));
  connect(preSouWat.ports[1], pum3.port_a) annotation (Line(points={{90,-24},{88,
          -24},{88,-76},{54,-76},{54,-70}}, color={0,127,255}));
  connect(pum2.port_b, vol.ports[1])
    annotation (Line(points={{14,-48},{14,-33}}, color={0,127,255}));
  connect(temSen1.port_a, vol.ports[2])
    annotation (Line(points={{14,-10},{14,-37}},color={0,127,255}));
  connect(booToReaPum2.y, pum2.m_flow_in)
    annotation (Line(points={{-2.8,-54},{6.8,-54}}, color={0,0,127}));
  connect(booToReaPum3.y, pum3.m_flow_in) annotation (Line(points={{64.8,-86},{42,
          -86},{42,-64},{46.8,-64}}, color={0,0,127}));
  connect(chiWat.TSet, chiWatTSet.y) annotation (Line(points={{57,-21},{57,-16},
          {46,-16},{46,-54},{38,-54},{38,-82},{5.2,-82}}, color={0,0,127}));
  connect(chiWat.on, booToReaPum3.u) annotation (Line(points={{63,-21},{63,-14},
          {86,-14},{86,-86},{79.2,-86}}, color={255,0,255}));
  connect(temSen1.T, greThrT1.u) annotation (Line(points={{7.4,-4},{0,-4},{0,20},
          {-2.8,20}}, color={0,0,127}));
  connect(temSen3.T, lesThrT3.u) annotation (Line(points={{140.6,-46},{148,-46},
          {148,-60},{150.8,-60}}, color={0,0,127}));
  connect(temSen3.T, greThrT3.u) annotation (Line(points={{140.6,-46},{148,-46},
          {148,-38},{150.8,-38}}, color={0,0,127}));
  connect(chiOnly.active, booToReaPum3.u) annotation (Line(points={{-104,-34.6},
          {-104,-94},{86,-94},{86,-86},{79.2,-86}}, color={255,0,255}));
  connect(swiVal3.u3, val3On.y) annotation (Line(points={{95.2,41.2},{98,41.2},{
          98,36},{98.8,36}}, color={0,0,127}));
  connect(val3Off.y, swiVal3.u1) annotation (Line(points={{98.8,56},{98,56},{98,
          50.8},{95.2,50.8}}, color={0,0,127}));
  connect(standby.outPort[1], T0.inPort) annotation (Line(points={{-165.7,4},{-164,
          4},{-164,4}},          color={0,0,0}));
  connect(T0.outPort, parallel.inPort)
    annotation (Line(points={{-158.5,4},{-155.47,4}}, color={0,0,0}));
  connect(ste1.inPort[1], parallel.split[1]) annotation (Line(points={{-138.6,28},
          {-140,28},{-140,4},{-142.975,4}},   color={0,0,0}));
  connect(ste1.outPort[1], T13.inPort)
    annotation (Line(points={{-125.7,28},{-122,28}}, color={0,0,0}));
  connect(T13.outPort, dualCool.inPort[1])
    annotation (Line(points={{-116.5,28},{-110.6,28}}, color={0,0,0}));
  connect(dualCool.outPort[1], T24.inPort)
    annotation (Line(points={{-97.7,28},{-94,28}}, color={0,0,0}));
  connect(T24.outPort, ste2.inPort[1])
    annotation (Line(points={{-88.5,28},{-84.6,28}}, color={0,0,0}));
  connect(ste2.outPort[1], parallel.join[1]) annotation (Line(points={{-71.7,28},
          {-70,28},{-70,4},{-67.025,4}},    color={0,0,0}));
  connect(parallel.split[2], chiOnly.inPort[1]) annotation (Line(points={{-142.975,
          4},{-140,4},{-140,-28},{-110.6,-28}}, color={0,0,0}));
  connect(chiOnly.outPort[1], parallel.join[2]) annotation (Line(points={{-97.7,
          -28},{-70,-28},{-70,4},{-67.025,4}}, color={0,0,0}));
  connect(T6.outPort, standby.inPort[1]) annotation (Line(points={{-135.5,-52},{
          -180,-52},{-180,4},{-178.6,4}}, color={0,0,0}));
  connect(parallel.outPort,T5. inPort)
    annotation (Line(points={{-55.02,4},{-50,4}}, color={0,0,0}));
  connect(iceOnly.inPort[1], T5.outPort) annotation (Line(points={{-71.4,-52},{-38,
          -52},{-38,4},{-44.5,4}}, color={0,0,0}));
  connect(iceOnly.outPort[1], T6.inPort)
    annotation (Line(points={{-84.3,-52},{-130,-52}}, color={0,0,0}));
  connect(fixHeaFloIce.port, vol.heatPort) annotation (Line(points={{-32,-82},{-24,
          -82},{-24,-25},{4,-25}}, color={191,0,0}));
  connect(iceTanCoo.y, fixHeaFloIce.Q_flow)
    annotation (Line(points={{-69.4,-82},{-52,-82}}, color={0,0,127}));
  connect(lesThrT1.u, temSen1.T) annotation (Line(points={{-2.8,-14},{0,-14},{0,
          -4},{7.4,-4}}, color={0,0,127}));
  connect(swiVal3.y, val3.y) annotation (Line(points={{80.8,46},{70,46},{70,16},
          {58.8,16}}, color={0,0,127}));
  connect(booToReaVal1.y, val1.y) annotation (Line(points={{15.2,36},{26,36},{26,
          16},{18.8,16}}, color={0,0,127}));
  connect(booToReaVal2.y, val2.y) annotation (Line(points={{15.2,54},{42,54},{
          42,-24},{38.8,-24}}, color={0,0,127}));
  connect(T13.condition, greThrT1.y) annotation (Line(points={{-118,16},{-118,
          12},{-52,12},{-52,20},{-17.2,20}}, color={255,0,255}));
  connect(lesThrT3.y, mulOrT5.u[1]) annotation (Line(points={{165.2,-60},{166,-60},
          {166,-100},{-56,-100},{-56,-36},{-48.1,-36},{-48.1,-31.2}}, color={255,
          0,255}));
  connect(lesThrT1.y, mulOrT5.u[2]) annotation (Line(points={{-17.2,-14},{-34,-14},
          {-34,-36},{-44,-36},{-44,-31.2},{-43.9,-31.2}}, color={255,0,255}));
  connect(mulOrT5.y, T5.condition)
    annotation (Line(points={{-46,-16.8},{-46,-8}}, color={255,0,255}));
  connect(mulOrT5.y, T24.condition) annotation (Line(points={{-46,-16.8},{-90,-16.8},
          {-90,16}}, color={255,0,255}));
  connect(mulOrT6.y, T6.condition)
    annotation (Line(points={{-134,-70.8},{-134,-64}}, color={255,0,255}));
  connect(greThrT1.y, mulOrT6.u[1]) annotation (Line(points={{-17.2,20},{-52,20},
          {-52,-4},{-118,-4},{-118,-94},{-136.8,-94},{-136.8,-85.2}}, color={255,
          0,255}));
  connect(greThrT3.y, mulOrT6.u[2]) annotation (Line(points={{165.2,-38},{172,-38},
          {172,-106},{-134,-106},{-134,-85.2}}, color={255,0,255}));
  connect(mulOrPum2.y, booToReaPum2.u) annotation (Line(points={{-34.8,-64},{-30,
          -64},{-30,-54},{-17.2,-54}}, color={255,0,255}));
  connect(dualCool.active, mulOrPum2.u[1]) annotation (Line(points={{-104,34.6},
          {-104,54},{-62,54},{-62,-62},{-50,-62},{-50,-61.9},{-49.2,-61.9}},
        color={255,0,255}));
  connect(iceOnly.active, mulOrPum2.u[2]) annotation (Line(points={{-78,-58.6},{
          -78,-66.1},{-49.2,-66.1}}, color={255,0,255}));
  connect(greThrT3.y, T0.condition) annotation (Line(points={{165.2,-38},{172,
          -38},{172,100},{-150,100},{-150,-20},{-160,-20},{-160,-8}}, color={
          255,0,255}));
  connect(lesThrT3.y, mulOrT6.u[3]) annotation (Line(points={{165.2,-60},{166,-60},
          {166,-100},{-132,-100},{-132,-85.2},{-131.2,-85.2}}, color={255,0,255}));
  connect(booToReaVal1.u, booToReaPum2.u) annotation (Line(points={{0.8,36},{-30,
          36},{-30,-54},{-17.2,-54}}, color={255,0,255}));
  connect(swiVal3.u2, booToReaPum2.u) annotation (Line(points={{95.2,46},{120,46},
          {120,72},{-30,72},{-30,-54},{-17.2,-54}}, color={255,0,255}));
  connect(booToReaVal2.u, dualCool.active) annotation (Line(points={{0.8,54},{-104,
          54},{-104,34.6}}, color={255,0,255}));
  connect(relPrePum4.p_rel, pum4.dp_in) annotation (Line(points={{106.6,-24},{104,
          -24},{104,12},{122,12},{122,18.8}}, color={0,0,127}));
  connect(pum4.port_b, val8.port_a)
    annotation (Line(points={{128,26},{134,26},{134,4}}, color={0,127,255}));
  connect(temSen3.T, conPIVal8.u_m) annotation (Line(points={{140.6,-46},{148,-46},
          {148,14.8}}, color={0,0,127}));
  connect(TSetVal8.y, conPIVal8.u_s)
    annotation (Line(points={{156.8,22},{155.2,22}}, color={0,0,127}));
  connect(conPIVal8.y, val8.y) annotation (Line(points={{140.8,22},{140,22},{140,
          0},{138.8,0}}, color={0,0,127}));
  connect(relPrePum4.port_b, temSen3.port_b) annotation (Line(points={{112,-32},
          {112,-56},{134,-56},{134,-52}}, color={0,127,255}));
  connect(relPrePum4.port_a, val8.port_a) annotation (Line(points={{112,-16},{112,
          8},{134,8},{134,4}}, color={0,127,255}));
  connect(bui.ports_bChiWat[1], temSen3.port_a) annotation (Line(points={{128,
          -32},{128,-36},{134,-36},{134,-40}}, color={0,127,255}));
  connect(bui.ports_aChiWat[1], val8.port_b) annotation (Line(points={{128,-12},
          {128,-8},{134,-8},{134,-4}}, color={0,127,255}));
  connect(T0.inPort, standby.outPort[2]) annotation (Line(points={{-164,4},{-164,
          4},{-165.7,4}},       color={0,0,0}));
  annotation (
    experiment(
      StopTime=259200,
      Interval=1,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a> through its implementation in a simplified district cooling system.
</p>
</p>
<p align=\"center\">
<img alt=\"image of ice system\" width=\"750\" src=\"modelica://Buildings/Resources/Images/Fluid/Storage/IceSystem.png\"/>
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2022, by Dre Helmns:<br/>
Implementation of ice tank in a simplified district cooling system.<br/>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-120},{180,120}})),
    Icon(coordinateSystem(extent={{-180,-120},{180,120}})));
end WaterLoopDistrictCooling;
