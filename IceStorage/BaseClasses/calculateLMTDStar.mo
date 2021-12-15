within IceStorage.BaseClasses;
function calculateLMTDStar
  "This function calculates the log mean temperature difference for the ice storage unit"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature TIn "Inlet temperature";
  input Modelica.SIunits.Temperature TOut "Outlet temperature";

  input Modelica.SIunits.Temperature TFre = 273.15
    "Freezing temperature of water or the latent energy storage material";
  input Modelica.SIunits.TemperatureDifference dT_nominal = 10
     "Nominal temperature difference";

  output Real lmtd
    "Normalized LMTD";

protected
  constant Modelica.SIunits.TemperatureDifference dTif_min=0.2
    "Small temperature difference, used for regularization";
  constant Modelica.SIunits.TemperatureDifference dTof_min=0.1
    "Small temperature difference, used for regularization";
  //Modelica.SIunits.Temperature TOutEps
  //  "Outlet temperature, bounded away from TIn";
  Real dTio "Inlet to outlet temperature difference";
  Real dTif "Inlet to freezing temperature difference";
  Real dTof "Outlet to frezzing temperature difference";
  Real lndT "log of the temperature difference";
  Real eps = 1E-09 "Small tolerance";
algorithm

  dTio := TIn-TOut;

  dTif := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = abs(TIn-TFre),
    x2 = dTif_min,
    deltaX = eps);
  dTof := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = abs(TOut-TFre),
    x2 = dTof_min,
    deltaX = eps);

//  lmtd := Buildings.Utilities.Math.Functions.smoothMax(
//    x1 = 0,
//    x2 = (dTio/log(dTif/dTof))/dT_nominal,
//    deltaX = 1E-09);
  lmtd := (dTio/max(eps, log(dTif/dTof)))/dT_nominal;

  annotation (
  smoothOrder=1, Documentation(info="<html>
<p>
This subroutine calculates the log mean temperature difference for the detailed ice storage unit. 
The temperature difference is non-dimensionalized using a nominal temperature difference of 10C. 
This value must be used when obtaining the curve fit coefficients.
</p>

<p>
The following equations are employed in a robust way for numerically calculating the log mean temperature difference:
</p>

<p align=\"center\" style=\"font-style:italic;\">
    T<sub>lmtd</sub><sup>*</sup> = T<sub>lmtd</sub>/T<sub>nom</sub>
</p>

<p align=\"center\" style=\"font-style:italic;\">
 T<sub>lmtd</sub> = (T<sub>in</sub> - T<sub>out</sub>)/ln((T<sub>in</sub> - T<sub>fre</sub>)/(T<sub>out</sub> - T<sub>fre</sub>))
</p>

where <code>T<sub>in</sub></code> is the inlet temperature, <code>T<sub>out</sub></code> is the outlet temperature, 
<code>T<sub>fre</sub></code> is the freezing temperature 
and <code>T<sub>nom</sub></code> is a nominal temperature difference of 10C.

</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end calculateLMTDStar;
