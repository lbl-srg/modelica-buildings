within Buildings.Examples.DistrictReservoirNetworks.Networks;
model DistributionPipe "DHC distribution pipe"
  extends Buildings.Fluid.FixedResistances.PressureDrop(
    final dp_nominal=R*length);

  parameter Real R(unit="Pa/m") "Pressure drop per meter at m_flow_nominal";
  final parameter Modelica.SIunits.Length length = 100 "Lenght of pipe";

  final parameter Modelica.SIunits.PressureDifference dpStraightPipe_nominal(displayUnit="Pa")=
      Modelica.Fluid.Pipes.BaseClasses.WallFriction.QuadraticTurbulent.pressureLoss_m_flow(
      m_flow=m_flow_nominal,
      rho_a=rho_default,
      rho_b=rho_default,
      mu_a=mu_default,
      mu_b=mu_default,
      length=length,
      diameter=diameter,
      roughness=2.5E-5,
      m_flow_small=m_flow_small)
    "Pressure loss of a straight pipe at m_flow_nominal";

  final parameter Modelica.SIunits.Length diameter(fixed=false, start=0.2, min=0.01) "Pipe diameter";
  final parameter Modelica.SIunits.Velocity v_nominal = m_flow_nominal/(rho_default*ARound)
    "Flow velocity (assuming a round cross section area)";
protected
  parameter Modelica.SIunits.Area ARound = diameter^2*Modelica.Constants.pi/4
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

initial equation
  R * length = dpStraightPipe_nominal;
equation
  when terminal() then
    Modelica.Utilities.Streams.print("Pipe diameter for '" + getInstanceName() + "' is " + String(diameter) + " m.");
  end when;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,140,72})}));
end DistributionPipe;
