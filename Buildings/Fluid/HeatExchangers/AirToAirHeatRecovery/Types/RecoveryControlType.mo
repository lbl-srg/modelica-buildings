within Buildings.Fluid.HeatExchangers.AirToAirHeatRecovery.Types;
type RecoveryControlType = enumeration(
    Bypass
    "with a bypass damper",
    VariableSpeed)
    "with a variable speed wheel"
     annotation (Documentation(info="<html>
<p>
Enumeration for the types of heat recovery (HR) devices.
The possible values are:
</p>

<table border=\"1\" summary=\"Explanation of the enumeration\">
<tr>
<th>Enumeration</th>
<th>Description</th></tr>
<tr><td><code>Bypass</code></td>
<td>
The HR devices adjust the heat exchange by modulating the flow rates through the wheel via a bypass damper.
</td></tr>
<tr><td><code>VariableSpeed</code></td>
<td>
The HR devices adjust the heat exchange by modulating the speed of the wheel.
</td></tr>
</table>
</html>", revisions="<html>
<ul>
<li>
September 17, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"));
