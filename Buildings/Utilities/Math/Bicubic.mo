within Buildings.Utilities.Math;
block Bicubic "Bicubic function"
  extends Modelica.Blocks.Interfaces.SI2SO;
 input Real a[10] "Coefficients";
equation
  y =  Buildings.Utilities.Math.Functions.bicubic(a=a, x1=u1, x2=u2);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          textColor={160,160,164},
          textString="bicubic()")}),
Documentation(info="<html>
<p>
This block computes
</p>
<p align=\"center\" style=\"font-style:italic;\">
 y = a<sub>1</sub>
    + a<sub>2</sub>  x<sub>1</sub> + a<sub>3</sub>  x<sub>1</sub><sup>2</sup>
    + a<sub>4</sub>  x<sub>2</sub> + a<sub>5</sub>  x<sub>2</sub><sup>2</sup>
    + a<sub>6</sub>  x<sub>1</sub>  x<sub>2</sub>
    + a<sub>7</sub>  x<sub>1</sub>^3
    + a<sub>8</sub>  x<sub>2</sub>^3
    + a<sub>9</sub>  x<sub>1</sub><sup>2</sup>  x<sub>2</sub>
    + a<sub>1</sub>0  x<sub>1</sub>  x<sub>2</sub><sup>2</sup>
</p>
</html>", revisions="<html>
<ul>
<li>
Sep 17, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bicubic;
