within Buildings.Templates.AirHandlersFans.Data;
record VAVMultiZone
  extends Buildings.Templates.AirHandlersFans.Interfaces.Data;

  parameter Buildings.Templates.Components.Types.Coil typCoiHeaPre
    "Type of heating coil in preheat position"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Coil typCoiCoo
    "Type of cooling coil"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Coil typCoiHeaReh
    "Type of heating coil in reheat position"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Valve typValCoiHeaPre
    "Type of valve for heating coil in preheat position"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Valve typValCoiCoo
    "Type of valve for cooling coil"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Valve typValCoiHeaReh
    "Type of valve for heating coil in reheat position"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal
    "Minimum outdoor air mass flow rate"
    annotation (Dialog(group="Schedule.Mechanical"));

  extends Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.Data(
    damOut(
      final m_flow_nominal=mAirSup_flow_nominal,
      dp_nominal=10),
    damOutMin(
      final m_flow_nominal=mOutMin_flow_nominal,
      dp_nominal=10),
    damRel(
      final m_flow_nominal=mAirRet_flow_nominal,
      dp_nominal=10),
    damRet(
      final m_flow_nominal=mAirRet_flow_nominal,
      dp_nominal=10))
    annotation (
      Dialog(group="Schedule.Mechanical"));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiHeaPre(
    final typ=typCoiHeaPre,
    final typVal=typValCoiHeaPre,
    final have_sou=have_souCoiHeaPre,
    mAir_flow_nominal=mAirSup_flow_nominal)
    "Heating coil in preheat position"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=typCoiHeaPre <> Buildings.Templates.Components.Types.Coil.None));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiCoo(
    final typ=typCoiCoo,
    final typVal=typValCoiCoo,
    final have_sou=have_souCoiCoo,
    mAir_flow_nominal=mAirSup_flow_nominal)
    "Cooling coil"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typCoiCoo <> Buildings.Templates.Components.Types.Coil.None));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiHeaReh(
    final typ=typCoiHeaReh,
    final typVal=typValCoiHeaReh,
    final have_sou=have_souCoiHeaReh,
    mAir_flow_nominal=mAirSup_flow_nominal)
    "Heating coil in reheat position"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typCoiHeaReh <> Buildings.Templates.Components.Types.Coil.None));

  parameter Modelica.Units.SI.PressureDifference dpFanSup_nominal=100
    "Total pressure rise"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dpFanRet_nominal=100
    "Total pressure rise"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));

annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "datRec");
end VAVMultiZone;
