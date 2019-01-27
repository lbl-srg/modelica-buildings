within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Down "Validate change stage down condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp annotation (Placement(transformation(extent={{60,20},{80,40}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(final k=273.15
         + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(final k=65*
        6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  CDL.Continuous.Sources.Sine oplr(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  CDL.Continuous.Sources.Constant splrUp(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

equation

  connect(splrUp.y, staUp.uSplrUp) annotation (Line(points={{1,30},{12,30},{12,37},
          {59,37}}, color={0,0,127}));
  connect(oplr.y, staUp.uOplr) annotation (Line(points={{1,70},{40,70},{40,39},{
          59,39}}, color={0,0,127}));
  connect(oplrUp.y, staUp.uOplrUp) annotation (Line(points={{-39,50},{20,50},{20,
          34},{59,34}}, color={0,0,127}));
  connect(oplrUpMin.y, staUp.uOplrUpMin) annotation (Line(points={{-39,10},{20,10},
          {20,32},{59,32}}, color={0,0,127}));
  connect(TCWSupSet.y, staUp.TChiWatSupSet) annotation (Line(points={{-39,-30},{
          30,-30},{30,28},{59,28}}, color={0,0,127}));
  connect(TCWSup.y, staUp.TChiWatSup) annotation (Line(points={{-39,-70},{40,-70},
          {40,26},{59,26}}, color={0,0,127}));
  connect(dpChiWatSet.y, staUp.dpChiWatPumSet) annotation (Line(points={{1,-10},
          {44,-10},{44,23},{59,23}}, color={0,0,127}));
  connect(dpChiWat.y, staUp.dpChiWatPum) annotation (Line(points={{1,-50},{48,-50},
          {48,21},{59,21}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Up.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.Up</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 28, 2019, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end Down;
