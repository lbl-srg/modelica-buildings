within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Up "Validate change stage up condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Up
    staUp annotation (Placement(transformation(extent={{-20,20},{0,40}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUpMin(final k=0.4)
    "Minimum operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCWSupSet(final k=
        273.15 + 14) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpChiWatSet(final k=65
        *6895) "Chilled water differential pressure setpoint"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oplrUp(final k=0.5)
    "Operating part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TCWSup(
    final amplitude=1.5,
    final offset=273.15 + 15.5,
    final freqHz=1/600) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine dpChiWat(
    final amplitude=6895,
    final startTime=300,
    final freqHz=1/1200,
    final offset=63*6895) "Chilled water differential pressure"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  CDL.Continuous.Sources.Sine oplr(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  CDL.Continuous.Sources.Constant splrUp(final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

equation

  connect(splrUp.y, staUp.uSplrUp) annotation (Line(points={{-79,30},{-40,30},{
          -40,37},{-21,37}}, color={0,0,127}));
  connect(oplr.y, staUp.uOplr) annotation (Line(points={{-79,70},{-40,70},{-40,
          39},{-21,39}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-100},{160,100}})));
end Up;
