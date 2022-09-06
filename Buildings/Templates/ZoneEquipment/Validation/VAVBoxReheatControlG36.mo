within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheatControlG36 "Validation model for VAV terminal unit with reheat"
  extends VAVBoxCoolingOnly(
    redeclare UserProject.ZoneEquipment.VAVBoxReheatControlG36 VAVBox_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheatControlG36\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheatControlG36</a>
</p>
</html>"));
end VAVBoxReheatControlG36;
