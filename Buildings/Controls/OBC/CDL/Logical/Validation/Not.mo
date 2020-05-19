within Buildings.Controls.OBC.CDL.Logical.Validation;
model Not "Validation model for the Not block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=1.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Output true when input is false and output false when input is true"
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(booPul.y, not1.u)
    annotation (Line(points={{-4,0},{-4,0},{24,0}},color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Not.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Not\">
Buildings.Controls.OBC.CDL.Logical.Not</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Not;
