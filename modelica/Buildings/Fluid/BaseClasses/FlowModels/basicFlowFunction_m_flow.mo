within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow "Basic class for flow models"

 annotation (LateInline=true,
             inverse(m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_turbulent, linearized=linearized)),
             smoothOrder=2,
             Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Line(
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,0,255},
          smooth=Smooth.None,
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={232,0,0},
          textString="%name")}),
Documentation(info="<html>
<p>
Function that computes the pressure drop of flow elements as
<pre>
  dp = 1/k^2 * sign(m_flow) m_flow^2
</pre>
with regularization near the origin.
The variable <tt>m_flow_turbulent</tt> determines the location of the regularization.
</p>
</html>"),
revisions="<html>
<ul>
<li>
April 13, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0) "Mass flow rate";
  input Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate";
  output Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
 Real kSquInv(unit="1/(kg.m)") "Flow coefficient";
 constant Real conv(unit="m.s2/kg") = 1 "Factor, needed to satisfy unit check";
 constant Real conv2 = sqrt(conv) "Factor, needed to satisfy unit check";
algorithm
  kSquInv:=1/k^2;
  if linearized then
     dp := m_flow/k/conv2;
  else
     dp :=Modelica.Fluid.Utilities.regSquare2(x=m_flow, x_small=m_flow_turbulent, k1=kSquInv, k2=kSquInv);
  end if;
end basicFlowFunction_m_flow;
