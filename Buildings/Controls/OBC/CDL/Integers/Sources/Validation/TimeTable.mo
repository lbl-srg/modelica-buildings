within Buildings.Controls.OBC.CDL.Integers.Sources.Validation;
model TimeTable
  "Validation model for TimeTable block"
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab(
    table=[
      0,1,4;
      1.3,2,2;
      2.9,0,-1;
      4,3,7],
    period=5)
    "Integer time table"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab1(
    table=[
      0,-1,-2;
      6,1,4;
      7.3,2,2;
      8.9,0,-1;
      10,3,7],
    period=11)
    "Integer time table"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable tabOneRow(
    table=[
      0,-1],
    period=2)
    "Time table with only one row of data"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  annotation (
    experiment(
      Tolerance=1e-6,
      StopTime=15.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Sources/Validation/TimeTable.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable\">
Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 8, 2020, by Michael Wetter:<br/>
Added test for time table with only one row.
</li>
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
end TimeTable;
