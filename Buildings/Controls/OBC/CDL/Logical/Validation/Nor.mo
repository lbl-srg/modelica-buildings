within Buildings.Controls.OBC.CDL.Logical.Validation;
model Nor
  "Validation model for the Nor block"
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.5,
    period=1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,8},{-6,28}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    width=0.5,
    period=5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-26},{-6,-6}})));
  Buildings.Controls.OBC.CDL.Logical.Nor nor1
    "Outputs true if none of the inputs is true, otherwise outputs false"
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(booPul2.y,nor1.u2)
    annotation (Line(points={{-4,-16},{8,-16},{8,-6},{24,-6}},color={255,0,255}));
  connect(booPul1.y,nor1.u1)
    annotation (Line(points={{-4,18},{10,18},{10,2},{24,2}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/Nor.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Nor\">
Buildings.Controls.OBC.CDL.Logical.Nor</a>.
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
end Nor;
