within Buildings.Controls.OBC.CDL.Integers.Sources.Validation;
model Pulse "Validation model for the Integer Pulse block"

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse pul3(
    amplitude=1,
    width=0.5,
    period=1,
    offset=3)
    "Block that generates pulse signal of type Integer at simulation start time"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse pul1(
    amplitude=2,
    width=0.5,
    period=1,
    offset=1,
    delay=1.75)
    "Block that generates pulse signal of type Integer starting from after the simulation start time"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse pul2(
    amplitude=3,
    width=0.5,
    period=1,
    offset=-2,
    delay=-1.25)
    "Block that generates pulse signal of type Integer starting from before the simulation start time"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Pulse pul(
    width=0.5,
    period=1)
    "Block that generates pulse signal of type Integer at simulation start time and has infinite number of periods"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  annotation (
  experiment(
      StopTime=5,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Sources/Validation/Pulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Sources.Pulse\">
Buildings.Controls.OBC.CDL.Integers.Sources.Pulse</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 8, 2020, by Milica Grahovac:<br/>
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

end Pulse;
