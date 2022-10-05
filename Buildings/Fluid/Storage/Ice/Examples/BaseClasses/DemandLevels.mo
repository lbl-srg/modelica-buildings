within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
type DemandLevels = enumeration(
    None
        "No demand",
    Normal
        "Normal",
    Elevated
          "Elevated demand")
 "Enumeration to define demand levels" annotation (Documentation(
info="<html>
<p>
Enumeration for the demand levels.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>None</code></td>
<td>
No demand, system can be switched off.
</td></tr>
<tr><td><code>Normal</code></td>
<td>
Normal demand level.
</td></tr>
<tr><td><code>Elevated</code></td>
<td>
Elevated demand that cannot be served by the normal demand level.
</td>
</tr>
</table>
</html>",
revisions="<html>
<ul>
<li>
October 5, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>"));
