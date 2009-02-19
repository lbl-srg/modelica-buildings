within Buildings.Fluids.HeatExchangers.CoolingTowers.Examples;
model FixedApproachDryBulb
  extends
    Buildings.Fluids.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare Buildings.Fluids.HeatExchangers.CoolingTowers.FixedApproach tow);
  annotation(Diagram(graphics),
                      Commands(file="FixedApproachDryBulb.mos" "run"));
equation
  connect(TOut.y, tow.TAir) annotation (Line(points={{-39,90},{-32,90},{-32,-4},
          {-20,-4}}, color={0,0,127}));
end FixedApproachDryBulb;
