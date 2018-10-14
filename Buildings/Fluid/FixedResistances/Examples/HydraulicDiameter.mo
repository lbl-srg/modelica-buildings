within Buildings.Fluid.FixedResistances.Examples;
model HydraulicDiameter
  "Example model for flow resistance with hydraulic diameter as parameter"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.Water "Medium model";

  Modelica.Blocks.Sources.Ramp P(
    duration=1,
    height=4000,
    offset=300000 - 2000)
     "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=2)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=2,
    p(displayUnit="Pa") = 300000)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{50,-10},{30,10}})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter res(
    redeclare package Medium = Medium,
    m_flow_nominal=0.2,
    v_nominal=1,
    from_dp=true,
    length=1)
    "Fixed resistance with specified hydraulic diameter"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter resLarPip(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=10,
    length=100)
    "Fixed resistance with specified hydraulic diameter of a large pipe"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(P.y, sou.p_in) annotation (Line(points={{-71,8},{-62,8},{-52,8}},
                    color={0,0,127}));
  connect(sou.ports[1], res.port_a)
    annotation (Line(points={{-30,2},{-10,2}},          color={0,127,255}));
  connect(res.port_b, sin.ports[1])
    annotation (Line(points={{10,2},{30,2}},           color={0,127,255}));
  connect(resLarPip.port_a, sou.ports[2]) annotation (Line(points={{-10,-40},{
          -16,-40},{-16,-2},{-30,-2}},
                                   color={0,127,255}));
  connect(resLarPip.port_b, sin.ports[2]) annotation (Line(points={{10,-40},{20,
          -40},{20,-2},{30,-2}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/HydraulicDiameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for a fixed resistance that takes as a parameter the hydraulic diameter.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2018, by Michael Wetter:<br/>
Updated example to add a large diameter pipe, and to use water.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1026\">#1026</a>.
</li>
<li>
December 1, 2016, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/480\">#480</a>.
</li>
</ul>
</html>"));
end HydraulicDiameter;
