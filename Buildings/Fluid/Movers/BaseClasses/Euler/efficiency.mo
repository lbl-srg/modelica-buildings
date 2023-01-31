within Buildings.Fluid.Movers.BaseClasses.Euler;
function efficiency
  "Computes efficiency with the Euler number correlation"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.Movers.BaseClasses.Euler.peak peak
    "Operation point with maximum efficiency";
  input Modelica.Units.SI.PressureDifference dp
    "Pressure rise";
  input Modelica.Units.SI.VolumeFlowRate V_flow
    "Volumetric flow rate";
  output Modelica.Units.SI.Efficiency eta
    "Efficiency";

protected
  Real log_r_Eu "Log10 of Eu/Eu_peak";
  constant Real small = 1E-5 "A small value used in place of zero";

algorithm
  log_r_Eu:= log10(
               Buildings.Utilities.Math.Functions.smoothMax(
                 x1=dp * peak.V_flow^2,
                 x2=small,
                 deltaX=0.1*small)
              /Buildings.Utilities.Math.Functions.smoothMax(
                 x1=peak.dp * V_flow^2,
                 x2=small,
                 deltaX=0.1*small));
  eta:= peak.eta*
          Buildings.Fluid.Movers.BaseClasses.Euler.correlation(x=log_r_Eu);

          annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function uses the correlation of Euler number to compute
the efficiency <i>&eta;</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 12, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end efficiency;
