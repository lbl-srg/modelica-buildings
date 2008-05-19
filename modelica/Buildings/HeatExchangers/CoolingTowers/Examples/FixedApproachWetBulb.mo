model FixedApproachWetBulb 
  extends 
    Buildings.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram, Commands(file="FixedApproachDryBulb.mos" "run"));
end FixedApproachWetBulb;
