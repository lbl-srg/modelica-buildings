within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.Examples;
model YorkCalc "Example for yorkCalc correlation"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.TemperatureDifference TRan=5.56
    "Range temperature (water in - water out)";
  parameter Modelica.Units.SI.Temperature TAirInWB=25.55 + 273.15
    "Inlet air wet bulb temperature";
  Modelica.Units.SI.MassFraction x "Independent variable";
  Modelica.Units.SI.TemperatureDifference TApp_Wat
    "Approach temperature as a function of FRWat";
  Modelica.Units.SI.TemperatureDifference TApp_Air
    "Approach temperature as a function of FRAir";

equation
  x = 0.25+time;
  TApp_Wat=Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan,
                                                                    TWetBul=TAirInWB,
                                                                    FRWat=x,
                                                                    FRAir=1);
  TApp_Air=Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan,
                                                                    TWetBul=TAirInWB,
                                                                    FRWat=1,
                                                                    FRAir=x);

  annotation(experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Correlations/Examples/YorkCalc.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation model that plots the approach temperature based on the York model for different
ratios of water and air flow rates.
</p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;
