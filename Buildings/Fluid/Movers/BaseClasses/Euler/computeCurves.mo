within Buildings.Fluid.Movers.BaseClasses.Euler;
function computeCurves
  "Computes efficiency and power curves with Euler number"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Euler.peakCondition peak
    "Operation point with maximum efficiency";
  input Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Relationship of dp vs. flow rate";
  input Modelica.SIunits.VolumeFlowRate V_flow_max
    "Max flow rate";
  input Boolean use
    "Flag, if false return zeros";
  output Buildings.Fluid.Movers.BaseClasses.Euler.computedCurves curves(
    V_flow=zeros(11),
    eta=zeros(11),
    P=zeros(11))
    "Computed efficiency and power curves";

protected
  parameter Integer n = 11 "Number of data points";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_aux[:]=
    linspace(0,V_flow_max,n)
    "Auxilliary variable";
  Modelica.SIunits.PressureDifference dp "Pressure difference";
  Real log_r_Eu "Log10 of ratio Eu/Eu_peak";

algorithm
  if not use then
    return;
  //This function skips itself instead of letting its caller skip it
  //  to make the declaration of the output (which has multiple components)
  //  in its caller more straightforward and less verbose.
  end if;

  for i in 1:n loop
    curves.V_flow[i]:=V_flow_aux[i];
    dp:=Buildings.Utilities.Math.Functions.smoothInterpolation(
          x=curves.V_flow[i],
          xSup=pressure.V_flow,
          ySup=pressure.dp,
          ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
            x=pressure.dp,strict=false));
      log_r_Eu:= log10(Buildings.Utilities.Math.Functions.smoothMax(
                       x1=dp * peak.V_flow^2,x2=1E-5,deltaX=1E-6)
                      /Buildings.Utilities.Math.Functions.smoothMax(
                       x1=peak.dp * curves.V_flow[i]^2,x2=1E-5,deltaX=1E-6));

    curves.eta[i] :=peak.eta*
      Buildings.Fluid.Movers.BaseClasses.Euler.correlation(x=log_r_Eu);
    curves.P[i] :=dp*curves.V_flow[i]/curves.eta[i];
  end for;

  curves.P[1]:=Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=0,
                xSup=curves.V_flow[2:(end-1)],
                ySup=curves.P[2:(end-1)],
                ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
                  x=curves.P,strict=false));
  curves.P[end]:=Buildings.Utilities.Math.Functions.smoothInterpolation(
                x=curves.V_flow[end],
                xSup=curves.V_flow[2:(end-1)],
                ySup=curves.P[2:(end-1)],
                ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
                  x=curves.P,strict=false));

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function computes the curves for efficiency <i>&eta;</i> 
and power <i>P</i> against flow rate <i>V&#775;</i>. 
Eleven points are computed using the correlation of Euler number, 
representing 0% to 100% of the maximum flow with increments of 10%. 
Because the computed power may approach infinity 
near zero flow and max flow (zero pressure rise) due to zero efficiency, 
these two points are replaced by extrapolation. 
</p>
</html>",
revisions="<html>
<ul>
<li>
November 1, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end computeCurves;
