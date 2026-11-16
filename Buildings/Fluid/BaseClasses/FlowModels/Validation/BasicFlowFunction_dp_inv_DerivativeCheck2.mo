within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_dp_inv_DerivativeCheck2
  "Model that checks the correct implementation of the 1st and 2nd order derivative of the inverse of the flow function"
  extends Modelica.Icons.Example;

  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.36
    "Mass flow rate where transition to turbulent flow occurs";

  Modelica.Units.SI.PressureDifference dp "Pressure difference";
  Modelica.Units.SI.PressureDifference dp_comp "Comparison value for dp";
  Real der_dp(unit="Pa/s") "1st order derivative of pressure difference";
  Real der_dp_comp(unit="Pa/s")
    "1st order derivative of comparison value for dp";
  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  Modelica.Units.SI.PressureDifference err_dp "Integration error for dp";
  Real err_der_dp(unit="Pa/s") "Integration error for der_dp";

initial equation
  dp = dp_comp;
  der_dp = der_dp_comp;
equation
  // Multiply by 1 to avoid a warning due to unit mismatch,
  // and raise to third power so that m_flow_der2 has positive and negative sign
  // in Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2
  m_flow = 1*time^3;
  dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv(
    m_flow=m_flow,
    k=k,
    m_flow_turbulent=m_flow_turbulent);
  // Equate first and second order derivatives
  der_dp      = der(dp);
  der_dp_comp = der(dp_comp);
  der(der_dp) = der(der_dp_comp);
  // Error control
  err_dp = dp-dp_comp;
  assert(abs(err_dp) < 1E-3, "Error in implementation.");
  err_der_dp = der_dp-der_dp_comp;
  assert(abs(err_der_dp) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_dp_inv_DerivativeCheck2.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv</a>
and its first and second order derivatives
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der</a>
and
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
<h4>Implementation</h4>
<p>
The mass flow rate <code>m_flow</code> is increased non-linearly in order
for the first and second derivatives in
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2</a>
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
end BasicFlowFunction_dp_inv_DerivativeCheck2;
