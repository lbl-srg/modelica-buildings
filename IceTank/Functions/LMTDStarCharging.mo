within IceTank.Functions;
function LMTDStarCharging "LMTD star calculator for charging process"
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
  Modelica.SIunits.Temperature TOutEps
    "Outlet temperature, bounded away from TIn";
  Real dTio "Inlet to outlet temperature difference";
  Real dTif "Inlet to freezing temperature difference";
  Real dTof "Outlet to frezzing temperature difference";

algorithm
  TOutEps :=Buildings.Utilities.Math.Functions.smoothMax(
    x1=TOut,
    x2=TIn + deltaT,
    deltaX=deltaT/2);

  dTio := TIn-TOut;
  dTif := TIn-TFre;//For discharging, this term is >0
  dTof := TOutEps-TFre;

  lmtd := (dTio/log(dTif/dTof))/
    dT_nominal;

  annotation (
  smoothOrder=1);
end LMTDStarCharging;
