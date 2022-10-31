within Buildings.Fluid.FixedResistances.BaseClasses;
model PlugFlow
  "Lossless pipe model with spatialDistribution plug flow implementation"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.Units.SI.Length dh
    "Hydraulic diameter (assuming a round cross section area)";
  parameter Modelica.Units.SI.Length length(min=0) "Pipe length";
  final parameter Modelica.Units.SI.Area A=Modelica.Constants.pi*(dh/2)^2
    "Cross-sectional area of pipe";

  parameter Medium.MassFlowRate m_flow_small
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter Modelica.Units.SI.Temperature T_start_in=Medium.T_default
    "Initial temperature in pipe at inlet"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.Temperature T_start_out=Medium.T_default
    "Initial temperature in pipe at outlet"
    annotation (Dialog(group="Initialization"));

  Modelica.Units.SI.Length x
    "Spatial coordinate for spatialDistribution operator";
  Modelica.Units.SI.Velocity v "Flow velocity of medium in pipe";

  Modelica.Units.SI.VolumeFlowRate V_flow=port_a.m_flow/
      Modelica.Fluid.Utilities.regStep(
      port_a.m_flow,
      Medium.density(Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow))),
      Medium.density(Medium.setState_phX(
        p=port_b.p,
        h=inStream(port_b.h_outflow),
        X=inStream(port_b.Xi_outflow))),
      m_flow_small)
    "Volume flow rate at inflowing port (positive when flow from port_a to port_b)";


protected
  parameter Modelica.Units.SI.SpecificEnthalpy h_ini_in=Medium.specificEnthalpy(
      Medium.setState_pTX(
      T=T_start_in,
      p=Medium.p_default,
      X=Medium.X_default)) "For initialization of spatialDistribution inlet";

  parameter Modelica.Units.SI.SpecificEnthalpy h_ini_out=
      Medium.specificEnthalpy(Medium.setState_pTX(
      T=T_start_out,
      p=Medium.p_default,
      X=Medium.X_default)) "For initialization of spatialDistribution outlet";

  Medium.MassFraction Xi_inflow_a[Medium.nXi] = inStream(port_a.Xi_outflow)
    "Independent mixture mass fractions m_i/m close to the connection point flow into the component";
  Medium.MassFraction Xi_inflow_b[Medium.nXi] = inStream(port_b.Xi_outflow)
    "Independent mixture mass fractions m_i/m close to the connection point flow into the component";
  Medium.ExtraProperty C_inflow_a[Medium.nC] = inStream(port_a.C_outflow)
    "Properties c_i/m close to the connection point if flow into the component";
  Medium.ExtraProperty C_inflow_b[Medium.nC] = inStream(port_b.C_outflow)
    "Properties c_i/m close to the connection point if flow into the component";
initial equation
  x = 0;
equation
  // No pressure drop
  port_a.p = port_b.p;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  der(x) = v;
  v = V_flow/A;

  (port_a.h_outflow, port_b.h_outflow) = spatialDistribution(
    inStream(port_a.h_outflow),
    inStream(port_b.h_outflow),
    x/length,
    v >= 0,
    {0.0, 1.0},
    {h_ini_in, h_ini_out});

  // Transport of substances
  for i in 1:Medium.nXi loop
  (port_a.Xi_outflow[i], port_b.Xi_outflow[i]) = spatialDistribution(
    Xi_inflow_a[i],
    Xi_inflow_b[i],
    x/length,
    v >= 0,
    {0.0, 1.0},
    {0.01, 0.01});
  end for;

  for i in 1:Medium.nC loop
  (port_a.C_outflow[i], port_b.C_outflow[i]) = spatialDistribution(
    C_inflow_a[i],
    C_inflow_b[i],
    x/length,
    v >= 0,
    {0.0, 1.0},
    {0, 0});
  end for;


  annotation (
    Icon(graphics={
        Line(
          points={{-72,-28}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-100,60},{100,-60}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,50},{100,-48}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={217,236,256}),
        Rectangle(
          extent={{-20,50},{20,-48}},
          lineColor={175,175,175},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={175,175,175})}),
    Documentation(revisions="<html>
<ul>
<li>
October 20, 2017, by Michael Wetter:<br/>
Deleted various parameters and variables that were not used.
<br/>
Revised documentation to follow the guidelines.
</li>
<li>
May 19, 2016 by Marcus Fuchs:<br/>
Remove condition on <code>show_V_flow</code> for calculation of
<code>V_flow</code> to conform with pedantic checking.
</li>
<li>
October 10, 2015 by Marcus Fuchs:<br/>
Copy Icon from KUL implementation and rename model.
</li>
<li>
June 23, 2015 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model that computes the temperature propagation of
a fluid flow through a pipe, idealized as a plug flow.
</p>
<h4>Main equation</h4>
<p>
The transport delay is computed using the one-dimensional wave equation
without source or sink terms,
<p align=\"center\" style=\"font-style:italic;\">
&part;z(x,t)/&part;t + v(t) &part;z(x,t)/&part;x = 0,
</p>
<p>where <i>z(x,t)</i> is the spatial distribution as a function of time of any
property <i>z</i> of the fluid.
For the temperature propagation, <i>z </i>will be replaced by <i>T</i>.
</p>
<h4>Assumptions</h4>
<p>
This model is based on the following assumptions:
</p>
<ul>
<li>
Axial diffusion in water is assumed to be negligibe.
</li>
<li>
The water temperature is assumed uniform in a cross section.
</li>
</ul>
</html>"));
end PlugFlow;
