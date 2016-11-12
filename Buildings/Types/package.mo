within Buildings;
package Types "Package with type definitions"
  extends Modelica.Icons.TypesPackage;

  type Reset = enumeration(
    Disabled   "Disabled",
    Parameter   "Use parameter value",
    Input   "Use input signal")
    "Options for integrator reset"
    annotation (
    Documentation(info="<html>
<p>
Enumeration to define the choice of integrator reset
(to be selected via choices menu):
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td>Disabled</td>
<td>
Use this setting to disable the integrator reset.
</td></tr>
<tr><td>Parameter</td>
<td>
Use this setting to use reset the integrator to the value of the parameter.
</td></tr>
<tr><td>Input</td>
<td>Use this setting to reset the integrator to the value obtained
from the input signal.
</td></tr>
 </table>
</html>", revisions="<html>
<ul>
<li>
September 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>", revisions="<html>
<ul>
<li>
November 30 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Types;
