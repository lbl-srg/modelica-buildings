within Buildings.Controls.OBC.CDL.Routing.Validation;
model BooleanReplicator
  "Validation model for the BooleanReplicator block"
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    nout=3)
    "Block that outputs the array replicating input value"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=0.2)
    "Block that outputs boolean pulse"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

equation
  connect(booPul.y,booRep.u)
    annotation (Line(points={{-19,0},{18,0}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/BooleanReplicator.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.BooleanReplicator\">
Buildings.Controls.OBC.CDL.Routing.BooleanReplicator</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 24, 2017, by Jianjun Hu:<br/>
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
end BooleanReplicator;
