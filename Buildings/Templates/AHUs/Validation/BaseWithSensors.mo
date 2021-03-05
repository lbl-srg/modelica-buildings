within Buildings.Templates.AHUs.Validation;
model BaseWithSensors
  extends BaseNoEquipment(
    redeclare UserProject.AHUs.BaseWithSensors ahu);
  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end BaseWithSensors;
