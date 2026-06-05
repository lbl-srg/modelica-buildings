within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics;
function saturationEfficiency "Saturation efficiency vs. air velocity"
  extends Modelica.Icons.Function;
  input
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiencyParameters
    per "Efficiency performance data";
  input Real v "Air velocity";
  input Real d[:] "Derivatives at support points for spline interpolation";
  output Real eta(unit="1", final quantity="Efficiency") "Efficiency";

protected
  Integer n = size(per.v, 1) "Number of data points";
  Integer i "Integer to select data interval";
algorithm
  if n == 1 then
    eta := per.eta[1];
  else
    i :=1;
    for j in 1:n-1 loop
       if v > per.v[j] then
         i := j;
       end if;
    end for;
    // Extrapolate or interpolate the data
    eta:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                x=v,
                x1=per.v[i],
                x2=per.v[i + 1],
                y1=per.eta[i],
                y2=per.eta[i + 1],
                y1d=d[i],
                y2d=d[i+1]);
  end if;

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function computes the saturation efficiency of evaporative pads for given pad depth 
and air velocity. The efficiency is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &eta; = s(V&#775;/r<sub>N</sub>, d),
</p>
<p>
where
<i>&eta;</i> is the efficiency,
<i>r<sub>N</sub></i> is the normalized fan speed,
<i>V&#775;</i> is the volume flow rate, and
<i>d</i> are performance data for fan or pump efficiency.
</p>
<h4>Implementation</h4>
<p>
The function <i>s(&middot;, &middot;)</i> is a cubic hermite spline.
If the data <i>d</i> define a monotone decreasing sequence, then
<i>s(&middot;, d)</i> is a monotone decreasing function.
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
end saturationEfficiency;
