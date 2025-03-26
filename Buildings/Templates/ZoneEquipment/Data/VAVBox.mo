within Buildings.Templates.ZoneEquipment.Data;
record VAVBox "Record for VAV terminal unit"
  extends Buildings.Templates.ZoneEquipment.Data.PartialAirTerminal(
    redeclare Buildings.Templates.ZoneEquipment.Configuration.VAVBox cfg,
    redeclare Buildings.Templates.ZoneEquipment.Components.Data.VAVBoxController ctl(
      stdVen=cfg.stdVen),
    final mAir_flow_nominal=max(ctl.VAirHeaSet_flow_max, ctl.VAirCooSet_flow_max) * 1.2);

  parameter Buildings.Templates.Components.Data.Damper damVAV(
    final typ=cfg.typDamVAV,
    m_flow_nominal=mAir_flow_nominal)
    "VAV damper"
    annotation (Dialog(group="Equipment"));

  parameter Buildings.Templates.Components.Data.Coil coiHea(
    final typ=cfg.typCoiHea,
    final typVal=cfg.typValCoiHea,
    final have_sou=cfg.have_souHeaWat,
    mAir_flow_nominal=ctl.VAirHeaSet_flow_max*1.2)
    "Reheat coil"
    annotation (Dialog(group="Equipment",
    enable=cfg.typ==Buildings.Templates.ZoneEquipment.Types.Configuration.VAVBoxReheat));

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
<p>
The tab <code>Advanced</code> contains some optional parameters that can be used 
for workflow automation, but are not used for simulation.
</p>
</html>"));
end VAVBox;
