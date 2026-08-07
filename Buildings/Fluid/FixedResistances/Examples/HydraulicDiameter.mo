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
    length=1,
    rTub=0.015,
    eTub=0.0015,
    roughness=0.001e-3,
    nBend=1,
    kBend=0.5)
    "Fixed resistance with pressure drop computed from pipe geometry"
    annotation (Placement(transformation(extent={{-10,-8},{10,12}})));

  Buildings.Fluid.FixedResistances.HydraulicDiameter resLarPip(
    redeclare package Medium = Medium,
    m_flow_nominal=10,
    length=100,
    rTub=0.0615,
    eTub=0.005,
    roughness=0.001e-3,
    nBend=1,
    kBend=0.5)
    "Fixed resistance with pressure drop computed from geometry of a large pipe"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation
  connect(P.y, sou.p_in)
    annotation (Line(points={{-71,8},{-62,8},{-52,8}},
                    color={0,0,127}));

  connect(sou.ports[1], res.port_a)
    annotation (Line(points={{-30,2},{-10,2}},
                    color={0,127,255}));

  connect(res.port_b, sin.ports[1])
    annotation (Line(points={{10,2},{30,2}},
                    color={0,127,255}));

  connect(resLarPip.port_a, sou.ports[2])
    annotation (Line(points={{-10,-40},{-16,-40},{-16,-2},{-30,-2}},
                    color={0,127,255}));

  connect(resLarPip.port_b, sin.ports[2])
    annotation (Line(points={{10,-40},{20,-40},{20,-2},{30,-2}},
                    color={0,127,255}));

  annotation (
    experiment(Tolerance=1e-6, StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/HydraulicDiameter.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for a fixed resistance that computes the pressure drop from pipe
geometry using a Darcy-Weisbach pressure loss calculation.
</p>
<p>
The model compares two pipe geometries. The pressure difference across the
components is imposed by two pressure boundary conditions. The source pressure
is ramped so that the pressure difference changes sign during the simulation.
</p>
<p>
The example can be used to inspect the resulting mass flow rate, total pressure
drop, major pressure drop, minor pressure drop and Reynolds number.
</p>
</html>", revisions="<html>
<ul>
<li>
August 7, 2026, by Lone Meertens:<br/>
Updated the example for the Darcy-Weisbach implementation of
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>.
The example now parameterizes the resistance using pipe geometry and plots
the major pressure drop, minor pressure drop and Reynolds number.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4687\">Buildings, #4687</a>.
</li>
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
