within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseWithSensors
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare BaseClasses.Sensors.Temperature TMix,
    redeclare BaseClasses.Sensors.Temperature THea,
    redeclare BaseClasses.Sensors.Temperature TCoo,
    redeclare BaseClasses.Sensors.Temperature TSup,
    redeclare BaseClasses.Sensors.HumidityRatio xSup,
    redeclare BaseClasses.Sensors.DifferentialPressure pSup_rel,
    redeclare BaseClasses.Sensors.VolumeFlowRate VRet,
    redeclare BaseClasses.Sensors.DifferentialPressure pRet_rel,
    redeclare BaseClasses.Sensors.VolumeFlowRate VSup,
    redeclare BaseClasses.Sensors.VolumeFlowRate VOut,
    redeclare BaseClasses.Sensors.DifferentialPressure dpOut);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWithSensors;
