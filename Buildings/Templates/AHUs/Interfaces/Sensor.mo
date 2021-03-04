within Buildings.Templates.AHUs.Interfaces;
partial model Sensor
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Types.Sensor typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Types.Branch bra
    "Branch where the equipment is installed"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y if typ<>Types.Sensor.None
    "Measured quantity"
    annotation (Placement(transformation(
        origin={0,120},
        extent={{-20,-20},{20,20}},
        rotation=90), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,120})));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Sensor;
