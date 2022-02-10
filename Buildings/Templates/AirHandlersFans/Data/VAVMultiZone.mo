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
  parameter Buildings.Templates.Components.Types.HeatExchanger typHexCoiHeaPre
    "Type of heat exchanger for heating coil in preheat position"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.HeatExchanger typHexCoiCoo
    "Type of heat exchanger for cooling coil"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.HeatExchanger typHexCoiHeaReh
    "Type of heat exchanger for heating coil in reheat position"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  extends Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.Data(
    damOut(
      final m_flow_nominal=mAirSup_flow_nominal,
      dp_nominal=if typDamOut==Buildings.Templates.Components.Types.Damper.None then 0
        else dat.getReal(varName=id + ".mechanical.dampers.dpDamOut_nominal.value")),
    damOutMin(
      m_flow_nominal=if typDamOutMin==Buildings.Templates.Components.Types.Damper.None then 0
        else dat.getReal(varName=id + ".mechanical.dampers.mAirOutMin_flow_nominal.value"),
      dp_nominal=if typDamOutMin==Buildings.Templates.Components.Types.Damper.None then 0
        else dat.getReal(varName=id + ".mechanical.dampers.dpDamOutMin_nominal.value")),
    damRel(
      final m_flow_nominal=mAirRet_flow_nominal,
      dp_nominal=if typDamRel==Buildings.Templates.Components.Types.Damper.None then 0
        else dat.getReal(varName=id + ".mechanical.dampers.dpDamRel_nominal.value")),
    damRet(
      final m_flow_nominal=mAirRet_flow_nominal,
      dp_nominal=if typDamRet==Buildings.Templates.Components.Types.Damper.None then 0
        else dat.getReal(varName=id + ".mechanical.dampers.dpDamRet_nominal.value")))
    annotation (
      Dialog(group="Schedule.Mechanical"));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiHeaPre(
    final typ=typCoiHeaPre,
    final typVal=typValCoiHeaPre,
    final typHex=typHexCoiHeaPre,
    final have_sou=have_souCoiHeaPre,
    mAir_flow_nominal=if typCoiHeaPre==Buildings.Templates.Components.Types.Coil.None then
      mAirSup_flow_nominal else
      dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.mAir_flow_nominal.value"),
    dpAir_nominal=if typCoiHeaPre==Buildings.Templates.Components.Types.Coil.None then 0 else
      dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.dpAir_nominal.value"),
    mWat_flow_nominal=if have_souCoiHeaPre then
      dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.mWat_flow_nominal.value") else 0,
    dpWat_nominal=if have_souCoiHeaPre then
      dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.dpWat_flow_nominal.value") else 0,
    dpValve_nominal=if have_souCoiHeaPre then
      dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.dpValve_nominal.value") else 0,
    Q_flow_nominal(final min=0)=if typCoiHeaPre==Buildings.Templates.Components.Types.Coil.None then 0 else
      dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.Q_flow_nominal.value"))
    "Heating coil in preheat position"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=typCoiHeaPre <> Buildings.Templates.Components.Types.Coil.None));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiCoo(
    final typ=typCoiCoo,
    final typVal=typValCoiCoo,
    final typHex=typHexCoiCoo,
    final have_sou=have_souCoiCoo,
    mAir_flow_nominal=mAirSup_flow_nominal,
    dpAir_nominal=if typCoiCoo==Buildings.Templates.Components.Types.Coil.None then 0 else
      dat.getReal(varName=id + ".mechanical.coilCooling.dpAir_nominal.value"),
    mWat_flow_nominal=if have_souCoiCoo then
      dat.getReal(varName=id + ".mechanical.coilCooling.mWat_flow_nominal.value") else 0,
    dpWat_nominal=if have_souCoiCoo then
      dat.getReal(varName=id + ".mechanical.coilCooling.dpWat_flow_nominal.value") else 0,
    dpValve_nominal=if have_souCoiCoo then
      dat.getReal(varName=id + ".mechanical.coilCooling.dpValve_nominal.value") else 0,
    Q_flow_nominal(final max=0)=if typCoiCoo==Buildings.Templates.Components.Types.Coil.None then 0 else
      -1 * dat.getReal(varName=id + ".mechanical.coilCooling.Q_flow_nominal.value"))
    "Cooling coil"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typCoiCoo <> Buildings.Templates.Components.Types.Coil.None));

  parameter Buildings.Templates.Components.Coils.Interfaces.Data coiHeaReh(
    final typ=typCoiHeaReh,
    final typVal=typValCoiHeaReh,
    final typHex=typHexCoiHeaReh,
    final have_sou=have_souCoiHeaReh,
    mAir_flow_nominal=if typCoiHeaReh==Buildings.Templates.Components.Types.Coil.None then
      mAirSup_flow_nominal else
      dat.getReal(varName=id + ".mechanical.coilHeatingReheat.mAir_flow_nominal.value"),
    dpAir_nominal=if typCoiHeaReh==Buildings.Templates.Components.Types.Coil.None then 0 else
      dat.getReal(varName=id + ".mechanical.coilHeatingReheat.dpAir_nominal.value"),
    mWat_flow_nominal=if have_souCoiHeaReh then
      dat.getReal(varName=id + ".mechanical.coilHeatingReheat.mWat_flow_nominal.value") else 0,
    dpWat_nominal=if have_souCoiHeaReh then
      dat.getReal(varName=id + ".mechanical.coilHeatingReheat.dpWat_flow_nominal.value") else 0,
    dpValve_nominal=if have_souCoiHeaReh then
      dat.getReal(varName=id + ".mechanical.coilHeatingReheat.dpValve_nominal.value") else 0,
    Q_flow_nominal(final min=0)=if typCoiCoo==Buildings.Templates.Components.Types.Coil.None then 0 else
      dat.getReal(varName=id + ".mechanical.coilHeatingReheat.Q_flow_nominal.value"))
    "Heating coil in reheat position"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typCoiHeaReh <> Buildings.Templates.Components.Types.Coil.None));

  parameter Modelica.Units.SI.PressureDifference dpFanSup_nominal=
    if typFanSup<>Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".mechanical.Supply fan.Total pressure rise.value")
    else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dpFanRet_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None or
      typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".mechanical.Relief/return fan.Total pressure rise.value")
    else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dpDamOut_nominal=
    dat.getReal(varName=id + ".mechanical.dampers.dpDamOut_nominal.value")
    "Outdoor air damper pressure drop"
    annotation (
      Dialog(group="Economizer and dampers"));


  parameter Modelica.Units.SI.PressureDifference dpDamRet_nominal=
    if typDamRet <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".mechanical.dampers.dpDamRet_nominal.value")
    else 0
    "Return air damper pressure drop"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dpDamRel_nominal=
    if typDamRel<>Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".mechanical.dampers.dpDamRel_nominal.value")
    else 0
    "Relief air damper pressure drop"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamRel<>Buildings.Templates.Components.Types.Damper.None));
annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "datRec");
end VAVMultiZone;
