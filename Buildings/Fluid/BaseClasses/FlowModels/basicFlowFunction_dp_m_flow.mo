within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_m_flow
  "Inverse of flow function that computes the square inverse of flow coefficient"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Modelica.SIunits.PressureDifference dp
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Modelica.SIunits.MassFlowRate m_flow_small
    "Minimum value of mass flow rate guarding against k=(0)/sqrt(dp)";
  input Modelica.SIunits.PressureDifference dp_small
    "Minimum value of pressure drop guarding against k=m_flow/(0)";
  output Real kSquInv
    "Square inverse of flow coefficient";
protected
  Modelica.SIunits.PressureDifference dpPos=
    Buildings.Utilities.Math.Functions.smoothMax(dp, -dp, dp_small)
    "Regularized absolute value of pressure drop";
  Real mSqu_flow = Buildings.Utilities.Math.Functions.smoothMax(
    m_flow^2, m_flow_small^2, m_flow_small^2)
    "Regularized square value of mass flow rate";
algorithm
  kSquInv := dpPos / mSqu_flow;
annotation (smoothOrder=1,
Documentation(info="<html>
<p>
Function that computes the flow coefficient from the mass flow rate
and pressure drop values, under the assumption of a turbulent
flow regime.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end basicFlowFunction_dp_m_flow;
