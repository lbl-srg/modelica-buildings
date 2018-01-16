within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MovingMean "Validation model for the MovingMean block"
  Modelica.Blocks.Sources.Sine sinInpNoDel(freqHz=1/80)
    "Start from zero second"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_1(delta=100)
    "Moving average with 100 s sliding window"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_2(delta=200)
    "Moving average with 200 s sliding window"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_3(delta=300)
    "Moving average with 300 s sliding window"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_4(delta=400)
    "Moving average with 400 s sliding window"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_5(delta=500)
    "Moving average with 500 s sliding window"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Modelica.Blocks.Sources.Sine sinInp50sDel(freqHz=1/80, startTime=50)
    "Start from 50 seconds"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_6(
    delta=100) "Moving average with 100 s sliding window"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_7(
    delta=200) "Moving average with 200 s sliding window"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Blocks.Sources.Sine sinInp100sDel(freqHz=1/80, startTime=100)
    "Start from 100 seconds"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_8(
    delta=100) "Moving average with 100 s sliding window"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean movingMean_9(
    delta=200) "Moving average with 200 s sliding window"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(sinInpNoDel.y, movingMean_3.u) annotation (Line(points={{-69,60},{-60,
          60},{-60,0},{-42,0}}, color={0,0,127}));
  connect(sinInpNoDel.y, movingMean_1.u)
    annotation (Line(points={{-69,60},{-42,60}},          color={0,0,127}));
  connect(sinInpNoDel.y, movingMean_2.u) annotation (Line(points={{-69,60},{-60,
          60},{-60,30},{-42,30}},          color={0,0,127}));
  connect(sinInpNoDel.y, movingMean_5.u) annotation (Line(points={{-69,60},{-60,
          60},{-60,-60},{-42,-60}}, color={0,0,127}));
  connect(sinInpNoDel.y, movingMean_4.u) annotation (Line(points={{-69,60},{-60,
          60},{-60,-30},{-42,-30}}, color={0,0,127}));
  connect(sinInp50sDel.y, movingMean_6.u)
    annotation (Line(points={{21,60},{21,60},{58,60}}, color={0,0,127}));
  connect(sinInp50sDel.y, movingMean_7.u) annotation (Line(points={{21,60},{21,60},
          {40,60},{40,30},{58,30}}, color={0,0,127}));
  connect(sinInp100sDel.y, movingMean_9.u) annotation (Line(points={{21,-20},{21,
          -20},{40,-20},{40,-50},{58,-50}}, color={0,0,127}));
  connect(sinInp100sDel.y, movingMean_8.u)
    annotation (Line(points={{21,-20},{58,-20}}, color={0,0,127}));
  annotation (experiment(StopTime=900.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MovingMean.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MovingMean\">
Buildings.Controls.OBC.CDL.Continuous.MovingMean</a>.
</p>
<p>
The input <code>sinInpNoDel</code>,  <code>sinInp50sDel</code>,
<code>sinInp100sDel</code>,  generate sine outputs with same frequency of
<code>1/80 Hz</code>, but different start times of <code>0 second</code>,
<code>50 second</code>, <code>100 second</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2017, by Jianjun Hu:<br/>
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
end MovingMean;
