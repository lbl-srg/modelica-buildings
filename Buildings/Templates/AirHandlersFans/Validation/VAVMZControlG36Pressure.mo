within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZControlG36Pressure
  "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(redeclare model VAV =
      UserProject.AirHandlersFans.VAVMZControlG36Pressure),
    redeclare UserProject.AirHandlersFans.VAVMZControlG36Pressure VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZControlG36Pressure\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZControlG36Pressure</a>
</p>
</html>"));
end VAVMZControlG36Pressure;
