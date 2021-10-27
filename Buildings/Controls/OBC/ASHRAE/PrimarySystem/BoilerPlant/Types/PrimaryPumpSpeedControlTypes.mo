within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Types;
type PrimaryPumpSpeedControlTypes = enumeration(
    localDP "Pump speed regulated to maintain local differential pressure setpoint",
    remoteDP "Pump speed regulated to maintain remote differential pressure setpoint",
    flowrate "Pump speed regulated to maintain flowrate through decoupler",
    temperature "Pump speed regulated to maintain temperature difference between
      primary and secondary loops")
  "Definitions for primary pump speed control types";
