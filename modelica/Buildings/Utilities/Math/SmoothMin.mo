block SmoothMin "Assert when condition is violated" 
  extends Modelica.Blocks.Interfaces.SI2SO;
  annotation (Icon(Text(
        extent=[-88,40; 92,-32],
        style(color=9), 
        string="smoothMin()"), Text(
        extent=[-66,-50; 76,-120], 
        style(color=3, rgbcolor={0,0,255}), 
        string="dX=%deltaX%")),               Diagram,
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
    annotation (extent=[100,-10; 120,10]);
 parameter Real deltaX "Width of transition interval";
equation 
  y = Buildings.Utilities.Math.spliceFunction(u1, u2, u2-u1, deltaX);
end SmoothMin;
