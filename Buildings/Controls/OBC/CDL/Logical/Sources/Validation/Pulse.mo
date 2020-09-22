within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
model Pulse "Validation model for the Boolean Pulse block"

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width = 0.5,
    period = 1)
    "Block that generates pulse signal of type Boolean at simulation start time"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.5,
    period=1,
    startTime=1.75)
    "Block that generates pulse signal of type Boolean starting from after the simulation start time"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    width=0.5,
    period=1,
    startTime=-1.25)
    "Block that generates pulse signal of type Boolean starting from before the simulation start time"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/Pulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.Pulse\">
Buildings.Controls.OBC.CDL.Logical.Sources.Pulse</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 1, 2020, by Milica Grahovac:<br/>
Added test cases for simulation time starting before and after the pulse <code>startTime</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2110\">#2110</a>.
</li>
<li>
July 17, 2017, by Jianjun Hu:<br/>
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
