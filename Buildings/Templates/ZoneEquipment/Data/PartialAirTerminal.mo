within Buildings.Templates.ZoneEquipment.Data;
record PartialAirTerminal "Record for air terminal unit interface class"
  extends Modelica.Icons.Record;

  replaceable parameter
    Buildings.Templates.ZoneEquipment.Configuration.PartialAirTerminal cfg
    "Configuration parameters"
    annotation (Dialog(enable=false));

  parameter String id=""
   "System tag"
    annotation (Dialog(tab="Advanced"));
  parameter String id_souAir=""
    "Air supply system tag"
    annotation (Dialog(tab="Advanced"));
  parameter String id_souChiWat=""
    "CHW supply system tag"
    annotation (Dialog(tab="Advanced", enable=cfg.have_souChiWat));
  parameter String id_souHeaWat=""
    "HHW supply system tag"
    annotation (Dialog(tab="Advanced", enable=cfg.have_souHeaWat));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0,
    start=1)
    "Discharge air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter
    Buildings.Templates.ZoneEquipment.Components.Data.PartialController ctl(
      final typ=cfg.typCtl)
    "Controller"
    annotation (Dialog(group="Controls"));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for the class
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal\">
Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal</a>.
</p>
<p>
The tab <code>Advanced</code> contains some optional parameters that can be used 
for workflow automation, but are not used for simulation.
</p>
</html>"));
end PartialAirTerminal;
