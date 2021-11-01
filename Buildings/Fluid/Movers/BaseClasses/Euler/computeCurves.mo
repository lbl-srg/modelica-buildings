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
    V_flow=zeros(10),
    eta=zeros(10),
    P=zeros(10))
    "Computed efficiency and power curves";

protected
  parameter Integer n = 10 "Number of data points";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_aux[:] = linspace(0,V_flow_max,n)
    "Auxilliary variable";
  Modelica.SIunits.PressureDifference dp "Pressure difference";
  Real log_r_Eu "Log10 of ratio Eu/Eu_peak";

algorithm
  if not use then
    return;
  //This function skips itself instead of letting its caller skip it directly
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
/*    log_r_Eu:= if curves.V_flow[i]==0
                 then Modelica.Constants.inf
               elseif dp==0
                 then Modelica.Constants.eps
               else log10((dp * peak.V_flow^2)
                         /(peak.dp * curves.V_flow[i]^2));*/
      log_r_Eu:= log10(Buildings.Utilities.Math.Functions.smoothMax(
                       x1=dp * peak.V_flow^2,x2=1E-5,deltaX=1E-6)
                      /Buildings.Utilities.Math.Functions.smoothMax(
                       x1=peak.dp * curves.V_flow[i]^2,x2=1E-5,deltaX=1E-6));

    curves.eta[i] :=peak.eta*
      Buildings.Fluid.Movers.BaseClasses.Euler.correlation(x=log_r_Eu);
    curves.P[i] :=dp*curves.V_flow[i]/curves.eta[i];
  end for;

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function computes the curves for efficiency <i>&eta;</i> 
and power <i>P</i> against flow rate <i>V&#775;</i>. 
[Documentation pending.]
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
