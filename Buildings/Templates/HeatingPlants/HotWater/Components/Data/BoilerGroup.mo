within Buildings.Templates.HeatingPlants.HotWater.Components.Data;
record BoilerGroup "Record for boiler group model"
  extends Modelica.Icons.Record;

  parameter Integer nBoi(final min=1)
    "Number of boilers (as installed)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mHeaWatBoi_flow_nominal[nBoi](
    each final min=0)
    "HW mass flow rate - Each boiler"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpHeaWatBoi_nominal[nBoi](
    each final min=0,
    each start=Buildings.Templates.Data.Defaults.dpHeaWatChi)
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
  replaceable parameter Buildings.Fluid.Chillers.Data.ElectricEIR.Generic per[nBoi](
    TConEnt_nominal=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then TConWatChiEnt_nominal
      elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled
      then TConAirChiEnt_nominal
      else fill(Buildings.Templates.Data.Defaults.TConAirEnt, nBoi),
    TConEntMin=TConBoiEnt_min,
    TConEntMax=TConBoiEnt_max)
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller(
      QEva_flow_nominal=-1 * capBoi_nominal,
      TEvaLvg_nominal=THeaWatChiSup_nominal,
      TEvaLvgMin=THeaWatChiSup_nominal,
      TEvaLvgMax=THeaWatChiSup_max,
      PLRMin=PLRBoi_min,
      PLRMinUnl=PLRUnlBoi_min,
      mEva_flow_nominal=mHeaWatBoi_flow_nominal,
      mCon_flow_nominal=if typChi==Buildings.Templates.Components.Types.Chiller.WaterCooled
      then mConWatBoi_flow_nominal
      elseif typChi==Buildings.Templates.Components.Types.Chiller.AirCooled
      then mConAirBoi_flow_nominal
      else fill(0, nBoi))
    "Chiller performance data"
    annotation(choicesAllMatching=true);
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
