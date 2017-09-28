within Buildings.Controls.OBC.ASHRAE;
package G36_PR1 "Package with control sequences from ASHRAE Guideline 36"
  extends Modelica.Icons.VariantsPackage;

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
for generating controller setpoints, e.g. supply air temperature <code>TSup</code>,
and actuation signals for mechanical elements of an AHU, e.g. outdoor air damper
position <code>yOutDamPos</code>.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants</a> is a library of status
signals used in the sequences for communicating system operation modes, freeze
protections status, zone state, etc.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic</a> stores any sequences with
outputs utilized accross the HVAC system, both for the AHU and the
terminal unit control.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits</a> contains terminal unit
control sequences for generating controller setpoints,
e.g. minimal zone airflow rate <code>VOccMinAir</code>, and actuation signals
for mechanical elements, e.g. terminal unit damper, <code>yDam</code>.
</li>
</ul>
<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC
systems</i>. First Public Review Draft (June 2016)</a>
</p>
</html>"));
end G36_PR1;
