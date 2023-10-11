within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Types;
type RecoveryControl = enumeration(
    BypassAir
    "With a bypass damper",
    ModulateWheel
    "With a variable speed wheel")
  "Enumeration of the control of heat recovery"
     annotation (Documentation(info="<html>
<p>
Enumeration for the types of heat recovery (HR) devices.
The possible values are:
</p>
<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>BypassAir</code></td>
<td>
The HR devices adjust the heat exchange by modulating the flow rates through the wheel via a bypass damper
</td></tr>
<tr><td><code>ModulateWheel</code></td>
<td>
The HR devices adjust the heat exchange by modulating the speed of the wheel
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
September 29, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
