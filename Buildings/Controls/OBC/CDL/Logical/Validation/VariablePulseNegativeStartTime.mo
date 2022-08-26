within Buildings.Controls.OBC.CDL.Logical.Validation;
model VariablePulseNegativeStartTime
  "Validation model for producing boolean pulse output, with a negative start time"

  Buildings.Controls.OBC.CDL.Logical.VariablePulse conTru(
    final samplePeriod=1.0,
    final period=4)
    "Variable pulse with zero pulse width"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse fal(
    final samplePeriod=1.0,
    final period=4)
    "Variable pulse with the zero width input"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse truFal(
    final samplePeriod=1.0,
    final period=4)
    "Variable pulse with width input changing from positive value to zero"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse falTru(
    final samplePeriod=1.0,
    final period=4)
    "Variable pulse with width input changing from zero to positive value"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul(
    final amplitude=0.65,
    final width=0.8,
    final period=20) "Continuous pulse signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.75)
    "Constant"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul1(
    final amplitude=0.65,
    final width=0.85,
    final period=20,
    final shift=2) "Continuous pulse signal"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse tru(
    final samplePeriod=1.0,
    final period=4)
    "Variable pulse with the constant width input"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    final k=1)
    "Constant value"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
equation
  connect(con.y, conTru.uWid)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
  connect(con1.y, fal.uWid)
    annotation (Line(points={{-18,80},{18,80}}, color={0,0,127}));
  connect(conPul.y, truFal.uWid)
    annotation (Line(points={{-18,-40},{18,-40}}, color={0,0,127}));
  connect(conPul1.y, falTru.uWid)
    annotation (Line(points={{-18,-80},{18,-80}}, color={0,0,127}));
  connect(con2.y, tru.uWid)
    annotation (Line(points={{-18,40},{18,40}}, color={0,0,127}));
annotation (experiment(
      StartTime=-20,
      StopTime=20,
      Tolerance=1e-06),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/VariablePulseNegativeStartTime.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.VariablePulse\">
Buildings.Controls.OBC.CDL.Logical.VariablePulse</a>.
</p>
<p>
This validates the blocks with a start time of <i>-20</i>.
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
end VariablePulseNegativeStartTime;
