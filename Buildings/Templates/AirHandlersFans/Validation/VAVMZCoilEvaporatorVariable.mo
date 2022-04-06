within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZCoilEvaporatorVariable "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(redeclare
    UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZCoilEvaporatorVariable</a>
</p>
</html>"));
end VAVMZCoilEvaporatorVariable;
