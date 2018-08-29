within Buildings.Controls.OBC.CDL.Continuous.Sources.Validation;
model CalendarTimeMonths
  "Validation model for the calendar time model"
  Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime calTim(
    zerTim=Buildings.Controls.OBC.CDL.Types.ZeroTime.NY2017)
    "Computes date and time assuming time=0 corresponds to new year 2017"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  annotation (experiment(StartTime=172800, Tolerance=1e-6, StopTime=345600),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Sources/Validation/CalendarTimeMonths.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the use of the
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime\">
Buildings.Controls.OBC.CDL.Continuous.Sources.CalendarTime</a>
block for a period of a couple of months.
This shorter simulation time has been selected to
store the reference results that are used in the regression tests
at a resulation that makes sense for the minute and hour outputs.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end CalendarTimeMonths;
