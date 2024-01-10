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

  // Default fluid properties
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHeaWat_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "HW default specific heat capacity"
    annotation (Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "CHW default specific heat capacity"
    annotation (Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(
    final min=0)
    "HW mass flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWat_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Pressure drop at design HW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capHea_nominal
    "Heating capacity"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature THeaWatSup_nominal(
    final min=273.15)
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
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    final min=253.15)
    "(Lowest) CHW supply temperature"
    annotation(Dialog(group="Nominal condition", enable=is_rev));

  parameter Modelica.Units.SI.MassFlowRate mSouHea_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in heating mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouHea_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop at design heating conditions"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.MassFlowRate mSouCoo_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in cooling mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));

  replaceable parameter Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic per(
    dpHeaLoa_nominal=dpHeaWat_nominal,
    dpHeaSou_nominal=dpSouHea_nominal,
    hea(
      Q_flow=abs(capHea_nominal),
      mLoa_flow=mHeaWat_flow_nominal,
      mSou_flow=if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater
        then mSouHea_flow_nominal
        else Buildings.Templates.Data.Defaults.mConAirByCapChi *
          max(abs(capHea_nominal), abs(capCoo_nominal)),
      TRefLoa=THeaWatSup_nominal-
        abs(capHea_nominal)/cpHeaWat_default/max(1,mHeaWat_flow_nominal)),
    coo(
      Q_flow=if is_rev then -abs(capCoo_nominal) else -1,
      P=0,
      mLoa_flow=mChiWat_flow_nominal,
      mSou_flow=if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater
        then mSouCoo_flow_nominal
        else Buildings.Templates.Data.Defaults.mConAirByCapChi *
          max(abs(capHea_nominal), abs(capCoo_nominal)),
      coeQ={1,0,0,0,0},
      coeP={1,0,0,0,0},
      TRefLoa=TChiWatSup_nominal+
        abs(capCoo_nominal)/cpChiWat_default/max(1,mChiWat_flow_nominal),
      TRefSou=273.15))
    constrainedby Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic
    "Heat pump performance data"
    annotation (Dialog(
    enable=typMod==Buildings.Templates.Components.Types.HeatPumpModel.EquationFit),
    choicesAllMatching=true);
annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="datHeaPum",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
heat pump models that can be found within 
<a href=\"modelica://Buildings.Templates.Components.HeatPumps\">
Buildings.Templates.Components.HeatPumps</a>.
</p>
<h4>Performance data for the equation fit model</h4>
<p>When using 
<code>typMod=Buildings.Templates.Components.Types.HeatPumpModel.EquationFit</code>, 
the design values declared at the top-level 
are propagated by default to the performance data record <code>per</code> 
under the assumption that the reference conditions used for assessing the 
performance data match the design conditions.
This avoids duplicate parameter assignments when manually entering
the performance curve coefficients. 
</p>
<p>
Note that this propagation does not persist when redeclaring or
reassigning the record.
This is because the equation fit method uses reference values that
must match the ones used to compute the performance curve coefficients. 
<p>
<p>
Also note that placeholders values are assigned to the performance curves,
the reference source temperature and the input power in 
cooling mode to avoid assigning these parameters in case of non-reversible
heat pumps.
These values are unrealistic and must be overwritten for reversible heat pumps, which
is always the case when redeclaring or
reassigning the performance record <code>per</code>.
Models that use this record will issue a warning if these placeholders values 
are not overwritten in case of reversible heat pumps.
</p>
<p>
The validation model
<a href=\"modelica://Buildings.Templates.Components.Validation.HeatPumpsRecord\">
Buildings.Templates.Components.Validation.HeatPumpsRecord</a> 
illustrates how the default bindings from this class may be 
overwritten and how specific performance curves may be assigned.
</p>
</html>"));
end HeatPump;
