within Buildings.Utilities.Math;
block Average "Average of a vector"
  extends Modelica.Blocks.Interfaces.MISO;
equation
 y = Buildings.Utilities.Math.Functions.average(u=u, nin=nin);
annotation (defaultComponentName="ave",
Documentation(info="<html>
<p>This block outputs the average of the vector. </p>
</html>",
revisions="<html>
<ul>
<li>November 28, 2013, by Marcus Fuchs:<br/>
Changed block to use function average.
</li>
<li>
April 3, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={Text(
          extent={{-74,46},{66,-58}},
          textColor={0,0,255},
          textString="ave")}));
end Average;
