within Buildings.Templates.Plants.Boilers.HotWater.Components.Data;
record BoilerGroup
  "Record for boiler group model"
  extends Modelica.Icons.Record;
  parameter Integer nBoi(final min=0)
    "Number of boilers (as installed)"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
    "Type of boiler model (same model for all boilers)"
    annotation(Evaluate=true,
      Dialog(group="Configuration",
        enable=false));
  parameter Buildings.Fluid.Data.Fuels.Generic fue =
    Buildings.Fluid.Data.Fuels.NaturalGasHigherHeatingValue()
    "Fuel type"
    annotation(choicesAllMatching=true, Dialog(enable=nBoi>0));
  parameter Modelica.Units.SI.MassFlowRate mHeaWatBoi_flow_nominal[nBoi](
    each final min=0, each start=0)
    "HW mass flow rate - Each boiler"
    annotation(Dialog(group="Nominal condition", enable=nBoi>0));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatBoi_nominal[nBoi](
    each final min=0,
    each start=0)
    "HW pressure drop - Each boiler"
    annotation(Dialog(group="Nominal condition", enable=nBoi>0));
  parameter Modelica.Units.SI.PressureDifference dpBalHeaWatBoi_nominal[nBoi](
    each final min=0,
    each start=0) = fill(0, nBoi)
    "HW balancing valve pressure drop at design mass flow rate - Each boiler"
    annotation(Dialog(group="Nominal condition", enable=nBoi>0));
  parameter Modelica.Units.SI.HeatFlowRate capBoi_nominal[nBoi](
    each final min=0, each start=0)
    "Heating capacity - Each boiler"
    annotation(Dialog(group="Nominal condition", enable=nBoi>0));
  parameter Modelica.Units.SI.Temperature THeaWatSupBoi_nominal[nBoi](
    each final min=273.15,
    each start=Buildings.Templates.Data.Defaults.THeaWatSupHig)
    "(Highest) HW supply temperature - Each boiler"
    annotation(Dialog(group="Nominal condition", enable=nBoi>0));
  final parameter Modelica.Units.SI.Temperature THeaWatRetBoi_nominal[nBoi] =
    if nBoi>0 then THeaWatSupBoi_nominal - capBoi_nominal /
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq ./
    mHeaWatBoi_flow_nominal else fill(273.15, 0)
    "HW return temperature - Each boiler"
    annotation(Dialog(group="Nominal condition"));
  // To avoid missing support for zero-sized record in case of nBoi=0 we use max(nBoi, 1).
  replaceable parameter Buildings.Fluid.Boilers.Data.Generic per[max(nBoi, 1)]
    constrainedby Buildings.Fluid.Boilers.Data.Generic(
      each fue=fue,
      Q_flow_nominal=if nBoi > 0 then capBoi_nominal else {0},
      TIn_nominal=if nBoi > 0 then THeaWatRetBoi_nominal
        else {Buildings.Templates.Data.Defaults.THeaWatRetHig},
      m_flow_nominal=if nBoi > 0 then mHeaWatBoi_flow_nominal else {0},
      dp_nominal=if nBoi > 0 then dpHeaWatBoi_nominal else {0})
    "Boiler performance data - Each boiler"
    annotation(Dialog(
      enable=nBoi>0 and typMod ==
        Buildings.Templates.Components.Types.BoilerHotWaterModel.Table),
      choicesAllMatching=true);
  parameter Buildings.Fluid.Types.EfficiencyCurves effCur =
    Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency (same curve type for all boilers)"
    annotation(Dialog(
      enable=nBoi>0 and typMod ==
        Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial));
  parameter Real a[nBoi, :] = fill({0.9}, nBoi)
    "Coefficients for efficiency curve - Each boiler"
    annotation(Dialog(
      enable=nBoi>0 and typMod ==
        Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial));
  parameter Modelica.Units.SI.Temperature T_nominal[nBoi] =
    THeaWatSupBoi_nominal
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature) - Each boiler"
    annotation(Dialog(
      enable=nBoi>0 and typMod ==
        Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial
        and (effCur ==
          Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear)));
annotation(defaultComponentName="datBoi",
  Documentation(
    info="<html>
<p>
  This record provides the set of sizing and operating parameters for boiler
  group models that can be found within
  <a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup\">
    Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup</a>.
</p>
<p>
  See the documentation of
  <a href=\"modelica://Buildings.Templates.Components.Data.BoilerHotWater\">
    Buildings.Templates.Components.Data.BoilerHotWater</a>
  for the recommended approach when using this record with
  <code>typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table</code>.
</p>
</html>"));
end BoilerGroup;
