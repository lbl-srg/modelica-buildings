model YorkCalc 
  extends 
    Buildings.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.HeatExchangers.CoolingTowers.YorkCalc tow);
  annotation(Diagram, Commands(file="YorkCalc.mos" "run"));
  
  Modelica.Blocks.Sources.Step yFan(
    height=-1,
    offset=1,
    startTime=1) "Fan control signal" annotation (extent=[-100,20; -80,40]);
  Modelica.Blocks.Sources.Ramp y(
    height=-1,
    duration=0.1,
    offset=1,
    startTime=1) annotation (extent=[-68,2; -48,22]);
equation 
  connect(y.y, tow.y) annotation (points=[-47,12; -32,12; -32,-42; -20,-42],
      style(color=74, rgbcolor={0,0,127}));
end YorkCalc;
