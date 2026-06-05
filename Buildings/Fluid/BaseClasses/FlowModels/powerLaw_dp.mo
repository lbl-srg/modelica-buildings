within Buildings.Fluid.BaseClasses.FlowModels;
function powerLaw_dp
  "Power law used in pressure drop equations when the flow exponent is constant and may be different from 2"

  input Real k "Flow coefficient, k = m_flow/ dp^(1/n)";
  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  input Real n(min=1, max=2)
    "Flow exponent, n=1 for laminar, n=2 for turbulent";
  input Modelica.Units.SI.MassFlowRate m_flow_turbulent(min=0)
    "Mass flow rate where transition to turbulent flow occurs";
  output Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";

protected
  Real m = 1/n "Flow exponent for the pressure drop, used internally";
  Modelica.Units.SI.PressureDifference dp_turbulent(displayUnit="Pa")
    = (m_flow_turbulent^n) / k
    "Pressure difference where turbulent flow occurs";

  // Polynomial coefficients
  Real a1;
  Real a3;
  Real a5;
  Real abs_dp = abs(dp);

algorithm
  // 1. Calculate the coefficients for the C2-continuous polynomial
  // These are derived from the matching conditions at |dp| = dp_turbulent

  a1 := (k * (m - 3) * (m - 5) / 8) * (dp_turbulent^(m - 1));
  a3 := (k * (m - 1) * (5 - m) / 4) * (dp_turbulent^(m - 3));
  a5 := (k * (m - 1) * (m - 3) / 8) * (dp_turbulent^(m - 5));

  // 2. Apply the conditional logic
  if abs_dp < dp_turbulent then
    // Polynomial region: ensures smoothness at dp=0 and C2 continuity at dp_turbulent
    m_flow := a1 * dp + a3 * dp^3 + a5 * dp^5;
  else
    // Power-law region: the standard physical model
    m_flow := k * sign(dp) * abs_dp^m;
  end if;

annotation (
  smoothOrder=2,
  Inline=true,
  inverse(
    dp=Buildings.Fluid.BaseClasses.FlowModels.powerLaw_m_flow(
      k=k, m_flow=m_flow, n=n, m_flow_turbulent=m_flow_turbulent)),
  Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of a flow resistance in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = k sign(&Delta;p) |&Delta;p|<sup>1/n</sup>
</p>
<p>
where
<i>m&#775;</i> is the mass flow rate,
<i>k > 0</i> is a flow coefficient
<i>&Delta; p</i> is the pressure drop and
<i>n &isin; [1, 2]</i> is a flow exponent.
The equation is regularized for
<i>|&Delta;p| < &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub></i> is a parameter that is computed from the input <code>m_flow_turbulent</code>.
For laminar flow, set <i>n=1</i> and
for turbulent flow, set <i>n=2</i>.
</p>
<p>
The model is used for the fluid flow models that are neither fully laminar nor fully turbulent.
It is identical to
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a> except that it
is formulated for mass flow rate rather than volume flow rate.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| < &Delta;p<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>&Delta;p</i>, and that it
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
          points={{-80,-40},{-80,60},{80,-40},{80,60}},
          color={0,140,72},
          thickness=1), Text(
          extent={{-40,-40},{40,-80}},
          textColor={0,0,0},
          textString="%name")}));
end powerLaw_dp;