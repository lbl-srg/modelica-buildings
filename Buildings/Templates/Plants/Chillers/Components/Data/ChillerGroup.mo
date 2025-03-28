within Buildings.Templates.Plants.Chillers.Components.Data;
record ChillerGroup
  "Record for chiller group model"
  extends Modelica.Icons.Record;
  parameter Integer nChi(
    start =1, final min=1)
    "Number of chillers (as installed)"
    annotation (Evaluate=true,
    Dialog(group="Configuration",
      enable=false));
  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi](
    each final min=0)
    "CHW mass flow rate - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi](
    each final min=0,
    start=fill(0, nChi))
    "CW mass flow rate - Each chiller"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  final parameter Modelica.Units.SI.MassFlowRate mConChi_flow_nominal[nChi]=if typ ==
    Buildings.Templates.Components.Types.Chiller.WaterCooled then mConWatChi_flow_nominal
    else Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(capChi_nominal)
    "Condenser cooling fluid mass flow rate - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConChi_nominal[nChi](
    each final min=0,
    each start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      then Buildings.Templates.Data.Defaults.dpConWatChi elseif
      typ == Buildings.Templates.Components.Types.Chiller.AirCooled
      then Buildings.Templates.Data.Defaults.dpAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each final min=0)
    "Cooling capacity - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSupChi_nominal[nChi](
    each final min=260)
    "Design (lowest) CHW supply temperature - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatChi_nominal[nChi](
    each final min=273.15,
    start=fill(Buildings.Templates.Data.Defaults.TConWatSup, nChi))
    "Condenser water entering or leaving temperature (depending on per.use_TConOutForTab) - Each chiller"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TOut_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TOutChi)
    "Design outdoor air temperature"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.AirCooled));
  final parameter Modelica.Units.SI.Temperature TConChi_nominal[nChi](
    each final min=273.15)=if typ==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then TConWatChi_nominal else fill(TOut_nominal, nChi)
    "Condenser entering or leaving fluid temperature (depending on per.use_TConOutForTab) - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic perChi[nChi](
    mCon_flow_nominal=mConChi_flow_nominal,
    mEva_flow_nominal=mChiWatChi_flow_nominal,
    dpCon_nominal=dpConChi_nominal,
    dpEva_nominal=dpChiWatChi_nominal,
    tabLowBou={[
      TConChi_nominal[i] - 30, TChiWatSupChi_nominal[i] - 2;
      TConChi_nominal[i] + 10, TChiWatSupChi_nominal[i] - 2] for i in 1:nChi},
    each devIde="")
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Chiller performance data"
    annotation (choicesAllMatching=true);
  annotation (
    defaultComponentName="datChi",
    Documentation(
      info="<html>
<p>
This record provides the set of sizing and operating parameters for
chiller group models that can be found within
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.ChillerGroups\">
Buildings.Templates.Plants.Chillers.Components.ChillerGroups</a>.
</p>
</html>"));
end ChillerGroup;
