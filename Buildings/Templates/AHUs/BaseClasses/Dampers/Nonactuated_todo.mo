within Buildings.Templates.AHUs.BaseClasses.Dampers;
model Nonactuated_todo
  extends Templates.AHUs.Interfaces.Damper(
    final typ=Templates.AHUs.Types.Damper.Nonactuated)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Nonactuated_todo;
