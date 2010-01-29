within Buildings.Utilities.Math;
block Max "Maximum element of a vector"
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
          extent={{-74,90},{70,-70}},
          lineColor={0,0,255},
          textString="max")}));
equation
 y = max(u);
end Max;
