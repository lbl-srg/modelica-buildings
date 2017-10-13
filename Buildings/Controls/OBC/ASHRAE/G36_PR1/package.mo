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
for generating controller setpoints such as for the supply air temperature,
and actuation signals for mechanical elements of an AHU such as for the outdoor air damper
position.
</li>
<li><a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.Constants</a> is a library of constants
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
<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC
systems</i>. First Public Review Draft (June 2016)</a>
</p>
</html>"));
end G36_PR1;
