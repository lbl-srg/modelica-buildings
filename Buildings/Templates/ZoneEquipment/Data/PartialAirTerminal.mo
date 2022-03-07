within Buildings.Templates.ZoneEquipment.Data;
record PartialAirTerminal
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

  parameter String id
   "System tag"
    annotation (Dialog(group="Configuration"));
  parameter String id_souAir=""
    "Air supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter String id_souCoiHea=""
    "Hot water supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souCoiHea));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal(
    final min=0,
    start=1)
    "Discharge air mass flow rate"
    annotation (Dialog(group="Nominal condition"));

  replaceable parameter Buildings.Templates.ZoneEquipment.Components.Data.PartialController
    ctl(final typ=typCtl)
    "Controller"
    annotation (Dialog(group="Controls"));

end PartialAirTerminal;
