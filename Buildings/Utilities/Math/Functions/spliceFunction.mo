within Buildings.Utilities.Math.Functions;
function spliceFunction
  extends Modelica.Icons.Function;
    input Real pos "Argument of x > 0";
    input Real neg "Argument of x < 0";
    input Real x "Independent value";
    input Real deltax "Half width of transition interval";
    output Real out "Smoothed value";
protected
    constant Real lim = 0.9999999999;
    Real scaledX1;
    Real y;
    constant Real asin1 = Modelica.Math.asin(1);
algorithm
    scaledX1 := x/deltax;
    if scaledX1 <= -lim then
      out := neg;
    elseif scaledX1 >= lim then
      out := pos;
    else
      y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX1*asin1)) + 1)/2;
      out := pos*y + (1 - y)*neg;
    end if;

    annotation (
smoothOrder=3,
derivative=BaseClasses.der_spliceFunction,
Documentation(info="<html>
<p>
Function to provide a once continuously differentiable transition between
to arguments.
</p><p>
The function is adapted from
<a href=\"modelica://Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">
Modelica.Media.Air.MoistAir.Utilities.spliceFunction</a> and provided here
for easier accessability to model developers.
</p>
</html>", revisions="<html>
<ul>
<li>
September 27, 2022, by Matthis Thorade:<br/>
Changed limits.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1640\">IBPSA, issue #1640</a>.
</li>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
May 11, 2010, by Michael Wetter:<br/>
Removed default value for transition interval as this is problem dependent.
</li>
<li>
May 20, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end spliceFunction;
