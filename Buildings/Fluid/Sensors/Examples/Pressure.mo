within Buildings.Fluid.Sensors.Examples;
model Pressure "Test model for the pressure sensor"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air
    "Medium model";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=293.15,
    nPorts=1) "Flow boundary condition" annotation (Placement(
        transformation(extent={{62,-10},{42,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    use_T_in=false,
    X={0.02,0.98},
    use_m_flow_in=true,
    nPorts=1) "Flow boundary condition"
     annotation (Placement(transformation(
          extent={{-52,-10},{-32,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop dp(
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    dp_nominal=200) "Flow resistance"
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=-20,
    offset=10,
    duration=1)
    annotation (Placement(transformation(extent={{-90,-2},{-70,18}})));
  Buildings.Fluid.Sensors.Pressure senPre_a(redeclare package Medium = Medium)
    "Pressure sensor at resistance port a"
    annotation (Placement(transformation(extent={{-22,20},{-2,40}})));
  Buildings.Fluid.Sensors.Pressure senPre_b(redeclare package Medium = Medium)
    "Pressure sensor at resistance port b"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = Medium) "Pressure difference across resistance"
    annotation (Placement(transformation(extent={{-2,-50},{18,-30}})));
equation
  connect(ramp.y, masFloRat.m_flow_in) annotation (Line(
      points={{-69,8},{-54,8}},
      color={0,0,127}));
  connect(masFloRat.ports[1], dp.port_a) annotation (Line(
      points={{-32,0},{-18,0},{-18,6.66134e-16},{-2,6.66134e-16}},
      color={0,127,255}));
  connect(dp.port_b, sin.ports[1]) annotation (Line(
      points={{18,6.66134e-16},{28,6.66134e-16},{28,8.88178e-16},{42,8.88178e-16}},
      color={0,127,255}));

  connect(senPre_a.port, dp.port_a) annotation (Line(
      points={{-12,20},{-12,0},{-2,0}},
      color={0,127,255}));
  connect(senPre_b.port, dp.port_b) annotation (Line(
      points={{30,20},{30,0},{18,0}},
      color={0,127,255}));
  connect(senRelPre.port_a, dp.port_a) annotation (Line(
      points={{-2,-40},{-12,-40},{-12,0},{-2,0}},
      color={0,127,255}));
  connect(senRelPre.port_b, dp.port_b) annotation (Line(
      points={{18,-40},{30,-40},{30,0},{18,0}},
      color={0,127,255}));
    annotation (experiment(Tolerance=1e-6, StopTime=1),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/Pressure.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the pressure sensors.
</p>
</html>", revisions="<html>
<ul>
<li>
August 31, 2013 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Pressure;
