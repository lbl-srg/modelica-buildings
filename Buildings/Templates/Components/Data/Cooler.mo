within Buildings.Templates.Components.Data;
record Cooler "Record for condenser water cooling equipment"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Cooler typ
    "Type of equipment"
    annotation(Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)
    "CW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatFri_nominal(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen then
    Buildings.Templates.Data.Defaults.dpConWatFriTow else
    Buildings.Templates.Data.Defaults.dpConWatTowClo)
    "CW flow-friction losses through tower and piping only (without elevation head or valve)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatSta_nominal(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen then
    Buildings.Templates.Data.Defaults.dpConWatStaTow else
    0)
    "CW elevation head"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen));
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0,
    start=mConWat_flow_nominal / Buildings.Templates.Data.Defaults.ratFloWatByAirTow)
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TAirDryCooEnt)
    "Entering air drybulb temperature"
    annotation (Dialog(group="Nominal condition", enable=
    typ==Buildings.Templates.Components.Types.Cooler.DryCooler));
  parameter Modelica.Units.SI.Temperature TWetBulEnt_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TWetBulTowEnt)
    "Entering air wetbulb temperature"
    annotation (Dialog(group="Nominal condition", enable=
    typ==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typ==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed));
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TConWatRet)
    "CW return temperature (cooler entering)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TConWatSup)
    "CW supply temperature (cooler leaving)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Power PFan_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.PFanByFloConWatTow * mConWat_flow_nominal)
    "Fan power"
    annotation (Dialog(group="Nominal condition"));
end Cooler;
