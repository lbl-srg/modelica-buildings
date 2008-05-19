model YorkCalc 
  extends 
    Buildings.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.HeatExchangers.CoolingTowers.YorkCalc tow, res_1(dh=1));
  annotation(Diagram, Commands(file="YorkCalc.mos" "run"));
  
  Modelica.Blocks.Sources.Step yFan(
    height=-1, 
    offset=1, 
    startTime=1) "Fan control signal" annotation (extent=[-60,0; -40,20]);
equation 
  connect(yFan.y, tow.y) annotation (points=[-39,10; -30,10; -30,-42; -20,-42], 
      style(
      color=74, 
      rgbcolor={0,0,127}, 
      fillColor=74, 
      rgbfillColor={0,0,127}, 
      fillPattern=1));
end YorkCalc;
