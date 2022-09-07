within Buildings.Templates.Components.HydronicArrangements;
model SingleToMultiple "Single inlet port, multiple outlet ports"
  extends Buildings.Fluid.Interfaces.PartialTwoPortVector;
equation
  for i in 1:nPorts loop
    connect(port_a, ports_b[i])
      annotation (Line(points={{-100,0},{100,0}}, color={0,127,255}));
  end for;
  annotation (
    defaultComponentName="man",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Line( points={{0,0},{-100,0}},
          color={0,0,0},
          thickness=1),
    Line( visible=nPorts <= 1,
          points={{100,0},{0,0}},
          color={0,0,0},
          thickness=1),
        Line(visible=nPorts==2,
          points={{100,50},{0,50},{0,-50},{100,-50}},
          color={0,0,0},
          thickness=1)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleToMultiple;
