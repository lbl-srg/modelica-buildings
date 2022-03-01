within Buildings.Templates.AirHandlersFans.Components.Controls.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.AirHandlersFans.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of relief/return fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

end Data;
