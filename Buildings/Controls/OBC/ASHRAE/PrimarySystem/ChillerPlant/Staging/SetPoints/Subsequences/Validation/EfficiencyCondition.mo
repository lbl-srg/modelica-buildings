within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.Validation;
model EfficiencyCondition "Validate efficiency condition sequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition
    effCon
    "Failsafe condition to test for the operating part load ratio input"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin oplr(
    final amplitude=0.1,
    final phase(displayUnit="rad"),
    final startTime=0,
    final offset=0.85,
    final freqHz=1/2100) "Operating part load ratio of the current stage"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant splrUp(
    final k=0.8)
    "Staging part load ratio of the next stage up"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

equation
  connect(oplr.y, effCon.uOpe) annotation (Line(points={{-18,30},{-10,30},{-10,
          15},{-2,15}}, color={0,0,127}));
  connect(splrUp.y, effCon.uStaUp) annotation (Line(points={{-18,-10},{-10,-10},
          {-10,5},{-2,5}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/SetPoints/Subsequences/Validation/EfficiencyCondition.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.SetPoints.Subsequences.EfficiencyCondition\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.EfficiencyCondition</a>.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-60,-40},{40,60}})));
end EfficiencyCondition;
