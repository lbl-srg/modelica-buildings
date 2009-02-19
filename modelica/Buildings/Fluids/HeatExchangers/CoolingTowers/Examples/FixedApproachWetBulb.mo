within Buildings.Fluids.HeatExchangers.CoolingTowers.Examples;
model FixedApproachWetBulb
  extends
    Buildings.Fluids.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluids.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram(graphics),
                      Commands(file="FixedApproachDryBulb.mos" "run"));
end FixedApproachWetBulb;
