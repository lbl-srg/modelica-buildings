within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseWithSensors
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Sensors.Temperature TMix,
    redeclare Sensors.Temperature THea2,
    redeclare Sensors.Temperature TCoo,
    redeclare Sensors.Temperature TSup,
    redeclare Sensors.HumidityRatio xSup,
    redeclare Sensors.DifferentialPressure pSup);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWithSensors;
