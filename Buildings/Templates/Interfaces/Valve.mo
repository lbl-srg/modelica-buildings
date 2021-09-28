within Buildings.Templates.Interfaces;
partial model Valve
  extends PumpOrValve;

  parameter Types.Valve typ
    "Type of valve"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

end Valve;
