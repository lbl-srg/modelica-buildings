within OCTExamples.DualFanDualDuct.Controls;
block HeatingCoilTemperatureSetpoint "Set point scheduler for heating coil"
  import OCTExamples.VAVReheat.BaseClasses.Controls.OperationModes;
  extends CoolingCoilTemperatureSetpoint(TSetPoi(
    y=if (mode.y == Integer(OperationModes.unoccupiedOff)) then TOff else TOn));
end HeatingCoilTemperatureSetpoint;
