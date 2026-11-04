within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_m_flow_inv_DerivativeCheck2
  "Model that checks the correct implementation of the 1st and 2nd order derivative of the inverse of the flow function"
  extends Modelica.Icons.Example;

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.36
    "Mass flow rate where transition to turbulent flow occurs";

  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.MassFlowRate m_flow_comp "Comparison value for m_flow";
  Real der_m_flow(unit="kg/s2") "1st order derivative of mass flow rate";
  Real der_m_flow_comp(unit="kg/s2")
    "1st order derivative of comparison value for m_flow";
  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.MassFlowRate err_m_flow "Integration error for m_flow";
  Real err_der_m_flow(unit="kg/s2") "Integration error for der_m_flow";

initial equation
  m_flow = m_flow_comp;
  der_m_flow = der_m_flow_comp;
equation
  // Multiply by 1 to avoid a warning due to unit mismatch,
  // and raise to third power so that dp_der2 has positive and negative sign
  // in Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2
  dp = 1*time^3;
  m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv(
    dp=dp,
    k=k,
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
      Tolerance=1e-08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_m_flow_inv_DerivativeCheck2.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv</a>
and its first and second order derivatives
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
<h4>Implementation</h4>
<p>
The pressure difference <code>dp</code> is increased non-linearly in order
for the first and second derivatives in
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2</a>
to be non-zero during part of the simulation.
The input sweeps through the laminar and the turbulent region.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 22, 2026, by Martin Sj&ouml;lund:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4798\">Buildings, #4798</a>.
</li>
</ul>
</html>"));
end BasicFlowFunction_m_flow_inv_DerivativeCheck2;
