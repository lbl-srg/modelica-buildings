within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheat "Validation model for VAV terminal unit with reheat"
  extends VAVBoxCoolingOnly(redeclare UserProject.ZoneEquipment.VAVBoxReheat
      VAVBox_1);
  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheat\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheat</a>
</p>
</html>"));
end VAVBoxReheat;
