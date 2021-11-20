within Buildings.Fluid.Movers.BaseClasses.Euler;
function findPeak
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
  Real m[2] "Mode as (x,y)";
  Real eta[size(pressure.V_flow,1)] "Efficiency series";
  Boolean etaLes "Efficiency series has less than three points";
  Boolean etaMon "Efficiency series is monotonic";

algorithm

  eta:=pressure.V_flow.*pressure.dp./power.P;
  etaLes:=n<3;
  etaMon:=Buildings.Utilities.Math.Functions.isMonotonic(
    x=eta,strict=false);
  assert(not etaLes,"Less than 3 data points were supplied. 
  The point with maximum efficiency will be directly used.
  This may cause the computed values to be highly inaccurate.",
          level = AssertionLevel.warning);
  assert(not etaMon,"The supplied curve is monotonic.
  The point with maximum efficiency will be directly used.
  This may cause the computed values to be highly inaccurate.",
          level = AssertionLevel.warning);
  if etaLes or etaMon then
    m[2]:=max(eta);
    for i in 1:n loop
      if eta[i]==m[2] then
        m[1]:=pressure.V_flow[i];
      end if;
    end for;
  else
    m:=Buildings.Utilities.Math.Functions.splineMode(
      x=pressure.V_flow,y=eta);
  end if;
  peak.V_flow:=m[1];
  peak.eta:=m[2];
  peak.dp:=Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=m[1],xSup=pressure.V_flow,ySup=pressure.dp,ensureMonotonicity=false);

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function finds the flow rate <i>V&#775;</i>,
the pressure rise <i>&Delta;p</i>, and the efficiency <i>&eta;</i>
on the mover curve provided via
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.power</a> and
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a>.
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
October 20, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end findPeak;
