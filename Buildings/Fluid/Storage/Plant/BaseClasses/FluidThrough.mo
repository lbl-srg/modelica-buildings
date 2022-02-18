within Buildings.Fluid.Storage.Plant.BaseClasses;
model FluidThrough "Fluid passes through"
  extends Interfaces.PartialTwoPort;
equation
  connect(port_a, port_b) annotation (Line(points={{-100,0},{0,0},{0,0},{100,0}},
        color={0,127,255}));
  annotation (
    defaultComponentName="pas",
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Line(
          points={{-100,0},{100,0}},
          color={28,108,200},
          thickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
Fluid directly passes through the two ports.
This is used to replace conditionally-enabled components with a connection.
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end FluidThrough;
