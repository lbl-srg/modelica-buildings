within Buildings.Controls.OBC.CDL.Integers.Validation;
model OnCounter
  "Validation model for the OnCounter block"
  Buildings.Controls.OBC.CDL.Integers.OnCounter onCounter
    "Block that outputs increment if the input switches to true"
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.5,
    period=0.1)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse reset(
    width=0.5,
    period=1.0)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-50},{-6,-30}})));

equation
  connect(reset.y,onCounter.reset)
    annotation (Line(points={{-5,-40},{26,-40},{26,-14},{26,-14},{26,-12},{26,-12}},color={255,0,255}));
  connect(booPul.y,onCounter.trigger)
    annotation (Line(points={{-5,0},{12,0},{12,0}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=2.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/OnCounter.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.OnCounter\">
Buildings.Controls.OBC.CDL.Integers.OnCounter</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
end OnCounter;
