within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.Examples;
model YorkCalc "Example for yorkCalc correlation"

  annotation(Diagram(graphics),
                      Commands(file="YorkCalc.mos" "run"));
  parameter Modelica.SIunits.Temperature TRan = 5.56
    "Range temperature (water in - water out)";
  parameter Modelica.SIunits.Temperature TAirInWB = 25.55 + 273.15
    "Inlet air wet bulb temperature";
  Modelica.SIunits.MassFraction x "Independent variable";
  Modelica.SIunits.Temperature TApp_Wat
    "Approach temperature as a function of FRWat";
  Modelica.SIunits.Temperature TApp_Air
    "Approach temperature as a function of FRAir";

equation
  x = 0.25+time;
  TApp_Wat=Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan,
                                                                    TWB=TAirInWB,
                                                                    FRWat=x,
                                                                    FRAir=1);
  TApp_Air=Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan,
                                                                    TWB=TAirInWB,
                                                                    FRWat=1,
                                                                    FRAir=x);

end YorkCalc;
