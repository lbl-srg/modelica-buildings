within Buildings.Fluid.Movers.BaseClasses.Euler;
function getPeak
  "Find peak condition from power characteristics"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters
    pressure "Pressure vs. flow rate";
  input BaseClasses.Characteristics.powerParameters
    power "Power vs. flow rate";
  output Buildings.Fluid.Movers.BaseClasses.Euler.peak
    peak "Operation point at maximum efficiency";

protected
  parameter Integer nPre = size(pressure.V_flow, 1) "Size of the pressure array";
  parameter Integer nPow = size(power.V_flow, 1) "Size of the power array";
  parameter Integer n = max(nPre, nPow) "Bigger of the two arrays";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_hal=
    if max(pressure.V_flow) < 1E-6
      then 0
    else (pressure.V_flow[nPre]
                -(pressure.V_flow[nPre] - pressure.V_flow[nPre - 1])
                /(pressure.dp[nPre] - pressure.dp[nPre - 1])
                * pressure.dp[nPre])/2
    "Half of max flow, max flow is where dp=0";
  parameter Modelica.Units.SI.PressureDifference dpHalFlo=
    if max(pressure.V_flow) < 1E-6
      then 0
    else Buildings.Utilities.Math.Functions.smoothInterpolation(
               x=V_flow_hal,
               xSup=pressure.V_flow,
               ySup=pressure.dp,
               ensureMonotonicity=true)
    "Pressure rise at half flow";

  Modelica.Units.SI.VolumeFlowRate V_flow[n] "Flow rate";
  Modelica.Units.SI.PressureDifference dp[n] "Pressure rise";
  Modelica.Units.SI.Power P[n] "Power";

  Real eta[n] "Efficiency series";
  Boolean etaLes "Efficiency series has less than four points";
  Boolean etaMon "Efficiency series is monotonic";

  // A b = y
  Real A[n,5] "Design matrix";
  Real b[5] "Parameter vector";
  Real r[3,2] "Roots";
algorithm

  if max(pressure.V_flow) < 1E-6 and
     max(pressure.dp)     < 1E-6 then
    // If there is no pressure curve, no estimation can be made
    peak.V_flow:=0;
    peak.dp:=0;
    peak.eta:=0.7;

  elseif max(power.P) < 1E-6 then
    // If a pressure curve is available, but no power curve,
    //   peak.V_flow = V_flow_max / 2,
    //   peak.dp = dp(V_flow = V_flow_max / 2)
    peak.V_flow:=V_flow_hal;
    peak.dp:=dpHalFlo;
    peak.eta:=0.7;

  else
    // Both a pressure curve and a power curve are available.

    // Create arrays of the equal size
    if nPre == nPow then
      V_flow:= pressure.V_flow;
      dp:= pressure.dp;
      P:= power.P;
    else
      if nPre > nPow then
        V_flow:= pressure.V_flow;
        dp:= pressure.dp;
        for i in 1:n loop
          P[i]:= Buildings.Utilities.Math.Functions.smoothInterpolation(
                   x=V_flow[i],
                   xSup=power.V_flow,
                   ySup=power.P,
                   ensureMonotonicity=false);
        end for;
      else
        V_flow:= power.V_flow;
        P:= power.P;
        for i in 1:n loop
          dp[i]:= Buildings.Utilities.Math.Functions.smoothInterpolation(
                    x=V_flow[i],
                    xSup=pressure.V_flow,
                    ySup=pressure.dp,
                    ensureMonotonicity=true);
        end for;
      end if;
    end if;

    // Compute efficiency array
    eta:=V_flow.*dp./P;
    etaLes:=n<4;
    etaMon:=Buildings.Utilities.Math.Functions.isMonotonic(
      x=eta,
      strict=false);

    if etaLes or etaMon then
    // If less than four data points are provided or the efficiency curve is
    //   monotonic, use the one of two which has the higher efficiency:
    //   1. the interpolated point at half of max flow;
    //   2. the available point with the highest efficiency.
      peak.eta:=Buildings.Utilities.Math.Functions.smoothInterpolation(
               x=V_flow_hal,
               xSup=V_flow,
               ySup=eta,
               ensureMonotonicity=
                 Buildings.Utilities.Math.Functions.isMonotonic(eta, strict=false));
      if peak.eta>max(eta) then
             peak.V_flow:=V_flow_hal;
             peak.dp:=dpHalFlo;
      else
        peak.eta:=max(eta);
        for i in 1:n loop
          if abs(eta[i]-peak.eta)<1E-6 then
            peak.V_flow:=V_flow[i];
            peak.dp:=dp[i];
          end if;
        end for;
      end if;
    else

      // Constructs the matrix equation A b = y for quartic regression, where
      //   A is a 5-by-n design matrix,
      //   b is a parameter vector with length 5,
      //   and y = eta is the response vector with length n.
      A[:,1]:=ones(n); // Avoids 0^0
      for i in 2:5 loop
        A[:,i]:=V_flow[:].^(i-1);
      end for;
      b:=Modelica.Math.Matrices.leastSquares(A,eta);

      // Solve the derivative for the max eta and corresponding V_flow.
      // This assumes that there will only be one real solution
      //   and it falls within the range of V_flow[:].
      r:=Modelica.Math.Polynomials.roots({b[5]*4,b[4]*3,b[3]*2,b[2]});
      for i in 1:3 loop
        if abs(r[i,2])<=1E-6 and
          r[i,1]>V_flow[1] and r[i,1]<V_flow[n] then
          peak.V_flow:=r[i,1];
        end if;
      end for;
      peak.eta:=Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=peak.V_flow,
        xSup=V_flow,
        ySup=eta,
        ensureMonotonicity=false);
      peak.dp:=Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=peak.V_flow,
        xSup=V_flow,
        ySup=dp,
        ensureMonotonicity=false);
    end if;
  end if;

  annotation(Documentation(info="<html>
<p>
This function finds or estimates the peak point
<i>(V&#775;,&Delta;p,&eta;)|&eta;=&eta;<sub>max</sub></i>
from the input power curve <i>P(V&#775;)</i>
and pressure curve <i>&Delta;p(V&#775;)</i>
which may or may not contain non-zero values.
The results are output as an instance of
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.peak\">
Buildings.Fluid.Movers.BaseClasses.Euler.peak</a>.
There are the following branches of computation based on information provided
to the function:
</p>
<ul>
<li>
If <i>&Delta;p(V&#775;)</i> is unavailable, the function simply outputs
<i>(0,0,0.7)</i>.
</li>
<li>
If <i>&Delta;p(V&#775;)</i> is provided but <i>P(V&#775;)</i> is unavailable,
the function provides an estimation of the peak point at half of max flow rate
<i>(V&#775;<sub>max</sub> &frasl; 2,
&Delta;p(V&#775;=V&#775;<sub>max</sub> &frasl; 2),
0.7)</i>.
</li>
<li>
If both <i>&Delta;p(V&#775;)</i> and <i>P(V&#775;)</i> are available,
the function first computes
<i>&eta;(V&#775;)=V&#775;&nbsp;&Delta;p &frasl; P</i>.
<ul>
<li>
If <i>&eta;(V&#775;)</i> has less than four data points or is monotonic,
use one of the two which ever produces a higher <i>&eta;</i>:
<ul>
<li>
The interpolated point at half of max flow rate
<i>(V&#775;<sub>max</sub> &frasl; 2,
&Delta;p(V&#775;=V&#775;<sub>max</sub> &frasl; 2),
&eta;(V&#775;=V&#775;<sub>max</sub> &frasl; 2))</i>
</li>
<li>
The available point with the highest computed efficiency.
</li>
</ul>
</li>
<li>
Otherwise, the function runs a quartic regression on <i>&eta;(V&#775;)</i>
then solves its derivative to find an extremum.
It assumes that there is only one extremum on the open interval
<i>(0,V&#775;<sub>max</sub>)</i>.
</li>
</ul>
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
August 18, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end getPeak;
