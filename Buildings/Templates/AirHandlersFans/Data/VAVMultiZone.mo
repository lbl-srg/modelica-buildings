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
  parameter Buildings.Templates.AirHandlersFans.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection typSecRel
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.MultizoneAHUMinOADesigns minOADes
    "Design of minimum outdoor air and economizer function"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mOutMin_flow_nominal
    "Minimum outdoor air mass flow rate"
    annotation (Dialog(group="Schedule.Mechanical"));

  parameter Buildings.Templates.Components.Fans.Interfaces.Data fanSup(
    final typ=typFanSup,
    m_flow_nominal=mAirSup_flow_nominal)
    "Supply fan"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));

  extends Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.Data(
    fanRel(
      m_flow_nominal=mAirRet_flow_nominal),
    fanRet(
      m_flow_nominal=mAirRet_flow_nominal),
    damOut(
      m_flow_nominal=mAirSup_flow_nominal,
      dp_nominal=10),
    damOutMin(
      m_flow_nominal=mOutMin_flow_nominal,
      dp_nominal=10),
    damRel(
      m_flow_nominal=mAirRet_flow_nominal,
      dp_nominal=10),
    damRet(
      m_flow_nominal=mAirRet_flow_nominal,
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

  parameter Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces.DataVAVMultiZone ctl(
    final typFanSup=typFanSup,
    final typFanRet=typFanRet,
    final typ=typCtl,
    final typSecRel=typSecRel,
    final minOADes=minOADes,
    final buiPreCon=buiPreCon)
    "Relief/return air section type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "dat");
end VAVMultiZone;
