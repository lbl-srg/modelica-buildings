within Buildings.Controls.OBC.CDL.Integers.Validation;
model MultiSum
  "Validation model for the block to find sum of multiple inputs"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Integers.MultiSum add1(nu=3)
    "Block that outputs the sum of the inputs"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-64,30},{-44,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation2
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-0.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-64,-10},{-44,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Truncation truncation3
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp3(
    duration=1,
    height=7.0,
    offset=-1.5)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(ramp1.y, truncation1.u)
    annotation (Line(points={{-43,40},{-22,40}}, color={0,0,127}));
  connect(ramp2.y, truncation2.u)
    annotation (Line(points={{-43,0},{-22,0}}, color={0,0,127}));
  connect(ramp3.y,truncation3. u)
    annotation (Line(points={{-39,-40},{-22,-40}}, color={0,0,127}));
  connect(truncation1.y, add1.u[1])
    annotation (Line(points={{1,40},{20,40},{20,4.66667},{38,4.66667}},
      color={255,127,0}));
  connect(truncation2.y, add1.u[2])
    annotation (Line(points={{1,0},{18,0},{18,0},{38,0}}, color={255,127,0}));
  connect(truncation3.y, add1.u[3])
    annotation (Line(points={{1,-40},{20,-40},{20,-4.66667},{38,-4.66667}},
      color={255,127,0}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Integers/Validation/MultiSum.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Integers.MultiSum\">
Buildings.Controls.OBC.CDL.Integers.MultiSum</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end MultiSum;
