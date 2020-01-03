within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions;
function cpe
  "Computes equivalent specific heat of moist air"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Temperature TIn "Inlet temperature";
  input Modelica.SIunits.Temperature TOut "Outlet temperature";

  output Modelica.SIunits.SpecificHeatCapacity cpe "Equivalent specific heat capacity";

protected
  Modelica.SIunits.SpecificEnthalpy hIn "Specific enthalpy";
  Modelica.SIunits.SpecificEnthalpy hOut "Specific enthalpy";
  Modelica.SIunits.TemperatureDifference deltaT=1e-6;

algorithm

  hIn :=
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.h_TDryBulPhi(
    TIn,
    1,
    101325);
  hOut :=
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.h_TDryBulPhi(
    TOut,
    1,
    101325);

  cpe := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = if noEvent(abs(TIn-TOut) > deltaT) then (hIn-hOut)/(TIn-TOut) else 1008,
    x2 = 0,
    deltaX = deltaT);

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
