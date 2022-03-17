within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZControlG36Airflow "Return fan control based on airflow tracking"
  extends VAVMZNoEconomizer(
                       redeclare
      UserProject.AirHandlersFans.VAVMZControlG36Airflow VAV_1);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMZControlG36Airflow;
