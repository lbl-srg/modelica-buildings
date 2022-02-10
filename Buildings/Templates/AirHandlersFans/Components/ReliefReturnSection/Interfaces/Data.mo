within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Dampers.Interfaces.Data damRel(
    final typ=typDamRel)
    "Relief damper"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamRel <> Buildings.Templates.Components.Types.Damper.None));

end Data;
