within Buildings.Templates.AirHandlersFans.Data;
record VAVMultiZone "Record for multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.Data.PartialAirHandler(
    redeclare Buildings.Templates.AirHandlersFans.Configuration.VAVMultiZone cfg,
    redeclare Buildings.Templates.AirHandlersFans.Components.Data.VAVMultiZoneController
    ctl(
      final typSecOut=cfg.typSecOut,
      final buiPreCon=cfg.buiPreCon,
      final stdVen=cfg.stdVen),
    final mAirSup_flow_nominal=if cfg.typFanSup<>Buildings.Templates.Components.Types.Fan.None
      then fanSup.m_flow_nominal else 0,
    final mAirRet_flow_nominal=if cfg.typFanRet<>Buildings.Templates.Components.Types.Fan.None
      then fanRet.m_flow_nominal
    elseif cfg.typFanRel<>Buildings.Templates.Components.Types.Fan.None
      then fanRel.m_flow_nominal
    elseif cfg.typFanSup<>Buildings.Templates.Components.Types.Fan.None
      then fanSup.m_flow_nominal else 0);

  parameter Buildings.Templates.Components.Data.Fan fanSup(
    final typ=cfg.typFanSup)
    "Supply fan"
    annotation (Dialog(
    group="Fans", enable=cfg.typFanSup <> Buildings.Templates.Components.Types.Fan.None));

  extends
    Buildings.Templates.AirHandlersFans.Components.Data.OutdoorReliefReturnSection(
    final typDamOut=cfg.typDamOut,
    final typDamOutMin=cfg.typDamOutMin,
    final typDamRel=cfg.typDamRel,
    final typDamRet=cfg.typDamRet,
    final typFanRel=cfg.typFanRel,
    final typFanRet=cfg.typFanRet,
    fanRel,
    fanRet,
    damOut(
      m_flow_nominal=mAirSup_flow_nominal),
    damOutMin(
      m_flow_nominal=mOutMin_flow_nominal),
    damRel(
      m_flow_nominal=mAirRet_flow_nominal),
    damRet(
      m_flow_nominal=mAirRet_flow_nominal));

  parameter Buildings.Templates.Components.Data.Coil coiHeaPre(
    final typ=cfg.typCoiHeaPre,
    final typVal=cfg.typValCoiHeaPre,
    final have_sou=cfg.have_souHeaWat,
    mAir_flow_nominal=mAirSup_flow_nominal)
    "Heating coil in preheat position"
    annotation (Dialog(group="Coils",
    enable=cfg.typCoiHeaPre <> Buildings.Templates.Components.Types.Coil.None));

  parameter Buildings.Templates.Components.Data.Coil coiCoo(
    final typ=cfg.typCoiCoo,
    final typVal=cfg.typValCoiCoo,
    final have_sou=cfg.have_souChiWat,
    mAir_flow_nominal=mAirSup_flow_nominal)
    "Cooling coil"
    annotation (Dialog(
    group="Coils", enable=cfg.typCoiCoo <> Buildings.Templates.Components.Types.Coil.None));

  parameter Buildings.Templates.Components.Data.Coil coiHeaReh(
    final typ=cfg.typCoiHeaReh,
    final typVal=cfg.typValCoiHeaReh,
    final have_sou=cfg.have_souHeaWat,
    mAir_flow_nominal=mAirSup_flow_nominal)
    "Heating coil in reheat position"
    annotation (Dialog(group="Coils",
    enable=cfg.typCoiHeaReh <> Buildings.Templates.Components.Types.Coil.None));

annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "dat",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for the class
<a href=\"modelica://Buildings.Templates.AirHandlersFans.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.VAVMultiZone</a>.
</p>
<p>
The tab <code>Advanced</code> contains some optional parameters that can be used 
for workflow automation, but are not used for simulation.
</p>
</html>"));
end VAVMultiZone;
