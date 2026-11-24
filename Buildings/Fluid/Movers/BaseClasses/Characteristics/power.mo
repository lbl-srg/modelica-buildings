within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function power "Flow vs. electrical power characteristics for fan or pump"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters per
    "Pressure performance data";
  input Modelica.Units.SI.VolumeFlowRate V_flow "Volumetric flow rate";
  input Real r_N(unit="1") "Relative speed";
  input Real d[:] "Derivatives at support points for spline interpolation";
  input Real delta "Small value for switching implementation around zero speed";
  output Modelica.Units.SI.Power P "Power consumption";

protected
   Integer n=size(per.V_flow, 1) "Dimension of data vector";

  Modelica.Units.SI.VolumeFlowRate rat "Ratio of V_flow/r_N";
   Integer i "Integer to select data interval";
  Modelica.Units.SI.Power P_rN1 "Interpolated nominal power at r_N = 1";
  Modelica.Units.SI.Power deltaP "Small value for non-negative power regularization";

algorithm
  if r_N <= 0 then
    P := 0;
  elseif n == 1 then
    P := r_N^3*per.P[1];
  else
    i :=1;
    // The use of the max function to avoids problems for low speeds
    // and turned off pumps
    rat:=V_flow/
            Buildings.Utilities.Math.Functions.smoothMax(
              x1=r_N,
              x2=0.1,
              deltaX=delta);
    for j in 1:n-1 loop
       if rat > per.V_flow[j] then
         i := j;
       end if;
    end for;
    // Extrapolate or interpolate the data with C1 non-negative lower bound
    deltaP := max(1E-6, 1E-4*max(per.P));
    P_rN1 := Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                x=rat,
                x1=per.V_flow[i],
                x2=per.V_flow[i + 1],
                y1=per.P[i],
                y2=per.P[i + 1],
                y1d=d[i],
                y2d=d[i+1]);
    P := r_N^3 * (if P_rN1 >= deltaP then P_rN1
                  elseif P_rN1 <= -deltaP then 0
                  else (P_rN1 + deltaP)^2 / (4*deltaP));
  end if;
  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function computes the fan power consumption for given volume flow rate,
speed and performance data. The power consumption is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  P = r<sub>N</sub><sup>3</sup> &nbsp; s(V&#775;/r<sub>N</sub>, d),
</p>
<p>
where
<i>P</i> is the power consumption,
<i>r<sub>N</sub></i> is the normalized fan speed,
<i>V&#775;</i> is the volume flow rate and
<i>d</i> are performance data for fan or pump power consumption at <i>r<sub>N</sub>=1</i>.
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
November 15, 2026, by Michael Wetter:<br/>
Used non-negative speed scaling and clamped extrapolated power so mover shaft/electrical power <code>P</code> cannot become negative.
</li>
<li>
February 26, 2014, by Filip Jorissen:<br/>
Changed polynomial to be evaluated at <code>V_flow/r_N</code>
instead of <code>V_flow</code> to properly account for the
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
end power;
