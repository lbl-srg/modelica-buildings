within Buildings.Templates.AirHandlersFans.Data;
record VAVMultiZone
  extends Modelica.Icons.Record;

  parameter String id
    "System tag"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));

  /*
  FIXME: Not strictly compliant with Modelica specification, see
  https://github.com/lbl-srg/linkage.js/wiki/20211220_HVACTemplates#use-of-an-external-parameter-file-1
  */
  parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan"
    annotation(Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of return fan"
    annotation(Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Type of relief fan"
    annotation(Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Coil typCoiHeaPre
    "Type of heating coil in preheat position"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Coil typCoiCoo
    "Type of cooling coil"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Coil typCoiHeaReh
    "Type of heating coil in reheat position"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCoiHeaPre
    "Type of valve for heating coil in preheat position"
    annotation (Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCoiCoo
    "Type of valve for cooling coil"
    annotation (Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Valve typValCoiHeaReh
    "Type of valve for heating coil in reheat position"
    annotation (Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.Components.Types.Damper typDamRet
    "Return damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal=
    dat.getReal(varName=id + ".mechanical.mAirSup_flow_nominal.value")
    "Supply air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal=
    dat.getReal(varName=id + ".mechanical.mAirRet_flow_nominal.value")
    "Return air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAirOutMin_flow_nominal=
    if typDamOutMin <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".mechanical.dampers.mAirOutMin_flow_nominal.value")
    else 0
    "Minimum outdoor air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));

  parameter Modelica.Units.SI.MassFlowRate mAirCoiHeaPre_flow_nominal=
    if typCoiHeaPre <> Buildings.Templates.Components.Types.Coil.None then
    dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.mAir_flow_nominal.value") else
    mAirSup_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Heating coil in preheat position",
      enable=typCoiHeaPre <> Buildings.Templates.Components.Types.Coil.None));

  parameter Modelica.Units.SI.MassFlowRate mAirCoiCoo_flow_nominal=
    mAirSup_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Cooling coil",
      enable=typCoiCoo <> Buildings.Templates.Components.Types.Coil.None));

  parameter Modelica.Units.SI.MassFlowRate mAirCoiHeaReh_flow_nominal=
    if typCoiHeaReh <> Buildings.Templates.Components.Types.Coil.None then
    dat.getReal(varName=id + ".mechanical.coilHeatingReheat.mAir_flow_nominal.value") else
    mAirSup_flow_nominal
    "Air mass flow rate"
    annotation (Dialog(group="Heating coil in reheat position",
      enable=typCoiHeaReh <> Buildings.Templates.Components.Types.Coil.None));

  parameter Modelica.Units.SI.PressureDifference dpFanSup_nominal=
    if typFanSup<>Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".mechanical.Supply fan.Total pressure rise.value")
    else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Supply fan",
        enable=typFanSup <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dpFanRet_nominal=
    if typFanRel <> Buildings.Templates.Components.Types.Fan.None or
      typFanRet <> Buildings.Templates.Components.Types.Fan.None then
      dat.getReal(varName=id + ".mechanical.Relief/return fan.Total pressure rise.value")
    else 0
    "Total pressure rise"
    annotation (
      Dialog(group="Relief/return fan",
        enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None or
          typFanRet <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dpDamOut_nominal=
    dat.getReal(varName=id + ".mechanical.dampers.dpDamOut_nominal.value")
    "Outdoor air damper pressure drop"
    annotation (
      Dialog(group="Economizer and dampers"));
  parameter Modelica.Units.SI.PressureDifference dpDamOutMin_nominal=
    if typDamOutMin <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".mechanical.dampers.dpDamOutMin_nominal.value")
    else 0
    "Minimum outdoor air damper pressure drop"
    annotation (
      Dialog(group="Economizer and dampers",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dpDamRet_nominal=
    if typDamRet <> Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".mechanical.dampers.dpDamRet_nominal.value")
    else 0
    "Return air damper pressure drop"
    annotation (
      Dialog(group="Economizer and dampers",
        enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dpDamRel_nominal=
    if typDamRel<>Buildings.Templates.Components.Types.Damper.None then
      dat.getReal(varName=id + ".mechanical.dampers.dpDamRel_nominal.value")
    else 0
    "Relief air damper pressure drop"
    annotation (
      Dialog(group="Economizer and dampers",
        enable=typDamRel<>Buildings.Templates.Components.Types.Damper.None));

  parameter Modelica.Units.SI.PressureDifference dpAirCoiHeaPre_nominal(
    displayUnit="Pa")=
    if typCoiHeaPre==Buildings.Templates.Components.Types.Coil.None then 0 else
    dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.dpAir_nominal.value")
    "Air pressure drop"
    annotation (
      Dialog(group="Heating coil in preheat position"),
      enable=typCoiHeaPre<>Buildings.Templates.Components.Types.Coil.None);

  parameter Modelica.Units.SI.PressureDifference dpAirCoiCoo_nominal(
    displayUnit="Pa")=
    if typCoiCoo==Buildings.Templates.Components.Types.Coil.None then 0 else
    dat.getReal(varName=id + ".mechanical.coilCooling.dpAir_nominal.value")
    "Air pressure drop"
    annotation (
      Dialog(group="Cooling coil"),
      enable=typCoiCoo<>Buildings.Templates.Components.Types.Coil.None);

  parameter Modelica.Units.SI.PressureDifference dpAirCoiHeaReh_nominal(
    displayUnit="Pa")=
    if typCoiHeaReh==Buildings.Templates.Components.Types.Coil.None then 0 else
    dat.getReal(varName=id + ".mechanical.coilHeatingReheat.dpAir_nominal.value")
    "Air pressure drop"
    annotation (
      Dialog(group="Heating coil in reheat position"),
      enable=typCoiHeaReh<>Buildings.Templates.Components.Types.Coil.None);

  parameter Modelica.Units.SI.MassFlowRate mWatCoiHeaPre_flow_nominal(final min=0)=
    if typCoiHeaPre==Buildings.Templates.Components.Types.Coil.WaterBased then
    dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.mWat_flow_nominal.value") else
    0
    "Liquid mass flow rate"
    annotation(Dialog(group="Heating coil in preheat position"));
  parameter Modelica.Units.SI.PressureDifference dpWatCoiHeaPre_nominal(final min=0,
    displayUnit="Pa")=if typCoiHeaPre==Buildings.Templates.Components.Types.Coil.WaterBased then
    dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.dpWat_nominal.value") else
    0
    "Liquid pressure drop"
    annotation(Dialog(group="Heating coil in preheat position"));
  parameter Modelica.Units.SI.PressureDifference dpValveCoiHeaPre_nominal(final min=0,
    displayUnit="Pa")=if typValCoiHeaPre==Buildings.Templates.Components.Types.Valve.None then 0 else
    dat.getReal(varName=id + ".mechanical.coilHeatingPreheat.dpValve_nominal.value")
    "Nominal pressure drop of fully open valve"
    annotation(Dialog(group="Heating coil in preheat position",
      enable=typValCoiHeaPre<>Buildings.Templates.Components.Types.Valve.None));


annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "datRec");
end VAVMultiZone;
