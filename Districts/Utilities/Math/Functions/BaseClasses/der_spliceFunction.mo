within Districts.Utilities.Math.Functions.BaseClasses;
function der_spliceFunction "Derivative of splice function"
    input Real pos;
    input Real neg;
    input Real x;
    input Real deltax=1;
    input Real dpos;
    input Real dneg;
    input Real dx;
    input Real ddeltax=0;
    output Real out;
protected
    Real scaledX;
    Real scaledX1;
    Real dscaledX1;
    Real y;
algorithm
    scaledX1 := x/deltax;
    scaledX := scaledX1*Modelica.Math.asin(1);
    dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
    if scaledX1 <= -0.99999999999 then
      y := 0;
    elseif scaledX1 >= 0.9999999999 then
      y := 1;
    else
      y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
    end if;
    out := dpos*y + (1 - y)*dneg;
    if (abs(scaledX1) < 1) then
      out := out + (pos - neg)*dscaledX1*Modelica.Math.asin(1)/2/(
        Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
        scaledX))^2;
    end if;
annotation (
Documentation(
info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Districts.Utilities.Math.Functions.spliceFunction\">
Districts.Utilities.Math.Functions.spliceFunction</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 7, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_spliceFunction;
