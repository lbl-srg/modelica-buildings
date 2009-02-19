within Buildings.Utilities.Math;
block SmoothMax
  "Once continuously differentiable approximation to the maximum function"
  extends Modelica.Blocks.Interfaces.SI2SO;
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          lineColor={160,160,164},
          textString="smoothMax()"), Text(
          extent={{-74,-44},{68,-114}},
          lineColor={0,0,255},
          textString="dX=%deltaX%")}),        Diagram(graphics),
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <tt>max(.,.)</tt> function.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  Modelica.Blocks.Interfaces.RealOutput y "Connector of Real output signal" 
    annotation (Placement(transformation(extent={{100,-10},{120,10}}, rotation=
            0)));
 parameter Real deltaX "Width of transition interval";
equation
  y = Buildings.Utilities.Math.spliceFunction(u1, u2, u1-u2, deltaX);
end SmoothMax;
