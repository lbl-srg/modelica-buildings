within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Conditionals.Validation;
model UnpopulatedWithOccupancySensor
  "Validates a subsequence that sets minimum area volume when the zone has an occupancy sensor and is unpopulated"

  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Conditionals.UnpopulatedWithOccupancySensor
    unpWitOcc annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/VentilationZones/SetPoints/Validation/UnpopulatedWithOccupancySensor.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Conditionals.UnpopulatedWithOccupancySensor\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24.Conditionals.UnpopulatedWithOccupancySensor</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
Jun 20, 2020, by Milica Grahovac:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-40,-20},{20,20}})));
end UnpopulatedWithOccupancySensor;
