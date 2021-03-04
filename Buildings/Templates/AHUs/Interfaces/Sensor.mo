within Buildings.Templates.AHUs.Interfaces;
partial model Sensor
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Sensor typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sensor;
