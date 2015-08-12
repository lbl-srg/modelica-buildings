within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_der2
  "2nd derivative of flow function2nd derivative of function that computes mass flow rate for given pressure drop"
  extends Modelica.Icons.Function;

  input Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real dp_der
    "1st derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real dp_der2
    "2nd derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  output Real m_flow_der2
    "2nd derivative of mass flow rate in design flow direction";
protected
  Real m_k = m_flow_turbulent/k "Auxiliary variable";
  Modelica.SIunits.Pressure dp_turbulent = (m_k)^2
    "Pressure where flow changes to turbulent";
algorithm
 m_flow_der2 := if noEvent(dp>dp_turbulent) then
                  -0.25*k*dp^(-3/2) * dp_der^2 + 0.5*k*dp^(-1/2)*dp_der2
                 elseif noEvent(dp<-dp_turbulent) then
                   0.25*k*(-dp)^(-3/2) * dp_der^2 + 0.5*k*(-dp)^(-1/2)*dp_der2
                 else
                   (1.25*k/m_k-0.75*k/m_k^5*dp^2)*dp_der2
                   -1.5/m_k^5*k*dp*dp_der^2;

 annotation (LateInline=true,
Documentation(info="<html>
<p>
Function that implements the second order derivative of
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp\">
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp</a>
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
end basicFlowFunction_dp_der2;
