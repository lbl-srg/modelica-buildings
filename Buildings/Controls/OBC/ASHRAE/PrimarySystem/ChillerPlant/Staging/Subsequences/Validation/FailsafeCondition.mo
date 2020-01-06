within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model FailsafeCondition "Validate failsafe condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon0
    "Failsafe condition to test for the operating part load ratio input"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon1
    "Failsafe condition to test for the chilled water supply temperature and differential pressure inputs"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.FailsafeCondition
    faiSafCon2(final serChi=true)
    "Failsafe condition to test for the chilled water supply temperature and differential pressure inputs"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine OpeUp(
    final amplitude=0.1,
    final freqHz=1/2100,
    final offset=0.45)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,140},{-120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUpMin(
    final k=0.4) "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 18)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(
    final k=64.1*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUpMin1(
    final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUp1(
    final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/900) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat2(
    final amplitude=6895,
    final offset=63*6895,
    final freqHz=1/1500,
    final startTime=0,
    phase=0.78539816339745)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUpMin2(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet2(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant OpeUp2(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup2(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/2100)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));

equation
  connect(OpeUpMin.y, faiSafCon0.uOpeUpMin) annotation (Line(points={{-118,110},
          {-80,110},{-80,135},{-42,135}},color={0,0,127}));
  connect(OpeUp.y, faiSafCon0.uOpeUp) annotation (Line(points={{-118,150},{-80,
          150},{-80,138},{-42,138}}, color={0,0,127}));
  connect(TCWSup.y, faiSafCon0.TChiWatSup) annotation (Line(points={{-118,30},{-100,
          30},{-100,100},{-60,100},{-60,128},{-42,128}},   color={0,0,127}));
  connect(TCWSupSet.y, faiSafCon0.TChiWatSupSet) annotation (Line(points={{-118,70},
          {-102,70},{-102,102},{-62,102},{-62,132},{-42,132}},   color={0,0,127}));
  connect(dpChiWatSet.y, faiSafCon0.dpChiWatPumSet) annotation (Line(points={{-58,70},
          {-50,70},{-50,125},{-42,125}},     color={0,0,127}));
  connect(dpChiWat.y, faiSafCon0.dpChiWatPum) annotation (Line(points={{-58,30},
          {-48,30},{-48,122},{-42,122}},color={0,0,127}));
  connect(OpeUpMin1.y, faiSafCon1.uOpeUpMin) annotation (Line(points={{42,110},
          {80,110},{80,135},{118,135}},color={0,0,127}));
  connect(TCWSupSet1.y, faiSafCon1.TChiWatSupSet) annotation (Line(points={{42,70},
          {58,70},{58,102},{98,102},{98,132},{118,132}},color={0,0,127}));
  connect(dpChiWatSet1.y, faiSafCon1.dpChiWatPumSet) annotation (Line(points={{102,70},
          {110,70},{110,125},{118,125}},color={0,0,127}));
  connect(OpeUp1.y, faiSafCon1.uOpeUp) annotation (Line(points={{42,150},{80,150},
          {80,138},{118,138}},color={0,0,127}));
  connect(TCWSup1.y, faiSafCon1.TChiWatSup) annotation (Line(points={{42,30},{60,
          30},{60,100},{100,100},{100,128},{118,128}}, color={0,0,127}));
  connect(dpChiWat2.y, faiSafCon1.dpChiWatPum) annotation (Line(points={{102,30},
          {112,30},{112,122},{118,122}},color={0,0,127}));
  connect(OpeUpMin2.y,faiSafCon2. uOpeUpMin) annotation (Line(points={{-118,-70},
          {-80,-70},{-80,-45},{-42,-45}}, color={0,0,127}));
  connect(TCWSupSet2.y,faiSafCon2. TChiWatSupSet) annotation (Line(points={{-118,
          -110},{-102,-110},{-102,-78},{-62,-78},{-62,-48},{-42,-48}}, color={0,0,127}));
  connect(OpeUp2.y,faiSafCon2. uOpeUp) annotation (Line(points={{-118,-30},{-80,
          -30},{-80,-42},{-42,-42}}, color={0,0,127}));
  connect(TCWSup2.y,faiSafCon2. TChiWatSup) annotation (Line(points={{-118,-150},
          {-100,-150},{-100,-80},{-60,-80},{-60,-52},{-42,-52}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-180},{160,180}})));
end FailsafeCondition;
