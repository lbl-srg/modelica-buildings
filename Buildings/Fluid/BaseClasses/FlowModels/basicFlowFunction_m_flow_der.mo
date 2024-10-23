within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_der
  "1st derivative of function that computes pressure drop for given mass flow rate"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real m_flow_der
    "Derivative of mass flow rate in design flow direction";
  output Real dp_der
    "Derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
  Modelica.Units.SI.PressureDifference dp_turbulent=(m_flow_turbulent/k)^2
    "Pressure where flow changes to turbulent";
  Real m_flowNormSq = (m_flow/m_flow_turbulent)^2
    "Square of normalised mass flow rate";
algorithm
 dp_der :=(if noEvent(abs(m_flow)>m_flow_turbulent)
           then sign(m_flow)*2*m_flow/k^2
           else (0.375  + (2.25 - 0.625*m_flowNormSq)*m_flowNormSq)*dp_turbulent/m_flow_turbulent)*m_flow_der;

 annotation (Inline=false,
             smoothOrder=1,
             derivative(order=2, zeroDerivative=k, zeroDerivative=m_flow_turbulent)=
             Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2,
Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>,
assuming a constant flow coefficient.
</p>
<p>
When called with <code>m_flow_der=der(m_flow)</code>, this function returns
the time derivative of <code>dp</code>.
When called with <code>m_flow_der=1</code>, this function returns
the derivative of <code>dp</code> with respect to <code>m_flow</code>.
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
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
is C2 continuous.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/725\">#725</a>.
</li>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation to avoid in Dymola 2016 the warning
\"Differentiating ... under the assumption that it is continuous at switching\".
</li>
</ul>
</html>"));
end basicFlowFunction_m_flow_der;
