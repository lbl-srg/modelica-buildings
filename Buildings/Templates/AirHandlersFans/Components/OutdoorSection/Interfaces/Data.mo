within Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.Components.Dampers.Interfaces.Data damOut(
    final typ=typDamOut)
    "Outdoor air damper"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamOut <> Buildings.Templates.Components.Types.Damper.None));
  parameter Buildings.Templates.Components.Dampers.Interfaces.Data damOutMin(
    final typ=typDamOutMin)
    "Minimum outdoor air damper"
      annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamOutMin <> Buildings.Templates.Components.Types.Damper.None));

end Data;
