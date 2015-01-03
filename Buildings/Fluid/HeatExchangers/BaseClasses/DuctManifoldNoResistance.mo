within Buildings.Fluid.HeatExchangers.BaseClasses;
model DuctManifoldNoResistance "Duct manifold without resistance"
  extends PartialDuctManifold;

equation
  for i in 1:nPipPar loop
    for j in 1:nPipSeg loop
    connect(port_a, port_b[i, j]) annotation (Line(points={{-100,5.55112e-016},
              {-3,5.55112e-016},{-3,5.55112e-016},{100,5.55112e-016}}, color={0,
              127,255}));
    end for;
  end for;
  annotation (Documentation(info="<html>
<p>
Duct manifold without flow resistance.
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
end DuctManifoldNoResistance;
