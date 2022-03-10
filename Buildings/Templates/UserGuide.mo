within Buildings.Templates;
package UserGuide "Templates Package User Guide"
  extends Modelica.Icons.Information;
  class Conventions
    "Conventions"
    extends Modelica.Icons.Information;
    annotation (
      preferredView="info",
      Documentation(
        info="<html>
<h4>Control point connections</h4>
<p>
The connect clauses involving control points typically do not have
any graphical annotation and are therefore not rendered as 
connection lines in the diagram view.
Those connect clauses are grouped together in a dedicated section of
the equation section of each class, namely
<code>Control point connection - (start | stop)</code>.
</p>
<h4>Abbreviations</h4>
<p>
The following abbreviations are used in that package.<br/>
</p>
<table summary=\"log levels\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Abbreviation</th><th>Description</th></tr>
<tr><td>AI</td><td>Analog input (integer or real)</td></tr>
<tr><td>AFMS</td><td>Airflow measuring station</td></tr>
<tr><td>AO</td><td>Analog output (integer or real)</td></tr>
<tr><td>CHW</td><td>Chilled water</td></tr>
<tr><td>CW</td><td>Condenser water</td></tr>
<tr><td>DHW</td><td>Domestic hot water</td></tr>
<tr><td>DI</td><td>Digital input (Boolean)</td></tr>
<tr><td>DO</td><td>Digital output (Boolean)</td></tr>
<tr><td>HHW</td><td>Heating hot water</td></tr>
<tr><td>OA</td><td>Outdoor air</td></tr>
</table>
</html>"));
  end Conventions;
  annotation (
    preferredView="info",
    Documentation(
      revisions="<html>
<ul>
<li>
March 11, 2022, by Antoine Gautier:<br/>
Created user guide.
</li>
</ul>
</html>", info="<html>
<p>
This user guide describes how to use the templates.
</p>
<h4>Parameterization</h4>
<p>
Explain how to use and propagate the records.
Using Linkage
Using any Modelica tool
</p>
</html>"));

end UserGuide;
