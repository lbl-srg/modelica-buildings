within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types;
type SecondaryPumpSpeedControlTypes = enumeration(
    localDP "Pump speed regulated to maintain local differential pressure setpoint",
    remoteDP "Pump speed regulated to maintain remote differential pressure setpoint")
  "Definitions for secondary pump speed control types" annotation (
    Documentation(info="<html>
<p>
Enumeration to define the choice of secondary pump speed control types:
</p>
<table summary=\"enumeration\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>localDP</td><td>Pump speed regulated to maintain local differential pressure setpoint.</td></tr>
<tr><td>remoteDP</td><td>Pump speed regulated to maintain remote differential pressure setpoint.</td></tr>
</table>
</html>"));
