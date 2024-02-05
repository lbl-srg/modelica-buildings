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
  /*
  cpChiWat_default is for internal use only.
  It is the same as cpChiWat_default for reversible HP.
  Non-reversible HP that can be controlled to produce either HW or CHW
  shall be modeled with chiller components (as a chiller/heater).
  */
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    cpHeaWat_default
    "CHW default specific heat capacity";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpSou_default=
    if typ==Buildings.Templates.Components.Types.HeatPump.AirToWater then
       Buildings.Utilities.Psychrometrics.Constants.cpAir else
       Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Source fluid default specific heat capacity"
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
  final parameter Modelica.Units.SI.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal-abs(capHea_nominal)/cpHeaWat_default/mHeaWat_flow_nominal
    "HW return temperature"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    start=0,
    final min=0)
    "CHW mass flow rate"
    annotation(Dialog(group="Nominal condition", enable=is_rev));
  final parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal=
    dpHeaWat_nominal * (mChiWat_flow_nominal/mHeaWat_flow_nominal)^2
    "Pressure drop at design CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.HeatFlowRate capCoo_nominal(
    start=0)
    "Cooling capacity"
    annotation(Dialog(group="Nominal condition", enable=is_rev));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    start=Buildings.Templates.Data.Defaults.TChiWatSup,
    final min=253.15)
    "(Lowest) CHW supply temperature"
    annotation(Dialog(group="Nominal condition", enable=is_rev));
  final parameter Modelica.Units.SI.Temperature TChiWatRet_nominal=
    if is_rev then
    TChiWatSup_nominal+abs(capCoo_nominal)/cpChiWat_default/mChiWat_flow_nominal
    else Buildings.Templates.Data.Defaults.TChiWatRet
    "CHW return temperature"
    annotation(Dialog(group="Nominal condition", enable=is_rev));

  parameter Modelica.Units.SI.Temperature TSouHea_nominal(
    start=Buildings.Templates.Data.Defaults.TOutHeaPumHeaLow,
    final min=220)
    "OAT or source fluid supply temperature (evaporator entering) in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mSouHea_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in heating mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouHea_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop in heating mode"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.Temperature TSouCoo_nominal(
    start=Buildings.Templates.Data.Defaults.TOutHeaPumCoo,
    final min=273.15)
    "OAT or source fluid supply temperature (condenser entering) in cooling mode"
    annotation(Dialog(group="Nominal condition",
    enable=is_rev));
  parameter Modelica.Units.SI.MassFlowRate mSouCoo_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in cooling mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater and
    is_rev));
  final parameter Modelica.Units.SI.PressureDifference dpSouCoo_nominal=
    dpSouHea_nominal * (mSouCoo_flow_nominal/mSouHea_flow_nominal)^2
    "Source fluid pressure drop in cooling mode"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater and
    is_rev));
  replaceable parameter
    Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump hea(
      mCon_flow_nominal=mHeaWat_flow_nominal,
      mEva_flow_nominal=if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
        mSouHea_flow_nominal else
        Buildings.Templates.Data.Defaults.mAirFloByCapChi * abs(capHea_nominal),
      dpCon_nominal=dpHeaWat_nominal,
      dpEva_nominal=if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
        dpSouHea_nominal else Buildings.Templates.Data.Defaults.dpAirChi)
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.GenericHeatPump
    "Performance data in heating mode"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{-38,2},{-22,18}})));

  replaceable parameter Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic coo(
      mCon_flow_nominal=if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
        mSouCoo_flow_nominal else
        Buildings.Templates.Data.Defaults.mAirFloByCapChi * abs(capCoo_nominal),
      mEva_flow_nominal=mChiWat_flow_nominal,
      dpCon_nominal=if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
        dpSouCoo_nominal else Buildings.Templates.Data.Defaults.dpAirChi,
      dpEva_nominal=dpChiWat_nominal)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.Generic
    "Performance data in cooling mode"
    annotation (Dialog(enable=is_rev),
    choicesAllMatching=true,
    Placement(transformation(extent={{22,2},{38,18}})));

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
<a href=\"modelica://Buildings.Templates.Components.HeatPumps.Validation.DataRecord\">
Buildings.Templates.Components.Validation.HeatPumpsRecord</a> 
illustrates how the default bindings from this class may be 
overwritten and how specific performance curves may be assigned.
</p>
</html>"));
end HeatPump;
