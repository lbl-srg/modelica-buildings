within Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.BaseClasses;
model PipeConnection
  "Connection pipe"
  extends Buildings.Fluid.FixedResistances.PressureDrop(
    final deltaM =  eta_default*dh/4*Modelica.Constants.pi*ReC/m_flow_nominal_pos,
    final dp_nominal=dp_length_nominal*length);
  parameter Real dp_length_nominal(final unit="Pa/m")
    "Pressure drop per pipe length at nominal mass flow rate";
  parameter Modelica.SIunits.Length length "Length of pipe";
  parameter Real ReC(min=0) = 4000
    "Reynolds number where transition to turbulent starts";
  parameter Modelica.SIunits.Length roughness(min=0) = 2.5e-5
    "Absolute roughness of pipe, with a default for a smooth steel pipe";
  parameter Real fac(min=1) = 2
    "Factor to take into account resistance of bends etc., fac=dp_nominal/dpStraightPipe_nominal";
  final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(
    displayUnit="Pa") = Modelica.Fluid.Pipes.BaseClasses.WallFriction.QuadraticTurbulent.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=dh,
      roughness=2.5E-5,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";
  parameter Modelica.SIunits.Length dh "Pipe diameter";
  final parameter Modelica.SIunits.Velocity v_nominal = m_flow_nominal/(rho_default*ARound)
    "Flow velocity (assuming a round cross section area)";
protected
  parameter Modelica.SIunits.Area ARound = dh^2*Modelica.Constants.pi/4
     "Cross sectional area (assuming a round cross section area)";
  parameter Medium.ThermodynamicState state_default=
    Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default[1:Medium.nXi]) "Default state";
  parameter Modelica.SIunits.Density rho_default = Medium.density(state_default)
    "Density at nominal condition";
  parameter Modelica.SIunits.DynamicViscosity mu_default = Medium.dynamicViscosity(
      state_default)
    "Dynamic viscosity at nominal condition";
annotation (
    DefaultComponentName="pipCon",
    Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}));
end PipeConnection;
