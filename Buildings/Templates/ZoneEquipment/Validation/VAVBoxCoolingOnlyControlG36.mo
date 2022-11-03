within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnlyControlG36
  "Validation model for VAV terminal unit cooling only"
  extends VAVBoxCoolingOnly(
    datAll(
      redeclare model VAVBox =
        UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36),
    redeclare UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36 VAVBox_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36</a>
</p>
</html>"));
end VAVBoxCoolingOnlyControlG36;
