within Buildings.Fluid.HeatExchangers.BaseClasses;
model PipeManifoldNoResistance "Manifold for heat exchanger register"
  extends PartialPipeManifold;
 parameter Boolean connectAllPressures=true;
  Modelica.Fluid.Fittings.MultiPort mulPor(
      redeclare package Medium = Medium,
      final nPorts_b=nPipPar)
    annotation (Placement(transformation(extent={{0,-10},{8,10}})));
equation
  connect(port_a, mulPor.port_a) annotation (Line(
      points={{-100,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mulPor.ports_b, port_b) annotation (Line(
      points={{8,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
annotation (Documentation(info="<html>
<p>
Pipe manifold without flow resistance.
</p>
<p>
This model connects the flows between the ports without
modeling flow friction. The model is used in conjunction with
a manifold which contains pressure drop elements and that
is added to the other side of the heat exchanger registers.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PipeManifoldNoResistance;
