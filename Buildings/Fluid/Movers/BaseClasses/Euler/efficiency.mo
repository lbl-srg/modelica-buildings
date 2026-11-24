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
  input Real V_flow_dp_small(
    final unit="m6.Pa/s2",
    min = Modelica.Constants.eps)
    "Small number for regularisation of dp * V_flow^2";
  output Modelica.Units.SI.Efficiency eta
    "Efficiency";

protected
  Real log_r_Eu "Log10 of Eu/Eu_peak";

algorithm
  log_r_Eu:= log10(
               Buildings.Utilities.Math.Functions.smoothMax(
                 x1=dp * peak.V_flow^2,
                 x2=V_flow_dp_small,
                 deltaX=V_flow_dp_small/2)
              /Buildings.Utilities.Math.Functions.smoothMax(
                 x1=peak.dp * V_flow^2,
                 x2=V_flow_dp_small,
                 deltaX=V_flow_dp_small/2));
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
November 15, 2026, by Michael Wetter:<br/>
Corrected the dimensional scaling and <code>unit=\"m6.Pa/s2\"</code> attribute of regularization threshold <code>V_flow_dp_small</code>.
</li>
<li>
December 12, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end efficiency;
