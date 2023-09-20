within Buildings.Controls.OBC.CDL.Reals.Sources.Validation;
model StandardTime
  "Test model for the StandardTime block"
  Buildings.Controls.OBC.CDL.Reals.Sources.ModelTime staTim
    "Standard time"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
    experiment(
      StartTime=-1,
      Tolerance=1e-6,
      StopTime=1),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Sources/Validation/StandardTime.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model tests the implementation of the block that outputs the
model time.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 18, 2017, by Jianjun Hu:<br/>
First implementation in CDL.
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
end StandardTime;
