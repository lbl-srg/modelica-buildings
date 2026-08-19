within Buildings.Controls.OBC.DemandFlexibility.Generic.Validation;
model BooleanPassThrough "Pass a Boolean signal through without modification"

  Buildings.Controls.OBC.DemandFlexibility.Generic.BooleanPassThrough booPasThr
    "Boolean pass-through block"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse pul(
    period=30)
    "Pulse signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(pul.y, booPasThr.u)
    annotation (Line(points={{-38,10},{18,10}}, color={255,0,255}));
annotation (experiment(StopTime=60, Interval=1, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/BooleanPassThrough.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.BooleanPassThrough\">
Buildings.Controls.OBC.DemandFlexibility.Generic.BooleanPassThrough</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 18, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
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
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})));
end BooleanPassThrough;
