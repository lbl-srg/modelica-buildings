within Buildings.Utilities.Math;
block SmoothLimit
  "Once continuously differentiable approximation to the limit function"
    extends Modelica.Blocks.Interfaces.BlockIcon;
  Modelica.Blocks.Interfaces.RealInput u "Connector of Real input signal"
 annotation (Placement(transformation(extent={{-120,-10},{-100,10}},
                                                                   rotation=
            0)));

  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));
 parameter Real deltaX "Width of transition interval";
 parameter Real upper "Upper limit";
 parameter Real lower "Lower limit";
equation
  y = Buildings.Utilities.Math.Functions.smoothLimit(u, lower, upper, deltaX);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          lineColor={160,160,164},
          textString="smoothLimit()")}),        Diagram(graphics),
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <tt>limit(.,.)</tt> function.
The output is bounded to [0,1].
</p>
</html>",
revisions="<html>
<ul>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end SmoothLimit;
