within Buildings.Templates.ZoneEquipment.Data;
record PartialAirTerminal "Record for air terminal unit interface class"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ZoneEquipment.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Boolean have_souChiWat
    "Set to true if system uses CHW"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_souHeaWat
    "Set to true if system uses HHW"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Buildings.Templates.ZoneEquipment.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter String id
   "System tag"
    annotation (Dialog(group="Configuration"));
  parameter String id_souAir=""
    "Air supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter String id_souChiWat=""
    "CHW supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souChiWat));
  parameter String id_souHeaWat=""
    "HHW supply system tag"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=have_souHeaWat));

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
