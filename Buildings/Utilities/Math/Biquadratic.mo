within Buildings.Utilities.Math;
block Biquadratic "Biquadratic function"
  extends Modelica.Blocks.Interfaces.SI2SO;
  parameter Real a[6] "Coefficients";
equation
  y =  Buildings.Utilities.Math.Functions.biquadratic(a=a, x1=u1, x2=u2);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          textColor={160,160,164},
          textString="biquadratic()")}),
Documentation(info="<html>
<p>
This block computes
</p>
<p align=\"center\" style=\"font-style:italic;\">
  y =   a<sub>1</sub> + a<sub>2</sub>  x<sub>1</sub>
        + a<sub>3</sub>  x<sub>1</sub><sup>2</sup>
        + a<sub>4</sub>  x<sub>2</sub> + a<sub>5</sub>  x<sub>2</sub><sup>2</sup>
        + a<sub>6</sub>  x<sub>1</sub>  x<sub>2</sub>
</p>
</html>",
revisions="<html>
<ul>
<li>
Sep. 8, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Biquadratic;
