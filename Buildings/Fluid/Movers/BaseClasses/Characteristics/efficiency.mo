within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function efficiency "Flow vs. efficiency characteristics for fan or pump"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters per
    "Efficiency performance data";
  input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
  input Real d[:] "Derivatives at support points for spline interpolation";
  input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
  input Real delta "Small value for switching implementation around zero rpm";
  output Real eta(unit="1", final quantity="Efficiency") "Efficiency";

protected
  Integer n = size(per.V_flow, 1) "Number of data points";
  Real rat "Ratio of V_flow/r_N";
  Integer i "Integer to select data interval";
algorithm
  if n == 1 then
    eta := per.eta[1];
  else
    // The use of the max function to avoids problems for low speeds
    // and turned off pumps
    rat:=V_flow/
            Buildings.Utilities.Math.Functions.smoothMax(
              x1=r_N,
              x2=0.1,
              deltaX=delta);
    i :=1;
    for j in 1:n-1 loop
       if rat > per.V_flow[j] then
         i := j;
       end if;
    end for;
    // Extrapolate or interpolate the data
    eta:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                x=rat,
                x1=per.V_flow[i],
                x2=per.V_flow[i + 1],
                y1=per.eta[i],
                y2=per.eta[i + 1],
                y1d=d[i],
                y2d=d[i+1]);
  end if;

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function computes the fan or pump efficiency for given normalized volume flow rate
and performance data. The efficiency is
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
December 2, 2016, by Michael Wetter:<br/>
Removed <code>min</code> attribute as otherwise numerical noise can cause
the assertion on the limit to fail.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/606\">#606</a>.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
Corrected documentation as curve uses <i>V&#775;</i>
as an independent variable.
</li>
<li>
September 30, 2014, by Filip Jorissen:<br/>
Changed polynomial to be evaluated at <code>V_flow</code>
instead of <code>r_V</code>.
</li>
<li>
April 19, 2014, by Filip Jorissen:<br/>
Changed polynomial to be evaluated at <code>r_V/r_N</code>
instead of <code>r_V</code> to properly account for the
scaling law. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
<li>
September 28, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end efficiency;
