within Buildings.Controls.OBC.CDL.Logical.Validation;
model VariablePulse
  "Validation model for producing boolean pulse output"

  Buildings.Controls.OBC.CDL.Logical.VariablePulse conTru(
    period=900) "Variable pulse with constant pulse width"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse fal(
    period=900)
    "Variable pulse with the zero width input"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse truFal(
    period=900)
    "Variable pulse with width input changing from positive value to zero"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse falTru(
    period=900)
    "Variable pulse with width input changing from zero to positive value"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse tru(
    period=900)
    "Variable pulse with the constant width input"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse falTru1(
    period=900)
    "Variable pulse with width input changing between different positive values"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul(
    amplitude=0.65,
    width=0.8,
    period=4000)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    k=0.75)
    "Constant"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    k=0)
    "Constant value"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul1(
    amplitude=0.65,
    width=0.85,
    period=3600,
    shift=360)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con2(
    k=1)
    "Constant value"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse conPul2(
    amplitude=0.5,
    width=0.5,
    period=3600,
    shift=360,
    offset=0.3)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.VariablePulse conChaWid(
    period=900)
    "Variable pulse with constantly changing pulse width "
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=0.8,
    duration=900,
    startTime=300)
    "Ramp input"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
equation
  connect(con.y, conTru.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={0,0,127}));
  connect(con1.y, fal.u)
    annotation (Line(points={{-58,60},{-42,60}}, color={0,0,127}));
  connect(conPul.y, truFal.u)
    annotation (Line(points={{42,60},{58,60}}, color={0,0,127}));
  connect(conPul1.y, falTru.u)
    annotation (Line(points={{42,20},{58,20}}, color={0,0,127}));
  connect(con2.y, tru.u)
    annotation (Line(points={{-58,20},{-42,20}}, color={0,0,127}));
  connect(conPul2.y, falTru1.u)
    annotation (Line(points={{42,-20},{58,-20}}, color={0,0,127}));
  connect(ram.y, conChaWid.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={0,0,127}));
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
<ul>
<li>
The instance <code>fal</code> has the constant <code>0</code> input. It gives
constant <code>false</code> output.
</li>
<li>
The instance <code>tru</code> has the constant <code>1</code> input. It gives
constant <code>true</code> output.
</li>
<li>
The instance <code>conTru</code> has the constant <code>0.75</code> input.
It gives the pulse output, with the width (75%).
</li>
<li>
The instance <code>truFal</code> has the input changing from <code>0.65</code>
to <code>0</code>. It outputs a pulse (with the width of 65%) and then changes
to constant <code>false</code>. 
</li>
<li>
The instance <code>falTru</code> has the input changing from <code>0</code>
to <code>0.65</code> and then back to <code>0</code>. It firstly outputs the constant
<code>false</code>, then a pulse (with the width of 65%) and finally back
to <code>false</code>.
</li>
<li>
The instance <code>falTru1</code> has the input changing from <code>0.3</code>
to <code>0.8</code> and then back to <code>0.3</code>. It firstly outputs a
pulse with the width of 30%, then a pulse with the width of 80%, and
finally a pulse with the width of 30% again. When the input changes, it gives
a new pulse immediately.
</li>
<li>
The instance <code>conChaWid</code> has a ramp input. It gives constant
<code>true</code> output when the input is ramping up.
</li>
</ul>
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
