within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MatrixGain "Validation model for the MatrixGain block"

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai(
    K=[1,0; 1,1; 1,2])
    "Block that outputs the product of a matrix gain value with the input signal"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

  Buildings.Controls.OBC.CDL.Continuous.MatrixGain matGai1(
    K=[1,2; 3,4])
    "Block that outputs the product of a matrix gain value with the input signal"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));


  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp(
    duration=1,
    offset=0,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Sources.Ramp ramp2(
    duration=1,
    offset=0,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

equation
  connect(ramp2.y, matGai1.u[2]) annotation (Line(points={{-19,-60},{0,-60},{0,-40},
          {18,-40}}, color={0,0,127}));
  connect(ramp1.y, matGai1.u[1]) annotation (Line(points={{-19,-20},{0,-20},{0,-40},
          {18,-40}},          color={0,0,127}));
  connect(ramp.y, matGai.u[1])
    annotation (Line(points={{-19,40},{18,40}}, color={0,0,127}));
  connect(ramp.y, matGai.u[2])
    annotation (Line(points={{-19,40},{18,40}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MatrixGain.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MatrixGain\">
Buildings.Controls.OBC.CDL.Continuous.MatrixGain</a>.
</p>
<p>
The input vector output two identical values <code>u[1]</code> and 
<code>u[2]</code> that vary from <i>0.0</i> to <i>+2</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 11, 2019, by Milica Grahovac:<br/>
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
end MatrixGain;
