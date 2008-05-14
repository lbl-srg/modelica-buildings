model YorkCalc 
  extends BaseClasses.PartialStaticFourPortCoolingTower(
    redeclare Buildings.HeatExchangers.CoolingTowers.YorkCalc tow);
  annotation(Diagram, Commands(file="YorkCalc.mos" "run"));
end YorkCalc;
