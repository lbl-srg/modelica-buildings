within Buildings.Templates.HeatingPlants.HotWater.Components.Data;
record BoilerGroup "Record for boiler group model"
  extends Modelica.Icons.Record;

  parameter Integer nBoi(final min=0)
    "Number of boilers (as installed)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.BoilerHotWaterModel typMod
    "Type of boiler model (same model for all boilers)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Fluid.Data.Fuels.Generic fue
    "Fuel type"
    annotation (choicesAllMatching = true);
  parameter Modelica.Units.SI.MassFlowRate mHeaWatBoi_flow_nominal[nBoi](
    each final min=0)
    "HW mass flow rate - Each boiler"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatBoi_nominal[nBoi](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpHeaWatBoi)
    "HW pressure drop - Each boiler"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capBoi_nominal[nBoi](
    each final min=0)
    "Heating capacity - Each boiler"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatBoiSup_nominal[nBoi](
    each final min=260)
    "(Highest) HW supply temperature - Each boiler"
    annotation(Dialog(group="Nominal condition"));
  // To avoid missing support for zero-sized record in case of nBoi=0 we use max(nBoi, 1).
  replaceable parameter Buildings.Fluid.Boilers.Data.Generic per[max(nBoi, 1)]
    constrainedby Buildings.Fluid.Boilers.Data.Generic(
      each fue=fue,
      Q_flow_nominal=if nBoi>0 then capBoi_nominal else {0},
      TIn_nominal=if nBoi>0 then THeaWatBoiSup_nominal -
        capBoi_nominal / Buildings.Utilities.Psychrometrics.Constants.cpWatLiq ./ mHeaWatBoi_flow_nominal
        else {Buildings.Templates.Data.Defaults.THeaWatRet},
      m_flow_nominal=if nBoi>0 then mHeaWatBoi_flow_nominal else {0},
      dp_nominal=if nBoi>0 then dpHeaWatBoi_nominal else {0})
    "Boiler performance data - Each boiler"
    annotation (
    Dialog(enable=typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Table),
    choicesAllMatching=true);

  parameter Buildings.Fluid.Types.EfficiencyCurves effCur=
    Buildings.Fluid.Types.EfficiencyCurves.Constant
    "Curve used to compute the efficiency (same curve type for all boilers)"
    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial));
  parameter Real a[nBoi, :] = fill({0.9}, nBoi)
    "Coefficients for efficiency curve - Each boiler"
    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial));
  parameter Modelica.Units.SI.Temperature T_nominal[nBoi]=THeaWatBoiSup_nominal
    "Temperature used to compute nominal efficiency (only used if efficiency curve depends on temperature) - Each boiler"
    annotation (Dialog(enable=
    typMod==Buildings.Templates.Components.Types.BoilerHotWaterModel.Polynomial and
    (effCur==Buildings.Fluid.Types.EfficiencyCurves.QuadraticLinear)));

  annotation (
  defaultComponentName="datBoi",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
boiler group models that can be found within 
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups\">
Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups</a>.
</p>
<p>
Within this class, the design values declared at the top-level 
are propagated by default to the performance data record <code>per</code> 
under the assumption that the nominal conditions used for assessing the 
performance data match the design conditions.
</p>
<p>
Note that, among those propagated parameters, the only meaningful parameter 
is the chiller capacity that should be consistent with the value 
used for performance assessment.
Regarding the nominal value of the condenser cooling fluid, it may 
only yield a warning if an inconsistent value is used.
All other propagated parameters have no impact on the 
computation of the chiller performance and are informative 
only inside the performance data record. 
</p>
<p>
The validation model
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Validation.RecordChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Validation.RecordChillerGroup</a> 
illustrates how the default bindings from this class may be 
overwritten when redeclaring the performance data record,
and how different performance curves may be assigned to each chiller
inside the same group.
</p>
</html>"));
end BoilerGroup;
