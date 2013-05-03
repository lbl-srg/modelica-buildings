within Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater;
model MultiStage "Multi stage water to water heat pump"
  import Buildings;
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToWater.BaseClasses.PartialWaterToWater;
  Modelica.Blocks.Interfaces.IntegerInput heaSta
    "Heating stage (positive value, 0: off)"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));
  Modelica.Blocks.Interfaces.IntegerInput cooSta
    "Cooling stage (positive value, 0: off)"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeSelect modSel
    "Selects mode of operation of the heat pump"
    annotation (Placement(transformation(extent={{-72,40},{-60,52}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.SpeedSelect speSel(
    nHeaSta=datHP.heaMod.nSta,
    heaSpeSet=datHP.heaMod.heaPer.spe,
    nCooSta=datHP.cooMod.nSta,
    cooSpeSet=datHP.cooMod.cooPer.spe)
    annotation (Placement(transformation(extent={{-50,28},{-38,40}})));
equation
  connect(heaSta, modSel.heaSta) annotation (Line(
      points={{-120,100},{-84,100},{-84,48.4},{-73.2,48.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(cooSta, modSel.cooSta) annotation (Line(
      points={{-120,40},{-84,40},{-84,43.6},{-73.2,43.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, heaFlo.mode) annotation (Line(
      points={{-58.8,48.4},{-28,48.4},{-28,10},{-11,10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, dynStaSto1.mode) annotation (Line(
      points={{-58.8,48.4},{-28,48.4},{-28,30},{38,30}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, dynStaSto2.mode) annotation (Line(
      points={{-58.8,48.4},{-28,48.4},{-28,30},{30,30},{30,-10},{38,-10}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.mode, speSel.mode) annotation (Line(
      points={{-58.8,48.4},{-54,48.4},{-54,36.4},{-50.6,36.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modSel.stage, speSel.stage) annotation (Line(
      points={{-58.8,43.6},{-56,43.6},{-56,31.6},{-50.6,31.6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speSel.speRat, heaFlo.speRat) annotation (Line(
      points={{-37.4,34},{-34,34},{-34,7},{-11,7}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Icon(graphics),defaultComponentName="mulStaHP",
Documentation(info="<html>
<p>
This model can be used to simulate a water to water heat pump with multi stage compressor.
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
end MultiStage;
