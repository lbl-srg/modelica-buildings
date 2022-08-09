within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo;
block PIGain "Identifies the control gain of a PI controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput kp(min=1E-6)
    "Connector of gain of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(min=1E-6)
    "Connector of time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(min=1E-6)
    "Connector of time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Connector for control gain signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Calculates the sum of the time constant and the time delay"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Calculates the sume of the output of mul3 and the out put of div1"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const1(final k=0.35)
    "Constant parameter 1"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const2(final k=0.15)
    "Constant parameter 2"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Calculate 0.15 divided by the gain"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div2
    "Calculate the output of mul2 divided by the output of mul1"
    annotation (Placement(transformation(extent={{20,-40},{40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div3
    "Calculate the time constant divided by the output of mul2"
    annotation (Placement(transformation(extent={{-20,20},{0,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "Calculate the square value of the sum of the time constant and the time delay"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Calculate the product of the gain and the time delay"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul3
    "Calculate the product of the output of sub and the output of div3"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul4
    "Calculate the product of the time constant times the time delay"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub
    "Calculate the difference between 0.35 and the output of div2"
    annotation (Placement(transformation(extent={{50,-60},{70,-40}})));

equation
  connect(div1.u2, kp) annotation (Line(points={{-62,44},{-80,44},{-80,60},{
          -120,60}}, color={0,0,127}));
  connect(add2.u1, div1.y) annotation (Line(points={{18,36},{-20,36},{-20,50},{
          -38,50}}, color={0,0,127}));
  connect(add1.u1, T) annotation (Line(points={{-62,-24},{-80,-24},{-80,0},{
          -120,0}}, color={0,0,127}));
  connect(add1.u2, L) annotation (Line(points={{-62,-36},{-80,-36},{-80,-60},{
          -120,-60}}, color={0,0,127}));
  connect(mul4.u1, T) annotation (Line(points={{-62,-64},{-90,-64},{-90,0},{-120,
          0}}, color={0,0,127}));
  connect(mul4.u2, L) annotation (Line(points={{-62,-76},{-94,-76},{-94,-60},{-120,
          -60}}, color={0,0,127}));
  connect(mul1.u1, add1.y) annotation (Line(points={{-22,-24},{-32,-24},{-32,
          -30},{-38,-30}}, color={0,0,127}));
  connect(mul1.u2, add1.y) annotation (Line(points={{-22,-36},{-32,-36},{-32,
          -30},{-38,-30}}, color={0,0,127}));
  connect(div2.u2, mul1.y) annotation (Line(points={{18,-44},{8,-44},{8,-30},{2,
          -30}}, color={0,0,127}));
  connect(div2.u1, mul4.y) annotation (Line(points={{18,-56},{-20,-56},{-20,-70},
          {-38,-70}}, color={0,0,127}));
  connect(mul2.u1, kp) annotation (Line(points={{-62,26},{-72,26},{-72,44},{-80,
          44},{-80,60},{-120,60}}, color={0,0,127}));
  connect(mul2.u2, L) annotation (Line(points={{-62,14},{-72,14},{-72,-36},{-80,
          -36},{-80,-60},{-120,-60}}, color={0,0,127}));
  connect(div3.u2, mul2.y) annotation (Line(points={{-22,16},{-30,16},{-30,20},
          {-38,20}}, color={0,0,127}));
  connect(div3.u1, T) annotation (Line(points={{-22,4},{-52,4},{-52,0},{-120,0}},
        color={0,0,127}));
  connect(mul3.u1, div3.y) annotation (Line(points={{18,6},{10,6},{10,10},{2,10}}, color={0,0,127}));
  connect(const2.y, div1.u1) annotation (Line(points={{-78,80},{-68,80},{-68,56},
          {-62,56}},                   color={0,0,127}));
  connect(add2.u2, mul3.y) annotation (Line(points={{18,24},{10,24},{10,16},{48,
          16},{48,0},{42,0}}, color={0,0,127}));
  connect(add2.y, k) annotation (Line(points={{42,30},{60,30},{60,0},{110,0}},
        color={0,0,127}));
  connect(div2.y, sub.u2)
  annotation (Line(points={{42,-50},{44,-50},{44,-56},{
          48,-56}}, color={0,0,127}));
  connect(const1.y, sub.u1) annotation (Line(points={{12,-80},{46,-80},{46,-44},
          {48,-44}}, color={0,0,127}));
  connect(sub.y, mul3.u2) annotation (Line(points={{72,-50},{80,-50},{80,-22},{
          10,-22},{10,-6},{18,-6}}, color={0,0,127}));
  annotation (defaultComponentName = "PIGain",
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
<p align=\"center\" style=\"font-style:italic;\">
k = 0.15/k<sub>p</sub> + (0.35-LT/(L+T)<sup>2</sup>)(T/k<sub>p</sub>/L),
</p>
<p>
where <i>k<sub>p</i></sub> is the gain of the first-order time-delayed model;
</p>
<p><i>T</i> is the time constant of the first-order time-delayed model;</p>
<p><i>L</i> is the time delay of the first-order time-delayed model.</p>
<h4>Validation</h4>
<p>
This block was validated analytically, see
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.Validation.PIGain\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.Validation.PIGain</a>.
</p>
<h4>References</h4>
<p>Garpinger, Olof, Tore H&auml;gglund, and Karl Johan &Aring;str&ouml;m (2014) &quot;Performance and robustness trade-offs in PID control.&quot; Journal of Process Control 24.5 (2014): 568-577. </p>
</html>"));
end PIGain;
