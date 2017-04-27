within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_dp_DerivativeCheck2
  "Model that checks the correct implementation of the 2nd order derivative of the flow function"
  extends Modelica.Icons.Example;

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.SIunits.MassFlowRate m_flow_turbulent = 0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  Modelica.SIunits.MassFlowRate m_flow_comp "Comparison value for m_flow";
  Real der_m_flow(unit="kg/s2") "1st order derivative of mass flow rate";
  Real der_m_flow_comp(unit="kg/s2")
    "2nd order derivative of comparison value for m_flow";

  Modelica.SIunits.PressureDifference dp "Pressure drop";
  Modelica.SIunits.MassFlowRate err_m_flow "Integration error for m_flow";
  Real err_der_m_flow(unit="kg/s2") "Integration error for der_m_flow";
initial equation
  m_flow = m_flow_comp;
  der_m_flow = der_m_flow_comp;
equation
  // Multiply by 1 to avoid a warning due to unit mismatch,
  // and raise to third power so that dp_der2 has positive and negative sign
  // in Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2
  dp = 1*time^3;

  m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
    dp=dp,
    k=  k,
    m_flow_turbulent=m_flow_turbulent);

  // Equate first and second order derivatives
  der_m_flow      = der(m_flow);
  der_m_flow_comp = der(m_flow_comp);
  der(der_m_flow) = der(der_m_flow_comp);

  // Error control
  err_m_flow = m_flow-m_flow_comp;
  assert(abs(err_m_flow) < 1E-3, "Error in implementation.");
  err_der_m_flow = der_m_flow-der_m_flow_comp;
  assert(abs(err_der_m_flow) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_dp_DerivativeCheck2.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
and its second order derivative
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
<h4>Implementation</h4>
<p>
The pressure drop <code>dp</code> is increased non-linearly in order
for the first and second derivatives in
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2</a>
to be non-zero during part of the simulation. This will ensure
full code coverage of this function.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BasicFlowFunction_dp_DerivativeCheck2;
