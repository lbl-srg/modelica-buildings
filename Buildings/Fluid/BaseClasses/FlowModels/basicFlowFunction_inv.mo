within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_inv
  "Inverse of flow function that computes the square of flow coefficient"

  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Modelica.SIunits.PressureDifference dp
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Modelica.SIunits.MassFlowRate m_flow_small
    "Minimal value of mass flow rate for guarding against k=(0)/sqrt(dp)";
  input Modelica.SIunits.PressureDifference dp_small
    "Minimal value of pressure drop for guarding against k=m_flow/(0)";
  input Real k_min
    "Minimal value of flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Real k_max
    "Maximal value of flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  output Real kSqu
    "Square of flow coefficient";
protected
  Real m_flowNorm = m_flowGuard / m_flow_turbulent
    "Normalised mass flow rate";
  Real m_flowNormSq = m_flowNorm^2
    "Square of normalised mass flow rate";
  Real m_flowGuard = max(abs(m_flow), m_flow_small);
  Real dpGuard = max(abs(dp), dp_small);
algorithm
  kSqu := if noEvent(abs(m_flow) > m_flow_turbulent) then min(k_max^2, max(k_min^2, m_flowGuard^2 / dpGuard))
    else min(k_max^2, max(k_min^2,
      (0.375 + (0.75 - 0.125 * m_flowNormSq) * m_flowNormSq) * m_flow_turbulent^2 / dpGuard * m_flowNorm));
annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
  -100},{100,100}}), graphics={Line(
  points={{-80,-40},{-80,60},{80,-40},{80,60}},
  color={0,0,255},
  thickness=1), Text(
  extent={{-40,-40},{40,-80}},
  lineColor={0,0,0},
  fillPattern=FillPattern.Sphere,
  fillColor={232,0,0},
  textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the square value of the flow coefficient from the flow rate and
pressure drop values.
</p>
<p>
This function is the formal inverse of <a href=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow>
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2019, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end basicFlowFunction_inv;
