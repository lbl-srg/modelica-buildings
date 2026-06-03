within Buildings.Fluid.BaseClasses.FlowModels;
function powerLawFixedM_m_flow
  "Inverse of power law used in pressure drop equations when m is constant and may be different from 0.5"

  input Real k "Flow coefficient, k = m_flow/ dp^m";
  input Modelica.Units.SI.MassFlowRate m_flow(displayUnit="kg/s")
    "Mass flow rate";
  input Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  input Real a "Polynomial coefficient";
  input Real b "Polynomial coefficient";
  input Real c "Polynomial coefficient";
  input Real d "Polynomial coefficient";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  output Modelica.Units.SI.PressureDifference dp(displayUnit="Pa") "Pressure difference";

protected
  Modelica.Units.SI.PressureDifference dp_turbulent = (m_flow_turbulent/k)^(1/m)
    "Pressure difference where regularization starts";
  Real pi = m_flow/m_flow_turbulent "Normalized mass flow rate";
  Real pi2 = pi*pi "Square of normalized mass flow rate";
algorithm
 dp :=
   if (m_flow >= m_flow_turbulent) then
     (m_flow/k)^(1/m)
   elseif (m_flow <= -m_flow_turbulent) then
     -(abs(m_flow)/k)^(1/m)
   else
      dp_turbulent * pi * (a + pi2*(b + pi2*(c + pi2*d)));

  annotation (
  smoothOrder=2,
  Inline=true,
  derivative(
    order=1,
    zeroDerivative=k,
    zeroDerivative=a,
    zeroDerivative=b,
    zeroDerivative=c,
    zeroDerivative=d,
    zeroDerivative=m_flow_turbulent)=Buildings.Fluid.BaseClasses.FlowModels.powerLawFixedM_m_flow_der,
   inverse(
     m_flow=Buildings.Fluid.BaseClasses.FlowModels.powerLawFixedM_dp(
       k=k, dp=dp, m=m, a=a, b=b, c=c, d=d, m_flow_turbulent=m_flow_turbulent)),
  Documentation(info="<html>
<p>
This model describes the pressure difference and mass flow rate relation
of a flow resistance in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = sign(m&#775;) (m&#775; &frasl; k)<sup>1/m</sup>
</p>
<p>
where
<i>&Delta;p</i> is the pressure drop,
<i>k > 0</i> is a flow coefficient,
<i>m&#775;</i> is the mass flow rate, and
<i>m &isin; [0.5, 1]</i> is a flow coefficient.
The equation is regularized for
<i>|m&#775;| < m&#775;<sub>t</sub></i>, where
<i>m&#775;<sub>t</sub></i> is a parameter.
For turbulent flow, set <i>m=1 &frasl; 2</i> and
for laminar flow, set <i>m=1</i>.
</p>
<p>
The model is used for the fluid flow models that are neither fully laminar nor fully turbulent.
</p>
<h4>Implementation</h4>
<p>
For <i>|m&#775;| < m&#775;<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>m&#775;</i>, and that it
has an infinite number of continuous derivatives in <i>m</i> and in <i>k</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 30, 2026, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4620\">#4620</a>.
</li>
</ul>
</html>"),
    Icon(graphics={                Line(
          points={{-80,-42},{-80,58},{80,-42},{80,58}},
          color={0,140,72},
          thickness=1), Text(
          extent={{-40,-42},{40,-82}},
          textColor={0,0,0},
          textString="%name")}));
end powerLawFixedM_m_flow;
