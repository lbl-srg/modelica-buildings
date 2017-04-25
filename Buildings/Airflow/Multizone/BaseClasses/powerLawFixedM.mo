within Buildings.Airflow.Multizone.BaseClasses;
function powerLawFixedM
  "Power law used in orifice equations when m is constant"
  input Real k "Flow coefficient, k = V_flow/ dp^m";
  input Modelica.SIunits.PressureDifference dp(displayUnit="Pa") "Pressure difference";
  input Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  input Real a "Polynomial coefficient";
  input Real b "Polynomial coefficient";
  input Real c "Polynomial coefficient";
  input Real d "Polynomial coefficient";
  input Modelica.SIunits.PressureDifference dp_turbulent(min=0)=0.001
    "Pressure difference where regularization starts";
  output Modelica.SIunits.VolumeFlowRate V_flow "Volume flow rate";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  Real pi "Normalized pressure";
  Real pi2 "Square of normalized pressure";
algorithm
 if (dp >= dp_turbulent) then
   V_flow := k*dp^m;
 elseif (dp <= -dp_turbulent) then
   V_flow :=-k*(-dp)^m;
 else
   pi  := dp/dp_turbulent;
   pi2 := pi*pi;
   V_flow := k*dp_turbulent^m * pi * ( a + pi2 * ( b + pi2 * ( c + pi2 * d)));
 end if;

  annotation (smoothOrder=2,
Documentation(info="<html>
<p>
This model describes the mass flow rate and pressure difference relation
of an orifice in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  V = k sign(&Delta;p) |&Delta;p|<sup>m</sup>
</p>
<p>
where
<i>V</i> is the volume flow rate,
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
The model is used for the interzonal air flow models.
It is identical to
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw</a> but it
requires the polynomial coefficients as an input.
This allows a more efficient simulation if <i>m</i> and therefore also
<i>a</i>, <i>b</i>, <i>c</i> and <i>d</i> are constant.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>&Delta;p</i>, and that it
has an infinite number of continuous derivatives in <i>m</i> and in <i>k</i>.
</p>
<p>
If <i>m</i>, and therefore also
<i>a</i>, <i>b</i>, <i>c</i> and <i>d</i>, change with time, then
it is more convenient and efficient to use
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLaw\">
Buildings.Airflow.Multizone.BaseClasses.powerLaw</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
<i>August 12, 2011</i> by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end powerLawFixedM;
