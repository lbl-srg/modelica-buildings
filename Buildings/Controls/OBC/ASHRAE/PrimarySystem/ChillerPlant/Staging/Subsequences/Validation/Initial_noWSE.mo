within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Initial_noWSE
  "Validate initial stage sequence in case of no WSE"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial iniSta(
    final have_WSE=false) "Tests if initial stage is the lowest available stage"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant lowAvaSta(
    final k=2)
    "Lowest chiller stage that is available"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(lowAvaSta.y, iniSta.uUp)
    annotation (Line(points={{-18,0},{-2,0}}, color={255,127,0}));
annotation (
 experiment(StopTime=100.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Initial_noWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Initial</a>
 for chiller plants without WSE.
</p>
</html>", revisions="<html>
<ul>
<li>
March 12, 2020, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-60,-40},{40,40}})));
end Initial_noWSE;
