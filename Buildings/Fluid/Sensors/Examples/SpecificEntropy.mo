within Buildings.Fluid.Sensors.Examples;
model SpecificEntropy "Test model for the entropy flow rate sensors"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  Buildings.Fluid.Sources.MassFlowSource_h sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_h_in=false,
    nPorts=2) "Flow boundary condition"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Fluid.Sources.Boundary_ph sin(
    redeclare package Medium = Medium,
    use_h_in=false,
    h=20,
    nPorts=1) "Flow boundary condition"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={70,-12})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-2,
    offset=1,
    duration=60)
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));

  Buildings.Fluid.Sensors.SpecificEntropy senFloSou(
    redeclare package Medium = Medium, warnAboutOnePortConnection=false)
                                       "Sensor at the flow source"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.Sensors.SpecificEntropyTwoPort senStr(
    redeclare package Medium = Medium,
    m_flow_nominal=2) "Sensor in the fluid stream"
    annotation (Placement(transformation(extent={{20,-22},{40,-2}})));
equation
  connect(ramp.y, sou.m_flow_in) annotation (Line(
      points={{-59,-2},{-42,-2}},
      color={0,0,127}));
  connect(sou.ports[1], senFloSou.port) annotation (Line(
      points={{-20,-8},{0,-8},{0,0}},
      color={0,127,255}));
  connect(sou.ports[2], senStr.port_a) annotation (Line(
      points={{-20,-12},{20,-12}},
      color={0,127,255}));
  connect(senStr.port_b, sin.ports[1]) annotation (Line(
      points={{40,-12},{60,-12}},
      color={0,127,255}));
    annotation (
experiment(Tolerance=1e-6, StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/SpecificEntropy.mos"
        "Simulate and plot"),    Documentation(info="<html>
<p>
This example tests the specific entropy sensors.
</p>
</html>", revisions="<html>
<ul>
<li>
August 31, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpecificEntropy;
