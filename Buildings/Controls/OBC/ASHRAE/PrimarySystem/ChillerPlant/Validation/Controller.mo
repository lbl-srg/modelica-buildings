within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model Controller "Validation head pressure controller"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Controller chiPlaCon
    annotation (Placement(transformation(extent={{-40,-140},{60,160}})));
equation

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
fixme
</p>
</html>", revisions="<html>
<ul>
<li>
August 30, 2020, by Milica Grahovac:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-680,-800},{680,800}})));
end Controller;
