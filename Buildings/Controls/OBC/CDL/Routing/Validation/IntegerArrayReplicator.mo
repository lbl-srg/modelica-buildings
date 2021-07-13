within Buildings.Controls.OBC.CDL.Routing.Validation;
model IntegerArrayReplicator
  "Validation model for the IntegerArrayReplicator block"
  Buildings.Controls.OBC.CDL.Routing.IntegerArrayReplicator
    intRep(nin=2, nout=3)
    "Block that outputs the array replicating input value"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram[2](
    each height=5,
    each duration=1,
    each offset=-2) "Block that outputs ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt[2]
    "Convert Real input to Integer output"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(ram.y,reaToInt.u)
    annotation (Line(points={{-38,0},{-12,0}},color={0,0,127}));
  connect(reaToInt.y,intRep.u)
    annotation (Line(points={{12,0},{38,0}},color={255,127,0}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Routing/Validation/IntegerArrayReplicator.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Routing.IntegerArrayReplicator\">
Buildings.Controls.OBC.CDL.Routing.IntegerArrayReplicator</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 25, 2021, by Baptiste Ravache:<br/>
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
end IntegerArrayReplicator;
