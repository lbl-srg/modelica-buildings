within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MultiplyByParameter "Validation model for the Gain block"
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gain1(k=2.5)
    "Block that outputs the product of a gain value with the input signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=2)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp1.y,gain1.u)
    annotation (Line(points={{-38,0},{-12,0}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MultiplyByParameter.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter\">
Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter</a>.
</p>
<p>
The input <code>u</code> varies from <i>0.0</i> to <i>+2</i>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from Gain to MultiplyByParameter.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
March 20, 2017, by Jianjun Hu:<br/>
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
end MultiplyByParameter;
