within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_der2
  "2nd derivative of function that computes pressure drop for given mass flow rate"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real m_flow_der(unit="kg/s2")
    "1st derivative of mass flow rate in design flow direction";
  input Real m_flow_der2(unit="kg/s3")
    "2nd derivative of mass flow rate in design flow direction";
  output Real dp_der2
    "2nd derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
  Modelica.Units.SI.PressureDifference dp_turbulent=(m_flow_turbulent/k)^2
    "Pressure where flow changes to turbulent";
  Real m_flowNorm = m_flow/m_flow_turbulent
    "Normalised mass flow rate";
  Real m_flowNormSq = m_flowNorm^2
    "Square of normalised mass flow rate";
algorithm
 dp_der2 :=if noEvent(abs(m_flow)>m_flow_turbulent)
           then sign(m_flow)*2/k^2 * (m_flow_der^2 + m_flow * m_flow_der2)
           else dp_turbulent/m_flow_turbulent*(
                 (0.375  + (2.25 - 0.625*m_flowNormSq)*m_flowNormSq)*m_flow_der2
               + (4.5 - 2.5*m_flowNormSq)*m_flowNorm/m_flow_turbulent*m_flow_der^2);

 annotation (smoothOrder=0,
 Inline=false,
Documentation(info="<html>
<p>
Function that implements the second order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
with respect to the mass flow rate.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 4, 2019, by Michael Wetter:<br/>
Set `Inline=false`.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1070\">#1070</a>.
</li>
<li>
May 1, 2017, by Filip Jorissen:<br/>
Revised implementation such that
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
is C2 continuous.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/725\">#725</a>.
</li>
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
end basicFlowFunction_m_flow_der2;
