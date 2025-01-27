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
    Dialog(group="Configuration",
      enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpChiWat_default=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "CHW default specific heat capacity"
    annotation (Dialog(group="Configuration",
      enable=false));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon_default=if typ ==
    Buildings.Templates.Components.Types.Chiller.AirCooled then
    Buildings.Utilities.Psychrometrics.Constants.cpAir
    else Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Condenser cooling fluid default specific heat capacity"
    annotation (Dialog(group="Configuration",
      enable=false));
  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi](
    each final min=0)
    "CHW mass flow rate - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi](
    each final min=0,
    start=if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled
      then capChi_nominal *(1 + 1 / Buildings.Templates.Data.Defaults.COPChiWatCoo) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq /(
      Buildings.Templates.Data.Defaults.TConWatRet -
      Buildings.Templates.Data.Defaults.TConWatSup) else fill(0, nChi))
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
  final parameter Modelica.Units.SI.HeatFlowRate QConChi_flow_nominal[nChi](
    each final min=0)=abs(capChi_nominal) .*(fill(1, nChi) ./ COPChi_nominal .+ 1)
    "Condenser heat flow rate - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Real COPChi_nominal[nChi](
    each start=Buildings.Templates.Data.Defaults.COPChiAirCoo,
    each final min=1,
    each final unit="1")
    "Cooling COP - Each chiller"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Chiller.None));
  parameter Modelica.Units.SI.Temperature TChiWatSupChi_nominal[nChi](
    each final min=260)
    "Design (lowest) CHW supply temperature - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatSupChi_max[nChi]=
    fill(Buildings.Templates.Data.Defaults.TChiWatSup_max, nChi)
    "Maximum CHW supply temperature - Each chiller"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConWatEntChi_nominal[nChi](
    each final min=273.15,
    start=fill(Buildings.Templates.Data.Defaults.TConWatSup, nChi))
    "CW supply temperature (condenser entering) - Each chiller"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TOut_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TOutChi)
    "Design OAT"
    annotation (Dialog(group="Nominal condition",
      enable=typ==Buildings.Templates.Components.Types.Chiller.AirCooled));
  final parameter Modelica.Units.SI.Temperature TConEntChi_nominal[nChi]=
    if typ == Buildings.Templates.Components.Types.Chiller.WaterCooled then
      TConWatEntChi_nominal else fill(TOut_nominal, nChi)
    "OAT or CW supply temperature (condenser entering) - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConLvgChi_nominal[nChi](
    each final min=273.15)=TConEntChi_nominal + QConChi_flow_nominal ./
    mConChi_flow_nominal / cpCon_default
    "Condenser leaving fluid temperature (CW or air) - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConLvgChi_min[nChi](
    each final min=273.15)=fill(Buildings.Templates.Data.Defaults.TConLvg_min, nChi)
    "Minimum condenser leaving fluid temperature (CW or air) - Each chiller"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConLvgChi_max[nChi](
    each final min=273.15)=fill(Buildings.Templates.Data.Defaults.TConLvg_max, nChi)
    "Maximum condenser leaving fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits"));
  parameter Real PLRUnlChi_min[nChi](
    final min=PLRChi_min,
    each final max=1)=PLRChi_min
    "Minimum unloading ratio before engaging hot gas bypass if any, otherwise default to PLRChi_min";
  parameter Real PLRChi_min[nChi](
    each final min=0,
    each final max=1)=fill(0.15, nChi)
    "Minimum part load ratio before cycling";
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.Generic perChi[nChi](
    COP_nominal=COPChi_nominal,
    QEva_flow_nominal=-abs(capChi_nominal),
    TConLvg_nominal=TConLvgChi_nominal,
    TConLvgMin=TConLvgChi_min,
    TConLvgMax=TConLvgChi_max,
    TEvaLvg_nominal=TChiWatSupChi_nominal,
    TEvaLvgMin=TChiWatSupChi_nominal,
    TEvaLvgMax=TChiWatSupChi_max,
    PLRMin=PLRChi_min,
    PLRMinUnl=PLRUnlChi_min,
    each PLRMax=1.0,
    each etaMotor=1.0,
    mEva_flow_nominal=mChiWatChi_flow_nominal,
    mCon_flow_nominal=mConChi_flow_nominal)
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
<p>
Within this class, the design values declared at the top-level 
are propagated by default to the performance data record <code>per</code> 
under the assumption that the nominal conditions used for assessing the 
performance data match the design conditions.
However, the nominal, minimum and maximum value of the
condenser cooling fluid temperature are overwritten if the performance data
record is redeclared. 
(This is a limitation that comes from the constraint to make this record class
(type-)compatible with chiller group models using
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIRs</a> 
instead of 
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricEIR\">
Buildings.Fluid.Chillers.ElectricEIR</a>).
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
<a href=\"modelica://Buildings.Templates.Plants.Chillers.Components.Validation.RecordChillerGroup\">
Buildings.Templates.Plants.Chillers.Components.Validation.RecordChillerGroup</a> 
illustrates how the default bindings from this class may be 
overwritten when redeclaring the performance data record,
and how different performance curves may be assigned to each chiller
inside the same group.
</p>
</html>"));
end ChillerGroup;
