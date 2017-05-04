within Buildings.Utilities.Math.Functions.BaseClasses;
function der_spliceFunction "Derivative of splice function"
  extends Modelica.Icons.Function;
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
    constant Real asin1 = Modelica.Math.asin(1);
algorithm
    scaledX1 := x/deltax;
    if scaledX1 <= -0.99999999999 then
      out := dneg;
    elseif scaledX1 >= 0.9999999999 then
      out := dpos;
    else
      scaledX := scaledX1*asin1;
      dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
      y := (Modelica.Math.tanh(Modelica.Math.tan(scaledX)) + 1)/2;
      out := dpos*y + (1 - y)*dneg;
      out := out + (pos - neg)*dscaledX1*asin1/2/(
        Modelica.Math.cosh(Modelica.Math.tan(scaledX))*Modelica.Math.cos(
        scaledX))^2;
    end if;

annotation (
Documentation(
info="<html>
<p>
Implementation of the first derivative of the function
<a href=\"modelica://Buildings.Utilities.Math.Functions.spliceFunction\">
Buildings.Utilities.Math.Functions.spliceFunction</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Reformulated implementation to avoid unrequired computations.
</li>
<li>
April 7, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_spliceFunction;
