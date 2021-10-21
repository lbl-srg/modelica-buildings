within Buildings.Templates.Components.Dampers;
model Barometric
  extends Buildings.Templates.Interfaces.Damper(
    final typ=Types.Damper.Barometric)
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
  annotation (Diagram(graphics={                               Text(
          extent={{-90,-4},{92,-50}},
          lineColor={238,46,47},
          textString="Todo: To develop, no model available yet in MBL")}));
end Barometric;
