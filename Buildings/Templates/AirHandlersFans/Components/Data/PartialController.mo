within Buildings.Templates.AirHandlersFans.Components.Data;
record PartialController
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.AirHandlersFans.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Type of relief fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of return fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

end PartialController;
