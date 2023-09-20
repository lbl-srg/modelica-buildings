within Buildings.Controls.OBC.CDL.Reals.Sources.Validation;
model Sin
  "Validation model for Sin"
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=5,
    freqHz=1/60,
    phase=0,
    offset=10,
    startTime=10)
    "Sine source block"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  annotation (
    experiment(
      StopTime=130.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Sources/Validation/Sin.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Sources.Ramp\">
Buildings.Controls.OBC.CDL.Reals.Sources.Ramp</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 06, 2017, by Milica Grahovac:<br/>
First CDL implementation.
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
end Sin;
