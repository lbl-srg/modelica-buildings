within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxReheatControlG36 "Validation model for VAV terminal unit with reheat"
  extends VAVBoxCoolingOnly(
    datAll(redeclare replaceable model VAVBox =
    Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheatControlG36),
    redeclare UserProject.ZoneEquipment.VAVBoxReheatControlG36 VAVBox_1(
        redeclare replaceable
        Buildings.Templates.Components.Coils.ElectricHeating coiHea
        "Modulating electric heating coil"));
  annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/ZoneEquipment/Validation/VAVBoxReheatControlG36.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=3600), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheatControlG36\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxReheatControlG36</a>.
It is intended to check whether the template model is well-defined for
this particular system configuration.
</p>
</html>"));
end VAVBoxReheatControlG36;
