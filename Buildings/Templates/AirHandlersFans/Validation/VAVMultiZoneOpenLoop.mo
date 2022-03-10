within Buildings.Templates.AirHandlersFans.Validation;
model VAVMultiZoneOpenLoop
  extends NoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMultiZoneOpenLoop VAV_1);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneOpenLoop;
