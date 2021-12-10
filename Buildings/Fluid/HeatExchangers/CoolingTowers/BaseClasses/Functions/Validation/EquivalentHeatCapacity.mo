within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.Validation;
model EquivalentHeatCapacity
  "Validation model for the equivalent heat capacity calculation"
  extends Modelica.Icons.Example;

  Modelica.Units.SI.TemperatureDifference deltaT
    "Change in temperature of the air entering and leaving the cooling tower";

  Modelica.Units.SI.Temperature TIn[1,5]=[283.15,288.15,293.15,298.15,303.15]
    "Inlet temperatures";

  Modelica.Units.SI.Temperature TOut[1,5]=[TIn[1, 1] + deltaT,TIn[1, 2] +
      deltaT,TIn[1, 3] + deltaT,TIn[1, 4] + deltaT,TIn[1, 5] + deltaT]
    "Outlet temperatures";

  Modelica.Units.SI.SpecificHeatCapacity cpe10
    "Equivalent specific heat capacity with 10 degC inlet temperature";
  Modelica.Units.SI.SpecificHeatCapacity cpe15
    "Equivalent specific heat capacity with 15 degC inlet temperature";
  Modelica.Units.SI.SpecificHeatCapacity cpe20
    "Equivalent specific heat capacity with 20 degC inlet temperature";
  Modelica.Units.SI.SpecificHeatCapacity cpe25
    "Equivalent specific heat capacity with 25 degC inlet temperature";
  Modelica.Units.SI.SpecificHeatCapacity cpe30
    "Equivalent specific heat capacity with 30 degC inlet temperature";

protected
  constant Real con = 1 "Conversion factor to avoid warning because of unit missmatch";
equation
  deltaT = con*time;
  cpe10 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn[1,1], TOut = TOut[1,1]);
  cpe15 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn[1,2], TOut = TOut[1,2]);
  cpe20 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn[1,3], TOut = TOut[1,3]);
  cpe25 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn[1,4], TOut = TOut[1,4]);
  cpe30 = Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
    TIn = TIn[1,5], TOut = TOut[1,5]);

  annotation (
    experiment(StartTime=10, Tolerance=1e-06, StopTime=20),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/BaseClasses/Functions/Validation/EquivalentHeatCapacity.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model validates the computation of the equivalent heat capacity for five inlet temperature conditions and
variable changes in temperature between inlet and outlet airflows.
</p>
</html>", revisions="<html>
<ul>
<li>
January 6, 2020, by Kathryn Hinkelman:<br/>
First implementation.<br/>
</li>
</ul>
</html>"));
end EquivalentHeatCapacity;
