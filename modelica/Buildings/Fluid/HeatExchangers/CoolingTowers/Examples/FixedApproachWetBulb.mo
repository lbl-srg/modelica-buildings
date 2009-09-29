within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachWetBulb
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram(graphics),
                      Commands(file="FixedApproachDryBulb.mos" "run"));
end FixedApproachWetBulb;
