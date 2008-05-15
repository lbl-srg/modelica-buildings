model YorkCalc "Example for yorkCalc correlation" 
  annotation(Diagram, Commands(file="YorkCalc.mos" "run"));
    parameter Modelica.SIunits.Temperature TRan = 5.56 
    "Range temperature (water in - water out)";
  parameter Modelica.SIunits.Temperature TAirInWB = 25.55 + 273.15 
    "Inlet air wet bulb temperature";
  Modelica.SIunits.MassFraction FRWat 
    "Ratio actual over design water mass flow ratio";
  Modelica.SIunits.Temperature TApp "Approach temperature";
  
equation 
  FRWat = 0.25+time;
  TApp=Buildings.HeatExchangers.CoolingTowers.Correlations.yorkCalc(TRan=TRan,
                                                                    TWB=TAirInWB,
                                                                    FRWat=FRWat,
                                                                    FRAir=1);
end YorkCalc;
