within Buildings.Fluid.FixedResistances.Examples;
model PressureDrop
  "Example model for flow resistance with nominal pressure drop as parameter"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Air "Medium model";

  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=20,
    offset=101325 - 10) "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=1)
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

  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    from_dp=true,
    dp_nominal=10)
    "Fixed resistance"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(P.y, sou.p_in) annotation (Line(points={{-71,8},{-62,8},{-52,8}},
                    color={0,0,127}));
  connect(sou.ports[1], res.port_a)
    annotation (Line(points={{-30,0},{-10,0}},          color={0,127,255}));
  connect(res.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{10,0},{30,0}},    color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/PressureDrop.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for a fixed resistance that takes as a parameter the
pressure drop at nominal condition.
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
end PressureDrop;
