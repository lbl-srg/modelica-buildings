within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types;
type PrimaryPumpSpeedControlTypes = enumeration(
    localDP "Pump speed regulated to maintain local differential pressure setpoint",
    remoteDP "Pump speed regulated to maintain remote differential pressure setpoint",
    flowrate "Pump speed regulated to maintain flowrate through decoupler",
    temperature "Pump speed regulated to maintain temperature difference between
      primary and secondary loops")
  "Definitions for primary pump speed control types" annotation (Documentation(
      info="<html>
<p>
Enumeration to define the choice of primary pump speed control types:
</p>
<table summary=\"enumeration\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>Enumeration</th><th>Description</th></tr>
<tr><td>localDP</td><td>Pump speed regulated to maintain local differential pressure setpoint.</td></tr>
<tr><td>remoteDP</td><td>Pump speed regulated to maintain remote differential pressure setpoint.</td></tr>
<tr><td>flowrate</td><td>Pump speed regulated to maintain flowrate through decoupler.</td></tr>
<tr><td>temperature</td><td>Pump speed regulated to maintain temperature difference between primary and secondary loops.</td></tr>
</table>
</html>"));
