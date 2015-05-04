within Buildings.Fluid.BaseClasses.FlowModels;
function basicFlowFunction_m_flow "Basic class for flow models"

  input Modelica.SIunits.MassFlowRate m_flow
    "Mass flow rate in design flow direction";
  input Real k(unit="")
    "Flow coefficient, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  input Modelica.SIunits.MassFlowRate m_flow_turbulent(min=0) "Mass flow rate";
  output Modelica.SIunits.Pressure dp(displayUnit="Pa")
    "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
protected
 Real kSquInv(unit="1/(kg.m)") "Flow coefficient";
algorithm
 kSquInv:=1/k^2;
 dp :=Modelica.Fluid.Utilities.regSquare2(x=m_flow, x_small=m_flow_turbulent, k1=kSquInv, k2=kSquInv);

 annotation (LateInline=true,
             inverse(m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k, m_flow_turbulent=m_flow_turbulent)),
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
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = sign(m) (m &frasl; k)<sup>2</sup>
</p>
<p>
with regularization near the origin.
Therefore, the flow coefficient is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
The input <code>m_flow_turbulent</code> determines the location of the regularization.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 10, 2011, by Michael Wetter:<br/>
Removed <code>if-then</code> optimization that set <code>dp=0</code> if <code>m_flow=0</code>,
as this causes the derivative to be discontinuous at <code>m_flow=0</code>.
</li>
<li>
August 4, 2011, by Michael Wetter:<br/>
Removed option to use a linear function. The linear implementation is now done
in models that call this function. With the previous implementation,
the symbolic processor may not rearrange the equations, which can lead
to coupled equations instead of an explicit solution.
</li>
<li>
April 13, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end basicFlowFunction_m_flow;
