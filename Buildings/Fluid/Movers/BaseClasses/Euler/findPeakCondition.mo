within Buildings.Fluid.Movers.BaseClasses.Euler;
function findPeakCondition
  "Find peak condition from power characteristics"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters
    pressure;
  input BaseClasses.Characteristics.powerParameters
    power;
  output Buildings.Fluid.Movers.BaseClasses.Euler.peakCondition
    peak;

protected
  Integer n = size(pressure.V_flow, 1) "Number of data points";
  Real m[2] "Mode as (x,y)";
  Real eta[:] "Efficiency series";
  Boolean etaLes "Efficiency series has less than three points";
  Boolean etaMon "Efficiency series is monotonic";

algorithm

  eta:=pressure.V_flow.*pressure.dp./power.P;
  etaLes:=n<3;
  etaMon:=Buildings.Utilities.Math.Functions.isMonotonic(
    x=eta,strict=false);
  assert(not etaLes,"Less than 3 data points were supplied. 
  The point with maximum efficiency will be directly used.",
          level = AssertionLevel.warning);
  assert(not etaMon,"The supplied curve is monotonic.
  The point with maximum efficiency will be directly used.",
          level = AssertionLevel.warning);
  if etaLes or etaMon then
    m[2]:=max(eta);
    for i in 1:n loop
      if eta[i]==m[2] then m[1]:=i; end if;
    end for;
  else
    m:=Buildings.Utilities.Math.Functions.splineMode(
      x=pressure.V_flow,y=eta);
  end if;
  peak.V_flow_peak:=m[1];
  peak.eta_peak:=m[2];
  peak.dp_peak:=Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=m[1],xSup=pressure.V_flow,ySup=pressure.dp,ensureMonotonicity=false);

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function finds the flow rate <i>V&#775;</i>,
the pressure rise <i>&Delta;p</i>, and the efficiency <i>&eta;</i>
on the mover curve provided via 
<code><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.power</a></code> and 
<code><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a></code>.
The results are output as record to 
<code><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.peakCondition\">
Buildings.Fluid.Movers.BaseClasses.Euler.peakCondition</a></code>.
If the input series has only two data points or is monotonic,
the point with the highest efficiency is directly used 
and the function issues a warning.
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
end findPeakCondition;
