within Buildings.Airflow.Multizone.BaseClasses;
partial model PowerLawResistance "Flow resistance that uses the power law"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=true,
    final m_flow_nominal=rho_default*k*dp_turbulent,
    final m_flow_small=1E-4*abs(m_flow_nominal));
  extends Buildings.Airflow.Multizone.BaseClasses.ErrorControl;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  parameter Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  parameter Boolean useDefaultProperties=true
    "Set to false to use density and viscosity based on actual medium state, rather than using default values"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.PressureDifference dp_turbulent(min=0, displayUnit="Pa") = 0.1
    "Pressure difference where laminar and turbulent flow relation coincide. Recommended = 0.1"
    annotation(Dialog(tab="Advanced"));

  Modelica.SIunits.VolumeFlowRate V_flow
    "Volume flow rate through the component";
  Modelica.SIunits.Velocity v(nominal=1) "Average velocity";
  Modelica.SIunits.Density rho "Fluid density at port_a";

protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";

  parameter Real k "Flow coefficient, k = V_flow/ dp^m";

  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default)
    "State of the medium at the medium default properties";
  parameter Modelica.SIunits.Density rho_default=Medium.density(sta_default)
    "Density at the medium default properties";
  parameter Modelica.SIunits.DynamicViscosity dynVis_default=
    Medium.dynamicViscosity(sta_default)
    "Dynamic viscosity at the medium default properties";

  parameter Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real b = 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real c = -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  parameter Real d = 1/8*m^2 - gamma - m + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";

  Medium.ThermodynamicState sta "State of the medium in the component";
  Modelica.SIunits.DynamicViscosity dynVis "Dynamic viscosity";
  Real mExc(quantity="Mass", final unit="kg")
    "Air mass exchanged (for purpose of error control only)";
initial equation
  mExc=0;
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  if forceErrorControlOnFlow then
    der(mExc) = port_a.m_flow;
  else
    der(mExc) = 0;
  end if;

  if useDefaultProperties then
    sta    = sta_default;
    rho    = rho_default;
    dynVis = dynVis_default;
  else
    sta    = if homotopyInitialization then
                Medium.setState_phX(port_a.p,
                          homotopy(actual=actualStream(port_a.h_outflow),
                                   simplified=inStream(port_a.h_outflow)),
                          homotopy(actual=actualStream(port_a.Xi_outflow),
                                   simplified=inStream(port_a.Xi_outflow)))
             else
               Medium.setState_phX(port_a.p,
                          actualStream(port_a.h_outflow),
                          actualStream(port_a.Xi_outflow));

    rho    = Medium.density(sta);
    dynVis = Medium.dynamicViscosity(sta);
  end if;

  V_flow = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
    k=k,
    dp=dp,
    m=m,
    a=a,
    b=b,
    c=c,
    d=d,
    dp_turbulent=dp_turbulent);

  port_a.m_flow = rho*V_flow;

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
    Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of an orifice in the form
</p>
<pre>
    V_flow = k * dp^m,
</pre>
<p>
where <code>k</code> is a variable and
<code>m</code> a parameter.
For turbulent flow, set <code>m=1/2</code> and
for laminar flow, set <code>m=1</code>.
</p>
<p>
The model is used as a base for the interzonal air flow models.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 12, 2020, by Michael Wetter:<br/>
Changed assignment of <code>m_flow_small</code> to <code>final</code>.
This quantity are not used in this model and models that extend from it.
Hence there is no need for the user to change the value.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>
June 24, 2018, by Michael Wetter:<br/>
Removed parameter <code>A</code> because
<a href=\"modelica://Buildings.Airflow.Multizone.EffectiveAirLeakageArea\">
Buildings.Airflow.Multizone.EffectiveAirLeakageArea</a>
uses the effective leakage area <code>L</code> rather than <code>A</code>.<br/>
Removed calculation <code>v=V_flow/A</code> as parameter <code>A</code> has been removed.<br/>
Removed parameter <code>lWet</code> as this is only used to compute
the Reynolds number, and the Reynolds number is not used by this model.
Also removed the variable <code>Re</code> for the Reynolds number.<br/>
This change is non-backward compatible.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/932\">IBPSA, #932</a>.
</li>
<li>
May 1, 2018, by Filip Jorissen:<br/>
Set <code>final allowFlowReversal=true</code>.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/877\">#877</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
November 19, 2015, by Michael Wetter:<br/>
Removed assignment of parameter
<code>showDesignFlowDirection</code> in <code>extends</code> statement.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/349\">#349</a>.
</li>
<li>
January 21, 2015 by Michael Wetter:<br/>
Changed type of <code>mExc</code> as <code>Modelica.SIunits.Mass</code>
sets <code>min=0</code>, but <code>mExc</code> can be negative.
</li>
<li>
October 8, 2013 by Michael Wetter:<br/>
Changed the parameter <code>useConstantDensity</code> to
<code>useDefaultProperties</code> and also applied the parameter
to the computation of the dynamic viscosity.
The conversion script can be used to update this parameter.<br/>
Change model to not use the instance <code>sta_a</code>, as this
may be conditionally removed and hence it is not proper Modelica
syntax to use it outside of a <code>connect</code> statement.
</li>
<li>
March 27, 2013 by Michael Wetter:<br/>
Added assignment of initial value for <code>mExc</code> to avoid error when checking model
in pedantic mode with Dymola 2014.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>December 6, 2011 by Michael Wetter:<br/>
       Removed <code>fixed=false</code> attribute of protected parameter
       <code>k</code>.
</li>
<li>July 20, 2010 by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li>February 4, 2005 by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end PowerLawResistance;
