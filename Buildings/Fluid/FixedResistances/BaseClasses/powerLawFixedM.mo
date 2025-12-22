within Buildings.Fluid.FixedResistances.BaseClasses;
function powerLawFixedM
  "Power law used in pressure drop equations when m is constant and may be different from 0.5"
  extends Modelica.Icons.Function;

  input Real k "Flow coefficient, k = m_flow/ dp^m";
  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  input Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  input Real a "Polynomial coefficient";
  input Real b "Polynomial coefficient";
  input Real c "Polynomial coefficient";
  input Real d "Polynomial coefficient";
  input Modelica.Units.SI.PressureDifference dp_turbulent(min=0)
    "Pressure difference where regularization starts";
  output Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  Real pi = dp/dp_turbulent "Normalized pressure";
  Real pi2 = pi*pi "Square of normalized pressure";
algorithm
 m_flow :=
   if (dp >= dp_turbulent) then
     k*dp^m
   elseif (dp <= -dp_turbulent) then
     -k*(-dp)^m
   else
     k*dp_turbulent^m*pi*(a + pi2*(b + pi2*(c + pi2*d)));

  annotation (
  smoothOrder=2,
  Inline=true,
Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of a flow resistance in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = k sign(&Delta;p) |&Delta;p|<sup>m</sup>
</p>
<p>
where
<i>m&#775;</i> is the mass flow rate,
<i>k &gt; 0</i> is a flow coefficient
<i>&Delta; p</i> is the pressure drop and
<i>m &isin; [0.5, 1]</i> is a flow coefficient.
The equation is regularized for
<i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub></i> is a parameter.
For turbulent flow, set <i>m=1 &frasl; 2</i> and
for laminar flow, set <i>m=1</i>.
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
For <i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>&Delta;p</i>, and that it
has an infinite number of continuous derivatives in <i>m</i> and in <i>k</i>.
</p>
<p>
If <i>m = 0.5</i>, use
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 18, 2025 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end powerLawFixedM;
