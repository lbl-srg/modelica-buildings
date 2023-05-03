within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model FailsafeCondition "Validate failsafe condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon0(have_locSen=true)
    "Failsafe condition to test for the current stage availability input"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon1(have_locSen=true)
    "Failsafe condition to test for the chilled water supply temperature and differential pressure inputs"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.FailsafeCondition
    faiSafCon2(final have_serChi=true)
    "Failsafe condition to test for the chilled water supply temperature input for series chillers plant"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSup(
    final k=273.15 + 18)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWat(
    final k=64.1*6895)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet1(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet1(
    final k=65*6895)
    "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TCWSup1(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/900) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin dpChiWat2(
    final amplitude=6895,
    final offset=63*6895,
    final freqHz=1/1500,
    final startTime=0,
    phase=0.78539816339745)
    "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet2(
    final k=273.15 + 14)
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin TCWSup2(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/2100)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

equation
  connect(TCWSup.y, faiSafCon0.TChiWatSup) annotation (Line(points={{-118,70},{
          -110,70},{-110,96},{-42,96}},                    color={0,0,127}));
  connect(TCWSupSet.y, faiSafCon0.TChiWatSupSet) annotation (Line(points={{-118,
          110},{-60,110},{-60,99},{-42,99}},                     color={0,0,127}));
  connect(dpChiWatSet.y, faiSafCon0.dpChiWatPumSet_local) annotation (Line(
        points={{-78,70},{-60,70},{-60,91},{-42,91}}, color={0,0,127}));
  connect(dpChiWat.y, faiSafCon0.dpChiWatPum_local) annotation (Line(points={{
          -78,30},{-56,30},{-56,88},{-42,88}}, color={0,0,127}));
  connect(TCWSupSet1.y, faiSafCon1.TChiWatSupSet) annotation (Line(points={{42,110},
          {100,110},{100,99},{118,99}},                 color={0,0,127}));
  connect(dpChiWatSet1.y, faiSafCon1.dpChiWatPumSet_local) annotation (Line(
        points={{82,70},{90,70},{90,91},{118,91}}, color={0,0,127}));
  connect(TCWSup1.y, faiSafCon1.TChiWatSup) annotation (Line(points={{42,70},{
          50,70},{50,96},{118,96}},                    color={0,0,127}));
  connect(dpChiWat2.y, faiSafCon1.dpChiWatPum_local) annotation (Line(points={{
          82,30},{100,30},{100,88},{118,88}}, color={0,0,127}));
  connect(TCWSupSet2.y,faiSafCon2. TChiWatSupSet) annotation (Line(points={{-118,
          -30},{-100,-30},{-100,-21},{-42,-21}},                       color={0,0,127}));
  connect(TCWSup2.y,faiSafCon2. TChiWatSup) annotation (Line(points={{-118,-70},
          {-100,-70},{-100,-40},{-60,-40},{-60,-24},{-42,-24}},  color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/FailsafeCondition.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.FailsafeCondition\">
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,140}})));
end FailsafeCondition;
