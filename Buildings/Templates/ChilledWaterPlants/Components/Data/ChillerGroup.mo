within Buildings.Templates.ChilledWaterPlants.Components.Data;
record ChillerGroup "Record for chiller group model"
  extends Modelica.Icons.Record;

  parameter Integer nChi(final min=1)
    "Number of chillers"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi](
    each final min=0)
    "CHW mass flow rate for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConFluChi_flow_nominal[nChi](
    each final min=0,
    start=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo)/
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
    (Buildings.Templates.Data.Defaults.TConWatRet-
    Buildings.Templates.Data.Defaults.TConWatSup) elseif
    typChi==Buildings.Templates.Components.Types.Chiller.AirCooled
      then capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiAirCoo)*
    Buildings.Templates.Data.Defaults.mConAirByCap else fill(0, nChi))
    "Condenser cooling fluid mass flow rate for each chiller"
    annotation(Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop for each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConFluChi_nominal[nChi](
    each final min=0,
    each start=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then Buildings.Templates.Data.Defaults.dpConWatChi elseif
    typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
    Buildings.Templates.Data.Defaults.dpConAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each final min=0)
    "Cooling capacity for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatChiSup_nominal[nChi](
    each final min=260)
    "(lowest) CHW supply temperature for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatChiSup_max[nChi]=
    fill(Buildings.Templates.Data.Defaults.TChiWatSup_max, nChi)
    "Maximum CHW supply temperature for each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Real PLRUnlChi_min[nChi](
    final min=PLRChi_min,
    each final max=1)=PLRChi_min
    "Minimum unloading ratio (before engaging hot gas bypass, if any)";
  parameter Real PLRChi_min[nChi](
    each final min=0,
    each final max=1)=fill(0.15, nChi)
    "Minimum part load ratio before cycling";
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[nChi]
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-1 * capChi_nominal,
      TEvaLvg_nominal=TChiWatChiSup_nominal,
      TEvaLvgMin=TChiWatChiSup_nominal,
      TEvaLvgMax=TChiWatChiSup_max,
      PLRMin=PLRChi_min,
      PLRMinUnl=PLRUnlChi_min,
      mEva_flow_nominal=mChiWatChi_flow_nominal,
      mCon_flow_nominal=mConFluChi_flow_nominal)
    "Chiller performance data"
    annotation(Dialog(group="Nominal condition"));
  final parameter Buildings.Templates.Components.Data.Chiller datChi[nChi](
    each final typ=typChi,
    final mChiWat_flow_nominal=mChiWatChi_flow_nominal,
    final mConFlu_flow_nominal=mConFluChi_flow_nominal,
    final cap_nominal=capChi_nominal,
    final dpChiWat_nominal=dpChiWatChi_nominal,
    final dpConFlu_nominal=dpConFluChi_nominal,
    final TChiWatSup_nominal=TChiWatChiSup_nominal,
    final TChiWatSup_max=TChiWatChiSup_max,
    final PLRUnl_min=PLRUnlChi_min,
    final PLR_min=PLRChi_min,
    final per=per)
    "Parameter record of each chiller";
end ChillerGroup;
