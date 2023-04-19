within Buildings.Templates.Components.Data;
record BoilerHotWater "Data for hot water boilers"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
    "Type of boiler model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Fluid.Data.Fuels.Generic fue
    "Fuel type"
    annotation (choicesAllMatching = true);

  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(
    final min=0)
    "HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal(
    final min=0)
    "Heating capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpHeaWatBoi)
    "HW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    final min=260)
    "HW supply temperature"
    annotation(Dialog(group="Nominal condition"));

  /* FIXME: The following yields a final overriding message for fue with Dymola
  when redeclaring per. Open ticket at DS.
  */
  replaceable parameter Buildings.Fluid.Boilers.Data.Generic per
    constrainedby Buildings.Fluid.Boilers.Data.Generic(
      fue=fue,
      Q_flow_nominal=cap_nominal,
      TIn_nominal=THeaWatSup_nominal -
        cap_nominal/Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/mHeaWat_flow_nominal,
      m_flow_nominal=mHeaWat_flow_nominal,
      dp_nominal=dpHeaWat_nominal)
    "Boiler performance data"
    annotation (
    Dialog(enable=typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Table),
    choicesAllMatching=true);

  parameter Buildings.Fluid.Types.EfficiencyCurves effCur=
    Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency"
    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial));
  parameter Real a[:] = {0.9}
    "Coefficients for efficiency curve"
    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial));
  parameter Modelica.Units.SI.Temperature T_nominal=THeaWatSup_nominal
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature)"
    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial and
    (effCur==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear)));

    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.ModelBoilerHotWater.Table),
  defaultComponentName="datBoi", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the classes within
<a href=\"modelica://Buildings.Templates.Components.Boilers\">
Buildings.Templates.Components.Boilers</a>.
</p>
</html>"));
end BoilerHotWater;
