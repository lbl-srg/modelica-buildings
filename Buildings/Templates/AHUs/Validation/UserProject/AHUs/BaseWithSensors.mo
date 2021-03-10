within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseWithSensors
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare BaseClasses.Sensors.Temperature TMix,
    redeclare BaseClasses.Sensors.Temperature THea2,
    redeclare BaseClasses.Sensors.Temperature TCoo,
    redeclare BaseClasses.Sensors.Temperature TSup,
    redeclare BaseClasses.Sensors.HumidityRatio xSup,
    redeclare BaseClasses.Sensors.DifferentialPressure pSup);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWithSensors;
