within Buildings.Controls.OBC.CDL.Integers.Sources.Validation;
model TimeTable "Validation model for TimeTable block"

  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,1,4.1; 1.3,1,2; 2.9,0,-1; 4,1,7; 5,1,1],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint,
    offset={-3,1},
    timeScale=2) "Time table with integer output"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable intTimTabPer(
    table=[0,1,4; 1.3,2,2; 2.9,0,-1; 4,3,7; 5,1,1],
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic)
    "Time table with integer output and periodic repetition"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  annotation (experiment(Tolerance=1e-6, StopTime=10.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Sources/Validation/TimeTable.mos"
       "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable\">
Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 14, 2020, by Milica Grahovac:<br/>
Initial CDL implementation.
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

end TimeTable;
