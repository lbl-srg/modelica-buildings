within Buildings.Templates.Components.Data;
record HeatPump "Record for heat pump model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.HeatPumpModel typMod
    "Type of heat pump model"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(
    final min=0)
    "HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpHeaWatBoi)
    "Pressure drop at design HW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capHea_nominal
    "Heating capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate PHea_nominal(
    final min=0)
    "Input power in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    each final min=273.15)
    "(Highest) HW supply temperature"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    start=0,
    final min=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=is_rev));
  parameter Modelica.Units.SI.HeatFlowRate capCoo_nominal(
    start=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition", enable=is_rev));
  parameter Modelica.Units.SI.HeatFlowRate PCoo_nominal(
    start=0,
    final min=0)
    "Input power in cooling mode"
    annotation(Dialog(group="Nominal condition", enable=is_rev));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    each final min=253.15)
    "(Lowest) CHW supply temperature"
    annotation(Dialog(group="Nominal condition", enable=is_rev));

  parameter Modelica.Units.SI.MassFlowRate mSouHea_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in heating mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterSource));
  parameter Modelica.Units.SI.MassFlowRate mSouCoo_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in cooling mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterSource));

  replaceable parameter Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic per
    constrainedby Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic(
      hea(
        Q_flow=abs(capHea_nominal),
        P=PHea_nominal,
        mLoa_flow=mHeaWat_flow_nominal,
        mSou_flow=if typ==Buildings.Templates.Components.Types.HeatPump.WaterSource
          then mSouCoo_flow_nominal
          else Buildings.Templates.Data.Defaults.mConAirByCapChi *
            max(abs(capCoo_nominal), abs(capCoo_nominal))),
      coo(
        Q_flow=if is_rev then -abs(capCoo_nominal) else 0,
        P=if is_rev then PCoo_nominal else 0,
        mLoa_flow=mChiWat_flow_nominal,
        mSou_flow=if typ==Buildings.Templates.Components.Types.HeatPump.WaterSource
          then mSouCoo_flow_nominal
          else Buildings.Templates.Data.Defaults.mConAirByCapChi *
            max(abs(capCoo_nominal), abs(capCoo_nominal))))
    "Heat pump performance data"
    annotation (Dialog(
    enable=typMod==Buildings.Templates.Components.Types.HeatPumpModel.EquationFit),
    choicesAllMatching=true);

  annotation (
  defaultComponentName="datHeaPum",
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
end HeatPump;
