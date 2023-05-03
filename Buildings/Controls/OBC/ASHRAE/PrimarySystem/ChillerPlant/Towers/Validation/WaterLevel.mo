within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Validation;
model WaterLevel
  "Validation sequence of cooling tower make-up water control"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.WaterLevel
    makUpWat(
    final watLevMin=0.7,
    final watLevMax=1.2) "Makeup water level control"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin watLev(
    final amplitude=1,
    final freqHz=1/7200,
    final offset=0.3) "Measured water level"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(watLev.y, makUpWat.watLev)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/Validation/WaterLevel.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.WaterLevel\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.WaterLevel</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 16, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
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
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end WaterLevel;
