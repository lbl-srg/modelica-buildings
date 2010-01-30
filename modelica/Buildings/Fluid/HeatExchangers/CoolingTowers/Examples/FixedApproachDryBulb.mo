within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachDryBulb
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram(graphics),
                      Commands(file="FixedApproachDryBulb.mos" "run"));
equation
  connect(TOut.y, tow.TAir) annotation (Line(points={{-39,90},{-32,90},{-32,-46},
          {-20,-46}},color={0,0,127}));
end FixedApproachDryBulb;
