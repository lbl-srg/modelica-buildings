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
  constant Real lim = 0.9999999999 "Limit in criterion for smoothing range";
  Real scaledX1 "x scaled to -1 ... 1 interval";
  Real scaledXp "x scaled to -pi/2 ... pi/2 interval";
  Real scaledXt "x scaled to -inf ... inf interval";
  Real dscaledX1;
  Real y;
algorithm
  scaledX1 := x/deltax;
  if scaledX1 <= -lim then
    y := 0.0;
  elseif scaledX1 >= lim then
    y := 1.0;
  else
    scaledXp := scaledX1*0.5*Modelica.Constants.pi;
    scaledXt := Modelica.Math.tan(scaledXp);
    y := 0.5*Modelica.Math.tanh(scaledXt) + 0.5;
  end if;
  out := dpos*y + (1 - y)*dneg;

  if (abs(scaledX1) < lim) then
    dscaledX1 := (dx - scaledX1*ddeltax)/deltax;
    out := out + (pos - neg)*dscaledX1*0.25*Modelica.Constants.pi*(1 - Modelica.Math.tanh(scaledXt)^2)*(scaledXt^2 + 1);
  end if;

annotation (
  smoothOrder=2,
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
September 27, 2022, by Matthis Thorade:<br/>
Changed limits.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1640\">IBPSA, issue #1640</a>.
</li>
<li>
October 13, 2021, by Michael Wetter:<br/>
Changed implementation to not use <code>cosh</code> which overflows around <i>800</i>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1531\">IBPSA, issue 1531</a>.
</li>
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
