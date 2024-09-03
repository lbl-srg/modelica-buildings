within Buildings.Fluid.Examples.FlowSystem;
model Basic "Example implementation of flow system"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  Buildings.Fluid.Movers.FlowControlled_dp pmpSouth(
    redeclare package Medium = Medium,
    redeclare replaceable
      Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos80slash1to12 per,
    dp_nominal=12*9810,
    m_flow_nominal=27570/3600,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    heads=pmpSouth.dp_nominal*{0,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump to south of building" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-20})));
  Buildings.Fluid.FixedResistances.PressureDrop pipSouth1(
    redeclare package Medium = Medium,
    dp_nominal=50000,
    m_flow_nominal=4) "Pipe 1 to south of building"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,18})));
  Buildings.Fluid.FixedResistances.PressureDrop pipSouth2(
    redeclare package Medium = Medium,
    dp_nominal=50000,
    m_flow_nominal=3) "Pipe 2 to south of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,18})));
  Buildings.Fluid.Movers.FlowControlled_dp pmpNorth(
    redeclare package Medium = Medium,
    redeclare replaceable
      Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos80slash1to12 per,
    dp_nominal=12*9810,
    m_flow_nominal=24660/3600,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    heads=pmpNorth.dp_nominal*{0,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
     "Pump to north of building" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-20})));
  Buildings.Fluid.FixedResistances.PressureDrop pipNorth2(
    redeclare package Medium = Medium,
    dp_nominal=50000,
    m_flow_nominal=5) "Pipe 2 to north of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,18})));
  Buildings.Fluid.FixedResistances.PressureDrop pipNorth1(
    redeclare package Medium = Medium,
    dp_nominal=50000,
    m_flow_nominal=3) "Pipe 1 to north of building"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,18})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear[4] valSouth1(
    each dpFixed_nominal=0,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each dpValve_nominal=8e4,
    redeclare each package Medium = Medium,
    each m_flow_nominal=1) "Valves on souther tabs section 1"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-80,60})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear[8] valSouth2(
    each dpFixed_nominal=0,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each dpValve_nominal=8e4,
    redeclare each package Medium = Medium,
    each m_flow_nominal=1) "Valves on souther tabs section 2"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-40,60})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear[4] valNorth1(
    each dpFixed_nominal=0,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each dpValve_nominal=8e4,
    redeclare each package Medium = Medium,
    each m_flow_nominal=1) "Valves on northern tabs section 1"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={40,60})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear[8] valNorth2(
    each dpFixed_nominal=0,
    each CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each dpValve_nominal=8e4,
    redeclare each package Medium = Medium,
    each m_flow_nominal=1) "Valves on northern tabs section 2"
    annotation (Placement(transformation(extent={{10,10},{-10,-10}},
        rotation=270,
        origin={80,60})));
  Modelica.Blocks.Math.BooleanToInteger booleanToInteger(integerTrue=2,
      integerFalse=1) "Boolean to integer conversion block"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Modelica.Blocks.Sources.BooleanPulse stepPump(startTime=5, period=1000)
    "Step control"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Modelica.Blocks.Sources.Sine sine(
    amplitude=0.5,
    offset=0.5,
    f=0.001) "Valve control signal"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valSouth(
    redeclare package Medium = Medium,
    m_flow_nominal=5,
    dpFixed_nominal={20000,0},
    from_dp=true,
    dpValve_nominal=10000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Three way valve for controlling supply temperature to south of building"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-50})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valNorth(
    redeclare package Medium = Medium,
    m_flow_nominal=5,
    dpFixed_nominal={20000,0},
    from_dp=true,
    dpValve_nominal=10000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Three way valve for controlling supply temperature to north of building"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-50})));
  Buildings.Fluid.HeatExchangers.PrescribedOutlet heater(
    m_flow_nominal=10,
    dp_nominal=100,
    redeclare package Medium = Medium,
    use_X_wSet=false)                  "Heating device"
    annotation (Placement(transformation(extent={{-70,-110},{-50,-90}})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=1,
  redeclare package Medium = Medium) "Boundary for setting absolute temperature"
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Fluid.FixedResistances.Junction spl(
    m_flow_nominal={10,10,10},
    dp_nominal={1000,10,10},
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Buildings.Fluid.FixedResistances.Junction spl1(
    m_flow_nominal={10,10,10},
    dp_nominal={10,10,10},
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter"
    annotation (Placement(transformation(extent={{-20,-120},{-40,-140}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumpHea(
    m_flow_nominal=10,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2 per,
    redeclare package Medium = Medium,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for circulating hot water"
    annotation (Placement(transformation(extent={{-50,-140},{-70,-120}})));
  Modelica.Blocks.Sources.Constant Thot(k=273.15 + 50) "Hot water temperature"
    annotation (Placement(transformation(extent={{-96,-98},{-84,-86}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHea(
    dpFixed_nominal=0,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dpValve_nominal=1e4)
    "Valve for allowing water to be drawn from hot water circuit"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={-10,-86})));
  Modelica.Blocks.Sources.Pulse stepValve(startTime=10, period=500)
    "Set point for valves"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCoo(
    dpFixed_nominal=0,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dpValve_nominal=1e4)
    "Valve for allowing water to be drawn from cold water circuit"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={12,-86})));
  Modelica.Blocks.Sources.RealExpression valCooExp(y=1 - stepValve.y)
    "Cooling valve opens when heating valve is closed"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-80}})));
  Buildings.Fluid.FixedResistances.Junction spl2(
    m_flow_nominal={10,10,10},
    dp_nominal={1000,10,10},
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter"
    annotation (Placement(transformation(extent={{40,-110},{20,-90}})));
  Buildings.Fluid.FixedResistances.Junction spl3(
    m_flow_nominal={10,10,10},
    dp_nominal={10,10,10},
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter"
    annotation (Placement(transformation(extent={{20,-120},{40,-140}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumpCoo(
    m_flow_nominal=10,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2 per,
    redeclare package Medium = Medium,
    inputType=Buildings.Fluid.Types.InputType.Stages,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for circulating cold water"
    annotation (Placement(transformation(extent={{46,-140},{66,-120}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    V=1) "Simplified model of cold water source"
    annotation (Placement(transformation(extent={{74,-100},{54,-80}})));
  Buildings.HeatTransfer.Sources.FixedTemperature Tcold(T=273.15 + 10)
    "Cold water temperature"
    annotation (Placement(transformation(extent={{100,-100},{80,-80}})));
  Buildings.Fluid.FixedResistances.PressureDrop tabsSouth1[4](
    redeclare each package Medium = Medium,
    each dp_nominal=50000,
    m_flow_nominal=valSouth1.m_flow_nominal)
    "Pressure drop of southern tabs sections on collector 1" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,90})));
  Buildings.Fluid.FixedResistances.PressureDrop tabsSouth2[8](
    redeclare each package Medium = Medium,
    each dp_nominal=50000,
    m_flow_nominal=valSouth2.m_flow_nominal)
    "Pressure drop of southern tabs sections on collector 2" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,90})));
  Buildings.Fluid.FixedResistances.PressureDrop tabsNorth1[4](
    redeclare each package Medium = Medium,
    each dp_nominal=50000,
    m_flow_nominal=valNorth1.m_flow_nominal)
    "Pressure drop of northern tabs sections on collector 1" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,90})));
  Buildings.Fluid.FixedResistances.PressureDrop tabsNorth2[8](
    redeclare each package Medium = Medium,
    each dp_nominal=50000,
    m_flow_nominal=valNorth2.m_flow_nominal)
    "Pressure drop of northern tabs sections on collector 2" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,90})));
equation
  connect(pipSouth2.port_a, pmpSouth.port_b) annotation (Line(
      points={{-40,8},{-40,-10},{-60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pmpSouth.port_b, pipSouth1.port_a) annotation (Line(
      points={{-60,-10},{-80,-10},{-80,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pipNorth1.port_a, pmpNorth.port_b) annotation (Line(
      points={{40,8},{40,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pmpNorth.port_b, pipNorth2.port_a) annotation (Line(
      points={{60,-10},{80,-10},{80,8}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:4 loop
      connect(tabsNorth1[i].port_b,valNorth. port_3) annotation (Line(points={{40,100},
          {40,100},{40,118},{6,118},{6,-50},{50,-50}}, color={0,127,255}));
    connect(tabsSouth1[i].port_b, valSouth.port_3) annotation (Line(points={{-80,
            100},{-80,120},{-4,120},{-4,-50},{-50,-50}}, color={0,127,255}));

    connect(valSouth1[i].y, sine.y)
      annotation (Line(points={{-92,60},{-92,60},{-98,60},{-98,60},{-98,60},{
            -98,30},{-119,30}},                              color={0,0,127}));

    connect(pipSouth1.port_b, valSouth1[i].port_a) annotation (Line(points={{-80,28},
            {-80,28},{-80,50}},     color={0,127,255}));
    connect(pipNorth1.port_b, valNorth1[i].port_a)
      annotation (Line(points={{40,28},{40,50}},         color={0,127,255}));
   end for;
    for i in 1:8 loop
  connect(tabsNorth2[i].port_b,valNorth. port_3) annotation (Line(points={{80,100},
          {80,120},{4,120},{4,-50},{50,-50}}, color={0,127,255}));
    connect(tabsSouth2[i].port_b, valSouth.port_3) annotation (Line(points={{-40,
            100},{-40,118},{-6,118},{-6,-50},{-50,-50}}, color={0,127,255}));

    connect(valSouth2[i].y, sine.y) annotation (Line(points={{-52,60},{-48,60},
            {-60,60},{-60,30},{-119,30}},color={0,0,127}));
    connect(pipSouth2.port_b, valSouth2[i].port_a) annotation (Line(points={{-40,
            28},{-40,39},{-40,50}}, color={0,127,255}));
    connect(pipNorth2.port_b, valNorth2[i].port_a)
      annotation (Line(points={{80,28},{80,50}}, color={0,127,255}));
  end for;

  connect(pmpSouth.stage, pmpNorth.stage)
    annotation (Line(points={{-72,-20},{-88,-20},{-88,-32},{36,-32},{36,-20},{
          48,-20}},                               color={255,127,0}));
  connect(booleanToInteger.y, pmpSouth.stage)
    annotation (Line(points={{-119,-20},{-108,-20},{-108,-32},{-88,-32},{-88,
          -20},{-72,-20}},                          color={255,127,0}));
  connect(stepPump.y, booleanToInteger.u) annotation (Line(points={{-159,-20},{
          -159,-20},{-142,-20}},
                            color={255,0,255}));
  connect(valSouth1.y, valNorth1.y)
    annotation (Line(points={{-92,60},{-98,60},{-98,30},{-102,30},{14,30},{14,
          60},{28,60}},                                  color={0,0,127}));
  connect(valSouth2.y,valNorth2. y) annotation (Line(points={{-52,60},{-60,60},
          {-60,30},{60,30},{60,30},{60,60},{68,60}},
                                    color={0,0,127}));

  connect(valSouth.port_2, pmpSouth.port_a) annotation (Line(points={{-60,-40},
          {-60,-38},{-60,-30}}, color={0,127,255}));
  connect(valNorth.port_2, pmpNorth.port_a)
    annotation (Line(points={{60,-40},{60,-30}}, color={0,127,255}));
  connect(valNorth.y, valSouth.y) annotation (Line(points={{72,-50},{70,-50},{
          70,-36},{-72,-36},{-72,-50}}, color={0,0,127}));
  connect(bou.ports[1], heater.port_a) annotation (Line(points={{-80,-130},{-80,
          -130},{-76,-130},{-74,-130},{-74,-100},{-70,-100}},
                             color={0,127,255}));
  connect(spl1.port_3, spl.port_3) annotation (Line(points={{-30,-120},{-30,-110}},
                       color={0,127,255}));
  connect(heater.port_b, spl.port_1)
    annotation (Line(points={{-50,-100},{-40,-100}}, color={0,127,255}));
  connect(pumpHea.port_a, spl1.port_2)
    annotation (Line(points={{-50,-130},{-46,-130},{-40,-130}},
                                                     color={0,127,255}));
  connect(pumpHea.port_b, heater.port_a) annotation (Line(points={{-70,-130},{-74,
          -130},{-74,-104},{-74,-100},{-70,-100}}, color={0,127,255}));
  connect(Thot.y, heater.TSet) annotation (Line(points={{-83.4,-92},{-83.4,-92},
          {-72,-92}},
                 color={0,0,127}));
  connect(spl1.port_1, valSouth.port_3) annotation (Line(points={{-20,-130},{-20,
          -130},{0,-130},{0,-52},{-50,-52},{-50,-50}}, color={0,127,255}));
  connect(spl.port_2, valHea.port_a)
    annotation (Line(points={{-20,-100},{-10,-100},{-10,-96}},
                                                           color={0,127,255}));
  connect(valHea.port_b, valSouth.port_1) annotation (Line(points={{-10,-76},{-10,
          -76},{-10,-64},{-60,-64},{-60,-60}}, color={0,127,255}));
  connect(stepValve.y, valSouth.y) annotation (Line(points={{-119,-50},{-119,-50},
          {-72,-50}}, color={0,0,127}));
  connect(stepValve.y, valHea.y) annotation (Line(points={{-119,-50},{-112,-50},
          {-112,-76},{-28,-76},{-28,-86},{-22,-86}},
                               color={0,0,127}));
  connect(valCooExp.y, valCoo.y) annotation (Line(points={{-119,-70},{32,-70},{
          32,-86},{24,-86},{24,-86}},
                          color={0,0,127}));
  connect(valCoo.port_b, valSouth.port_1) annotation (Line(points={{12,-76},{12,
          -64},{-60,-64},{-60,-60}}, color={0,127,255}));
  connect(valCoo.port_b,valNorth. port_1) annotation (Line(points={{12,-76},{12,
          -76},{12,-64},{60,-64},{60,-60}}, color={0,127,255}));
  connect(spl2.port_2, valCoo.port_a) annotation (Line(points={{20,-100},{12,-100},
          {12,-96}}, color={0,127,255}));
  connect(spl3.port_1, spl1.port_1) annotation (Line(points={{20,-130},{-20,-130}},
                       color={0,127,255}));
  connect(spl3.port_3, spl2.port_3) annotation (Line(points={{30,-120},{30,-115},
          {30,-110}}, color={0,127,255}));
  connect(spl3.port_2, pumpCoo.port_a) annotation (Line(points={{40,-130},{43,-130},
          {46,-130}}, color={0,127,255}));
  connect(vol.ports[1], pumpCoo.port_b) annotation (Line(points={{66,-100},{66,-100},
          {66,-130}}, color={0,127,255}));
  connect(vol.ports[2], spl2.port_1) annotation (Line(points={{62,-100},{62,-100},
          {40,-100}}, color={0,127,255}));
  connect(Tcold.port, vol.heatPort)
    annotation (Line(points={{80,-90},{77,-90},{74,-90}}, color={191,0,0}));
  connect(pumpHea.stage, pumpCoo.stage) annotation (Line(points={{-60,-118},{
          -60,-114},{56,-114},{56,-118},{56,-118}},
                            color={255,127,0}));
  connect(pumpHea.stage, booleanToInteger.y) annotation (Line(points={{-60,-118},
          {-60,-118},{-60,-114},{-108,-114},{-108,-20},{-119,-20}},
                                           color={255,127,0}));
  connect(valNorth.port_3, spl3.port_1) annotation (Line(points={{50,-50},{50,-52},
          {0,-52},{0,-130},{20,-130}}, color={0,127,255}));
  connect(valSouth1.port_b, tabsSouth1.port_a)
    annotation (Line(points={{-80,70},{-80,80}},          color={0,127,255}));
  connect(valSouth2.port_b, tabsSouth2.port_a)
    annotation (Line(points={{-40,70},{-40,80}},          color={0,127,255}));
  connect(valNorth1.port_b, tabsNorth1.port_a)
    annotation (Line(points={{40,70},{40,70},{40,80}}, color={0,127,255}));
  connect(valNorth2.port_b, tabsNorth2.port_a)
    annotation (Line(points={{80,70},{80,80}}, color={0,127,255}));
   annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{100,
            140}}), graphics={
        Rectangle(
          extent={{0,130},{100,-62}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,130},{0,-62}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,114},{56,40}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{64,114},{96,40}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,114},{-24,40}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,114},{-64,40}},
          lineColor={28,108,200},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,86},{-94,74}},
          textColor={28,108,200},
          textString="X4"),
        Text(
          extent={{-24,86},{-8,74}},
          textColor={28,108,200},
          textString="X8"),
        Text(
          extent={{8,86},{24,74}},
          textColor={28,108,200},
          textString="X4"),
        Text(
          extent={{96,86},{112,74}},
          textColor={28,108,200},
          textString="X8"),
        Text(
          extent={{-66,122},{-36,130}},
          textColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="South"),
        Text(
          extent={{34,122},{64,130}},
          textColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="North"),
        Rectangle(
          extent={{-100,-80},{-20,-160}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,-80},{100,-160}},
          lineColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-64,-156},{-34,-148}},
          textColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Heat"),
        Text(
          extent={{36,-156},{66,-148}},
          textColor={28,108,200},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Cold")}),
    experiment(
      Tolerance=1e-6, StopTime=1000),
    Documentation(info="<html>
<p>
Example model demonstrating the use of the <code>Buildings</code> components in a larger system.
This model is extended in
<a href=\"modelica://Buildings.Fluid.Examples.FlowSystem.Simplified1\">
Buildings.Fluid.Examples.FlowSystem.Simplified1</a>,
<a href=\"modelica://Buildings.Fluid.Examples.FlowSystem.Simplified2\">
Buildings.Fluid.Examples.FlowSystem.Simplified2</a>,
<a href=\"modelica://Buildings.Fluid.Examples.FlowSystem.Simplified3\">
Buildings.Fluid.Examples.FlowSystem.Simplified3</a>.
In these examples, the flow network is simplified in three steps, which reduces the size of algebraic loops.
</p>
<p>
The system model is for a hydronic system with a hot and cold water production device,
each having its own circulation pump.
The warm and cold supply water temperatures are selected by switching the bottom two-way valves.
The building consists of a west and east wing.
Each wing has multiple zones that are heated or cooled using the hydronic system.
Each wing has a north and south section with a different supply temperature,
which is controlled using two main three way valves.
In total there are therefore four supply pipes,
which are each connected to four or eight emission devices in the zones.
The flow through the emission devices is controlled using two way valves.
The emission device itself also generates a pressure drop,
represented by components <code>tabsX</code>.
Note that the emission devices are in the real building
cooling and heating concrete slabs, but this simplified example
only models their flow resistance.
The control model consists of dummy inputs.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2019 by Michael Wetter:<br/>
Removed <code>each</code> statements.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1079\">#1079</a>.
</li>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Basic.mos"
        "Simulate and plot"));
end Basic;
