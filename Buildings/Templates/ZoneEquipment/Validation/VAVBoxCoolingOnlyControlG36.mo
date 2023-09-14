within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnlyControlG36
  "Validation model for VAV terminal unit cooling only"
  extends VAVBoxCoolingOnly(
    datAll(redeclare replaceable model VAVBox =
    Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36),
    redeclare UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36 VAVBox_1);
  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ZoneEquipment/Validation/VAVBoxCoolingOnlyControlG36.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=3600), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36</a>.
It is intended to check whether the template model is well-defined for
this particular system configuration.
</p>
</html>"));
end VAVBoxCoolingOnlyControlG36;
