within Buildings.Fluid.Storage.Ice.Examples.BaseClasses;
type OperationModes = enumeration(
    LowPower
          "Operate for low power consumption",
    Efficiency
            "Operate in efficiency mode",
    HighPower
           "Operate in high power consumption")
 "Enumeration to define modes of operation"
annotation (Documentation(
info="<html>
<p>
Enumeration for the operation modes.
Possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>LowPower</code></td>
<td>
Operate for low power consumption, such as by discharging a thermal storage.
</td></tr>
<tr><td><code>Efficiency</code></td>
<td>
Operate in efficiency mode.
</td></tr>
<tr><td><code>HighPower</code></td>
<td>
Operate in high power consumption, such as to charge a thermal storage.
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
