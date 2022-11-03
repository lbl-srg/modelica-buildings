within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilWaterHeatingCooling "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZCoilWaterHeatingCooling),
    redeclare UserProject.AirHandlersFans.VAVMZCoilWaterHeatingCooling VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilWaterHeatingCooling\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilWaterHeatingCooling</a>
</p>
</html>"));
end VAVMZCoilWaterHeatingCooling;
