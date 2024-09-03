within Buildings.Airflow.Multizone.BaseClasses;
partial model PartialOneWayFlowElement
  "Partial model for flow resistance with one-way flow"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final allowFlowReversal=true);
  extends Buildings.Airflow.Multizone.BaseClasses.ErrorControl;

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true, Dialog(tab="Advanced"));

  parameter Boolean useDefaultProperties=true
    "Set to false to use density and viscosity based on actual medium state, rather than using default values"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.Units.SI.PressureDifference dp_turbulent(min=0, displayUnit="Pa") = 0.1
    "Pressure difference where laminar and turbulent flow relation coincide. Recommended = 0.1"
    annotation(Dialog(tab="Advanced"));

  Modelica.Units.SI.VolumeFlowRate V_flow = m_flow/rho
    "Volume flow rate through the component";
  Modelica.Units.SI.Density rho "Fluid density at port_a";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default)
    "State of the medium at the medium default properties";
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density at the medium default properties";
  parameter Modelica.Units.SI.DynamicViscosity dynVis_default=
    Medium.dynamicViscosity(sta_default)
    "Dynamic viscosity at the medium default properties";

  Medium.ThermodynamicState sta "State of the medium in the component";
  Modelica.Units.SI.DynamicViscosity dynVis "Dynamic viscosity";
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
    sta = sta_default;
    rho = rho_default;
    dynVis = dynVis_default;

  else
    sta = if homotopyInitialization then
        Medium.setState_phX(
          port_a.p,
          homotopy(
            actual=actualStream(port_a.h_outflow),
            simplified=inStream(port_a.h_outflow)),
          homotopy(
            actual=actualStream(port_a.Xi_outflow),
            simplified=inStream(port_a.Xi_outflow)))
      else
        Medium.setState_phX(
          port_a.p,
          actualStream(port_a.h_outflow),
          actualStream(port_a.Xi_outflow));

    rho = Medium.density(sta);
    dynVis = Medium.dynamicViscosity(sta);
  end if;

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

  m_flow=port_a.m_flow;

  annotation (
    Documentation(info="<html>
<p>
This partial model is used to model one way flow-elements.
It holds the conservation equations and should be extended by
definition of <u><b>one</b></u> of the following variables:
</p>
<p>m_flow = mass flow rate trough the component</p>
<p>or</p>
<p>V_flow = volume flow rate through the component</p>
<p>
The flow from A-&gt;B is the positive flow.
The resulting equation should be in the <code>extends</code> statement,
not in the equation section since this model sets both
<code>m_flow = V_flow*rho</code> and <code>V_flow = m_flow/rho</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
Apr 06, 2021, by Klaas De Jonge:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialOneWayFlowElement;
