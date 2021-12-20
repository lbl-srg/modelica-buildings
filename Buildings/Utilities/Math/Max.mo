within Buildings.Utilities.Math;
block Max "Maximum element of a vector"
  extends Modelica.Blocks.Interfaces.MISO;
equation
 y = max(u);
annotation (defaultComponentName="max",
Documentation(info="<html>
<p>
Outputs the maximum of the vector.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 3, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={Text(
          extent={{-74,90},{70,-70}},
          textColor={0,0,255},
          textString="max")}));
end Max;
