within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions;
function cpe
  "Computes equivalent specific heat of moist air"
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

  annotation (Documentation(info="<html>
<p>
This function computes the equivalent specific heat of moist air 
as the ratio of change in enthalpy relative to the change in 
temperature of the air entering and leaving the tower. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 22, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end cpe;
