within Buildings.Utilities.Math;
block SmoothHeaviside
  "Once continuously differentiable approximation to the Heaviside function"
  extends Modelica.Blocks.Interfaces.SISO;
 parameter Real delta "Width of transition interval";
equation
  y = Buildings.Utilities.Math.Functions.smoothHeaviside(x=u, delta=delta);
  annotation (Icon(graphics={
    Line(points={{-84,-74},{84,-74}},  color={192,192,192}),
    Polygon(
      points={{94,-74},{78,-68},{78,-80},{94,-74}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{70,-82},{96,-100}},
      lineColor={160,160,164},
      textString="u"),
    Polygon(
      points={{0,88},{-6,72},{6,72},{0,88}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-35,90},{-6,72}},
      lineColor={160,160,164},
      textString="y"),
    Line(points={{0,-90},{0,84}}, color={192,192,192}),
        Line(
          points={{-82,-74},{-40,-74},{-18,-58},{-6,-34},{0,-10},{14,24},{32,44},
              {46,48},{80,48}},
          color={0,0,0},
          smooth=Smooth.None),
    Line(points={{-6,48},{6,48}},      color={192,192,192}),
    Text(
      extent={{-31,58},{-2,40}},
      lineColor={160,160,164},
          textString="1"),
    Text(
      extent={{-53,-78},{-24,-96}},
      lineColor={160,160,164},
          textString="-delta"),
    Text(
      extent={{31,-76},{60,-94}},
      lineColor={160,160,164},
          textString="delta"),
    Line(points={{46,-78},{46,56}},
                                  color={192,192,192}),
    Line(points={{-40,-80},{-40,-68}},
                                  color={192,192,192})}),
Documentation(info="<html>
<p>
Once Lipschitz continuously differentiable approximation to the <i>Heaviside(.,.)</i> function.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothHeaviside;
