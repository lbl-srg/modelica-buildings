within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow_der2
  "2nd derivative of function that computes pressure drop for given mass flow rate"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real m_flow_der(unit="kg/s2")
    "1st derivative of mass flow rate in design flow direction";
  input Real m_flow_der2(unit="kg/s3")
    "2nd derivative of mass flow rate in design flow direction";
  output Real dp_der2
    "2nd derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
  Real m_k = m_flow_turbulent/k "Auxiliary variable";
  Modelica.SIunits.PressureDifference dp_turbulent = (m_k)^2
    "Pressure where flow changes to turbulent";
algorithm
 dp_der2 :=if (m_flow>m_flow_turbulent) then
             2/k^2 * (m_flow_der^2 + m_flow * m_flow_der2)
            elseif (m_flow<-m_flow_turbulent) then
             -2/k^2 * (m_flow_der^2 + m_flow * m_flow_der2)
            else
            0.5/k^2 * ((m_flow_turbulent+3*m_flow^2/m_flow_turbulent) * m_flow_der2
                       + 6*m_flow/m_flow_turbulent * m_flow_der^2);

 annotation (LateInline=true,
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
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/iea-annex60/modelica-annex60/issues/404\">#404</a>.
</li>
<li>
July 29, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end basicFlowFunction_m_flow_der2;
