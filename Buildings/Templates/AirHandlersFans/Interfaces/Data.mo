within Buildings.Templates.AirHandlersFans.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter String id
    "System tag"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration", enable=false));
  /*
  FIXME: Not strictly compliant with Modelica specification, see
  https://github.com/lbl-srg/linkage.js/wiki/20211220_HVACTemplates#use-of-an-external-parameter-file-1
  */
  parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (
      Evaluate=true,
      Dialog(group="Configuration", enable=false));
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

  parameter Modelica.Units.SI.MassFlowRate mAirSup_flow_nominal=
    if typ==Buildings.Templates.AirHandlersFans.Types.Configuration.ExhaustOnly then 0
    else dat.getReal(varName=id + ".mechanical.mAirSup_flow_nominal.value")
    "Supply air mass flow rate"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.ExhaustOnly));

  parameter Modelica.Units.SI.MassFlowRate mAirRet_flow_nominal=
    if typ==Buildings.Templates.AirHandlersFans.Types.Configuration.SupplyOnly then 0
    else dat.getReal(varName=id + ".mechanical.mAirRet_flow_nominal.value")
    "Return air mass flow rate"
    annotation (Dialog(group="Schedule.Mechanical",
      enable=typ<>Buildings.Templates.AirHandlersFans.Types.Configuration.SupplyOnly));

end Data;
