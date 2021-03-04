within Buildings.Templates.AHUs.Sensors;
model Temperature
  extends Interfaces.Sensor(
    final typ=Types.Sensor.Temperature);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Temperature;
