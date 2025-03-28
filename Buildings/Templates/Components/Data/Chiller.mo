within Buildings.Templates.Components.Data;
record Chiller
  "Record for chiller model"
  extends Modelica.Icons.Record;
  parameter Buildings.Templates.Components.Types.Chiller typ
    "Type of chiller"
    annotation (Evaluate=true,
    Dialog(group="Configuration", enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "CHW default specific heat capacity"
    annotation (Dialog(group="Configuration"));
  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)
    "CHW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal(
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      then mChiWat_flow_nominal elseif typ == Buildings.Templates.Components.Types.Chiller.AirCooled
      then Buildings.Templates.Data.Defaults.ratMFloAirByCapChi * abs(cap_nominal)
      else 0,
    final min=0)
    "Condenser cooling fluid (e.g. CW) mass flow rate"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate cap_nominal
    "Cooling capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpChiWat_nominal(
    final min=0,
    start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      then Buildings.Templates.Data.Defaults.dpConWatChi
      elseif typ == Buildings.Templates.Components.Types.Chiller.AirCooled
      then Buildings.Templates.Data.Defaults.dpAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TChiWatSup_nominal(
    final min=260)
    "CHW supply temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TCon_nominal(
    final min=273.15)
    "Condenser entering or leaving fluid temperature (depending on per.use_TConOutForTab)"
    annotation (Dialog(group="Nominal condition"));
  replaceable parameter
    Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic per(
      mCon_flow_nominal=mCon_flow_nominal,
      mEva_flow_nominal=mChiWat_flow_nominal,
      dpCon_nominal=dpCon_nominal,
      dpEva_nominal=dpChiWat_nominal,
      tabLowBou=[
        TCon_nominal - 30, TChiWatSup_nominal - 2;
        TCon_nominal + 10, TChiWatSup_nominal - 2],
      devIde="") constrainedby
    Buildings.Fluid.Chillers.ModularReversible.Data.TableData2DLoadDep.Generic
    "Cooling performance data"
    annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{-8,0},{8,16}})));
  annotation (
    defaultComponentPrefixes="parameter",
    defaultComponentName="datChi",
    Documentation(
      info="<html>
<p>
This record provides the set of sizing and operating parameters for
the classes within
<a href=\"modelica://Buildings.Templates.Components.Chillers\">
Buildings.Templates.Components.Chillers</a>.
It is composed of a set of parameters corresponding to the design
(selection) conditions and a sub-record <code>per</code> providing
the chiller performance data.
The design capacity is used to parameterize the chiller model.
The capacity (and power) computed from the external performance data file
is automatically scaled by the chiller model to match the value provided 
at design conditions.
</p>
<p>
Note that the design value for condenser cooling fluid (e.g., condenser water) 
mass flow rate is only required for water-cooled chillers.
Air-cooled chillers use a default outdoor air flow assignment
since the chiller model doesn't explicitly calculate fan power based on
outdoor air flow and condenser pressure drop. Instead, fan power 
is integrated into the chiller power computed from the performance data.
This is because both US (AHRI Standard 550/590) and European (EN14511) 
chiller performance rating standards incorporate fan power into the rated
total input power.
</p>
</html>"));
end Chiller;
