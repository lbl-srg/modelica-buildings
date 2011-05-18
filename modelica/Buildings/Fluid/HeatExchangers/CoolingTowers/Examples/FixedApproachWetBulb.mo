within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachWetBulb
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram(graphics),
                      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/FixedApproachWetBulb.mos" "Simulate and plot"));
end FixedApproachWetBulb;
