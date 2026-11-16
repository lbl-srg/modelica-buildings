within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_inv_der2
  "2nd derivative of basicFlowFunction_dp_inv"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real m_flow_der
    "1st derivative of mass flow rate in design flow direction";
  input Real m_flow_der2
    "2nd derivative of mass flow rate in design flow direction";
  output Real dp_der2
    "2nd derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";

protected
  Modelica.Units.SI.PressureDifference dp=
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv(
      m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  Real slope=
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
      dp=dp, k=k, m_flow_turbulent=m_flow_turbulent, dp_der=1)
    "Derivative of m_flow with respect to dp";
  Real dp_der=m_flow_der/slope
    "1st derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";

algorithm
  dp_der2 := (m_flow_der2 -
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
      dp=dp, k=k, m_flow_turbulent=m_flow_turbulent, dp_der=dp_der,
      dp_der2=0))
    /slope;

annotation (
  smoothOrder=0,
  Inline=false,
  Documentation(info="<html>
<p>
Function that implements the second order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv</a>,
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
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>.
Differentiating <code>m_flow = f(dp)</code> twice gives
<code>m_flow_der2 = f'(dp) dp_der2 + f''(dp) dp_der^2</code>,
which this function solves for <code>dp_der2</code>.
The term <code>f'(dp)</code> is computed by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der</a>
with <code>dp_der=1</code>, and the term <code>f''(dp) dp_der^2</code> by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2</a>
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
end basicFlowFunction_dp_inv_der2;
