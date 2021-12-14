within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions;
function equivalentHeatCapacity
  "Computes equivalent specific heat of moist air"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Temperature TIn "Inlet temperature";
  input Modelica.Units.SI.Temperature TOut "Outlet temperature";

  output Modelica.Units.SI.SpecificHeatCapacity equivalentHeatCapacity
    "Equivalent specific heat capacity";

protected
  constant Modelica.Units.SI.TemperatureDifference deltaT=0.01
    "Small temperature difference, used for regularization";

  Modelica.Units.SI.Temperature TOutEps
    "Outlet temperature, bounded away from TIn";

  Modelica.Units.SI.MassFraction XIn_w
    "Water vapor mass fraction per unit mass total air";
  Modelica.Units.SI.MassFraction XOut_w
    "Water vapor mass fraction per unit mass total air";

  Modelica.Units.SI.SpecificEnthalpy hIn "Inlet specific enthalpy";
  Modelica.Units.SI.SpecificEnthalpy hOut "Outlet specific enthalpy";

algorithm
  TOutEps :=Buildings.Utilities.Math.Functions.smoothMax(
    x1=TOut,
    x2=TIn + deltaT,
    deltaX=deltaT/2);
  XIn_w := Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      p = 101325,
      T = TIn,
      phi=1);
  XOut_w := Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      p = 101325,
      T = TOutEps,
      phi=1);

  hIn := Buildings.Media.Air.specificEnthalpy_pTX(
    p=101325,
    T=TIn,
    X={XIn_w, 1-XIn_w});

  hOut := Buildings.Media.Air.specificEnthalpy_pTX(
    p=101325,
    T=TOutEps,
    X={XOut_w, 1-XOut_w});

  equivalentHeatCapacity := (hIn-hOut)/(TIn-TOutEps);

  annotation (
  smoothOrder=1,
Documentation(info="<html>
<p>
This function computes the equivalent specific heat of moist air 
as the ratio of change in enthalpy relative to the change in 
temperature of the air entering and leaving the tower. 
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2020, by Michael Wetter:<br/>
Revised implementation to make it once continuously differentiable, which avoids a numerical Jacobian
in <a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Validation.MerkelEnergyPlus\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Validation.MerkelEnergyPlus</a>.
</li>
<li>
October 22, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end equivalentHeatCapacity;
