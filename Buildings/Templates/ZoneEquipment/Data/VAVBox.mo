within Buildings.Templates.ZoneEquipment.Data;
record VAVBox "Record for VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal(
    redeclare Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController ctl(
      stdVen=stdVen),
    final mAir_flow_nominal=max(ctl.VAirHeaSet_flow_max, ctl.VAirCooSet_flow_max) * 1.2);

  parameter Buildings.Templates.Components.Types.Damper typDamVAV
    "Type of VAV damper"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Coil typCoiHea
    "Type of heating coil"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Valve typValCoiHea
    "Type of valve for heating coil"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Data.Damper damVAV(
    final typ=typDamVAV,
    m_flow_nominal=mAir_flow_nominal)
    "VAV damper"
    annotation (Dialog(group="Equipment"));

  parameter Buildings.Templates.Components.Data.Coil coiHea(
    final typ=typCoiHea,
    final typVal=typValCoiHea,
    final have_sou=have_souHeaWat,
    mAir_flow_nominal=ctl.VAirHeaSet_flow_max*1.2)
    "Reheat coil"
    annotation (Dialog(group="Equipment"));

annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "dat",
    Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for the classes
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly\">
Buildings.Templates.ZoneEquipment.VAVBoxCoolingOnly</a>
and
<a href=\"modelica://Buildings.Templates.ZoneEquipment.VAVBoxReheat\">
Buildings.Templates.ZoneEquipment.VAVBoxReheat</a>.
</p>
</html>"));
end VAVBox;
