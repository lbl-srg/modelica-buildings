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
  Integer n = size(pressure.V_flow, 1) "Number of data points";
  Real eta[size(pressure.V_flow,1)] "Efficiency series";
  Boolean etaLes "Efficiency series has less than four points";
  Boolean etaMon "Efficiency series is monotonic";

  Real A[n,5] "Design matrix";
  Real b[5] "Parameter vector";
  Real r[3,2] "Roots";
algorithm

  eta:=pressure.V_flow.*pressure.dp./power.P;
  etaLes:=n<4;
  etaMon:=Buildings.Utilities.Math.Functions.isMonotonic(
    x=eta,strict=false);
  assert(not etaLes,"Less than 4 data points were supplied. 
  The point with maximum efficiency will be directly used.
  This may cause the computed values to be highly inaccurate.",
          level = AssertionLevel.warning);
  assert(not etaMon,"The supplied curve is monotonic.
  The point with maximum efficiency will be directly used.
  This may cause the computed values to be highly inaccurate.",
          level = AssertionLevel.warning);

  // Constructs the matrix equation A b = y, where
  //   A is a 5-by-n design matrix,
  //   b is a parameter vector with length 5 (corresponds to a quartic regression),
  //   and y = eta is the response vector with length n.
  for i in 1:5 loop
    A[:,i]:=pressure.V_flow[:].^(i-1);
  end for;
  b:=Modelica.Math.Matrices.leastSquares(A,eta);

  // Solve the derivative for the max eta and corresponding V_flow.
  // This assumes that there will only be one real solution
  //   and it falls within the range of V_flow[:].
  r:=Modelica.Math.Polynomials.roots({b[5]*4,b[4]*3,b[3]*2,b[2]});
  for i in 1:3 loop
    if r[i,2]<=1E-6 and
      r[i,1]>pressure.V_flow[1] and r[i,1]<pressure.V_flow[end] then
      peak.V_flow:=r[i,1];
    end if;
  end for;
  peak.eta:=Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=peak.V_flow,xSup=pressure.V_flow,ySup=eta,ensureMonotonicity=false);
  peak.dp:=Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=peak.V_flow,xSup=pressure.V_flow,ySup=pressure.dp,ensureMonotonicity=false);

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
On the mover curves provided via
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.power</a> and
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a>,
this function finds the peak point with the highest efficiency <i>&eta;</i>
and the corresponding flow rate <i>V&#775;</i> and pressure rise <i>&Delta;p</i>.
The results are output as record to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.peak\">
Buildings.Fluid.Movers.BaseClasses.Euler.peak</a>.
If the input series has only two data points or is monotonic,
the point with the highest efficiency is directly used and the function
issues a warning stating that the computation may be highly inaccurate.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 26, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end getPeak;
