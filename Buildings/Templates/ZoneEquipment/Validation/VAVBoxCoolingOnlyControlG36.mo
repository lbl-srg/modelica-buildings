within Buildings.Templates.ZoneEquipment.Validation;
model VAVBoxCoolingOnlyControlG36
  "Validation model for VAV terminal unit cooling only"
  extends VAVBoxCoolingOnly(
    redeclare UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36 VAVBox_1(
        redeclare replaceable
        Buildings.Templates.ZoneEquipment.Components.Controls.G36VAVBoxCoolingOnly
        ctl(stdVen=Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard.ASHRAE62_1_2016)));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1), Documentation(info="<html>
<p>
This is a validation model for the configuration represented by
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36\">
Buildings.Templates.ZoneEquipment.Validation.UserProject.ZoneEquipment.VAVBoxCoolingOnlyControlG36</a>
</p>
</html>"));
end VAVBoxCoolingOnlyControlG36;
