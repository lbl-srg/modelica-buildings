within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanSupplyArrayVariable "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZFanSupplyArrayVariable,
      _VAV_1(fanSup(nFan=2))),
    redeclare UserProject.AirHandlersFans.VAVMZFanSupplyArrayVariable VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanSupplyArrayVariable\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanSupplyArrayVariable</a>
</p>
</html>"));
end VAVMZFanSupplyArrayVariable;
