within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses;
block PIGain "Identify the control gain of a PI controller"
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
    annotation (Placement(transformation(extent={{-140,-96},{-100,-56}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Control gain of a PI controller"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Calculate the sum of the time constant and the time delay"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Calculate the sum of the two inputs"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(final k=0.35)
    "Constant value"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const2(final k=0.15)
    "Constant value"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Block that calculates input 1 divided by input 2"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div2
    "Block that calculates input 1 divided by input 2"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div3
    "Block that calculates input 1 divided by input 2"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul4
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Block that calculates the difference between the two inputs"
    annotation (Placement(transformation(extent={{60,-54},{80,-34}})));

equation
  connect(div1.u2, kp) annotation (Line(points={{-42,44},{-80,44},{-80,60},{
          -120,60}}, color={0,0,127}));
  connect(add2.u1, div1.y) annotation (Line(points={{18,36},{0,36},{0,50},{-18,
          50}},     color={0,0,127}));
  connect(add1.u1, T) annotation (Line(points={{-62,-24},{-90,-24},{-90,0},{
          -120,0}}, color={0,0,127}));
  connect(add1.u2, L) annotation (Line(points={{-62,-36},{-80,-36},{-80,-76},{
          -120,-76}}, color={0,0,127}));
  connect(mul4.u1, T) annotation (Line(points={{-62,-64},{-90,-64},{-90,0},{-120,
          0}}, color={0,0,127}));
  connect(mul4.u2, L) annotation (Line(points={{-62,-76},{-120,-76}},
                 color={0,0,127}));
  connect(mul1.u1, add1.y) annotation (Line(points={{-22,-24},{-32,-24},{-32,
          -30},{-38,-30}}, color={0,0,127}));
  connect(mul1.u2, add1.y) annotation (Line(points={{-22,-36},{-32,-36},{-32,
          -30},{-38,-30}}, color={0,0,127}));
  connect(div2.u2, mul1.y) annotation (Line(points={{18,-56},{10,-56},{10,-30},
          {2,-30}}, color={0,0,127}));
  connect(div2.u1, mul4.y) annotation (Line(points={{18,-44},{-20,-44},{-20,-70},
          {-38,-70}}, color={0,0,127}));
  connect(mul2.u1, kp) annotation (Line(points={{-62,26},{-80,26},{-80,60},{
          -120,60}}, color={0,0,127}));
  connect(mul2.u2, L) annotation (Line(points={{-62,14},{-80,14},{-80,-76},{
          -120,-76}}, color={0,0,127}));
  connect(div3.u2, mul2.y) annotation (Line(points={{-22,4},{-30,4},{-30,20},{
          -38,20}},  color={0,0,127}));
  connect(div3.u1, T) annotation (Line(points={{-22,16},{-34,16},{-34,0},{-120,
          0}}, color={0,0,127}));
  connect(mul3.u1, div3.y) annotation (Line(points={{18,6},{10,6},{10,10},{2,10}}, color={0,0,127}));
  connect(const2.y, div1.u1) annotation (Line(points={{-58,80},{-50,80},{-50,56},
          {-42,56}}, color={0,0,127}));
  connect(add2.u2, mul3.y) annotation (Line(points={{18,24},{10,24},{10,16},{48,
          16},{48,0},{42,0}}, color={0,0,127}));
  connect(add2.y, k) annotation (Line(points={{42,30},{60,30},{60,0},{120,0}},
        color={0,0,127}));
  connect(div2.y, sub.u2) annotation (Line(points={{42,-50},{58,-50}},
                    color={0,0,127}));
  connect(const1.y, sub.u1) annotation (Line(points={{22,-80},{50,-80},{50,-38},
          {58,-38}}, color={0,0,127}));
  connect(sub.y, mul3.u2) annotation (Line(points={{82,-44},{90,-44},{90,-22},{
          10,-22},{10,-6},{18,-6}}, color={0,0,127}));

annotation (defaultComponentName = "PIGai",
        Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-154,148},{146,108}},
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
<p>This block calculates the control gain of a PI model, <i>k</i></p>
<h4>Main equations</h4>
<p>
The main equation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
k = 0.15/k<sub>p</sub> + (0.35-LT/(L+T)<sup>2</sup>)(T/k<sub>p</sub>/L),
</p>
<p>
where <code>k<sub>p</sub></code> is the gain of the first-order time-delayed model,
<code>T</code> is the time constant of the first-order time-delayed model, and
<code>L</code> is the time delay of the first-order time-delayed model.
</p>
<h4>References</h4>
<p>
Garpinger, Olof, Tore Hägglund, and Karl Johan Åström (2014)
\"Performance and robustness trade-offs in PID control.\"
Journal of Process Control 24.5 (2014): 568-577.
</p>
</html>"));
end PIGain;
