within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses;
block PIDGain "Identify the control gain of a PID controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput kp(
    final min=1E-6)
    "Gain of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Control gain signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Block that calculates the inverse of the input gain"
    annotation (Placement(transformation(extent={{-40,56},{-20,76}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(
    final k=1)
    "Constant parameter"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter add(
    final p=0.2)
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div2
    "Block that calculates the ratio of the time constant to the time delay"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.45)
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(div1.u2, kp) annotation (Line(points={{-42,60},{-120,60}},
                     color={0,0,127}));
  connect(const.y, div1.u1) annotation (Line(points={{-58,80},{-50,80},{-50,72},
          {-42,72}}, color={0,0,127}));
  connect(div2.u2, L) annotation (Line(points={{-62,-36},{-80,-36},{-80,-60},{
          -120,-60}}, color={0,0,127}));
  connect(div2.u1, T) annotation (Line(points={{-62,-24},{-80,-24},{-80,0},{
          -120,0}}, color={0,0,127}));
  connect(gai1.u, div2.y)
    annotation (Line(points={{-22,-30},{-38,-30}}, color={0,0,127}));
  connect(gai1.y, add.u)
    annotation (Line(points={{2,-30},{18,-30}}, color={0,0,127}));
  connect(mul.y, k) annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(div1.y, mul.u1) annotation (Line(points={{-18,66},{48,66},{48,6},{58,
          6}}, color={0,0,127}));
  connect(mul.u2, add.y) annotation (Line(points={{58,-6},{48,-6},{48,-30},{42,
          -30}}, color={0,0,127}));
  annotation (defaultComponentName = "PIDGai",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>This block calculates the control gain of a PID model.</p>
<h4>Main equations</h4>
<p>
The main equation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = 1/k<sub>p</sub> + (0.2 + 0.45 T/L),
</p>
<p>
where <code>k<sub>p</sub></code> is the gain of the first-order time-delayed model,
<code>T</code> is the time constant of the first-order time-delayed model,
and <code>L</code> is the time delay of the first-order time-delayed model.
</p>
<h4>References</h4>
<p>
Åström, Karl Johan and Tore Hägglund  (2004) 
\"Revisiting the Ziegler–Nichols step response method for PID control.\"
Journal of process control 14.6 (2004): 635-650.
</p>
</html>"));
end PIDGain;
