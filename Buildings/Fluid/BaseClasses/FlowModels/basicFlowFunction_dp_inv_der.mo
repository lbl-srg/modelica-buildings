within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_inv_der
  "1st derivative of basicFlowFunction_dp_inv"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real m_flow_der
    "Derivative of mass flow rate in design flow direction";
  output Real dp_der
    "Derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";

protected
  Modelica.Units.SI.PressureDifference dp=
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv(
      m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent)
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";

algorithm
  dp_der := m_flow_der/
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
      dp=dp, k=k, m_flow_turbulent=m_flow_turbulent, dp_der=1);

annotation (
  smoothOrder=1,
  Inline=false,
  derivative(
    order=2,
    zeroDerivative=k,
    zeroDerivative=m_flow_turbulent)=
      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv_der2,
  Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_inv</a>,
assuming constant flow coefficients.
</p>
<p>
When called with <code>m_flow_der=der(m_flow)</code>, this function returns
the time derivative of <code>dp</code>.
When called with <code>m_flow_der=1</code>, this function returns
the derivative of <code>dp</code> with respect to <code>m_flow</code>.
</p>
<h4>Implementation</h4>
<p>
The derivative of the inverse function is the reciprocal of the derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>,
which is computed by
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der</a>.
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
end basicFlowFunction_dp_inv_der;
