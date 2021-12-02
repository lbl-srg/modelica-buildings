within Buildings.Utilities.Math;
block QuadraticLinear
  "Function that is quadratic in first argument and linear in second argument"
  extends Modelica.Blocks.Interfaces.SI2SO;
  parameter Real a[6] "Coefficients";
equation
  y = Buildings.Utilities.Math.Functions.quadraticLinear(a=a, x1=u1, x2=u2);
  annotation (Documentation(info="<html>
<p>Block for function quadraticLinear, which computes </p>
<p align=\"center\"><i>y = a1 + a2 x1 + a3 x12 + (a4 + a5 x1 + a6 x12) x2 </i></p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013 by Marcus Fuchs:<br/>
Implementation based on Functions.quadraticLinear.
</li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-86,38},{94,-34}},
          textColor={160,160,164},
          textString="quadraticLinear()")}));
end QuadraticLinear;
