within Buildings.Utilities.Math;
block InverseXRegularized
  "Function that approximates 1/x by a twice continuously differentiable function"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real delta(min=0) "Abscissa value below which approximation occurs";
equation
  y = Buildings.Utilities.Math.Functions.inverseXRegularized(x=u, delta=delta);
  annotation (Documentation(info="<html>
<p>Function that approximates <i>y=1 &frasl; x</i> inside the interval <i>-&delta; &le; x &le; &delta;</i>. The approximation is twice continuously differentiable with a bounded derivative on the whole real line. </p>
<p>See the package <code>Examples</code> for the graph. </p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013, by Marcus Fuchs:<br/>
Implementation based on Functions.inverseXRegularized.
</li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-90,36},{90,-36}},
          textColor={160,160,164},
          textString="inverseXRegularized()")}));
end InverseXRegularized;
