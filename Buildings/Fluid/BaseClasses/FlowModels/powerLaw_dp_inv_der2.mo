within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_dp_inv_der2
  "2nd derivative of powerLaw_dp_inv"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFlowRate m_flow(displayUnit="kg/s")
    "Mass flow rate";
  input Real k "Flow coefficient, k = m_flow/ dp^(1/n)";
  input Real n(min=1, max=2)
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Modelica.Units.SI.PressureDifference dp_turbulent(displayUnit="Pa")
    "Pressure difference where turbulent flow occurs";
  input Real m(min=0.5, max=1) "Flow exponent for the pressure drop";
  input Real a1
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real a3
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real a5
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real C "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  input Real b1
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real b3
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real b5
    "Polynomial coefficient for regularized implementation of flow resistance";
  input Real m_flow_der
    "1st derivative of mass flow rate";
  input Real m_flow_der2
    "2nd derivative of mass flow rate";
  output Real dp_der2
    "2nd derivative of pressure difference";

protected
  Modelica.Units.SI.PressureDifference dp=
    Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv(
      m_flow=m_flow, k=k, n=n, m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5, C=C, b1=b1,
      b3=b3, b5=b5)
    "Pressure difference";
  Real slope=
    Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der(
      dp=dp, k=k, n=n, m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5, C=C, b1=b1,
      b3=b3, b5=b5, dp_der=1)
    "Derivative of m_flow with respect to dp";
  Real dp_der=m_flow_der/slope
    "1st derivative of pressure difference";

algorithm
  dp_der2 := (m_flow_der2 -
    Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2(
      dp=dp, k=k, n=n, m_flow_turbulent=m_flow_turbulent,
      dp_turbulent=dp_turbulent, m=m, a1=a1, a3=a3, a5=a5, C=C, b1=b1,
      b3=b3, b5=b5, dp_der=dp_der, dp_der2=0))
    /slope;

annotation (
  smoothOrder=0,
  Inline=false,
  Documentation(info="<html>
<p>
Function that implements the second order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_inv</a>,
assuming constant flow coefficients.
</p>
<p>
When called with <code>m_flow_der=der(m_flow)</code> and <code>m_flow_der2=der(m_flow_der)</code>,
this function returns the second order derivative of <code>dp</code>
with respect to time.
When called with <code>m_flow_der=1</code> and <code>m_flow_der2=0</code>,
this function returns the second order derivative of <code>dp</code>
with respect to <code>m_flow</code>.
</p>
<h4>Implementation</h4>
<p>
Let <i>f</i> denote
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp</a>.
Differentiating <code>m_flow = f(dp)</code> twice gives
<code>m_flow_der2 = f'(dp) dp_der2 + f''(dp) dp_der^2</code>,
which this function solves for <code>dp_der2</code>.
The term <code>f'(dp)</code> is computed by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der</a>
with <code>dp_der=1</code>, and the term <code>f''(dp) dp_der^2</code> by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2\">
Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp_der2</a>
with <code>dp_der2=0</code>.
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
end powerLaw_dp_inv_der2;
