within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_inv_der
  "1st derivative of basicFlowFunction_m_flow_inv"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real dp_der
    "Derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  output Real m_flow_der
    "Derivative of mass flow rate in design flow direction";

protected
  Modelica.Units.SI.MassFlowRate m_flow=
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv(
      dp=dp, k=k, m_flow_turbulent=m_flow_turbulent)
    "Mass flow rate in design flow direction";

algorithm
  m_flow_der := dp_der/
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der(
      m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent,
      m_flow_der=1);

annotation (
  smoothOrder=1,
  Inline=false,
  derivative(
    order=2,
    zeroDerivative=k,
    zeroDerivative=m_flow_turbulent)=
      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv_der2,
  Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_inv</a>,
assuming constant flow coefficients.
</p>
<p>
When called with <code>dp_der=der(dp)</code>, this function returns
the time derivative of <code>m_flow</code>.
When called with <code>dp_der=1</code>, this function returns
the derivative of <code>m_flow</code> with respect to <code>dp</code>.
</p>
<h4>Implementation</h4>
<p>
The derivative of the inverse function is the reciprocal of the derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>,
which is computed by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der</a>.
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
end basicFlowFunction_m_flow_inv_der;
