within Buildings.Fluid.Storage.Ice.Examples;
model WaterLoopDistrictCooling
  "Example that tests the ice tank model for a simplified district cooling application"
  extends Modelica.Icons.Example;

  package MediumGlycol = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15, X_a=0.30) "Fluid medium";
  package MediumWater = Buildings.Media.Water "Fluid medium";
  package MediumAir = Buildings.Media.Air "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=11.3
    "Nominal mass flow rate of air through the chiller condenser coil";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=4.3
    "Nominal mass flow rate of water through the water circuit";

  parameter Modelica.Units.SI.Temperature TStaVol = 273.15 + 1
    "Initial water temperature of volume";

  parameter
    Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
    perChi annotation (Placement(transformation(extent={{134,76},{154,96}})));

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    V=1,
    T_start = TStaVol,
    nPorts=2)      "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={4,-35})));

  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 6)
    "Set point"
    annotation (Placement(transformation(extent={{-8,-88},{4,-76}})));

  Chillers.ElectricEIR chiWat(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=perChi,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,-33})));

  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.00001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{160,10},{148,22}})));

  HeatExchangers.HeaterCooler_u disCooCoi(redeclare package Medium =
        MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=1500)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={134,-24})));

  Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={14,16})));

  Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={34,-24})));

  Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={54,16})));

  Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={14,-54})));

  Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={54,-64})));

  Movers.FlowControlled_m_flow pum4(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={126,26})));

  Sensors.TemperatureTwoPort temSen1(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal,
    T_start=TStaVol)                                    "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={14,-4})));

  Sensors.TemperatureTwoPort temSen2(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={54,-4})));

  Sensors.TemperatureTwoPort temSen3(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={134,-44})));

  Sources.MassFlowSource_T           sou1(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={78,-4})));

  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir,
      nPorts=1) "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={79,-55})));

  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{110,-30},{98,-18}})));

  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum2(realTrue=
        mWat_flow_nominal, realFalse=mWat_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{-16,-60},{-4,-48}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal(realTrue=1, realFalse=
        0.1)
    "Valve signal"
    annotation (Placement(transformation(extent={{4,40},{16,52}})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToReaPum3(realTrue=
        mWat_flow_nominal, realFalse=mWat_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{78,-92},{66,-80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pum4Flow(k=mWat_flow_nominal)
    "Pump 4 flow rate"
    annotation (Placement(transformation(extent={{160,34},{148,46}})));
  Actuators.Motors.IdealMotor motVal12(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{24,40},{36,52}})));
  Actuators.Motors.IdealMotor motVal3(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{78,40},{66,52}})));
  Modelica.StateGraph.StepWithSignal modSwi(nIn=1, nOut=1) "Mode switch"
    annotation (Placement(transformation(extent={{-110,34},{-98,22}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{-98,76},{-84,90}})));
  Modelica.StateGraph.StepWithSignal chillerOn(nIn=1, nOut=1) "Chiller is on"
    annotation (Placement(transformation(extent={{-110,-34},{-98,-22}})));
  Modelica.StateGraph.TransitionWithSignal T2 "Transition to switch pumps on"
    annotation (Placement(transformation(extent={{-128,18},{-108,38}})));
  Modelica.StateGraph.InitialStep ste0(nOut=1, nIn=1) "Initial Step"
    annotation (Placement(transformation(extent={{-180,-2},{-168,10}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT1(t=273.15 + 6)
    "Threshold for room temperature"
    annotation (Placement(transformation(extent={{-4,14},{-16,26}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT3(t=273.15 + 11)
    "Threshold for room temperature"
    annotation (Placement(transformation(extent={{150,-44},{162,-32}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThrT3(t=273.15 + 7)
    annotation (Placement(transformation(extent={{150,-66},{162,-54}})));
  Modelica.StateGraph.TransitionWithSignal T3 "Transition to switch pumps on"
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.StateGraph.Transition           T1 "Transition to switch pumps on"
    annotation (Placement(transformation(extent={{-170,-6},{-150,14}})));
  Modelica.StateGraph.TransitionWithSignal T5 "Transition to switch pumps on"
    annotation (Placement(transformation(extent={{-114,-62},{-134,-42}})));
  Modelica.StateGraph.Parallel parallel
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-154,-36},{-56,44}})));
  Modelica.StateGraph.Step ste1(nIn=1, nOut=1) "Step 1"
    annotation (Placement(transformation(extent={{-138,22},{-126,34}})));
  Modelica.StateGraph.Step ste2(nIn=1, nOut=1) "Step 2"
    annotation (Placement(transformation(extent={{-84,22},{-72,34}})));
  Controls.OBC.CDL.Continuous.Switch        swi
    annotation (Placement(transformation(extent={{94,40},{82,52}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val3On(k=1)
    "Valve 3 on position"
    annotation (Placement(transformation(extent={{112,42},{100,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val3Off(k=0.1)
    "Valve 3 off position"
    annotation (Placement(transformation(extent={{112,50},{100,62}})));
  Modelica.StateGraph.TransitionWithSignal
                                 T4 "Transition to switch pumps on"
    annotation (Placement(transformation(extent={{-56,-6},{-36,14}})));
  Modelica.StateGraph.Step ste3(nIn=1, nOut=1) "Step 2"
    annotation (Placement(transformation(extent={{-62,-58},{-74,-46}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow fixHeaFlo
    "Fixed heat flow rate"
    annotation (Placement(transformation(extent={{-54,-86},{-34,-66}})));
  Modelica.Blocks.Sources.Sine glyLooCoo(
    amplitude=100,
    f=0.000005785,
    offset=-1000,
    startTime=14440)
    annotation (Placement(transformation(extent={{-84,-82},{-72,-70}})));
  Controls.OBC.CDL.Continuous.LessThreshold    lesThrT1(t=273.15 + 4)
    "Threshold for room temperature"
    annotation (Placement(transformation(extent={{-4,-20},{-16,-8}})));
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
    annotation (Line(points={{120,26},{54,26},{54,20}}, color={0,127,255}));
  connect(pum4.port_b, disCooCoi.port_a)
    annotation (Line(points={{132,26},{134,26},{134,-14}},color={0,127,255}));
  connect(disCooCoi.port_b, temSen3.port_a)
    annotation (Line(points={{134,-34},{134,-38}}, color={0,127,255}));
  connect(temSen3.port_b, pum3.port_a) annotation (Line(points={{134,-50},{134,-76},
          {54,-76},{54,-70}},      color={0,127,255}));
  connect(pum2.port_a, pum3.port_a) annotation (Line(points={{14,-60},{14,-76},{
          54,-76},{54,-70}},  color={0,127,255}));
  connect(val3.port_b, pum3.port_a) annotation (Line(points={{54,20},{54,26},{94,
          26},{94,-76},{54,-76},{54,-70}},      color={0,127,255}));
  connect(val2.port_b, pum2.port_a) annotation (Line(points={{34,-28},{34,-66},{
          14,-66},{14,-60}}, color={0,127,255}));
  connect(sou1.ports[1], chiWat.port_a1)
    annotation (Line(points={{72,-4},{66,-4},{66,-23}},
                                                      color={0,127,255}));
  connect(chiWat.port_b1, sin1.ports[1])
    annotation (Line(points={{66,-43},{66,-55},{74,-55}}, color={0,127,255}));
  connect(preSou1.ports[1], pum3.port_a) annotation (Line(points={{98,-24},{94,-24},
          {94,-76},{54,-76},{54,-70}},     color={0,127,255}));
  connect(disCooCoi.u, disCooLoad.y)
    annotation (Line(points={{140,-12},{140,16},{147.4,16}},color={0,0,127}));
  connect(pum2.port_b, vol.ports[1])
    annotation (Line(points={{14,-48},{14,-33}}, color={0,127,255}));
  connect(temSen1.port_a, vol.ports[2])
    annotation (Line(points={{14,-10},{14,-37}},color={0,127,255}));
  connect(booToReaPum2.y, pum2.m_flow_in)
    annotation (Line(points={{-2.8,-54},{6.8,-54}}, color={0,0,127}));
  connect(booToReaPum3.y, pum3.m_flow_in) annotation (Line(points={{64.8,-86},{42,
          -86},{42,-64},{46.8,-64}}, color={0,0,127}));
  connect(pum4Flow.y, pum4.m_flow_in) annotation (Line(points={{146.8,40},{126,40},
          {126,33.2}}, color={0,0,127}));
  connect(booToReaVal.y, motVal12.u)
    annotation (Line(points={{17.2,46},{22.8,46}}, color={0,0,127}));
  connect(motVal12.y, val2.y) annotation (Line(points={{36.6,46},{40,46},{40,-24},
          {38.8,-24}}, color={0,0,127}));
  connect(motVal12.y, val1.y) annotation (Line(points={{36.6,46},{40,46},{40,16},
          {18.8,16}}, color={0,0,127}));
  connect(val3.y, motVal3.y)
    annotation (Line(points={{58.8,16},{62,16},{62,46},{65.4,46}},
                                                   color={0,0,127}));
  connect(chiWat.TSet, chiWatTSet.y) annotation (Line(points={{57,-21},{57,-16},
          {46,-16},{46,-54},{38,-54},{38,-82},{5.2,-82}}, color={0,0,127}));
  connect(booToReaPum2.u, booToReaVal.u) annotation (Line(points={{-17.2,-54},{-32,
          -54},{-32,46},{2.8,46}}, color={255,0,255}));
  connect(chiWat.on, booToReaPum3.u) annotation (Line(points={{63,-21},{63,-14},
          {88,-14},{88,-86},{79.2,-86}}, color={255,0,255}));
  connect(temSen1.T, greThrT1.u) annotation (Line(points={{7.4,-4},{0,-4},{0,20},
          {-2.8,20}}, color={0,0,127}));
  connect(temSen3.T, lesThrT3.u) annotation (Line(points={{140.6,-44},{146,-44},
          {146,-60},{148.8,-60}}, color={0,0,127}));
  connect(temSen3.T, greThrT3.u) annotation (Line(points={{140.6,-44},{146,-44},
          {146,-38},{148.8,-38}}, color={0,0,127}));
  connect(chillerOn.active, booToReaPum3.u) annotation (Line(points={{-104,-34.6},
          {-104,-94},{88,-94},{88,-86},{79.2,-86}},color={255,0,255}));
  connect(greThrT1.y, T3.condition) annotation (Line(points={{-17.2,20},{-56,20},
          {-56,12},{-90,12},{-90,16}}, color={255,0,255}));
  connect(modSwi.active, booToReaPum2.u) annotation (Line(points={{-104,34.6},{-104,
          54},{-32,54},{-32,-54},{-17.2,-54}}, color={255,0,255}));
  connect(motVal3.u, swi.y)
    annotation (Line(points={{79.2,46},{80.8,46}}, color={0,0,127}));
  connect(swi.u3, val3On.y) annotation (Line(points={{95.2,41.2},{98,41.2},{98,36},
          {98.8,36}}, color={0,0,127}));
  connect(val3Off.y, swi.u1) annotation (Line(points={{98.8,56},{98,56},{98,50.8},
          {95.2,50.8}}, color={0,0,127}));
  connect(modSwi.active, swi.u2) annotation (Line(points={{-104,34.6},{-104,54},
          {-32,54},{-32,68},{116,68},{116,46},{95.2,46}}, color={255,0,255}));
  connect(ste0.outPort[1], T1.inPort)
    annotation (Line(points={{-167.7,4},{-164,4}}, color={0,0,0}));
  connect(T1.outPort, parallel.inPort)
    annotation (Line(points={{-158.5,4},{-155.47,4}}, color={0,0,0}));
  connect(ste1.inPort[1], parallel.split[1]) annotation (Line(points={{-138.6,28},
          {-140,28},{-140,4},{-142.975,4}},   color={0,0,0}));
  connect(ste1.outPort[1], T2.inPort)
    annotation (Line(points={{-125.7,28},{-122,28}}, color={0,0,0}));
  connect(T2.outPort, modSwi.inPort[1])
    annotation (Line(points={{-116.5,28},{-110.6,28}}, color={0,0,0}));
  connect(modSwi.outPort[1], T3.inPort)
    annotation (Line(points={{-97.7,28},{-94,28}}, color={0,0,0}));
  connect(T3.outPort, ste2.inPort[1])
    annotation (Line(points={{-88.5,28},{-84.6,28}}, color={0,0,0}));
  connect(ste2.outPort[1], parallel.join[1]) annotation (Line(points={{-71.7,28},
          {-70,28},{-70,4},{-67.025,4}},    color={0,0,0}));
  connect(parallel.split[2], chillerOn.inPort[1]) annotation (Line(points={{-142.975,
          4},{-140,4},{-140,-28},{-110.6,-28}},     color={0,0,0}));
  connect(chillerOn.outPort[1], parallel.join[2]) annotation (Line(points={{-97.7,
          -28},{-70,-28},{-70,4},{-67.025,4}},       color={0,0,0}));
  connect(T5.outPort, ste0.inPort[1]) annotation (Line(points={{-125.5,-52},{-186,
          -52},{-186,4},{-180.6,4}}, color={0,0,0}));
  connect(parallel.outPort, T4.inPort)
    annotation (Line(points={{-55.02,4},{-50,4}}, color={0,0,0}));
  connect(ste3.inPort[1], T4.outPort) annotation (Line(points={{-61.4,-52},{-38,
          -52},{-38,4},{-44.5,4}}, color={0,0,0}));
  connect(ste3.outPort[1], T5.inPort)
    annotation (Line(points={{-74.3,-52},{-120,-52}}, color={0,0,0}));
  connect(fixHeaFlo.port, vol.heatPort) annotation (Line(points={{-34,-76},{-24,
          -76},{-24,-25},{4,-25}}, color={191,0,0}));
  connect(glyLooCoo.y, fixHeaFlo.Q_flow)
    annotation (Line(points={{-71.4,-76},{-54,-76}}, color={0,0,127}));
  connect(lesThrT3.y, T4.condition) annotation (Line(points={{163.2,-60},{164,
          -60},{164,-100},{-46,-100},{-46,-8}}, color={255,0,255}));
  connect(greThrT3.y, T5.condition) annotation (Line(points={{163.2,-38},{172,
          -38},{172,-108},{-124,-108},{-124,-64}}, color={255,0,255}));
  connect(lesThrT1.y, T2.condition) annotation (Line(points={{-17.2,-14},{
          -117.6,-14},{-117.6,16},{-118,16}}, color={255,0,255}));
  connect(lesThrT1.u, temSen1.T) annotation (Line(points={{-2.8,-14},{0,-14},{0,
          -4},{7.4,-4}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-120,-100},{160,100}})),
    Icon(coordinateSystem(extent={{-120,-100},{160,100}})));
end WaterLoopDistrictCooling;
