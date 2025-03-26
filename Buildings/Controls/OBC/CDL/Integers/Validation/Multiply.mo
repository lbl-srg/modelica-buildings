within Buildings.Controls.OBC.CDL.Integers.Validation;
model Multiply "Validation model for the Multiply block"
  Buildings.Controls.OBC.CDL.Integers.Multiply product
    "Block that outputs the product of the two inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[
      0,-1;
      0.3,0.5;
      0.5,0;
      0.7,1;
      1,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin1(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[
      0,0;
      0.35,1;
      0.55,0;
      0.7,1;
      1,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));

equation
  connect(reaToInt1.y,product.u1)
    annotation (Line(points={{2,20},{40,20},{40,6},{58,6}},color={255,127,0}));
  connect(reaToInt2.y,product.u2)
    annotation (Line(points={{2,-20},{40,-20},{40,-6},{58,-6}},color={255,127,0}));
  connect(timTabLin.y[1],reaToInt1.u)
    annotation (Line(points={{-58,20},{-22,20}},color={0,0,127}));
  connect(timTabLin1.y[1],reaToInt2.u)
    annotation (Line(points={{-58,-20},{-22,-20}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/Multiply.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.Multiply\">
Buildings.Controls.OBC.CDL.Integers.Multiply</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from Product to Multiply.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
September 26, 2017, by Thierry S. Nouidui:<br/>
Revised implementation for JModelica verification.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/939\">issue 939</a>.
</li>
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
end Multiply;
