within Districts.Utilities.Math.Functions;
function spliceFunction
    input Real pos "Argument of x > 0";
    input Real neg "Argument of x < 0";
    input Real x "Independent value";
    input Real deltax "Half width of transition interval";
    output Real out "Smoothed value";
protected
    Real scaledX;
    Real scaledX1;
    Real y;
algorithm
    scaledX1 := x/deltax;
    scaledX := scaledX1*Modelica.Math.asin(1);
    if scaledX1 <= -0.999999999 then
      y := 0;
    elseif scaledX1 >= 0.999999999 then
      y := 1;
    else
      y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
    end if;
    out := pos*y + (1 - y)*neg;
    annotation (
smoothOrder=1,
derivative=BaseClasses.der_spliceFunction,
Documentation(info="<html>
<p>
Function to provide a once continuously differentialbe transition between 
to arguments.
</p><p>
The function is adapted from 
<a href=\"Modelica:Modelica.Media.Air.MoistAir.Utilities.spliceFunction\">
Modelica.Media.Air.MoistAir.Utilities.spliceFunction</a> and provided here
for easier accessability to model developers.
</html>", revisions="<html>
<ul>
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
