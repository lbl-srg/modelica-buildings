within Buildings.Controls.OBC.CDL.Integers.Validation;
model GreaterEqualThreshold
  "Validation model for the GreaterEqualThreshold block"
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr(t=1)
    "Block output true if input is greater or equal to threshold value"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold intGreEquThr1(t=1,
    h=1)
    "Block output true if input is greater or equal to threshold value"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,-1; 0.3,0.5; 0.5,1.5; 0.6,0; 0.7,-2; 0.8,1; 1,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(reaToInt.y,intGreEquThr.u)
    annotation (Line(points={{22,0},{38,0}},color={255,127,0}));
  connect(reaToInt.y, intGreEquThr1.u)
    annotation (Line(points={{22,0},{30,0},{30,-40},{38,-40}}, color={255,127,0}));
  connect(timTabLin.y[1], reaToInt.u)
    annotation (Line(points={{-38,0},{-2,0}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/GreaterEqualThreshold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold\">
Buildings.Controls.OBC.CDL.Integers.GreaterEqualThreshold</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 27, 2022, by Jianjun Hu:<br/>
Added hysteresis.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2978\">issue 2978</a>.
</li>
<li>
August 30, 2017, by Jianjun Hu:<br/>
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
end GreaterEqualThreshold;
