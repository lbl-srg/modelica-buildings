within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types;
type PrimaryPumpSpeedControlTypes = enumeration(
    localDP "Pump speed regulated to maintain local differential pressure setpoint",
    remoteDP "Pump speed regulated to maintain remote differential pressure setpoint",
    flowrate "Pump speed regulated to maintain flowrate through decoupler",
    temperature "Pump speed regulated to maintain temperature difference between
      primary and secondary loops")
  "Definitions for primary pump speed control types" annotation (Documentation(
      info="<html>
<p>Enumeration to define the choice of primary pump speed control types: </p>
<table cellspacing=\"2\" cellpadding=\"0\" border=\"1\"><tr>
<td><p align=\"center\"><h4>Enumeration</h4></p></td>
<td><p align=\"center\"><h4>Description</h4></p></td>
</tr>
<tr>
<td><p>localDP</p></td>
<td><p>Pump speed regulated to maintain local differential pressure setpoint. </p></td>
</tr>
<tr>
<td><p>remoteDP</p></td>
<td><p>Pump speed regulated to maintain remote differential pressure setpoint. </p></td>
</tr>
<tr>
<td><p>flowrate</p></td>
<td><p>Pump speed regulated to maintain flowrate through decoupler. </p></td>
</tr>
<tr>
<td><p>temperature</p></td>
<td><p>Pump speed regulated to maintain temperature difference between primary and secondary loops. </p></td>
</tr>
</table>
</html>"));
