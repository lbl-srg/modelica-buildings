within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.Examples;
model YorkCalc "Example for yorkCalc correlation"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.TemperatureDifference TRan = 5.56
    "Range temperature (water in - water out)";
  parameter Modelica.SIunits.Temperature TAirInWB = 25.55 + 273.15
    "Inlet air wet bulb temperature";
  Modelica.SIunits.MassFraction x "Independent variable";
  Modelica.SIunits.TemperatureDifference TApp_Wat
    "Approach temperature as a function of FRWat";
  Modelica.SIunits.TemperatureDifference TApp_Air
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

  annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Correlations/Examples/YorkCalc.mos" "Simulate and plot"));
end YorkCalc;
