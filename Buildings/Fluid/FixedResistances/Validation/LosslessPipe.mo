within Buildings.Fluid.FixedResistances.Validation;
model LosslessPipe "Validation model for lossless pipe"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model";

  Modelica.Blocks.Sources.Ramp m_flow(
    duration=1,
    offset=-1,
    height=2)  "Mass flow source"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    T=273.15 + 20)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{50,-10},{30,10}})));

  Buildings.Fluid.FixedResistances.LosslessPipe res(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=1)
    "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(sou.ports[1], res.port_a)
    annotation (Line(points={{-30,0},{-10,0}},          color={0,127,255}));
  connect(res.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{10,0},{30,0}},    color={0,127,255}));
  connect(m_flow.y, sou.m_flow_in)
    annotation (Line(points={{-71,8},{-52,8},{-52,8}},   color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Validation/LosslessPipe.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model for a the pipe model with no friction and no heat loss.
</p>
</html>", revisions="<html>
<ul>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
</ul>
</html>"));
end LosslessPipe;
