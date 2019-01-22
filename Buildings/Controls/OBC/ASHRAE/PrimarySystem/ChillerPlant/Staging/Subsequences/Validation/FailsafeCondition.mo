within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model FailsafeCondition "Validate failsafe condition sequence"


  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon0
    "Failsafe condition to test for the operating part load ratio input"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon1 "Failsafe condition to test for the chilled water supply temperature and differential pressure inputs"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine oplrUp(
    final freqHz=1/300,
    final amplitude=0.1,
    final offset=0.4) "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 18)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(final k=64.1*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin1(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp1(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat2(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895)
                         "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

equation

  connect(oplrUpMin.y, faiSafCon0.uOplrUpMin) annotation (Line(points={{-119,30},
          {-80,30},{-80,54},{-41,54}},   color={0,0,127}));
  connect(oplrUp.y, faiSafCon0.uOplrUp) annotation (Line(points={{-119,70},{-80,
          70},{-80,58},{-41,58}},  color={0,0,127}));
  connect(TCWSup.y, faiSafCon0.TChiWatSup) annotation (Line(points={{-119,-50},{
          -100,-50},{-100,20},{-60,20},{-60,47},{-41,47}}, color={0,0,127}));
  connect(TCWSupSet.y, faiSafCon0.TChiWatSupSet) annotation (Line(points={{-119,
          -10},{-102,-10},{-102,22},{-62,22},{-62,49},{-41,49}}, color={0,0,127}));
  connect(dpChiWatSet.y, faiSafCon0.dpChiWatPumSet) annotation (Line(points={{-59,-10},
          {-50,-10},{-50,43},{-41,43}},      color={0,0,127}));
  connect(dpChiWat.y, faiSafCon0.dpChiWatPum) annotation (Line(points={{-59,-50},
          {-48,-50},{-48,41},{-41,41}}, color={0,0,127}));
  connect(oplrUpMin1.y, faiSafCon1.uOplrUpMin) annotation (Line(points={{41,30},
          {80,30},{80,54},{119,54}},   color={0,0,127}));
  connect(TCWSupSet1.y, faiSafCon1.TChiWatSupSet) annotation (Line(points={{41,-10},
          {58,-10},{58,22},{98,22},{98,49},{119,49}},   color={0,0,127}));
  connect(dpChiWatSet1.y, faiSafCon1.dpChiWatPumSet) annotation (Line(points={{101,-10},
          {110,-10},{110,43},{119,43}}, color={0,0,127}));
  connect(oplrUp1.y, faiSafCon1.uOplrUp) annotation (Line(points={{41,70},{80,70},
          {80,58},{119,58}},  color={0,0,127}));
  connect(TCWSup1.y, faiSafCon1.TChiWatSup) annotation (Line(points={{41,-50},{60,
          -50},{60,20},{100,20},{100,47},{119,47}},  color={0,0,127}));
  connect(dpChiWat2.y, faiSafCon1.dpChiWatPum) annotation (Line(points={{101,-50},
          {112,-50},{112,41},{119,41}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/FailsafeCondition.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.FailsafeCondition</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 21, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-80},{160,100}})));
end FailsafeCondition;
