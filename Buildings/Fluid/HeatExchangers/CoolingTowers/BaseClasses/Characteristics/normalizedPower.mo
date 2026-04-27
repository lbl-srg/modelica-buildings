within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;
function normalizedPower "Normalized flow vs. normalized power characteristics for fan"
  extends Modelica.Icons.Function;
  input Characteristics.fan per "Fan relative power consumption";
  input Real r_V(unit="1") "Volumetric flow rate divided by nominal flow rate";
  input Real d[:] "Derivatives at support points for spline interpolation";
  output Modelica.Units.SI.Efficiency r_P(max=1) "Normalized power consumption";
protected
Integer n = size(per.r_V, 1) "Number of data points";
Integer i "Integer to select data interval";

algorithm
  if n == 1 then
    r_P := per.r_V[1];
  else
    // Compute index for power consumption
    i := 1;
    for j in 1:n-1 loop
      if r_V > per.r_V[j] then
        i := j;
      end if;
    end for;

  // Extrapolate or interpolate the data
  r_P:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=r_V,
    x1=per.r_V[i],
    x2=per.r_V[i + 1],
    y1=per.r_P[i],
    y2=per.r_P[i + 1],
    y1d=d[i],
    y2d=d[i+1]);
  end if;

annotation(smoothOrder=1,
Documentation(info="<html>
<p>
This function computes the fan normalized power consumption
for a given normalized volume flow rate
and performance data. The fan normalized power consumption is
</p>
<p align=\"center\" style=\"font-style:italic;\">
r<sub>P</sub> = s(r<sub>V</sub>, d),
</p>
<p>
where
<i>r<sub>P</sub>;</i> is the normalized fan power consumption,
<i>r<sub>V</sub></i> is the normalized volume flow rate, and
<i>d</i> are performance data for fan or pump efficiency.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then
<i>s(&middot;, d)</i> is a monotone decreasing function.
</p>
</html>", revisions="<html>
<ul>
<li>
December, 22, 2019, by Kathryn Hinkelman:<br/>
Corrected cubic hermite spline calculation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1691\">
issue 1691</a>.
</li>
<li>
June 4, 2016, by Michael Wetter:<br/>
Change function from using <code>eta</code> to <code>r_P</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/522\">
issue 522</a>.
</li>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), smoothOrder=1);
end normalizedPower;
