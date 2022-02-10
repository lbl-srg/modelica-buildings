within Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces;
record Data
  extends Modelica.Icons.Record;

  extends Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.Data;

  extends Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.Data;

  parameter Buildings.Templates.Components.Types.Damper typDamRet
    "Return damper type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Dampers.Interfaces.Data damRet(
    final typ=typDamRet)
    "Return damper"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typDamRet <> Buildings.Templates.Components.Types.Damper.None));

end Data;
