within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model ChilledWaterSupplySetpoint
  "Validate model of generating setpoints for chilled water supply control"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterSupplySetpoint
    chiWatSupSet(
    dpChiWatPumMin=60,
    dpChiWatPumMax=150,
    TChiWatSupMin=280.15,
    TChiWatSupMax=291.15) "Generate setpoint for chilled water supply control"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(duration=3600)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(ram.y, chiWatSupSet.uChiWatPlaRes)
    annotation (Line(points={{-19,0},{18,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/ChilledWaterSupplySetpoint.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterSupplySetpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterSupplySetpoint</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2018, by Jianjun Hu:<br/>
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
end ChilledWaterSupplySetpoint;
