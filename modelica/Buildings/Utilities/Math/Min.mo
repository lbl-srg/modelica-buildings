within Buildings.Utilities.Math;
block Min "Minimum element of a vector"
  extends Modelica.Blocks.Interfaces.MISO;
annotation (
Documentation(info="<html>
<p>
Outputs the minimum of the vector.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 3, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={Text(
          extent={{-72,88},{72,-72}},
          lineColor={0,0,255},
          textString="min")}));
equation
 y = min(u);
end Min;
