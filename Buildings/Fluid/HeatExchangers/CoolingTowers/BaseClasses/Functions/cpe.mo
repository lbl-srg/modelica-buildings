within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions;
function cpe "Specific enthalpy for equivalent fluid"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature Tin;
  input Modelica.SIunits.Temperature Tout;

  output Modelica.SIunits.SpecificHeatCapacity cpe;

protected
  Modelica.SIunits.SpecificEnthalpy hin "Specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy hout "Specific enthalpy";
  Modelica.SIunits.TemperatureDifference deltaT=1e-6;

algorithm

  hin :=
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.h_TDryBulPhi(
    Tin,
    1,
    101325);
  hout :=
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.h_TDryBulPhi(
    Tout,
    1,
    101325);

  cpe := Buildings.Utilities.Math.Functions.smoothMax(if noEvent(abs(Tin-Tout)>deltaT) then (hin-hout)/(Tin-Tout) else 1008,0,deltaT);

end cpe;
