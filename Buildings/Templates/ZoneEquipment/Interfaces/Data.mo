within Buildings.Templates.ZoneEquipment.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ZoneEquipment.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Boolean have_souCoiHea
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ZoneEquipment.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=1
    "Discharge air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

end Data;
