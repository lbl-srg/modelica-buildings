within Buildings.Templates.Components.Data;
record Chiller "Data for chillers"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)
    "CW mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.MassFlowRate mConAir_flow_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.mConAirByCap*cap_nominal)
    "Air mass flow rate at condenser"
    annotation(Dialog(group="Nominal condition",
    enable=typ == Buildings.Templates.Components.Types.Chiller.AirCooled));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    final min=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpConWatChi)
    "CW pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typ == Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    final min=260)
    "CHW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max=
    Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Real PLRUnl_min(
    final min=PLR_min,
    final max=1)=PLR_min
    "Minimum unloading ratio (before engaging hot gas bypass, if any)";
  parameter Real PLR_min(
    final min=0,
    final max=1)=0.15
    "Minimum part load ratio before cycling";
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-1 * cap_nominal,
      TEvaLvg_nominal=TChiWatSup_nominal,
      TEvaLvgMin=TChiWatSup_nominal,
      TEvaLvgMax=TChiWatSup_max,
      PLRMin=PLR_min,
      PLRMinUnl=PLRUnl_min,
      mEva_flow_nominal=mChiWat_flow_nominal,
      mCon_flow_nominal=mConWat_flow_nominal)
    "Chiller performance data"
    annotation(Dialog(group="Nominal condition"));
end Chiller;
