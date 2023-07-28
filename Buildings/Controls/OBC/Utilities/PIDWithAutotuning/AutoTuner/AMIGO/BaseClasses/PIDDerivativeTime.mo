within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses;
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
protected
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.3)
    "Block that calculates the product of a constant and the input"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.5)
    "Block that calculates the product of a constant and the input"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Block that calculates the product of the two inputs"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add
    "Block that calculates the sum of the two inputs"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Block that calculates input 1 divided by input 2"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(div.y, Td) annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(gai1.u, L) annotation (Line(points={{-62,-60},{-120,-60}},
          color={0,0,127}));
  connect(gai1.y, add.u2) annotation (Line(points={{-38,-60},{-20,-60},{-20,-46},
          {-2,-46}}, color={0,0,127}));
  connect(add.u1, T) annotation (Line(points={{-2,-34},{-80,-34},{-80,60},{-120,
          60}}, color={0,0,127}));
  connect(gai2.u, T) annotation (Line(points={{-62,60},{-120,60}}, color={0,0,127}));
  connect(mul.u2, L) annotation (Line(points={{-2,14},{-70,14},{-70,-60},{-120,-60}},
          color={0,0,127}));
  connect(gai2.y, mul.u1) annotation (Line(points={{-38,60},{-20,60},{-20,26},{-2,
          26}}, color={0,0,127}));
  connect(mul.y, div.u1) annotation (Line(points={{22,20},{40,20},{40,6},{58,6}},
        color={0,0,127}));
  connect(div.u2, add.y) annotation (Line(points={{58,-6},{40,-6},{40,-40},{22,-40}},
         color={0,0,127}));
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
<p>This block calculates the derivative time of a PID controller.</p>
<h4>Main equations</h4>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>d</sub> = 0.5 L T/(0.3 L + T),
</p>
<p>
where <code>T</code> is the time constant of the first-order time delayed model
and <code>L</code> is the time delay of the first-order time delayed model.
</p>
<h4>References</h4>
<p>
Åström, Karl Johan and Tore Hägglund  (2004) 
\"Revisiting the Ziegler–Nichols step response method for PID control.\"
Journal of process control 14.6 (2004): 635-650.
</p>
</html>"));
end PIDDerivativeTime;
