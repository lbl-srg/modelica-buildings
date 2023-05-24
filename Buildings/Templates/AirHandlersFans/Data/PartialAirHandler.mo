within Buildings.Templates.AirHandlersFans.Data;
record PartialAirHandler "Record for air handler interface class"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.AirHandlersFans.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of return fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Type of relief fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_souChiWat
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_souHeaWat
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.AirHandlersFans.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter String id=""
    "System tag"
    annotation (Dialog(tab="Advanced"));
  parameter String id_souChiWat=""
    "CHW supply system tag"
    annotation (Dialog(tab="Advanced", enable=have_souChiWat));
  parameter String id_souHeaWat=""
    "HHW supply system tag"
    annotation (Dialog(tab="Advanced", enable=have_souHeaWat));

  replaceable parameter Buildings.Templates.AirHandlersFans.Components.Data.PartialController
    ctl(
    final typFanSup=typFanSup,
    final typFanRel=typFanRel,
    final typFanRet=typFanRet,
    final typ=typCtl)
    "Controller"
    annotation (Dialog(group="Controls"));

  parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal
    "Supply air mass flow rate"
    annotation (Dialog(enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.ExhaustOnly));
  parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal
    "Return air mass flow rate"
    annotation (Dialog(enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.SupplyOnly));

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
