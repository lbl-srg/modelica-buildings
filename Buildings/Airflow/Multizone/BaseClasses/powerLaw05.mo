within Buildings.Airflow.Multizone.BaseClasses;
function powerLaw05
  "Power law used in orifice equations when m is constant and equal to 0.5"
  extends Modelica.Icons.Function;

  input Real C "Flow coefficient, C = V_flow/ sqrt(dp)";
  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  input Real a "Polynomial coefficient";
  input Real b "Polynomial coefficient";
  input Real c "Polynomial coefficient";
  input Real d "Polynomial coefficient";
  input Modelica.Units.SI.PressureDifference dp_turbulent(min=0)
    "Pressure difference where regularization starts";
  input Modelica.Units.SI.PressureDifference sqrt_dp_turbulent(min=0)
    "Square root of dp_turbulent (exposed as it usually is a parameter expression)";
  output Modelica.Units.SI.VolumeFlowRate V_flow "Volume flow rate";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  Real pi = dp/dp_turbulent "Normalized pressure";
  Real pi2 = pi*pi "Square of normalized pressure";
algorithm
 V_flow := if (dp >= dp_turbulent) then
   C * sqrt(dp)
 elseif (dp <= -dp_turbulent) then
   -C* sqrt(-dp)
 else
    C * pi * sqrt_dp_turbulent * ( a + pi2 * ( b + pi2 * ( c + pi2 * d)));

  annotation (
    smoothOrder=2,
    Inline=true,
    Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of an orifice in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  V&#775; = C sign(&Delta;p) |&Delta;p|<sup>m</sup>
</p>
<p>
where
<i>V&#775;</i> is the volume flow rate,
<i>C &gt; 0</i> is a flow coefficient
<i>&Delta; p</i> is the pressure drop and
<i>m =0.5</i> is a constant flow coefficient.
The equation is regularized for
<i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub></i> is a parameter.
</p>
<p>
The model is used for the interzonal air flow models.
It is identical to
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a> but it
is optimized for the common case of <i>m=0.5</i>.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>&Delta;p</i>, and that it
has an infinite number of continuous derivatives in <i>k</i>.
</p>
<p>
If <i>m</i>, and therefore also
<i>a</i>, <i>b</i>, <i>c</i> and <i>d</i>, change with time, then
it is more convenient and efficient to use
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw</a>.
</p>
<p>
If <i>m</i> is constant but different from <i>0.5</i>, use
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 19, 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2043\">IBPSA, #2043</a>.
</li>
</ul>
</html>"));
end powerLaw05;
