within Buildings.Fluid.FixedResistances.Validation;
model FlowJunctionSteadyStateNoPressureDrop
  "Test model for the three way splitter/mixer model configured as steady-state"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model";

  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare package Medium = Medium,
    m_flow_nominal={2,2,2},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal={0,0,0}) "Splitter"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    use_m_flow_in=true) "Mass flow boundary condition"
     annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{90,-10},{70,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T bou3(
    redeclare package Medium = Medium,
    T=273.15 + 30,
    nPorts=1,
    use_m_flow_in=true) "Mass flow boundary condition"
    annotation (Placement(transformation(
          extent={{-60,-70},{-40,-50}})));

  Modelica.Blocks.Sources.Ramp m1_flow(
    duration=20,
    startTime=20,
    height=1,
    offset=-1) "Ramp mass flow signal"
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));

  Modelica.Blocks.Sources.Ramp m3_flow(
    height=1,
    duration=20,
    startTime=70,
    offset=1)     "Ramp mass flow signal"
    annotation (Placement(transformation(extent={{-92,-62},{-72,-42}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = Medium,
    m_flow_nominal=2)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem3(
    redeclare package Medium = Medium,
    m_flow_nominal=3)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
equation
  connect(bou3.ports[1], senTem3.port_a) annotation (Line(points={{-40,-60},{-40,
          -60},{-20,-60}}, color={0,127,255}));
  connect(senTem3.port_b, spl.port_3)
    annotation (Line(points={{0,-60},{20,-60},{20,-10}}, color={0,127,255}));
  connect(bou1.ports[1], senTem1.port_a)
    annotation (Line(points={{-40,0},{-30,0},{-20,0}}, color={0,127,255}));
  connect(senTem1.port_b, spl.port_1)
    annotation (Line(points={{0,0},{5,0},{10,0}}, color={0,127,255}));
  connect(spl.port_2, senTem2.port_a)
    annotation (Line(points={{30,0},{35,0},{40,0}}, color={0,127,255}));
  connect(senTem2.port_b, bou2.ports[1])
    annotation (Line(points={{60,0},{70,0}},        color={0,127,255}));
  connect(m1_flow.y, bou1.m_flow_in)
    annotation (Line(points={{-69,8},{-62,8}}, color={0,0,127}));
  connect(m3_flow.y, bou3.m_flow_in)
    annotation (Line(points={{-71,-52},{-62,-52}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=100),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/FlowJunctionSteadyStateNoPressureDrop.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the use of the splitter and mixer model
for different flow directions.
The example is configured such that the flow changes its direction in
each flow leg between <i>t = 0</i> seconds to <i>t = 100</i> seconds.
The splitter model has been configured as a steady-state model,
with no flow resistance.
</p>
</html>", revisions="<html>
<ul>
<li>
January 18, 2017, by Michael Wetter:<br/>
Changed <code>spl.m_flow_nominal</code>, boundary condition and enabled sensor dynamics.<br/>
This is for
<a href=\"modelica://https://github.com/ibpsa/modelica-ibpsa/issues/657\">issue 657</a>.
</li>
<li>
October 14, 2016, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"modelica://https://github.com/ibpsa/modelica-ibpsa/issues/451\">issue 451</a>.
</li>
</ul>
</html>"));
end FlowJunctionSteadyStateNoPressureDrop;
