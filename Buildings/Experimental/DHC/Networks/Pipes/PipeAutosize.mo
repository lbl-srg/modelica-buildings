within Buildings.Experimental.DHC.Networks.Pipes;
model PipeAutosize
  "Pipe model parameterized with pressure drop per pipe length"
  extends Buildings.Fluid.FixedResistances.PressureDrop(
    final deltaM =  eta_default*dh/4*Modelica.Constants.pi*ReC/m_flow_nominal_pos,
    final dp_nominal=dp_length_nominal*length);

  parameter Modelica.Units.SI.Length dh(
    fixed=false,
    start=0.01,
    min=0.001) "Hydraulic diameter (assuming a round cross section area)";

  parameter Real dp_length_nominal(final unit="Pa/m") = 250
    "Pressure drop per pipe length at nominal flow rate";

  parameter Modelica.Units.SI.Length length "Length of the pipe";

  parameter Real ReC(min=0)=4000
    "Reynolds number where transition to turbulence starts";
  parameter Modelica.Units.SI.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe (PE100: 7E-6)";

  parameter Real fac(min=1) = 2
    "Factor to take into account resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";

  final parameter Modelica.Units.SI.PressureDifference dpStraightPipe_nominal(
      displayUnit="Pa")=
    Modelica.Fluid.Pipes.BaseClasses.WallFriction.Detailed.pressureLoss_m_flow(
    m_flow=m_flow_nominal,
    rho_a=rho_default,
    rho_b=rho_default,
    mu_a=mu_default,
    mu_b=mu_default,
    length=length,
    diameter=dh,
    roughness=roughness,
    m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  Modelica.Units.SI.Velocity v=m_flow/(rho_default*ARound)
    "Flow velocity (assuming a round cross section area)";

protected
  parameter Modelica.Units.SI.Area ARound=dh^2*Modelica.Constants.pi/4
    "Cross sectional area (assuming a round cross section area)";

  parameter Modelica.Units.SI.Velocity v_nominal=m_flow_nominal/(rho_default*
      ARound)
    "Velocity at m_flow_nominal (used to compute default value for hydraulic diameter dh)";

  parameter Medium.ThermodynamicState state_default=
    Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";

  parameter Modelica.Units.SI.Density rho_default=Medium.density(state_default)
    "Density at nominal condition";

  parameter Modelica.Units.SI.DynamicViscosity mu_default=
      Medium.dynamicViscosity(state_default)
    "Dynamic viscosity at nominal condition";
initial equation
  dp_nominal = fac*dpStraightPipe_nominal;

annotation (
    DefaultComponentName="pipCon",
    Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}),
    Documentation(info="<html>
<p>
This model is similar to
<a href=\"modelica://Buildings.Fluid.FixedResistances.HydraulicDiameter\">
Buildings.Fluid.FixedResistances.HydraulicDiameter</a>
except for the modifications below which allow to use this model for computing the
hydraulic diameter at initialization, based on the pressure drop per pipe length
at nominal flow rate.
</p>
<ul>
<li>
The parameter <code>v_nominal</code> is computed based on the nominal flow rate.
</li>
<li>
The equation <code>dp_nominal = fac*dpStraightPipe_nominal</code> is
solved at initialization for the hydraulic diameter <code>dh</code>.
</li>
<li>
The parameter <code>dp_nominal</code> is assigned a value that does not need
to be computed at initialization.
This is required per Modelica specification because
the structural parameter <code>computeFlowResistance</code>
depends on <code>dp_nominal</code> and must be evaluated at compile time.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by David Blum:<br/>
<code>start</code> attribute for parameter <code>dh</code> changed to 0.01.<br/>
<code>min</code> attribute for parameter <code>dh</code> changed to 0.001.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2510\">issue 2510</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeAutosize;
