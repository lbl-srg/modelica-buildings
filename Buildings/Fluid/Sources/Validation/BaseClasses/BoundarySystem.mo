within Buildings.Fluid.Sources.Validation.BaseClasses;
model BoundarySystem "System model for testing of boundary condition"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

 Boundary_pT sou(redeclare final package Medium = Medium, nPorts=1) "Boundary"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  MassFlowSource_T sin(
    redeclare final package Medium = Medium,
    m_flow=-1,
    nPorts=1) "Mass flow source"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.SIunits.Temperature T = senTem.T "Temperature coming out of the source";
  Modelica.SIunits.MassFraction Xi[Medium.nXi]=sou.ports[1].Xi_outflow
    "Mass fraction coming out of the source";
  Modelica.SIunits.Pressure p = sou.ports[1].p "Pressure in the source";
  Modelica.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=1,
    m_flow_small=1E-4) "Temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(sou.ports[1], senTem.port_a)
    annotation (Line(points={{-40,0},{-10,0}}, color={0,127,255}));
  connect(sin.ports[1], senTem.port_b)
    annotation (Line(points={{40,0},{10,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
System model used to test the boundary conditions for different media.
This model has been introduced to get access to the medium mass fraction,
which is a protected variable in
<a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">
Buildings.Fluid.Sources.Boundary_pT</a>.
Therefore, this model has been created so that the boundary model has a port which
is used to access the mass fraction.
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2019 by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1205\">IBPSA, #1205</a>.
</li>
</ul>
</html>"));
end BoundarySystem;
