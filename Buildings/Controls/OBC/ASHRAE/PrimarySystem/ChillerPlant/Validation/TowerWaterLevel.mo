within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model TowerWaterLevel
  "Validate cooling tower water level control sequence"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine towWatLev(
    freqHz=1/1800,
    amplitude=0.9,
    offset=1.2) "Cooling tower water level"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel
    makUpWat(watLevMin=0.5, watLevMax=2) "Tower water level controller"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(towWatLev.y, makUpWat.watLev)
    annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));

annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/TowerWaterLevel.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.TowerWaterLevel</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
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
        coordinateSystem(preserveAspectRatio=false)));
end TowerWaterLevel;
