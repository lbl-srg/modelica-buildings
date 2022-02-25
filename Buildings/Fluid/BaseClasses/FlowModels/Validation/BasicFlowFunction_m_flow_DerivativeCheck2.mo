within Buildings.Fluid.BaseClasses.FlowModels.Validation;
model BasicFlowFunction_m_flow_DerivativeCheck2
  "Model that checks the correct implementation of the 2nd order derivative of the flow function"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Diagnostics.CheckEquality cheEqu1(
    threShold=1e-3)
    "Block for checking integration error";
  Buildings.Utilities.Diagnostics.CheckEquality cheEqu2(
    threShold=1e-3)
    "Block for checking integration error";
  parameter Real k = 0.35 "Flow coefficient";
  parameter Modelica.Units.SI.MassFlowRate m_flow_turbulent=0.36
    "Mass flow rate where transition to turbulent flow occurs";
  Modelica.Units.SI.PressureDifference dp "Pressure drop";
  Modelica.Units.SI.PressureDifference dp_comp "Comparison value for dp";
  Real der_dp(unit="Pa/s") "1st order derivative of pressure drop";
  Real der_dp_comp(unit="Pa/s")
    "2nd order derivative of comparison value for pressure drop";

  Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";

  Modelica.Units.SI.PressureDifference err_dp "Integration error for dp";
  Real err_der_dp(unit="Pa/s") "Integration error for der_dp";
initial equation
  dp = dp_comp;
  der_dp = der_dp_comp;
equation
  // Divide by 8 to avoid a warning due to unit mismatch, and
  // and raise to third power so that m_flow_der2 has positive and negative sign
  // in Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2
  m_flow = time^3/8;

  dp = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=m_flow,
    k = k,
    m_flow_turbulent=m_flow_turbulent);

  // Equate first and second order derivatives
  der_dp      = der(dp);
  der_dp_comp = der(dp_comp);
  der(der_dp) = der(der_dp_comp);

  // Error control
  cheEqu1.u1 = dp;
  cheEqu1.u2 = dp_comp;
  err_dp = cheEqu1.y;
  assert(abs(err_dp) < 1E-3, "Error in implementation.");
  cheEqu2.u1 = der_dp;
  cheEqu2.u2 = der_dp_comp;
  err_der_dp = cheEqu2.y;
  assert(abs(err_der_dp) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-2,
      StopTime=2,
      Tolerance=1e-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BaseClasses/FlowModels/Validation/BasicFlowFunction_m_flow_DerivativeCheck2.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
and its second order derivative
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
<h4>Implementation</h4>
<p>
The mass flow rate <code>m_flow</code> is increased non-linearly in order
for the first and second derivatives in
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2</a>
to be non-zero during part of the simulation. This will ensure
full code coverage of this function.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end BasicFlowFunction_m_flow_DerivativeCheck2;
