within Buildings.Fluid.Actuators.Dampers;
model Exponential
  "VAV box with a fixed resistance plus a damper model with exponential characteristics"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(
    dp(nominal=dp_nominal),
    final kFixed=sqrt(kResSqu),
    final char_linear_pro=char_linear);
  parameter Boolean dp_nominalIncludesDamper = true
    "Set to true if dp_nominal includes the pressure loss of the open damper"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean char_linear = false
    "Set to true to linearize the flow characteristics of damper plus fixed resistance"
    annotation(Dialog(tab="Advanced"));
protected
  parameter Modelica.SIunits.PressureDifference dpDamOpe_nominal(displayUnit="Pa")=
     k1*m_flow_nominal^2/2/Medium.density(sta_default)/A^2
    "Pressure drop of fully open damper at nominal flow rate";
  parameter Real kResSqu(unit="kg.m", fixed=false)
    "Resistance coefficient for fixed resistance element";
initial equation
  if not casePreInd then
    kResSqu = if dp_nominal < Modelica.Constants.eps then 0
    elseif dp_nominalIncludesDamper then
      m_flow_nominal^2 / (dp_nominal - dpDamOpe_nominal)
    else m_flow_nominal^2 / dp_nominal;
  end if;
  assert(kResSqu >= 0,
         "Wrong parameters in damper model: dp_nominal < dpDamOpe_nominal"
          + "\n  dp_nominal = "       + String(dp_nominal)
          + "\n  dpDamOpe_nominal = " + String(dpDamOpe_nominal));
annotation (
defaultComponentName="dam",
Documentation(info="<html>
<p>
<b>General Description</b>
</p>
<p>
Model of two resistances in series. One (optional) resistance has a fixed flow coefficient.
The other resistance corresponds to a damper whose loss coefficient is an exponential function
of the opening angle.
</p>
<p>
If <code>dp_nominalIncludesDamper=true</code>, then the parameter <code>dp_nominal</code>
is equal to the pressure drop of the damper plus the fixed flow resistance at the nominal
flow rate.
If <code>dp_nominalIncludesDamper=false</code>, then <code>dp_nominal</code>
does not include the flow resistance of the air damper.
</p>
<p>
If <code>char_linear=true</code>, then the lumped flow coefficient
(for both damper and optional fixed flow resistance) varies linearly with the filtered control
input signal <code>y_actual</code>.
This yields a linear relationship between the mass flow rate and <code>y_actual</code> when
the model is exposed to constant pressure boundary conditions.
</p>
<p>
<b>Exponential Damper Model Description</b>
</p>
<p>
This model is an air damper with loss coefficient that is an exponential function
of the opening angle. The model is as in ASHRAE 825-RP.
A control signal of <code>y=0</code> means the damper is closed, and <code>y=1</code> means the damper
is open. This is opposite of the implementation of ASHRAE 825-RP, but used here
for consistency within this library.
</p>
<p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>d</sub>(y) = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristics is defined by a quadratic polynomial that
matches the damper resistance at <code>y=0</code> and <code>y=yL</code> or <code>y=yU</code> and
<code>y=1</code>, respectively. In addition, the polynomials are such that
<i>k<sub>d</sub>(y)</i> is
differentiable in <i>y</i> and the derivative is continuous.
</p>
<p>
The damper characteristics <i>k<sub>d</sub>(y)</i> is then used to
compute the flow coefficient <i>k(y)</i> as
</p>
<p align=\"center\" style=\"font-style:italic;\">
k(y) = (2 &rho; &frasl; k<sub>d</sub>(y))<sup>1/2</sup> A,
</p>
<p>
where <i>A</i> is the face area, which is computed using the nominal
mass flow rate <code>m_flow_nominal</code>, the nominal velocity
<code>v_nominal</code> and the density of the medium. The flow coefficient <i>k(y)</i>
is used to compute the mass flow rate versus pressure
drop relation as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k(y)  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
with regularization near the origin.
</p>
<p>
ASHRAE 825-RP lists the following parameter values as typical:
</p>
<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<td></td><th>opposed blades</th><th>single blades</th>
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
<p>
ASHRAE 2009 <i>Dampers and Airflow Control</i> provides additional data.
</p>
<h4>References</h4>
<p>
P. Haves, L. K. Norford, M. DeSimone and L. Mei,
<i>A Standard Simulation Testbed for the Evaluation of Control Algorithms &amp; Strategies</i>,
ASHRAE Final Report 825-RP, Atlanta, GA.
</p>
<p>
L. G. Felker and T. L. Felker,
<i>Dampers and Airflow Control</i>,
ASHRAE, Atlanta, GA, 2009.
</p>
</html>", revisions="<html>
<ul>
<li>
April 19, 2019, by Antoine Gautier:<br/>
Refactored <code>Exponential</code> and <code>VAVBoxExponential</code> into one single class.<br/>
Added the option for characteristics linearization.<br/>
This is for
<a href=\https://github.com/lbl-srg/modelica-buildings/issues/1298\">#1298</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
April 13, 2010 by Michael Wetter:<br/>
Added <code>noEvent</code> to guard evaluation of the square root
for negative numbers during the solver iterations.
</li>
<li>
June 10, 2008 by Michael Wetter:<br/>
Introduced new partial base class,
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
PartialDamperExponential</a>.
</li>
<li>
September 11, 2007 by Michael Wetter:<br/>
Redefined <code>kRes</code>, now the pressure drop of the fully open damper is subtracted from the fixed resistance.
</li>
<li>
February 24, 2010 by Michael Wetter:<br/>
Added parameter <code>dp_nominalIncludesDamper</code>.
</li>
<li>
July 27, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-110,-34},{12,-100}},
          lineColor={0,0,255},
          textString="dp_nominal=%dp_nominal"),
        Text(
          extent={{-102,-76},{10,-122}},
          lineColor={0,0,255},
          textString="m0=%m_flow_nominal"),
        Polygon(
          points={{-24,-16},{24,22},{24,14},{-24,-24},{-24,-16}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end Exponential;
