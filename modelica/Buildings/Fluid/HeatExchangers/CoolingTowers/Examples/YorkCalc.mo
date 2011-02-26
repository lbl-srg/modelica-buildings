within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model YorkCalc
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc tow, TOut(
        freqHz=1));

  Modelica.Blocks.Sources.Ramp y(
    height=-1,
    duration=0.1,
    offset=1,
    startTime=1) annotation (Placement(transformation(extent={{-60,-20},{-40,0}},
          rotation=0)));
equation
  connect(y.y, tow.y) annotation (Line(points={{-39,-10},{-32,-10},{-32,-42},{
          -20,-42}},
                 color={0,0,127}));
  annotation(Diagram(graphics),
                      Commands(file="YorkCalc.mos" "run"));
end YorkCalc;
