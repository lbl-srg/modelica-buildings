within Buildings.Templates.BaseClasses;
model PassThroughFluid
  "Direct pass through between inlet and outlet ports"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

equation
  connect(port_a, port_b) annotation (Line(points={{-100,0},{0,0},{0,0},{100,0}},
        color={0,127,255}));
  annotation (
    defaultComponentName="pas",
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end PassThroughFluid;
