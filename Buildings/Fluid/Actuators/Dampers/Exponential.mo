within Buildings.Fluid.Actuators.Dampers;
model Exponential "Air damper with exponential opening characteristics"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(
  final dp_nominal=(m_flow_nominal/kDam_default)^2,
  dp(nominal=10),
  final kFixed=0);
protected
   parameter Real kDam_default = sqrt(2*rho_default)*A/kThetaSqRt_default
    "Flow coefficient for damper, k=m_flow/sqrt(dp), with unit=(kg*m)^(1/2)";
   parameter Real kThetaSqRt_default(min=0)=
     Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
       y=1,
       a=a,
       b=b,
       cL=cL,
       cU=cU,
       yL=yL,
       yU=yU)
    "Flow coefficient, kThetaSqRt = sqrt(pressure drop divided by dynamic pressure)";
initial algorithm
   assert(kThetaSqRt_default>0, "Flow coefficient must be strictly positive.");
   annotation (
defaultComponentName="dam",
Documentation(info="<html>
<p>
This model is an air damper with flow coefficient that is an exponential function 
of the opening angle. The model is as in ASHRAE 825-RP.
A control signal of <code>y=0</code> means the damper is closed, and <code>y=1</code> means the damper 
is open. This is opposite of the implementation of ASHRAE 825-RP, but used here
for consistency within this library.
</p>
<p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristic is defined by a quadratic polynomial that
matches the damper resistance at <code>y=0</code> and <code>y=yL</code> or <code>y=yU</code> and 
<code>y=1</code>, respectively. In addition, the polynomials are such that <code>k(y)</code> is
differentiable in <code>y</code> and the derivative is continuous.
</p>

ASHRAE 825-RP lists the following parameter values as typical:
<table summary=\"summary\" border=\"1\">
<tr>
<td></td><td>opposed blades</td><td>single blades</td>
</tr>
<tr>
<td>yL</td><td>15/90</td><td>15/90</td>
</tr>
<tr>
<td>yU</td><td>55/90</td><td>65/90</td>
</tr>
<tr>
<td>k0</td><td>1E6</td><td>1E6</td>
</tr>
<tr>
<td>k1</td><td>0.2 to 0.5</td><td>0.2 to 0.5</td>
</tr>
<tr>
<td>a</td><td>-1.51</td><td>-1.51</td>
</tr>
<tr>
<td>b</td><td>0.105*90</td><td>0.0842*90</td>
</tr>
</table>

<h4>References</h4>
<p>
P. Haves, L. K. Norford, M. DeSimone and L. Mei,
<i>A Standard Simulation Testbed for the Evaluation of Control Algorithms &amp; Strategies</i>, 
ASHRAE Final Report 825-RP, Atlanta, GA.
</p>
</html>", revisions="<html>
<ul>
<li>
September 26, 2013 by Michael Wetter:<br/>
Moved assignemnt of <code>kDam_default</code> and <code>kThetaSqRt_default</code>
from <code>initial algorithm</code> to the variable declaration, to avoid a division
by zero in OpenModelica.
</li> 
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
Extended range of control signal from 0 to 1 by implementing the function 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
exponentialDamper</a>.
</li>
<li>
June 10, 2008 by Michael Wetter:<br/>
Introduced new partial base class, 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
June 30, 2007 by Michael Wetter:<br/>
Introduced new partial base class, 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialActuator\">PartialActuator</a>.
</li>
<li>
July 27, 2007 by Michael Wetter:<br/>
Introduced partial base class.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255}),  Polygon(
          points={{-26,12},{22,54},{22,42},{-26,0},{-26,12}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid), Polygon(
          points={{-22,-32},{26,10},{26,-2},{-22,-44},{-22,-32}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid)}));
end Exponential;
