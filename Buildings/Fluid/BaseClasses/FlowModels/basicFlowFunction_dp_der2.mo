within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_dp_der2
  "2nd derivative of flow function2nd derivative of function that computes mass flow rate for given pressure drop"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real k(min=0, unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  input Real dp_der
    "1st derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  input Real dp_der2
    "2nd derivative of pressure difference between port_a and port_b (= port_a.p - port_b.p)";
  output Real m_flow_der2
    "2nd derivative of mass flow rate in design flow direction";
protected
  Modelica.Units.SI.PressureDifference dp_turbulent=(m_flow_turbulent/k)^2
    "Pressure where flow changes to turbulent";
  Real dpNorm=dp/dp_turbulent
    "Normalised pressure difference";
  Real dpNormSq=dpNorm^2
    "Square of normalised pressure difference";
algorithm
 m_flow_der2 := if noEvent(abs(dp)>dp_turbulent)
                 then 0.5*k/sqrt(abs(dp))*(-0.5/dp * dp_der^2 + dp_der2)
                 else m_flow_turbulent/dp_turbulent*(
                       (1.40625  + (0.78125*dpNormSq - 1.6875)*dpNormSq)*dp_der2
                     + (-3.375 + 3.125*dpNormSq)*dpNorm/dp_turbulent*dp_der^2);

 annotation (smoothOrder=0,
 Inline=false,
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
First implementation to avoid in Dymola 2016 the warning
\"Differentiating ... under the assumption that it is continuous at switching\".
</li>
</ul>
</html>"));
end basicFlowFunction_dp_der2;
