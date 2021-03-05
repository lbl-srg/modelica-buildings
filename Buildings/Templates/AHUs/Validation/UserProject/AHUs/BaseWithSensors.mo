within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model BaseWithSensors
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Sensors.Temperature senTemHea1,
    redeclare Sensors.Temperature senTemMix,
    redeclare Sensors.Temperature senTemHea2,
    redeclare Sensors.Temperature senTemCoo,
    redeclare Sensors.Temperature senTemHea3,
    redeclare Sensors.Temperature senTemSup,
    redeclare Sensors.HumidityRatio senHumSup,
    redeclare Sensors.DifferentialPressure senPreSta);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end BaseWithSensors;
