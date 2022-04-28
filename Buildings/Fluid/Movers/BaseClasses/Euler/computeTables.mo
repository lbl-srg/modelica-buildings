within Buildings.Fluid.Movers.BaseClasses.Euler;
function computeTables
  "Computes efficiency and power curves with Euler number"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Euler.peak peak
    "Operation point with maximum efficiency";
  input Modelica.Units.SI.PressureDifference dpMax
    "Max pressure rise";
  input Modelica.Units.SI.VolumeFlowRate V_flow_max
    "Max flow rate";
  input Boolean use
    "Flag, if false return zeros";
  output Buildings.Fluid.Movers.BaseClasses.Euler.lookupTables curves
    "Computed efficiency and power curves";

protected
  parameter Integer n = 12 "Dimensions of the look-up tables (12 by 12)";
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_aux[:]=
    linspace(0,V_flow_max,n-1)
    "Auxilliary array for flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_aux[:]=
    linspace(0,dpMax,n-1)
    "Auxilliary array for pressure rise";
  parameter Real small = 1E-5 "A small value used in place of zero";
  Real etaSup[:,:] = zeros(n,n) "2D look-up table for efficiency";
  Real powSup[:,:] = zeros(n,n) "2D look-up table for power";
  Real log_r_Eu "Log10 of ratio Eu/Eu_peak";

algorithm
  if not use then
    curves.eta :=zeros(n, n);
    curves.P :=zeros(n, n);
  //The skip is put within this function itself instead of its caller
  //  to make its declaration more straightforward.
  else

    //[1,1] must be zero for CombiTable2D.
    etaSup[1,1]:=0;
    powSup[1,1]:=0;

    //[1,2:end] are flow rates.
    etaSup[1,2:end]:=V_flow_aux[:];
    powSup[1,2:end]:=V_flow_aux[:];

    //[2:end,1] are pressures.
    etaSup[2:end,1]:=dp_aux[:];
    powSup[2:end,1]:=dp_aux[:];

    //[3:end,3:end] are support points.
    for i in 3:n loop
      for j in 3:n loop
        log_r_Eu:= log10(max(dp_aux[i-1] * peak.V_flow^2,small)
                        /max(peak.dp * V_flow_aux[j-1]^2,small));
        etaSup[i,j]:=peak.eta*
          Buildings.Fluid.Movers.BaseClasses.Euler.correlation(x=log_r_Eu);
        powSup[i,j]:=dp_aux[j-1]*V_flow_aux[i-1]/etaSup[i,j];
      end for;
    end for;

    //[2,2:end] and [2:end,2] represent points where V or dp is zero:
    //  [2,2] is set zero for both P and eta.
    powSup[2,2]:=small;
    etaSup[2,2]:=small;
    for i in 3:n loop
    //  The rest of P are extrapolated and bounded away from negative.
      powSup[2,i]:=max(small, Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=0,
        xSup=powSup[3:end, 1],
        ySup=powSup[3:end, i],
        ensureMonotonicity=true));
      powSup[i,2]:=max(small, Buildings.Utilities.Math.Functions.smoothInterpolation(
        x=0,
        xSup=powSup[1, 3:end],
        ySup=powSup[i, 3:end],
        ensureMonotonicity=true));
    //  The rest of eta are set zero.
      etaSup[2,i]:=small;
      etaSup[i,2]:=small;
    end for;

    curves.eta:=etaSup;
    curves.P:=powSup;
  end if;

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function uses the correlation of Euler number to compute look-up tables of
efficiency <i>&eta;</i> and power <i>P</i> in a grid from 10% to 100% of maximum
flow rate <i>V&#775;</i> and pressure rise <i>&Delta;p</i> at 10% increments.
The computation is not performed below 10% of maximum <i>V&#775;</i> or
<i>&Delta;p</i> to avoid the computed power approaching infinity
as the efficiency approaches zero.
<i>P</i> will be extrapolated when <i>V&#775;</i> or <i>&Delta;p</i> is below 10%,
with the exception that <i>P</i> is set to zero when both are zero.
<i>&eta;</i> is simply set to zero when <i>V&#775;</i> or <i>&Delta;p</i> is zero.
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
