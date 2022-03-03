within Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ZoneEquipment.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
end Data;
