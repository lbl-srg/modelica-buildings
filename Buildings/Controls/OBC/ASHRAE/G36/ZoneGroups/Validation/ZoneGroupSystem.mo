within Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.Validation;
model ZoneGroupSystem
  "Validate block for calculating AHU mode from the zone group modes"

  Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneGroupSystem ahuMod(
    final nGro=3)
    "AHU operation mode selection"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse groOne(
    final period=4,
    final offset=1)
    "Group 1 mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse groTwo(
    final amplitude=2,
    final period=10,
    final offset=1)
    "Group 2 mode"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant groThr(
    final k=3) "Group 3 mode"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(groOne.y, ahuMod.uOpeMod[1]) annotation (Line(points={{-38,50},{0,50},
          {0,-0.666667},{18,-0.666667}}, color={255,127,0}));
  connect(groTwo.y, ahuMod.uOpeMod[2])
    annotation (Line(points={{-38,0},{18,0}}, color={255,127,0}));
  connect(groThr.y, ahuMod.uOpeMod[3]) annotation (Line(points={{-38,-50},{0,
          -50},{0,0.666667},{18,0.666667}},
                                       color={255,127,0}));
annotation (
  experiment(StopTime=10, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/ZoneGroups/Validation/ZoneGroupSystem.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneGroupSystem\">
Buildings.Controls.OBC.ASHRAE.G36.ZoneGroups.ZoneGroupSystem</a>
for specifing the AHU operating mode when the system serves multiple zone groups.
</p>
</html>", revisions="<html>
<ul>
<li>
August 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
     graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end ZoneGroupSystem;
