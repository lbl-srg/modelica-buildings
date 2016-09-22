within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_der
  "1st derivative of function that computes pressure drop for given mass flow rate"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real m_flow_der(unit="kg/s2")
    "Derivative of mass flow rate in design flow direction";
  output Real dp_der
    "Derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
algorithm
 dp_der :=(if (m_flow>m_flow_turbulent) then 2 * m_flow/k^2
           elseif (m_flow<-m_flow_turbulent) then -2 * m_flow/k^2
           else (m_flow_turbulent+3*m_flow^2/m_flow_turbulent)/2/k^2) * m_flow_der;

 annotation (LateInline=true,
             smoothOrder=1,
             derivative(order=2, zeroDerivative=k, zeroDerivative=m_flow_turbulent)=
               Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2,
Documentation(info="<html>
<p>
Function that implements the first order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>
with respect to the mass flow rate.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation to avoid in Dymola 2016 the warning
\"Differentiating ... under the assumption that it is continuous at switching\".
</li>
</ul>
</html>"));
end basicFlowFunction_m_flow_der;
