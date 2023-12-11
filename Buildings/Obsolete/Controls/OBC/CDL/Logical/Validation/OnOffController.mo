within Buildings.Obsolete.Controls.OBC.CDL.Logical.Validation;
model OnOffController
  "Validation model for the OnOffController block"
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=5,
    offset=0,
    height=31.415926)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-76,-16},{-56,4}})));
  Buildings.Controls.OBC.CDL.Reals.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-32,-16},{-12,4}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cons2(
    k=0.7)
    "Constant as source term"
    annotation (Placement(transformation(extent={{-32,18},{-12,38}})));
  Buildings.Obsolete.Controls.OBC.CDL.Logical.OnOffController onOffController(
    bandwidth=0.1)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(ramp1.y,sin1.u)
    annotation (Line(points={{-54,-6},{-34,-6}},color={0,0,127}));
  connect(sin1.y,onOffController.u)
    annotation (Line(points={{-10,-6},{-10,-6},{24,-6}},
                                                      color={0,0,127}));
  connect(cons2.y,onOffController.reference)
    annotation (Line(points={{-10,28},{6,28},{6,6},{24,6}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete.Controls/OBC/CDL/Logical/Validation/OnOffController.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Logical.OnOffController\">
Buildings.Obsolete.Controls.OBC.CDL.Logical.OnOffController</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
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
end OnOffController;
