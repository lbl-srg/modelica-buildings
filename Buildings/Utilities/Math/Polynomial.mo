within Buildings.Utilities.Math;
block Polynomial "Polynominal function"
  extends Modelica.Blocks.Interfaces.SISO;
 parameter Real a[:] "Coefficients";
equation
  y = Buildings.Utilities.Math.Functions.polynomial(a=a, x=u);
  annotation (Documentation(info="<html>
<p>This block computes a polynomial of arbitrary order. The polynomial has the form </p>
<p align=\"center\"><i>y = a1 + a2 x + a3 x2 + ... </i></p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2021, by Michael Wetter:<br/>
Renamed class to correct typo in class name.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1524\">IBPSA, #1524</a>.
</li>
<li>
November 28, 2013, by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,38},{90,-34}},
          textColor={160,160,164},
          textString="polynominal()")}));
end Polynomial;
