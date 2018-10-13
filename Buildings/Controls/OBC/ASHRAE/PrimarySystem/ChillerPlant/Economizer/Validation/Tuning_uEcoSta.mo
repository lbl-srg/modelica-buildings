within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Validation;
model Tuning_uEcoSta "Validate water side economizer tuning parameter sequence"

  Tuning tuning annotation (Placement(transformation(extent={{0,0},{36,36}})));
  CDL.Logical.Sources.Pulse booPul(width=0.5, period=2*80*60)
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation

  connect(tuning.uEcoSta, booPul.y) annotation (Line(points={{-2,19.8},{-30,
          19.8},{-30,10},{-59,10}}, color={255,0,255}));
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
end Tuning_uEcoSta;
