within Buildings.Fluids.HeatExchangers.CoolingTowers.Examples;
model YorkCalc
  extends
    Buildings.Fluids.HeatExchangers.CoolingTowers.Examples.BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare Buildings.Fluids.HeatExchangers.CoolingTowers.YorkCalc tow);
  annotation(Diagram(graphics),
                      Commands(file="YorkCalc.mos" "run"));

  Modelica.Blocks.Sources.Step yFan(
    height=-1,
    offset=1,
    startTime=1) "Fan control signal" annotation (Placement(transformation(
          extent={{-100,20},{-80,40}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp y(
    height=-1,
    duration=0.1,
    offset=1,
    startTime=1) annotation (Placement(transformation(extent={{-68,2},{-48,22}},
          rotation=0)));
equation
  connect(y.y, tow.y) annotation (Line(points={{-47,12},{-32,12},{-32,-42},{-20,
          -42}}, color={0,0,127}));
end YorkCalc;
