within IceTank.Functions;
function LMTDStarDischarging "LMTD star calculator for discharging process"
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
  constant Modelica.SIunits.TemperatureDifference deltaT=0.001
    "Small temperature difference, used for regularization";
  constant Modelica.SIunits.TemperatureDifference dTif_min=1
    "Small temperature difference, used for regularization";
  constant Modelica.SIunits.TemperatureDifference dTof_min=0.5
    "Small temperature difference, used for regularization";
  //Modelica.SIunits.Temperature TOutEps
  //  "Outlet temperature, bounded away from TIn";
  Real dTio "Inlet to outlet temperature difference";
  Real dTif "Inlet to freezing temperature difference";
  Real dTof "Outlet to frezzing temperature difference";

algorithm

  dTio := abs(TIn-TOut);
  dTif := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = abs(TIn-TFre),
    x2 = dTif_min,
    deltaX = deltaT/2);//For discharging, this term is >0
  dTof := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = abs(TOut-TFre),
    x2 = dTof_min,
    deltaX = deltaT/2);

  lmtd := (dTio/log(dTif/dTof))/dT_nominal;

  annotation (
  smoothOrder=1);
end LMTDStarDischarging;
