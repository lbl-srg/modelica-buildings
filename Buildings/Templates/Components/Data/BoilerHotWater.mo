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
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal
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

  replaceable parameter Buildings.Fluid.Boilers.Data.Generic per(fue=fue)
    constrainedby Buildings.Fluid.Boilers.Data.Generic(
      Q_flow_nominal=abs(cap_nominal),
      TIn_nominal=THeaWatSup_nominal -
        abs(cap_nominal)/
        Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
        mHeaWat_flow_nominal,
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

annotation (
  defaultComponentName="datBoi", Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
the classes within
<a href=\"modelica://Buildings.Templates.Components.Boilers\">
Buildings.Templates.Components.Boilers</a>.
</p>
<p>
When using the boiler model where the efficiency is based on a lookup table 
(<code>typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table</code>),
the design values declared at the top-level  are propagated by default to the 
performance data record <code>per</code> under the assumption that the nominal 
conditions from the performance data match the design conditions.
Redeclaring the parameter <code>per</code> allows assigning a value to the efficiency curve
without overwriting the default bindings to the design values for the other parameters.
This is the recommended approach.
Alternatively, <i>assigning</i> the parameter <code>per</code> to a local instance of a 
compatible record allows completely overwriting all the parameters inside <code>per</code>.
In this case, the consistency between the design parameters and the values from the
subrecord <code>per</code> is checked and a warning is issued if the design capacity or
HW flow rate (resp. pressure drop) is higher (resp. lower) than the value from the 
performance data record.
This check is performed within
<a href=\"modelica://Buildings.Templates.Components.Interfaces.PartialBoilerHotWater\">
Buildings.Templates.Components.Interfaces.PartialBoilerHotWater</a>.
The validation model
<a href=\"modelica://Buildings.Templates.Components.Validation.BoilerHotWaterRecord\">
Buildings.Templates.Components.Validation.BoilerHotWater</a> 
illustrates the different use cases of this record.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end BoilerHotWater;
