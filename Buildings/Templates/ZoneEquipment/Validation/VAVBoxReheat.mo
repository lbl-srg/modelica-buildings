within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheat
  "Validation model for VAV terminal unit with reheat"
  extends VAVBoxCoolingOnly(
    redeclare Buildings.Templates.ZoneEquipment.VAVBoxReheat VAVBox_1);
  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ZoneEquipment/Validation/VAVBoxReheat.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=3600), Documentation(info="<html>
<p>
This is a validation model for the template
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxReheat\">
Buildings.Templates.ZoneEquipment.VAVBoxReheat</a>.
</p>
</html>"));
end VAVBoxReheat;
