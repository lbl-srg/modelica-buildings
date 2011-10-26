within Buildings.Airflow.Multizone.BaseClasses;
partial model PowerLawResistance "Flow resistance that uses the power law"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(final
      m_flow_nominal=rho_nominal*k*dp_turbulent, final show_V_flow=true,
      final show_T=true);
  extends Buildings.Airflow.Multizone.BaseClasses.ErrorControl;

  parameter Modelica.SIunits.Area A "|Orifice characteristics|Area of orifice";

  parameter Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Boolean useConstantDensity=true
    "Set to false to use density based on state (as implemented by the Medium model)"
    annotation (Evaluate=true);
  Modelica.SIunits.Density rho "Fluid density at port_a";
  parameter Modelica.SIunits.Pressure dp_turbulent(min=0, displayUnit="Pa") = 0.1
    "Pressure difference where laminar and turbulent flow relation coincide. Recommended = 0.1";
  Modelica.SIunits.Velocity v(nominal=1) "Average velocity";
  parameter Modelica.SIunits.Length lWet=sqrt(A)
    "Wetted perimeter used for Reynolds number calculation";
  Real Re "Reynolds number";

protected
  parameter Real k(fixed=false) "Flow coefficient, k = V_flow/ dp^m";

  parameter Medium.ThermodynamicState sta0=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default);
  parameter Modelica.SIunits.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid volume";

  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  parameter Real a = gamma 
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";

  Modelica.SIunits.DynamicViscosity dynVis "Dynamic viscosity";

  Modelica.SIunits.Mass mExc(start=0)
    "Air mass exchanged (for purpose of error control only)";

equation
  if forceErrorControlOnFlow then
    der(mExc) = port_a.m_flow;
  else
    der(mExc) = 0;
  end if;

  rho = if useConstantDensity then rho_nominal else Medium.density(sta_a);
  dynVis = Medium.dynamicViscosity(sta_a);
  port_a.m_flow = rho*Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
    k=k,
    dp=dp,
    m=m,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent);
  v = V_flow/A;
  Re = v*lWet*rho/dynVis;

  // Isenthalpic state transformation (no storage and no loss of energy)
  port_a.h_outflow = inStream(port_b.h_outflow);
  port_b.h_outflow = inStream(port_a.h_outflow);

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = inStream(port_b.Xi_outflow);
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = inStream(port_b.C_outflow);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (
    Diagram(graphics),
    Icon(graphics),
    Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of an orifice in the form
<PRE>
    V_flow = k * dp^m,
</PRE>
where <code>k</code> is a variable and
<code>m</code> a parameter.
For turbulent flow, set <code>m=1/2</code> and
for laminar flow, set <code>m=1</code>. 
<P>
The model is used as a base for the interzonal air flow models.
</html>",
revisions="<html>
<ul>
<li><i>July 20, 2010</i> by Michael Wetter:<br>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 4, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end PowerLawResistance;
