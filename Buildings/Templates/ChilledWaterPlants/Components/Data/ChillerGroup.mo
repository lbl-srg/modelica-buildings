within Buildings.Templates.ChilledWaterPlants.Components.Data;
record ChillerGroup "Record for chiller group model"
  extends Modelica.Icons.Record;

  parameter Integer nChi(final min=1)
    "Number of chillers (as installed)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal[nChi](
    each final min=0)
    "CHW mass flow rate - Each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal[nChi](
    each final min=0,
    start=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then capChi_nominal*(1+1/Buildings.Templates.Data.Defaults.COPChiWatCoo)/
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq/
      (Buildings.Templates.Data.Defaults.TConWatRet-
      Buildings.Templates.Data.Defaults.TConWatSup)
      else fill(0, nChi))
    "CW mass flow rate - Each chiller"
    annotation(Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.MassFlowRate mConAirChi_flow_nominal[nChi](
    each final min=0,
    start=if typChi==Buildings.Templates.Components.Types.Chiller.AirCooled
      then capChi_nominal*Buildings.Templates.Data.Defaults.mConAirByCapChi
      else fill(0, nChi))
    "Condenser air mass flow rate - Each chiller"
    annotation(Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.AirCooled));
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal[nChi](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpChiWatChi)
    "CHW pressure drop - Each chiller"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConChi_nominal[nChi](
    each final min=0,
    each start=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
    then Buildings.Templates.Data.Defaults.dpConWatChi elseif
    typChi==Buildings.Templates.Components.Types.Chiller.AirCooled then
    Buildings.Templates.Data.Defaults.dpConAirChi else 0)
    "Condenser cooling fluid pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.HeatFlowRate capChi_nominal[nChi](
    each final min=0)
    "Cooling capacity - Each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatChiSup_nominal[nChi](
    each final min=260)
    "(lowest) CHW supply temperature - Each chiller"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TChiWatChiSup_max[nChi]=
    fill(Buildings.Templates.Data.Defaults.TChiWatSup_max, nChi)
    "Maximum CHW supply temperature - Each chiller"
    annotation(Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConWatChiEnt_nominal[nChi](
    each final min=273.15,
    start=fill(Buildings.Templates.Data.Defaults.TConWatSup, nChi))
    "Condenser entering water temperature - Each chiller"
    annotation (Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled));
  parameter Modelica.Units.SI.Temperature TConAirChiEnt_nominal[nChi](
    each final min=273.15,
    start=fill(Buildings.Templates.Data.Defaults.TConAirEnt, nChi))
    "Condenser entering air temperature - Each chiller"
    annotation (Dialog(group="Nominal condition",
    enable=typChi==Buildings.Templates.Components.Types.Chiller.AirCooled));
  parameter Modelica.Units.SI.Temperature TConChiEnt_min[nChi](
    each final min=273.15)=
    fill(Buildings.Templates.Data.Defaults.TConEnt_min, nChi)
    "Minimum condenser entering fluid temperature (CW or air) - Each chiller"
    annotation (Dialog(group="Operating limits"));
  parameter Modelica.Units.SI.Temperature TConChiEnt_max[nChi](
    each final min=273.15)=
    fill(Buildings.Templates.Data.Defaults.TConEnt_max, nChi)
    "Maximum condenser entering fluid temperature (CW or air)"
    annotation (Dialog(group="Operating limits"));
  parameter Real PLRUnlChi_min[nChi](
    final min=PLRChi_min,
    each final max=1)=PLRChi_min
    "Minimum unloading ratio before engaging hot gas bypass if any, otherwise default to PLRChi_min";
  parameter Real PLRChi_min[nChi](
    each final min=0,
    each final max=1)=fill(0.15, nChi)
    "Minimum part load ratio before cycling";
  /* FIXME DS#SR00937490-01
  Propagation of per from ChillerGroup to Chiller is not supported in Dymola.
  */
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[nChi](
    TConEnt_nominal=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then TConWatChiEnt_nominal
      elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled
      then TConAirChiEnt_nominal
      else fill(Buildings.Templates.Data.Defaults.TConAirEnt, nChi),
    TConEntMin=TConChiEnt_min,
    TConEntMax=TConChiEnt_max)
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-1 * capChi_nominal,
      TEvaLvg_nominal=TChiWatChiSup_nominal,
      TEvaLvgMin=TChiWatChiSup_nominal,
      TEvaLvgMax=TChiWatChiSup_max,
      PLRMin=PLRChi_min,
      PLRMinUnl=PLRUnlChi_min,
      mEva_flow_nominal=mChiWatChi_flow_nominal,
      mCon_flow_nominal=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then mConWatChi_flow_nominal
      elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled
      then mConAirChi_flow_nominal
      else fill(0, nChi))
    "Chiller performance data"
    annotation(choicesAllMatching=true);
  annotation (
  defaultComponentName="datChi",
  Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
chiller group models that can be found within 
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups\">
Buildings.Templates.ChilledWaterPlants.Components.ChillerGroups</a>.
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
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.Validation.RecordChillerGroup\">
Buildings.Templates.ChilledWaterPlants.Components.Validation.RecordChillerGroup</a> 
illustrates how the default bindings from this class may be 
overwritten when redeclaring the performance data record,
and how different performance curves may be assigned to each chiller
inside the same group.
</p>
</html>"));
end ChillerGroup;
