within Buildings.Templates.ZoneEquipment.Configuration;
record VAVBox "Configuration parameters for VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.Configuration.PartialAirTerminal;

  parameter Buildings.Templates.Components.Types.Damper typDamVAV
    "Type of VAV damper"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Coil typCoiHea
    "Type of heating coil"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Valve typValCoiHea
    "Type of valve for heating coil"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard"
    annotation (Evaluate=true);

annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "cfg",
  Documentation(info="<html>
<p>
This record provides the set of configuration parameters for the classes
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly\">
Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly</a>
and
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxReheat\">
Buildings.Templates.ZoneEquipment.VAVBoxReheat</a>.
</p>
</html>"));
end VAVBox;
