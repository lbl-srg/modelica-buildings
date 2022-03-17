within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZControlG36Pressure
  "Validation model for multiple-zone VAV"
  extends VAVMZControlG36Airflow(redeclare
      UserProject.AirHandlersFans.VAVMZControlG36Pressure VAV_1);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMZControlG36Pressure;
