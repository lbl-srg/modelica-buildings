within Buildings.Templates.AirHandlersFans.Validation;
model ControlsGuideline36Pressure "Return fan control based on direct building pressure"
  extends ControlsGuideline36(
    redeclare UserProject.AHUs.ControlsGuideline36Pressure ahu);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ControlsGuideline36Pressure;
