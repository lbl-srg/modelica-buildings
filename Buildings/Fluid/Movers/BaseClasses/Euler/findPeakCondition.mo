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

  Real eta[:];

algorithm

  eta:=pressure.V_flow.*pressure.dp./power.P;
  m:=Buildings.Utilities.Math.Functions.splineMode(
    x=pressure.V_flow,y=eta);
  peak.V_flow_peak:=m[1];
  peak.eta_peak:=m[2];
  peak.dp_peak:=Buildings.Utilities.Math.Functions.smoothInterpolation(
    x=m[1],xSup=pressure.V_flow,ySup=pressure.dp,ensureMonotonicity=false);

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function finds the flow rate <i>V<sub>flow</sub></i>,
the pressure rise <i>dp</i>, and the efficiency <i>&eta;</i>
on the mover curve provided via 
<code><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.power\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.power</a></code> and 
<code><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure</a></code>.
The results are output as record to 
<code><a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Euler.peakCondition\">
Buildings.Fluid.Movers.BaseClasses.Euler.peakCondition</a></code>.
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
