within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanRelief "Validation model for multiple-zone VAV"
  extends VAVMZBase(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZFanRelief),
    redeclare
      UserProject.AirHandlersFans.VAVMZFanRelief VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanRelief\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanRelief</a>
</p>
</html>"));
end VAVMZFanRelief;
