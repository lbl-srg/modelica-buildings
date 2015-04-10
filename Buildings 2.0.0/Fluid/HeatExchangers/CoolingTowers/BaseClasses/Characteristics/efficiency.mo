within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;
function efficiency "Flow vs. efficiency characteristics for fan or pump"
  extends Modelica.Icons.Function;

  input Characteristics.efficiencyParameters per "Efficiency performance data";
  input Real r_V(unit="1") "Volumetric flow rate divided by nominal flow rate";
  input Real d[:] "Derivatives at support points for spline interpolation";
  output Real eta(min=0, unit="1") "Efficiency";
protected
Integer n = size(per.r_V, 1) "Number of data points";
Integer i "Integer to select data interval";

algorithm
  if n == 1 then
    eta := per.eta[1];
  else
    i :=1;
    for j in 1:n-1 loop
      if r_V > per.r_V[j] then
        i := j;
      end if;
    end for;

  // Extrapolate or interpolate the data
  eta:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x=r_V,
    x1=per.r_V[i],
    x2=per.r_V[i + 1],
    y1=per.eta[i],
    y2=per.eta[i + 1],
    y1d=d[i],
    y2d=d[i+1]);
  end if;

annotation(smoothOrder=1,
Documentation(info="<html>
<p>
This function computes the fan efficiency for given normalized volume flow rate
and performance data. The efficiency is
</p>
<p align=\"center\" style=\"font-style:italic;\">
&eta; = s(r<sub>V</sub>, d),
</p>
<p>
where
<i>&eta;</i> is the efficiency,
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
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), smoothOrder=1);
end efficiency;
