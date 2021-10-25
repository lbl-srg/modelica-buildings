within Buildings.Examples.DualFanDualDuct.Controls;
block HeatingCoilTemperatureSetpoint "Set point scheduler for heating coil"
  import Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes;
  extends CoolingCoilTemperatureSetpoint(TSetPoi(
    y=if (mode.y == Integer(OperationModes.unoccupiedOff)) then TOff else TOn));
end HeatingCoilTemperatureSetpoint;
