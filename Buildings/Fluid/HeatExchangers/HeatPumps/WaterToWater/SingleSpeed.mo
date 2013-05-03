within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater;
model SingleSpeed "Single speed water to water heat pump"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.PartialWaterToWater;

  Modelica.Blocks.Sources.Constant speRat(final k=1) "Speed ratio"
    annotation (Placement(transformation(extent={{-52,28},{-40,40}})));
public
  Modelica.Blocks.Interfaces.IntegerInput mode(final min=0, final max=2)
    "Set to 1 for heating mode and 2 for cooling mode and to 0 to turn off"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}})));
equation
  connect(speRat.y, heaFlo.speRat) annotation (Line(
      points={{-39.4,34},{-30,34},{-30,7},{-11,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, heaFlo.mode)  annotation (Line(
      points={{-120,100},{-24,100},{-24,10},{-11,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, dynStaSto1.mode) annotation (Line(
      points={{-120,100},{-24,100},{-24,30},{38,30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, dynStaSto2.mode) annotation (Line(
      points={{-120,100},{-24,100},{-24,30},{32,30},{32,-10},{38,-10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics),defaultComponentName="sinSpeHP",
Documentation(info="<html>
<p>
This model can be used to simulate a water to water heat pump with single speed compressor.
</p>
</html>",
revisions="<html>
<ul>
<li>
Jan 10, 2013 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"));
end SingleSpeed;
