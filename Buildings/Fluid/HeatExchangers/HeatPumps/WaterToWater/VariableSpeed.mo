within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater;
model VariableSpeed "Variable speed water to water heat pump"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.PartialWaterToWater;
  parameter Real cooModMinSpeRat(min=0,max=1)= 0.2
    "Minimum speed ratio in cooling mode";
  parameter Real cooModSpeRatDeaBan(min=0,max=1)= 0.05
    "Deadband for minimum speed ratio in cooling mode";
  parameter Real heaModMinSpeRat(min=0,max=1)= 0.2
    "Minimum speed ratio in heating mode";
  parameter Real heaModSpeRatDeaBan(min=0,max=1)= 0.05
    "Deadband for minimum speed ratio in heating mode";
  Modelica.Blocks.Interfaces.RealInput heaSpeRat(final min=0, final max=1)
    "Heating mode speed ratio"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.RealInput cooSpeRat(final min=0, final max=1)
    "Cooling mode speed ratio"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedRatioSelector speRatSel(
    cooModMinSpeRat=cooModMinSpeRat,
    cooModSpeRatDeaBan=cooModSpeRatDeaBan,
    heaModMinSpeRat=heaModMinSpeRat,
    heaModSpeRatDeaBan=heaModSpeRatDeaBan)
    annotation (Placement(transformation(extent={{-52,28},{-40,40}})));
equation
  connect(heaSpeRat, speRatSel.heaSpeRat) annotation (Line(
      points={{-120,100},{-86,100},{-86,37},{-53.2,37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooSpeRat, speRatSel.cooSpeRat) annotation (Line(
      points={{-120,20},{-86,20},{-86,31},{-53.2,31}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRatSel.speRat, heaFlo.speRat) annotation (Line(
      points={{-39.4,31.6},{-26,31.6},{-26,7},{-11,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRatSel.mode, heaFlo.mode) annotation (Line(
      points={{-39.4,36.4},{-20,36.4},{-20,10},{-11,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRatSel.mode, dynStaSto1.mode) annotation (Line(
      points={{-39.4,36.4},{-20,36.4},{-20,30},{38,30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRatSel.mode, dynStaSto2.mode) annotation (Line(
      points={{-39.4,36.4},{-20,36.4},{-20,30},{30,30},{30,-10},{38,-10}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics),defaultComponentName="varSpeHP",
Documentation(info="<html>
<p>
This model can be used to simulate a water to water heat pump with variable speed compressor.
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
end VariableSpeed;
