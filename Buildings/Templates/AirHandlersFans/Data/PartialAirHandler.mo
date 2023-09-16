within Buildings.Templates.AirHandlersFans.Data;
record PartialAirHandler "Record for air handler interface class"
  extends Modelica.Icons.Record;

  replaceable parameter
    Buildings.Templates.AirHandlersFans.Configuration.PartialAirHandler cfg
    "Configuration parameters"
    annotation (Dialog(enable=false));

  parameter String id=""
    "System tag"
    annotation (Dialog(tab="Advanced"));
  parameter String id_souChiWat=""
    "CHW supply system tag"
    annotation (Dialog(tab="Advanced", enable=cfg.have_souChiWat));
  parameter String id_souHeaWat=""
    "HHW supply system tag"
    annotation (Dialog(tab="Advanced", enable=cfg.have_souHeaWat));

  replaceable parameter Buildings.Templates.AirHandlersFans.Components.Data.PartialController
    ctl(
    final typFanSup=cfg.typFanSup,
    final typFanRel=cfg.typFanRel,
    final typFanRet=cfg.typFanRet,
    final typ=cfg.typCtl)
    "Controller"
    annotation (Dialog(group="Controls"));

  parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal
    "Supply air mass flow rate"
    annotation (Dialog(enable=cfg.typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.ExhaustOnly));
  parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal
    "Return air mass flow rate"
    annotation (Dialog(enable=cfg.typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.SupplyOnly));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for the class
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Interfaces.PartialAirHandler\">
Buildings.Templates.AirHandlersFans.Interfaces.PartialAirHandler</a>.
</p>
<p>
The tab <code>Advanced</code> contains some optional parameters that can be used 
for workflow automation, but are not used for simulation.
</p>
</html>"));
end PartialAirHandler;
