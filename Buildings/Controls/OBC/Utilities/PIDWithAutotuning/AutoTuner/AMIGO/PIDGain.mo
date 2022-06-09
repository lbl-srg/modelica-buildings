within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo;
block PIDGain "Identifies the control gain of a PID controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput kp(min=1E-6)
    "Connector for the signal of the gain of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(min=0)
    "Connector for the signal of the time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(min=1E-6)
    "Connector for the signal of the time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Connector for control gain signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  CDL.Continuous.Divide div1 "1/kp"
    annotation (Placement(transformation(extent={{-38,40},{-18,60}})));
  CDL.Continuous.Sources.Constant const(k=1) "Constant parameter"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  CDL.Continuous.Divide div2 "T/L"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  CDL.Continuous.MultiplyByParameter gai1(k=0.45) "0.45T/L"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  CDL.Continuous.AddParameter
                          addPar(p=0.2) "0.2+0.45T/L"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Continuous.Multiply mul "1/kp+(0.2+0.45T/L)"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(div1.u2, kp) annotation (Line(points={{-40,44},{-94,44},{-94,60},{
          -120,60}}, color={0,0,127}));
  connect(const.y, div1.u1) annotation (Line(points={{-58,80},{-50,80},{-50,56},
          {-40,56}}, color={0,0,127}));
  connect(div2.u2, L) annotation (Line(points={{-62,-36},{-80,-36},{-80,-60},{
          -120,-60}}, color={0,0,127}));
  connect(div2.u1, T) annotation (Line(points={{-62,-24},{-80,-24},{-80,0},{
          -120,0}}, color={0,0,127}));
  connect(gai1.u, div2.y)
    annotation (Line(points={{-22,-30},{-38,-30}}, color={0,0,127}));
  connect(gai1.y, addPar.u)
    annotation (Line(points={{2,-30},{18,-30}}, color={0,0,127}));
  connect(mul.y, k) annotation (Line(points={{82,0},{110,0}}, color={0,0,127}));
  connect(div1.y, mul.u1) annotation (Line(points={{-16,50},{42,50},{42,6},{58,
          6}}, color={0,0,127}));
  connect(mul.u2, addPar.y) annotation (Line(points={{58,-6},{48,-6},{48,-30},{
          42,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
<p>This block calculates the control gain of a PID model, <i>k</i>, by</p>
<p>k = 1/k<sub>p</sub> + (0.2 + 0.45T/L)</p>
<p>where <i>k<sub>p</i></sub> is the gain of the first-order time-delayed model;</p>
<p><i>T</i> is the time constant of the first-order time-delayed model;</p>
<p><i>L</i> is the time delay of the first-order time-delayed model.</p>
<h4>References</h4>
<p>&Aring;str&ouml;m, Karl Johan, and Tore H&auml;gglund. &quot;Revisiting the Ziegler&ndash;Nichols step response method for PID control.&quot; Journal of process control 14.6 (2004): 635-650.</p>
</html>"));
end PIDGain;
