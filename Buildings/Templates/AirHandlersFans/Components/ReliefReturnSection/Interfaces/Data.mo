within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Type of relief fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of return fan"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Fans.Interfaces.Data fanRel(
    final typ=typFanRel)
    "Relief fan"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=typFanRel <> Buildings.Templates.Components.Types.Fan.None));
  parameter Buildings.Templates.Components.Fans.Interfaces.Data fanRet(
    final typ=typFanRet)
    "Return fan"
    annotation(Dialog(group="Schedule.Mechanical",
      enable=typFanRet <> Buildings.Templates.Components.Types.Fan.None));

  parameter Buildings.Templates.Components.Dampers.Interfaces.Data damRel(
    final typ=typDamRel)
    "Relief damper"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamRel <> Buildings.Templates.Components.Types.Damper.None));

end Data;
