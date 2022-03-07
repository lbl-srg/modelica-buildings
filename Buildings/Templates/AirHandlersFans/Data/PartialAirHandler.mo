within Buildings.Templates.AirHandlersFans.Data;
record PartialAirHandler
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
  parameter Boolean have_souCoiCoo
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_souCoiHeaPre
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_souCoiHeaReh
    "Set to true if reheat coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter String id_souCoiCoo=""
    "Chilled water supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souCoiCoo));
  parameter String id_souCoiHea=""
    "Hot water supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=have_souCoiHeaPre or have_souCoiHeaReh));

  parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal
    "Supply air mass flow rate"
    annotation (Dialog(group="Mechanical",
      enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.ExhaustOnly));

  parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal
    "Return air mass flow rate"
    annotation (Dialog(group="Mechanical",
      enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.SupplyOnly));

end PartialAirHandler;
