within IceTank.Functions;
function LMTDStarEP "LMTD star calculator for discharging process"
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
  constant Modelica.SIunits.TemperatureDifference dTif_min=0.2
    "Small temperature difference, used for regularization";
  constant Modelica.SIunits.TemperatureDifference dTof_min=0.1
    "Small temperature difference, used for regularization";
  //Modelica.SIunits.Temperature TOutEps
  //  "Outlet temperature, bounded away from TIn";
  Real dTio "Inlet to outlet temperature difference";
  Real dTif "Inlet to freezing temperature difference";
  Real dTof "Outlet to frezzing temperature difference";

algorithm

  dTio := TIn-TOut;
  dTif := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = abs(TIn-TFre),
    x2 = dTif_min,
    deltaX = deltaT/2);//For discharging, this term is >0
  dTof := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = abs(TOut-TFre),
    x2 = dTof_min,
    deltaX = deltaT/2);
  // this might need to be improved by using more robust implementation
  lmtd := Buildings.Utilities.Math.Functions.smoothMin(
        x1 = (dTio/log(dTif/dTof))/dT_nominal,
        x2 = 1000,
        deltaX = 100);

  annotation (
  smoothOrder=1);
end LMTDStarEP;
