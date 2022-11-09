within Buildings.Templates.ChilledWaterPlants.Components.Data;
record CoolerGroup "Record for cooler group model"
  extends Modelica.Icons.Record;

  parameter Integer nCoo(final min=0)
    "Number of cooler units (count one unit for each cooling tower cell)"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Cooler typCoo
    "Type of cooler"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mConWatCoo_flow_nominal[nCoo](
    each final min=0)
    "CW mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatFriCoo_nominal[nCoo](
    each final min=0,
    each start=if typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen then
    Buildings.Templates.Data.Defaults.dpConWatFriTow else
    Buildings.Templates.Data.Defaults.dpConWatTowClo)
    "CW flow-friction losses through tower and piping only (without static head or valve)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatStaCoo_nominal[nCoo](
    each final min=0,
    each start=if typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen then
    Buildings.Templates.Data.Defaults.dpConWatStaTow else
    0)
    "CW static pressure drop"
    annotation (Dialog(group="Nominal condition",
    enable=typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen));
  parameter Modelica.Units.SI.MassFlowRate mAirCoo_flow_nominal[nCoo](
    each final min=0,
    start=mConWatCoo_flow_nominal / Buildings.Templates.Data.Defaults.ratFloWatByAirTow)
    "Air mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TAirDryCooEnt)
    "Entering air drybulb temperature"
    annotation (Dialog(group="Nominal condition", enable=
    typCoo==Buildings.Templates.Components.Types.Cooler.DryCooler));
  parameter Modelica.Units.SI.Temperature TWetBulEnt_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TWetBulTowEnt)
    "Entering air wetbulb temperature"
    annotation (Dialog(group="Nominal condition", enable=
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerOpen or
    typCoo==Buildings.Templates.Components.Types.Cooler.CoolingTowerClosed));
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TConWatRet)
    "CW return temperature (cooler entering)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal(
    final min=273.15,
    start=Buildings.Templates.Data.Defaults.TConWatSup)
    "CW supply temperature (cooler leaving)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Power PFanCoo_nominal[nCoo](
    each final min=0,
    start=Buildings.Templates.Data.Defaults.PFanByFloConWatTow * mConWatCoo_flow_nominal)
    "Fan power"
    annotation (Dialog(group="Nominal condition"));
  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for 
chiller group models that can be found within 
<a href=\"modelica://Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups\">
Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups</a>.
</p>
<p>
Design temperature conditions are common to all units.
Mass flow rates, pressure drops and fan power are specific to each unit.
</p>
</html>"));
end CoolerGroup;
