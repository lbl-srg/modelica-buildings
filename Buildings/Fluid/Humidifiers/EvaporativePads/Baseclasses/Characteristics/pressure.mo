within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics;
function pressure "Pressure vs. air velocity"
  extends Modelica.Icons.Function;
  input
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.pressureParameters
    per "Pressure performance data";
  input Real v "Air velocity";
  input Real d[:] "Derivatives at support points for spline interpolation";
  output Real dp(final quantity="Pressure") "Pressure drop";

protected
  Integer n = size(per.v, 1) "Number of data points";
  Integer i "Integer to select data interval";
algorithm
  if n == 1 then
    dp := per.dp[1];
  else
    i :=1;
    for j in 1:n-1 loop
       if v > per.v[j] then
         i := j;
       end if;
    end for;
    // Extrapolate or interpolate the data
    dp:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                x=v,
                x1=per.v[i],
                x2=per.v[i + 1],
                y1=per.dp[i],
                y2=per.dp[i + 1],
                y1d=d[i],
                y2d=d[i+1]);
  end if;

annotation(smoothOrder=1,
  Documentation(info="<html>
<p>
This function computes the air pressure drop through an evaporative pad for a given
air velocity in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
&Delta;p = s(v, d)
</p>
<p>
where <i>&Delta;p</i> is the pressure drop, <i>v</i> is the air velocity, and
<i>d</i> are performance data for an evaporative pad with a specified pad depth.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline. If the data
<i>d</i> define a monotone decreasing sequence, then <i>s(&middot;, d)</i> is a
monotone decreasing function.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 03, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end pressure;
