within Buildings.Templates.AirHandlersFans.Validation;
model VAVMultiZoneG36Airflow
  extends NoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMultiZoneG36Airflow VAV_1);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneG36Airflow;
