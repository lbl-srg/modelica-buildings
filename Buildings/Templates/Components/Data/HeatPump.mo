within Buildings.Templates.Components.Data;
record HeatPump "Record for heat pump model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.HeatPump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean is_rev
    "Set to true for reversible heat pumps, false for heating only"
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
    start=Buildings.Templates.Data.Defaults.TOutHpHeaLow,
    final min=220)
    "OAT or source fluid supply temperature (evaporator entering) in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mSouWwHea_flow_nominal(
    start=mHeaWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in heating mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  parameter Modelica.Units.SI.PressureDifference dpSouWwHea_nominal(
    min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "Source fluid pressure drop in heating mode"
    annotation (Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater));
  final parameter Modelica.Units.SI.MassFlowRate mSouHea_flow_nominal=
    if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
      mSouWwHea_flow_nominal else
      Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(capHea_nominal)
    "Source fluid mass flow rate in heating mode";
  final parameter Modelica.Units.SI.PressureDifference dpSouHea_nominal=
    if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
      dpSouWwHea_nominal else Buildings.Templates.Data.Defaults.dpAirChi
    "Source fluid pressure drop in heating mode";
  parameter Modelica.Units.SI.Temperature TSouCoo_nominal(
    start=Buildings.Templates.Data.Defaults.TOutHpCoo,
    final min=273.15)
    "OAT or source fluid supply temperature (condenser entering) in cooling mode"
    annotation(Dialog(group="Nominal condition",
    enable=is_rev));
  parameter Modelica.Units.SI.MassFlowRate mSouWwCoo_flow_nominal(
    start=mChiWat_flow_nominal,
    final min=0)
    "Source fluid mass flow rate in cooling mode"
    annotation(Dialog(group="Nominal condition",
    enable=typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater and
    is_rev));
  final parameter Modelica.Units.SI.MassFlowRate mSouCoo_flow_nominal=
    if typ==Buildings.Templates.Components.Types.HeatPump.WaterToWater then
      mSouWwCoo_flow_nominal else
      Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(capCoo_nominal)
    "Source fluid mass flow rate in cooling mode";
  final parameter Modelica.Units.SI.PressureDifference dpSouCoo_nominal=
    dpSouHea_nominal * (mSouCoo_flow_nominal/mSouHea_flow_nominal)^2
    "Source fluid pressure drop in cooling mode";
  // Propagation of mass flow rate and pressure drop to the subrecords perHea
  // and perCoo is for reference only. The mass flow rate and pressure drop in
  // the HP component are parameterized by the values from this record,
  // not from those subrecords.
  replaceable parameter
    Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump perHea(
      mCon_flow_nominal=mHeaWat_flow_nominal,
      mEva_flow_nominal=mSouHea_flow_nominal,
      dpCon_nominal=dpHeaWat_nominal,
      dpEva_nominal=dpSouHea_nominal,
      devIde="")
    constrainedby Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2DLoadDep.GenericHeatPump
    "Performance data in heating mode"
    annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-38,0},{-22,16}})));
  replaceable parameter
    Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic perCoo(
      mCon_flow_nominal=mSouCoo_flow_nominal,
      mEva_flow_nominal=mChiWat_flow_nominal,
      dpCon_nominal=dpSouCoo_nominal,
      dpEva_nominal=dpChiWat_nominal,
      fileName="",
      PLRSup={1},
      tabLowBou=[TSouCoo_nominal-30, TChiWatSup_nominal-2;
        TSouCoo_nominal+10, TChiWatSup_nominal-2],
      devIde="",
      use_TConOutForTab=false,
      use_TEvaOutForTab=true)
    constrainedby Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Performance data in cooling mode"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=is_rev),
      Placement(transformation(extent={{22,0},{38,16}})));
  parameter Modelica.Units.SI.Power P_min(final min=0)=0
    "Minimum power when system is enabled with compressor cycled off";
annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="datHp",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for
heat pump models that can be found within
<a href=\"modelica://Buildings.Templates.Components.HeatPumps\">
Buildings.Templates.Components.HeatPumps</a>.
</p>
<h4>Performance data</h4>
<p>
The design capacity is used to parameterize the heat pump model.
The capacity (and power) computed from the external performance data file
will be scaled to match the value provided at design conditions.
</p>
<p>
Also note that placeholders values are assigned to some parameters
of the subrecord <code>perCoo</code> which is used to specify
the performance data in cooling mode.
These values should be overwritten for reversible heat pumps.
This overwriting happens automatically when redeclaring or reassigning 
the performance record <code>perCoo</code>.
</p>
</html>"));
end HeatPump;
