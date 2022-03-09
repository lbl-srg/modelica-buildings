within Buildings.Templates.AirHandlersFans.Validation;
model VAVMultiZoneG36Pressure
  "Return fan control based on direct building pressure"
  extends VAVMultiZoneG36Airflow(redeclare
      UserProject.AirHandlersFans.VAVMultiZoneG36Pressure VAV_1);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneG36Pressure;
