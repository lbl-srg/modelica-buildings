within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachDryBulb
  "Test model for cooling tower with fixed approach temperature"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach tow);
equation
  connect(TOut.y, tow.TAir) annotation (Line(points={{-39,90},{-32,90},{-32,-46},
          {-20,-46}},color={0,0,127}));
  annotation(Diagram(graphics),
                      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/FixedApproachDryBulb.mos" "Simulate and plot"));
end FixedApproachDryBulb;
