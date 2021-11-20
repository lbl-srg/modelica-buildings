within Buildings.Fluid.Movers.BaseClasses.Euler;
function computeTables
  "Computes efficiency and power curves with Euler number"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Euler.peak peak
    "Operation point with maximum efficiency";
  input Modelica.SIunits.PressureDifference dpMax
    "Max pressure rise";
  input Modelica.SIunits.VolumeFlowRate V_flow_max
    "Max flow rate";
  input Boolean use
    "Flag, if false return zeros";
  output Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables curves
    "Computed efficiency and power curves";

protected
  constant Integer n = 11 "Dimensions of the look-up table (n by n)";
  parameter Modelica.SIunits.VolumeFlowRate V_flow_aux[:]=linspace(0,V_flow_max,n)
    "Auxilliary variable for flow rate";
  parameter Modelica.SIunits.PressureDifference dp_aux[:]=linspace(0,dpMax,n)
    "Auxilliary variable for pressure rise";
  Real etaSup[:,:] = zeros(n,n) "2D look-up table for efficiency";
  Real powSup[:,:] = zeros(n,n) "2D look-up table for power";
  Real log_r_Eu "Log10 of ratio Eu/Eu_peak";

algorithm
  if not use then
    return;
  //The skip is put within this function itself instead of its caller
  //  to make its declaration more straightforward.
  end if;

  etaSup[1,1]:=0;
  etaSup[1,2:end]:=V_flow_aux[2:end];
  etaSup[2:end,1]:=dp_aux[2:end];

  powSup[1,1]:=0;
  powSup[1,2:end]:=V_flow_aux[2:end];
  powSup[2:end,1]:=dp_aux[2:end];

  for i in 2:n loop
    for j in 2:n loop
      log_r_Eu:= log10(Buildings.Utilities.Math.Functions.smoothMax(
                       x1=dp_aux[i] * peak.V_flow^2,x2=1E-5,deltaX=1E-6)
                      /Buildings.Utilities.Math.Functions.smoothMax(
                       x1=peak.dp * V_flow_aux[j]^2,x2=1E-5,deltaX=1E-6));
      etaSup[i,j]:=peak.eta*
        Buildings.Fluid.Movers.BaseClasses.Euler.correlation(x=log_r_Eu);
      powSup[i,j]:=dp_aux[j]*V_flow_aux[i]/etaSup[i,j];
    end for;
  end for;

  curves.eta:=etaSup;
  curves.P:=powSup;

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function uses the correlation of Euler number to compute
efficiency <i>&eta;</i> and power <i>P</i> in a grid from 10% to 100% of maximum
flow rate <i>V&#775;</i> and pressure rise <i>&Delta;P</i> at 10% increments.
The computation is not performed below 10% of flow rate or pressure rise
to avoid the computed power approaching infinity as the efficiency approaches zero.
The power and efficiency will be evaluated via extrapolation instead under
such conditions.
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
end computeTables;
