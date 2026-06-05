within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_m_flow
  "Inverse of power law used in pressure drop equations when the flow exponent is constant and may be different from 2"

  input Real k "Flow coefficient, k = m_flow/ dp^(1/n)";
  input Modelica.Units.SI.MassFlowRate m_flow(displayUnit="kg/s")
    "Mass flow rate";
  input Real n(min=1, max=2)
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  output Modelica.Units.SI.PressureDifference dp(displayUnit="Pa") "Pressure difference";

protected
  Real C = 1.0 / (k^n) "Coefficient 1/k^n, based on the definition k = m_flow / dp^(1/n)";
  // Polynomial coefficients for C2 continuity
  // These coefficients match the value, 1st derivative, and 2nd derivative
  // of the function f(x) = C * x^n at the point x = m_flow_t
  Real b1 = (C * (n - 3) * (n - 5) / 8) * (m_flow_turbulent^(n - 1))
    "Polynomial coefficient for regularized implementation of flow resistance";
  Real b3 = (C * (n - 1) * (5 - n) / 4) * (m_flow_turbulent^(n - 3))
    "Polynomial coefficient for regularized implementation of flow resistance";
  Real b5 = (C * (n - 1) * (n - 3) / 8) * (m_flow_turbulent^(n - 5))
    "Polynomial coefficient for regularized implementation of flow resistance";
  Modelica.Units.SI.MassFlowRate abs_m = abs(m_flow)
    "Absolute value of mass flow rate";

algorithm
  dp := if abs_m < m_flow_turbulent 
        then b1 * m_flow + b3 * m_flow^3 + b5 * m_flow^5
        else C * sign(m_flow) * abs_m^n;
annotation (
  smoothOrder=2,
  Inline=true,
   inverse(
     m_flow=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_dp(
       k=k, dp=dp, n=n, m_flow_turbulent=m_flow_turbulent)),
  Documentation(info="<html>
<p>
This model describes the pressure difference and mass flow rate relation
of a flow resistance in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = sign(m&#775;) (m&#775; &frasl; k)<sup>n</sup>
</p>
<p>
where
<i>&Delta;p</i> is the pressure drop,
<i>k > 0</i> is a flow coefficient,
<i>m&#775;</i> is the mass flow rate, and
<i>n &isin; [1, 2]</i> is a flow exponent.
The equation is regularized for
<i>|m&#775;| < m&#775;<sub>t</sub></i>, where
<i>m&#775;<sub>t</sub></i> is a parameter.
For laminar flow, set <i>n=1</i> and
for turbulent flow, set <i>n=2</i>.
</p>
<p>
The model is used for the fluid flow models that are neither fully laminar nor fully turbulent.
</p>
<h4>Implementation</h4>
<p>
For <i>|m&#775;| < m&#775;<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>m&#775;</i>, and that it
has an infinite number of continuous derivatives in <i>n</i> and in <i>k</i>.
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
end powerLaw_m_flow;