within Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses;
model PassThroughFluid "Direct fluid pass-through"
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
          thickness=1)}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a model of a direct fluid pass-through used for
templating purposes.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PassThroughFluid;
