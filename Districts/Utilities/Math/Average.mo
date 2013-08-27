within Districts.Utilities.Math;
block Average "Average of a vector"
  extends Modelica.Blocks.Interfaces.MISO;
equation
 y = sum(u)/nin;
annotation (defaultComponentName="ave",
Documentation(info="<html>
<p>
This function outputs the average of the vector.
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
          extent={{-74,46},{66,-58}},
          lineColor={0,0,255},
          textString="ave")}));
end Average;
