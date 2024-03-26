within Buildings.Templates.Plants.Controls.Utilities.Validation;
model MultiMinInteger
  Buildings.Templates.Plants.Controls.Utilities.MultiMinInteger mulMin(nin=5)
    "Block that outputs the minimum element of the input vector"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant con[5](
    k={1, 2, 3, 4, 5})
    "Constant vector"
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
equation
  connect(con.y, mulMin.u)
    annotation (Line(points={{-26,0},{-2,0}},color={255,127,0}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Utilities/Validation/MultiMinInteger.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Templates.Plants.Controls.Utilities.MultiMinInteger\">
Buildings.Templates.Plants.Controls.Utilities.MultiMinInteger</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
XXXX, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end MultiMinInteger;
