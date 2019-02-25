within Buildings.Controls.OBC.ASHRAE;
package G36_PR1 "Package with control sequences from ASHRAE Guideline 36"

annotation (Documentation(info="<html>
<p>
This package contains control sequences from
ASHRAE Guideline 36 (G36).
All sequences are created using blocks from the
<a href=\"modelica://Buildings.Controls.OBC.CDL\">
Buildings.Controls.OBC.CDL</a> library, following the
<a href=\"http://obc.lbl.gov/specification/cdl.html\">
CDL specification</a>.
</p>
<p>
The G36 library is structured as follows:
<ul>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs</a> contains control sequences
for generating controller setpoints such as for the supply air temperature,
and actuation signals for mechanical elements of an AHU such as for the outdoor air damper
position.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Types\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Types</a> is a library of constants
that are used to indicate the operation mode, such as freeze
protections status and demand response status.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic</a> contains sequences that
are utilized across various parts of an HVAC system,
such as for AHU and for terminal unit control.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits</a> contains control
sequences for terminal units, such as setpoints for the minimal zone airflow rates and
actuator signals for the terminal unit dampers.
</li>
</ul>
<h4>Implementation of PID controllers</h4>
<p>
For the PID controllers, the implementation in
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LimPID\">
Buildings.Controls.OBC.CDL.Continuous.LimPID</a>
is used.
Hence, the PID controllers are in the standard form
</p>
<p align=\"center\" style=\"font-style:italic;\">
y(t) = k &nbsp; ( e(t) + 1 &frasl; T<sub>i</sub> &nbsp; &int; e(s) ds + T<sub>d</sub> de(t)&frasl;dt ),
</p>
<p>
where
<i>y(t)</i> is the control signal,
<i>e(t) = u<sub>s</sub>(t) - u<sub>m</sub>(t)</i> is the control error,
with <i>u<sub>s</sub>(t)</i> being the set point and <i>u<sub>m</sub>(t)</i> being
the measured quantity,
<i>k</i> is the gain,
<i>T<sub>i</sub></i> is the time constant of the integral term and
<i>T<sub>d</sub></i> is the time constant of the derivative term.
</p>
<p>
Note that the units of <i>k</i> are the inverse of the units of the control error,
while the units of <i>T<sub>i</sub></i> and <i>T<sub>d</sub></i> are seconds.
As the units of flow rates and pressure can vary between orders of magnitude,
for example depening on whether <i>cfm</i>, <i>m<sup>3</sup>&frasl;s</i> or
<i>m<sup>3</sup>&frasl;h</i> are used for flow measurements, the control
error is normalized as follows:
<ul>
<li>
For temperatures, no normalization is used, and the units of <i>k</i> are
<i>1/Kelvin</i>. No normalization is used because <i>1</i> Kelvin is <i>1.8</i>
Fahrenheit, and hence these are of the same order of magnitude.
</li>
<li>
For air flow rate control, the design flow rate is used to normalize the
control error, and hence <i>k</i> is unitless.
This also allows to use the same control gain for flows of different magnitudes,
for example for a VAV box of a large and a small room, provided the rooms
have similar transient response.
</li>
<li>
For pressure control, the pressure difference is used to normalize the
control error, and hence <i>k</i> is unitless.
</li>
</ul>
<p>
Guideline 36 is specific as the where a P or a PI controller should be
used. These recommendations are used as the default control configuration.
However, all controllers can be configured as P, PI or PID controller.
This allows to configure a PI controller as a P controller as part of the
tuning process.
</p>
<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC
systems</i>. First Public Review Draft (June 2016)</a>
</p>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Ellipse(
          origin={10.0,10.0},
          fillColor={76,76,76},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-80.0,-80.0},{-20.0,-20.0}}),
        Ellipse(
          origin={10.0,10.0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,-80.0},{60.0,-20.0}}),
        Ellipse(
          origin={10.0,10.0},
          fillColor={128,128,128},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{0.0,0.0},{60.0,60.0}}),
        Ellipse(
          origin={10.0,10.0},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-80.0,0.0},{-20.0,60.0}})}));
end G36_PR1;
