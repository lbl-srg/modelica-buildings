within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilElectricHeating "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(redeclare model VAV =
      UserProject.AirHandlersFans.VAVMZCoilElectricHeating),
    redeclare
      UserProject.AirHandlersFans.VAVMZCoilElectricHeating VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilElectricHeating\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilElectricHeating</a>
</p>
</html>"));
end VAVMZCoilElectricHeating;
