within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachWetBulb
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram(graphics),
                      Commands(file="FixedApproachWetBulb.mos" "run"));
end FixedApproachWetBulb;
