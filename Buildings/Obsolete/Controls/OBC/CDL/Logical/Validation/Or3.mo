within Buildings.Obsolete.Controls.OBC.CDL.Logical.Validation;
model Or3 "Validation model for the Or3 block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.5,
    period=1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,26},{-6,46}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    width=0.5,
    period=3)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-8},{-6,12}})));
  Buildings.Obsolete.Controls.OBC.CDL.Logical.Or3 or1
    "Output true if at least one input is true"
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul3(
    width=0.5,
    period=5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-42},{-6,-22}})));

equation
  connect(booPul3.y,or1.u3)
    annotation (Line(points={{-4,-32},{8,-32},{8,-6},{24,-6}},color={255,0,255}));
  connect(booPul2.y,or1.u2)
    annotation (Line(points={{-4,2},{-4,2},{24,2}},color={255,0,255}));
  connect(booPul1.y,or1.u1)
    annotation (Line(points={{-4,36},{10,36},{10,10},{24,10}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Logical/Validation/Or3.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Logical.Or3\">
Buildings.Obsolete.Controls.OBC.CDL.Logical.Or3</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
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
end Or3;
