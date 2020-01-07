within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.Validation;
model EquivalentHeatCapacity
  "Validation model for the equivalent heat capacity calculation"
  extends Modelica.Icons.Example;

  Real deltaT
    "Change in temperature of the air entering and leaving the cooling tower";

  Modelica.SIunits.Temperature TIn5 = 278.15
     "5degC inlet temperature";
  Modelica.SIunits.Temperature TIn10 = 283.15
     "10degC inlet temperature";
  Modelica.SIunits.Temperature TIn15 = 288.15
     "15degC inlet temperature";
  Modelica.SIunits.Temperature TIn20 = 293.15
     "20degC inlet temperature";
  Modelica.SIunits.Temperature TIn25 = 298.15
     "25degC inlet temperature";

  Modelica.SIunits.Temperature TOut5 = TIn5 + deltaT
     "Outlet temperature with 5degC inlet";
  Modelica.SIunits.Temperature TOut10 = TIn10 + deltaT
     "Outlet temperature with 10degC inlet";
  Modelica.SIunits.Temperature TOut15 = TIn15 + deltaT
     "Outlet temperature with 15degC inlet";
  Modelica.SIunits.Temperature TOut20 = TIn20 + deltaT
     "Outlet temperature with 20degC inlet";
  Modelica.SIunits.Temperature TOut25 = TIn25 + deltaT
     "Outlet temperature with 25degC inlet";

  Modelica.SIunits.SpecificHeatCapacity cpe5
    "Equivalent specific heat capacity with 5degC inlet temperature";
  Modelica.SIunits.SpecificHeatCapacity cpe10
    "Equivalent specific heat capacity with 10degC inlet temperature";
  Modelica.SIunits.SpecificHeatCapacity cpe15
    "Equivalent specific heat capacity with 15degC inlet temperature";
  Modelica.SIunits.SpecificHeatCapacity cpe20
    "Equivalent specific heat capacity with 20degC inlet temperature";
  Modelica.SIunits.SpecificHeatCapacity cpe25
    "Equivalent specific heat capacity with 25degC inlet temperature";

equation
  deltaT = time;
  cpe5 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn5, TOut = TOut5);
  cpe10 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn10, TOut = TOut10);
  cpe15 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn15, TOut = TOut15);
  cpe20 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn20, TOut = TOut20);
  cpe25 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn25, TOut = TOut25);

  annotation (
    experiment(StartTime=0, Tolerance=1e-06, StopTime=50),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/BaseClasses/Functions/Validation/EquivalentHeatCapacity.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This model validates the computation of the equivalent heat capacity for five inlet temperature conditions and variable changes in temperature between inlet and outlet airflows. </p>
</html>", revisions="<html>
<ul>
<li>
January 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.<br/>
</li>
</ul>
</html>"));
end EquivalentHeatCapacity;
