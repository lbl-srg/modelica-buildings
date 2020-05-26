within Buildings.Controls.OBC.CDL.Logical.Validation;
model Switch "Validation model for the Switch block"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=5,
    offset=-1,
    height=6)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,22},{-6,42}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=5,
    offset=-1,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,-42},{-6,-22}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch switch1
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(booPul.y, switch1.u2)
    annotation (Line(points={{-5,0},{10,0},{24,0}}, color={255,0,255}));
  connect(ramp2.y, switch1.u3) annotation (Line(points={{-5,-32},{8,-32},{8,-8},
          {24,-8}}, color={0,0,127}));
  connect(ramp1.y, switch1.u1)
    annotation (Line(points={{-5,32},{8,32},{8,8},{24,8}}, color={0,0,127}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Switch.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Switch\">
Buildings.Controls.OBC.CDL.Logical.Switch</a>.
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
end Switch;
