within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
model TimeTableNegativeStartTime
  "Validation model for TimeTable block with negative start time"
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTab(
    table=[
      0,1,0;
      1.3,1,1;
      2.9,0,0;
      4,1,0],
    period=5)
    "Time table with boolean output"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTabOneRow(
    table=[
      0,1,0],
    period=1)
    "Time table with boolean output for a single table row"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable booTimTabTwi(
    table=[
      0,1,0;
      1.3,1,1;
      2.9,0,0;
      4,1,0],
    period=10,
    timeScale=2)
    "Time table with boolean output, periodic repetition, and doubled time"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  annotation (
    experiment(
      Tolerance=1e-6,
      StartTime=-5.0,
      StopTime=10.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/TimeTableNegativeStartTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model validates the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable\">
Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable</a>.
The model is identical to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.Validation.TimeTable\">
Buildings.Controls.OBC.CDL.Logical.Sources.Validation.TimeTable</a>
except that the start time is negative.
</html>",
      revisions="<html>
<ul>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end TimeTableNegativeStartTime;
