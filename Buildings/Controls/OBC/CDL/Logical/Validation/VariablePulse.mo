within Buildings.Controls.OBC.CDL.Logical.Validation;
model VariablePulse "Validation model for producing boolean pulse output"

  Buildings.Controls.OBC.CDL.Logical.VariablePulse conTru(
    final samplePeriod=120,
    final period=900)
    "Variable pulse with zero pulse width"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse fal(
    final samplePeriod=120,
    final period=900)
    "Variable pulse with the zero width input"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse truFal(
    final samplePeriod=120,
    final period=900)
    "Variable pulse with width input changing from positive value to zero"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse falTru(
    final samplePeriod=120,
    final period=900)
    "Variable pulse with width input changing from zero to positive value"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul(
    final amplitude=0.65,
    final width=0.8,
    final period=3600)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.75)
    "Constant"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul1(
    final amplitude=0.65,
    final width=0.85,
    final period=3600,
    final shift=360)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse tru(
    final samplePeriod=120,
    final period=900)
    "Variable pulse with the constant width input"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=1)
    "Constant value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse falTru1(
    final samplePeriod=120,
    final period=900)
    "Variable pulse with width input changing from zero to positive value"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul2(
    final amplitude=0.5,
    final width=0.5,
    final period=3600,
    final shift=300,
    final offset=0.3)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
equation
  connect(con.y, conTru.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
  connect(con1.y, fal.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={0,0,127}));
  connect(conPul.y, truFal.u)
    annotation (Line(points={{42,60},{58,60}}, color={0,0,127}));
  connect(conPul1.y, falTru.u)
    annotation (Line(points={{42,0},{58,0}}, color={0,0,127}));
  connect(con2.y, tru.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={0,0,127}));
  connect(conPul2.y, falTru1.u)
    annotation (Line(points={{42,-60},{58,-60}}, color={0,0,127}));
annotation (experiment(
      StartTime=0,
      StopTime=3600,
      Tolerance=1e-06),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/VariablePulse.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.VariablePulse\">
Buildings.Controls.OBC.CDL.Logical.VariablePulse</a>.
</p>
<p>
This validates the blocks with a start time of <i>t=0</i> seconds.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 11, 2022, by Jianjun Hu:<br/>
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
end VariablePulse;
