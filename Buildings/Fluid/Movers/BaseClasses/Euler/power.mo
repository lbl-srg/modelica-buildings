within Buildings.Fluid.Movers.BaseClasses.Euler;
function power
  "Computes power as well as its derivative wrt flow rate using Euler number"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Euler.peak peak "Peak operation point";
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal
    pressure "Pressure curve with both max flow rate and max pressure";
  output Buildings.Fluid.Movers.BaseClasses.Euler.powerWithDerivative power(
    V_flow=zeros(11),P=zeros(11),d=zeros(11))
    "Power and its derivative vs. flow rate";
protected
  Modelica.Units.SI.VolumeFlowRate V_flow[11];
  Modelica.Units.SI.PressureDifference dp[11];
algorithm
  // Construct pressure curve of 10% max flow rate increments
  //   from the given pressure curve
  V_flow:={pressure.V_flow[end]*i for i in linspace(0,1,11)};
  for i in 1:11 loop
    dp[i]:=Buildings.Utilities.Math.Functions.smoothInterpolation(
             x=V_flow[i],
             xSup=pressure.V_flow,
             ySup=pressure.dp,
             ensureMonotonicity=false);
  end for;

  // Compute the power and derivative on non-boundary points
  //   using efficiency estimated by Euler number method
  power.V_flow:=V_flow;
  for i in 2:10 loop
    power.P[i]:=V_flow[i] * dp[i]
                / Buildings.Utilities.Math.Functions.smoothMax(
                    x1 = 1E-5,
                    x2 = Buildings.Fluid.Movers.BaseClasses.Euler.efficiency(
                    peak=peak,
                    dp=dp[i],
                    V_flow=V_flow[i]),
                    deltaX = 1E-6);
  end for;

  // The function splineDerivatives() is by passed when V[2:10] cannot be
  //   guaranteed to be strictly increasing.
  //   This is only for avoiding an error with optimica.
  if V_flow[10] - V_flow[2] > 1E-5 then
    power.d[2:10]:=Buildings.Utilities.Math.Functions.splineDerivatives(
                    x=V_flow[2:10],
                    y=power.P[2:10],
                    ensureMonotonicity=false);
  else
    power.d[2:10]:=zeros(9);
  end if;

  // Use linear extrapolation to find the boundary points
  power.d[1]:=power.d[2];
  power.d[11]:=power.d[10];
  power.P[1]:=power.P[2]-power.d[2]*V_flow[2];
  power.P[11]:=power.P[10]+power.d[10]*(V_flow[11]-V_flow[10]);

annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function outputs power values as well as its derivative versus
volumetric flow rate in the following steps:
</p>
<ul>
<li>
It first interpolates the input pressure curve to find a new pressure curve of
11 points on 10% increments of max flow rate.
It assumes that the last point on the input pressure curve corresponds to
<i>&Delta;p = 0</i>, which is ensured when this function is called by
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
</li>
<li>
It then computes power using efficiency evaluated with the Euler number
from 10% to 90% of max flow rate on 10% increments. 
</li>
<li>
With the incomplete power curve it computes the spline derivatives
wrt flow rate at the same points.
</li>
<li>
Once the derivatives are available, the power values at the two boundary points
are found through linear extrapolation.
</li>
</ul>
<p>
These steps are designed to ensure that power and efficiency computation with
the Euler number is handled correctly near zero flow or zero pressure, where<br/>
<p align=\"center\" style=\"font-style:italic;\">
W&#775;<sub>flo</sub> = 0,<br/>
&eta; = 0,<br/>
P &gt; 0
</p>
<p>
in the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
&eta; = W&#775;<sub>flo</sub> &frasl; P.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 13, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end power;
