within Buildings.Airflow.Multizone.BaseClasses;
function powerLaw "Power law used in orifice equations"
  extends Modelica.Icons.Function;

  input Real C "Flow coefficient, C = V_flow/ dp^m";
  input Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure difference";
  input Real m(min=0.5, max=1)
    "Flow exponent, m=0.5 for turbulent, m=1 for laminar";
  input Modelica.Units.SI.PressureDifference dp_turbulent(
    min=0,
    displayUnit="Pa") = 0.001 "Pressure difference where regularization starts";
  output Modelica.Units.SI.VolumeFlowRate V_flow "Volume flow rate";
protected
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  Real pi = dp/dp_turbulent "Normalized pressure";
  Real pi2 = pi*pi "Square of normalized pressure";
algorithm
 V_flow := if (dp >= dp_turbulent) then
   C *dp^m
 elseif (dp <= -dp_turbulent) then
   -C*(-dp)^m
 else
   C *dp_turbulent^m * pi *
     ( (gamma) + pi2 *
     ( (1/8*m^2 - 3*gamma - 3/2*m + 35.0/8) + pi2 *
     ( (-1/4*m^2 + 3*gamma + 5/2*m - 21.0/4) + pi2 *
     (1/8*m^2 - gamma - m + 15.0/8))));
   /*
   a := gamma;
   b := 1/8*m^2 - 3*gamma - 3/2*m + 35.0/8;
   c := -1/4*m^2 + 3*gamma + 5/2*m - 21.0/4;
   d := 1/8*m^2 - gamma - m + 15.0/8;
   V_flow :=C *dp_turbulent^m * pi * ( a + pi2 * ( b + pi2 * ( c + pi2 * d)));
   */


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
<i>m &isin; [0.5, 1]</i> is a flow coefficient.
The equation is regularized for
<i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, where
<i>&Delta;p<sub>t</sub></i> is a parameter.
For turbulent flow, set <i>m=1 &frasl; 2</i> and
for laminar flow, set <i>m=1</i>.
</p>
<p>
The model is used for the interzonal air flow models.
</p>
<h4>Implementation</h4>
<p>
For <i>|&Delta;p| &lt; &Delta;p<sub>t</sub></i>, the equation is regularized
so that it is twice continuously differentiable in <i>&Delta;p</i>, and that it
has an infinite number of continuous derivatives in <i>m</i> and in <i>k</i>.
</p>
<p>
If <i>m</i> is not a function of time, then
<i>a</i>, <i>b</i>, <i>c</i> and <i>d</i> can be pre-computed.
In this situation, use
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>, which allows
to compute these values outside of this function, for example as parameters
of a model.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 19, 2025, by Michael Wetter:<br/>
Refactored implementation to allow function to be inlined.
This leads to a 20% faster simulation of
<a href=\"modelica://Buildings.Airflow.Multizone.Examples.OneOpenDoor\">
Buildings.Airflow.Multizone.Examples.OneOpenDoor</a> compared to the previous
implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2043\">IBPSA, #2043</a>.
</li>
<li>
February 8, 2022, by Michael Wetter:<br/>
Changed to use <code>C</code> for volume flow coefficient (<i>C = V_flow/dp^m</i>),
and <code>k</code> for mass flow coefficient (<i>k = m_flow/dp^m</i>).
This is for consistency with
<a href=\"modelica://Buildings.Fluid.BaseClasses.FlowModels\">Buildings.Fluid.BaseClasses.FlowModels</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
<i>August 12, 2011</i> by Michael Wetter:<br/>
Reimplemented model so that it is continuously differentiable.
</li>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 4, 2005</i> by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end powerLaw;
