within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZDedicatedDampersPressure "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(
    datAll(
      redeclare model VAV =
        UserProject.AirHandlersFans.VAVMZDedicatedDampersPressure),
    redeclare UserProject.AirHandlersFans.VAVMZDedicatedDampersPressure VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZDedicatedDampersPressure\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZDedicatedDampersPressure</a>
</p>
</html>"));
end VAVMZDedicatedDampersPressure;
