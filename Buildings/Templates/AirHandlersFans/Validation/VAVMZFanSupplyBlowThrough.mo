within Buildings.Templates.AirHandlersFans.Validation;
model VAVMZFanSupplyBlowThrough "Validation model for multiple-zone VAV"
  extends VAVMZNoEconomizer(redeclare
      UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough VAV_1);

  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough\">
Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans.VAVMZFanSupplyBlowThrough</a>
</p>
</html>"));
end VAVMZFanSupplyBlowThrough;
