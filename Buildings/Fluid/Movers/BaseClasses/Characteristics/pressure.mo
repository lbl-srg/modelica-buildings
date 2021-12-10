within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function pressure
  "Pump or fan head away from the origin without correction for mover flow resistance"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.VolumeFlowRate V_flow "Volumetric flow rate";
  input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
  input Real d[:] "Derivatives of flow rate vs. pressure at the support points";
  input Modelica.Units.SI.PressureDifference dpMax(displayUnit="Pa")
    "Maximum pressure drop at nominal speed, for regularisation";
  input Modelica.Units.SI.VolumeFlowRate V_flow_max
    "Maximum flow rate at nominal speed, for regularisation";
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal per
    "Pressure performance data";

  output Modelica.Units.SI.PressureDifference dp(displayUnit="Pa")
    "Pressure raise";

protected
  constant Real delta = 0.05
    "Small number for r_N below which we don't care about the affinity laws";
  constant Real delta2 = delta/2 "= delta/2";
  Real r_R(unit="1") "Relative revolution, bounded below by delta";
  Integer i "Integer to select data interval";
  Modelica.Units.SI.VolumeFlowRate rat "Ratio of V_flow/r_R";

algorithm
  // For r_N < delta, we restrict r_N in the term V_flow/r_N.
  // This is done using a cubic spline in a region 0.75*delta < r_N < 1.25*r_N
  // We call this restricted value r_R
  if r_N > delta then
    r_R :=r_N;
  elseif r_N < 0 then
    r_R := delta2;
  else
    // Restrict r_N using a spline
    r_R :=Modelica.Fluid.Utilities.cubicHermite(
      x=r_N,
      x1=0,
      x2=delta,
      y1=delta2,
      y2=delta,
      y1d=0,
      y2d=1);
  end if;

  i :=1;

  rat := V_flow/r_R;
  for j in 1:size(d, 1)-1 loop
    if rat > per.V_flow[j] then
      i := j;
    end if;
  end for;
  // In the assignment below,
  // dp -> 0 as r_N -> 0 quadratically, because rat is bounded
  // by the above regularization
  if r_N>=0 then
    dp:=r_N^2*Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
              x=rat,
              x1=per.V_flow[i],
              x2=per.V_flow[i + 1],
              y1=per.dp[i],
              y2=per.dp[i + 1],
              y1d=d[i],
              y2d=d[i+1]);
  else
    dp:=-r_N^2*(dpMax-dpMax/V_flow_max*V_flow);
  end if;
annotation(smoothOrder=1,
Documentation(info="<html>
<p>
This function computes the fan static
pressure raise as a function of volume flow rate and revolution in the form
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p = r<sub>N</sub><sup>2</sup> &nbsp; s(V&#775;/r<sub>N</sub>, d),
</p>
<p>
where
<i>&Delta;p</i> is the pressure rise,
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
<p>
The function allows <i>r<sub>N</sub></i> to be zero.
</p>
</html>",
  revisions="<html>
<ul>
<li>
September 8, 2016, by Michael Wetter and Filip Jorissen:<br/>
Changed implementation to allow <code>r_N = 0</code>.<br/>
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/458\">#458</a>.
</li>
<li>
September 7, 2016, by Michael Wetter:<br/>
Moved function which was a protected function to make it public, as it
is now called by
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
</li>
</ul>
</html>"));
end pressure;
