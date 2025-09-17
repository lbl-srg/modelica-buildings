within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Types;
type PrimaryPumpSpeedControl = enumeration(
    LocalDP "Pump speed regulated to maintain local differential pressure setpoint",
    RemoteDP "Pump speed regulated to maintain remote differential pressure setpoint",
    Flowrate "Pump speed regulated to maintain flowrate through decoupler",
    Temperature "Pump speed regulated to maintain temperature difference between
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
