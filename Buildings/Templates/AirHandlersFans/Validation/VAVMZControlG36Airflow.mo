within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZControlG36Airflow "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(
    redeclare UserProject.AirHandlersFans.VAVMZControlG36Airflow VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info=" <html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZControlG36Airflow\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZControlG36Airflow</a>
</p>
</html>"));
end VAVMZControlG36Airflow;
