within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO;
block PIDDerivativeTime "Identify the derivative time of a PID controller"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay of a first order time-delayed model"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Td(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant signal for the derivative term"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.3)
    "Calculate the product of 0.3 and the time delay"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.5)
    "Calculate the product of 0.5 and the input time constant"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Calculate the product of the output of gai2 and the input time constant"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Calculate the sum of the output of gai1 and the input time constant"
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Calculate the output of mul divided by the output of add"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(div.y, Td) annotation (Line(points={{42,0},{120,0}}, color={0,0,127}));
  connect(gai1.u, L) annotation (Line(points={{-82,-60},{-96,-60},{-96,-60},{-120,
          -60}},      color={0,0,127}));
  connect(gai1.y, add.u2) annotation (Line(points={{-58,-60},{-42,-60}},
                      color={0,0,127}));
  connect(add.u1, T) annotation (Line(points={{-42,-48},{-48,-48},{-48,60},{
          -120,60}}, color={0,0,127}));
  connect(gai2.u, T) annotation (Line(points={{-82,40},{-90,40},{-90,60},{-120,
          60}}, color={0,0,127}));
  connect(mul.u2, L) annotation (Line(points={{-42,4},{-90,4},{-90,-60},{-120,
          -60}}, color={0,0,127}));
  connect(gai2.y, mul.u1) annotation (Line(points={{-58,40},{-52,40},{-52,16},{
          -42,16}}, color={0,0,127}));
  connect(mul.y, div.u1) annotation (Line(points={{-18,10},{2,10},{2,6},{18,6}},
        color={0,0,127}));
  connect(div.u2, add.y) annotation (Line(points={{18,-6},{12,-6},{12,-54},{-18,
          -54}}, color={0,0,127}));
  annotation (defaultComponentName = "PIDDerTim",
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
<p>This block calculates the derivative time of a PID model.</p>
<h4>Main equations</h4>
<p>
The main equations is
</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>d</sub> = 0.5 L T/(0.3 L + T),
</p>
<p>
where <code>T</code> is the time constant of the first-order time-delayed model
and <code>L</code> is the time delay of the first-order time-delayed model.
</p>
<h4>Validation</h4>
<p>
This block was validated analytically, see
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation.PIDDerivativeTime\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.Validation.PIDDerivativeTime</a>.
</p>
<h4>References</h4>
<p>
Åström, Karl Johan and Tore Hägglund  (2004) 
\"Revisiting the Ziegler–Nichols step response method for PID control.\"
Journal of process control 14.6 (2004): 635-650.
</p>
</html>"));
end PIDDerivativeTime;
