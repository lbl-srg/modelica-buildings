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
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal(
    final min=0)
    "Condenser cooling fluid (e.g. CW) mass flow rate"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    final min=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
    then Buildings.Templates.Data.Defaults.dpConWatChi elseif
    typ == Buildings.Templates.Components.Types.Chiller.AirCooled then
    Buildings.Templates.Data.Defaults.dpConAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    final min=260)
    "CHW supply temperature"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSup_max=
    Buildings.Templates.Data.Defaults.TChiWatSup_max
    "Maximum CHW supply temperature"
    annotation(Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConEnt_nominal(
    final min=273.15,
    start=if typ==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then Buildings.Templates.Data.Defaults.TConWatSup else
    Buildings.Templates.Data.Defaults.TConAirEnt)
    "Condenser entering fluid temperature (CW or air)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConEnt_min(
    final min=273.15)=
    Buildings.Templates.Data.Defaults.TConEnt_min
    "Minimum condenser entering fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConEnt_max(
    final min=273.15)=
    Buildings.Templates.Data.Defaults.TConEnt_max
    "Maximum condenser entering fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits"));
  parameter Real PLRUnl_min(
    final min=PLR_min,
    final max=1)=PLR_min
    "Minimum unloading ratio (before engaging hot gas bypass, if any)";
  parameter Real PLR_min(
    final min=0,
    final max=1)=0.15
    "Minimum part load ratio before cycling";
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per(
    TConEnt_nominal=TConEnt_nominal,
    TConEntMin=TConEnt_min,
    TConEntMax=TConEnt_max)
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-1 * cap_nominal,
      TEvaLvg_nominal=TChiWatSup_nominal,
      TEvaLvgMin=TChiWatSup_nominal,
      TEvaLvgMax=TChiWatSup_max,
      PLRMin=PLR_min,
      PLRMinUnl=PLRUnl_min,
      mEva_flow_nominal=mChiWat_flow_nominal,
      mCon_flow_nominal=mCon_flow_nominal)
    "Chiller performance data"
    annotation (
    choicesAllMatching=true);
  annotation (
  defaultComponentName="datChi", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the classes within
<a href=\"modelica://Buildings.Templates.Components.Chillers\">
Buildings.Templates.Components.Chillers</a>.
</p>
</html>"));
end Chiller;
