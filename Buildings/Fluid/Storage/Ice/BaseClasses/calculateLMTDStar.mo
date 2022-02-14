within Buildings.Fluid.Storage.Ice.BaseClasses;
function calculateLMTDStar
  "This function calculates the log mean temperature difference for the ice storage unit"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature TIn "Inlet temperature";
  input Modelica.Units.SI.Temperature TOut "Outlet temperature";

  input Modelica.Units.SI.Temperature TFre = 273.15
    "Freezing temperature of water or the latent energy storage material";
  input Modelica.Units.SI.TemperatureDifference dT_nominal = 10
     "Nominal temperature difference";

  output Real lmtd
    "Normalized LMTD";

protected
  constant Modelica.Units.SI.TemperatureDifference dTif_min=0.02
    "Small temperature difference, used for regularization";
  constant Modelica.Units.SI.TemperatureDifference dTof_min=0.01
    "Small temperature difference, used for regularization";
  //Modelica.Units.SI.Temperature TOutEps
  //  "Outlet temperature, bounded away from TIn";
  Real dTio "Inlet to outlet temperature difference";
  Real dTif "Inlet to freezing temperature difference";
  Real dTof "Outlet to frezzing temperature difference";
  Real lndT "log of the temperature difference";
  Real eps = 1E-09 "Small tolerance";
algorithm

  dTio := abs(TIn-TOut);

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
The temperature difference is non-dimensionalized using a nominal temperature difference of 10 Kelvin.
This value must be used when obtaining the curve fit coefficients.
</p>
<p>
The log mean temperature difference is calculated using
</p>
<p align=\"center\" style=\"font-style:italic;\">
    T<sub>lmtd</sub><sup>*</sup> = T<sub>lmtd</sub>/T<sub>nom</sub>
</p>
<p align=\"center\" style=\"font-style:italic;\">
 T<sub>lmtd</sub> = (T<sub>in</sub> - T<sub>out</sub>)/ln((T<sub>in</sub> - T<sub>fre</sub>)/(T<sub>out</sub> - T<sub>fre</sub>))
</p>
<p>
where <i>T<sub>in</sub></i> is the inlet temperature, <i>T<sub>out</sub></i> is the outlet temperature,
<i>T<sub>fre</sub></i> is the freezing temperature
and <i>T<sub>nom</sub></i> is a nominal temperature difference of 10 Kelvin.
</p>
</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end calculateLMTDStar;
