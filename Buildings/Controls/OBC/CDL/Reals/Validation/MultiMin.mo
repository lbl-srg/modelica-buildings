within Buildings.Controls.OBC.CDL.Reals.Validation;
model MultiMin
  "Validation model for the MultiMin block"
  parameter Integer sizOfVec=5
    "Size of the input vector";
  Buildings.Controls.OBC.CDL.Reals.MultiMin minVal(
    nin=sizOfVec)
    "Block that outputs the minimum element of the input vector"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con[sizOfVec](
    k={1,2,3,4,5})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));

equation
  for i in 1:sizOfVec loop
    connect(con[i].y,minVal.u[i])
      annotation (Line(points={{-37,0},{-24.5,0},{-12,0}},color={0,0,127}));
  end for;
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/MultiMin.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.MultiMin\">
Buildings.Controls.OBC.CDL.Reals.MultiMin</a>.
</p>
<p>
The input vector<code>con</code> has size <i>5</i> and its element values are <code>{1,2,3,4,5}</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
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
end MultiMin;
