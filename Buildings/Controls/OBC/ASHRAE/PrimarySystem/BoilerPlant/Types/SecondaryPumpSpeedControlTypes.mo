within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types;
type SecondaryPumpSpeedControlTypes = enumeration(
    localDP "Pump speed regulated to maintain local differential pressure setpoint",
    remoteDP "Pump speed regulated to maintain remote differential pressure setpoint")
  "Definitions for secondary pump speed control types" annotation (
    Documentation(info="<html>
<p>Enumeration to define the choice of secondary pump speed control types: </p>
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
</table>
</html>"));
