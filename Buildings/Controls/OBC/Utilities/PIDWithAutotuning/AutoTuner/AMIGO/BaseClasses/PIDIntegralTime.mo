within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.AMIGO.BaseClasses;

block PIDIntegralTime "Identify the integral time of a PID controller"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Ti(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant signal for the integral term"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Block that calculates the sum of the time delay and the product of 0.1 and the input time constant"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Block that calculates the sum of the output of gai1 and the product of 0.8 and the input time constant"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div
    "Block that calculates the input 1 divided by the input 2"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=0.4)
    "Block that calculates the product of 0.4 and the time delay"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=0.8)
    "Block that calculates the product of 0.8 and the input time constant"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(
    final k=0.1)
    "Block that calculates the product of 0.1 and the input time constant"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Block that calculates the two inputs"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(gai1.u, L) annotation (Line(points={{-82,-10},{-90,-10},{-90,-60},{
          -120,-60}}, color={0,0,127}));
  connect(gai3.u, T) annotation (Line(points={{-82,20},{-90,20},{-90,60},{-120,
          60}}, color={0,0,127}));
  connect(gai2.u, T) annotation (Line(points={{-82,60},{-120,60}},
                color={0,0,127}));
  connect(gai1.y, add2.u2) annotation (Line(points={{-58,-10},{-30,-10},{-30,14},
          {-22,14}},       color={0,0,127}));
  connect(add2.u1, gai2.y) annotation (Line(points={{-22,26},{-30,26},{-30,60},
          {-58,60}}, color={0,0,127}));
  connect(add1.u2, L) annotation (Line(points={{-22,-36},{-90,-36},{-90,-60},{
          -120,-60}}, color={0,0,127}));
  connect(add1.u1, gai3.y) annotation (Line(points={{-22,-24},{-40,-24},{-40,20},
          {-58,20}}, color={0,0,127}));
  connect(div.y, mul.u1)
    annotation (Line(points={{42,0},{48,0},{48,6},{58,6}}, color={0,0,127}));
  connect(mul.u2, L) annotation (Line(points={{58,-6},{50,-6},{50,-60},{-120,
          -60}},
        color={0,0,127}));
  connect(mul.y, Ti)
    annotation (Line(points={{82,0},{120,0}}, color={0,0,127}));
  connect(div.u2, add1.y) annotation (Line(points={{18,-6},{10,-6},{10,-30},{2,
          -30}},color={0,0,127}));
  connect(div.u1, add2.y) annotation (Line(points={{18,6},{10,6},{10,20},{2,20}},
                 color={0,0,127}));
  annotation (defaultComponentName = "PIDIntTim",
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
<p>This block calculates the integral time of a PID model.</p>
<h4>Main equations</h4>
<p>
The main equation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>i</sub> = L (0.4 L + 0.8 T)/(L + 0.1 T),
</p>
<p>
where <code>T</code> is the time constant of the first-order time-delayed model
and <code>L</code> is the time delay of the first-order time-delayed model.
</p>
<h4>References</h4>
<p>
Åström, Karl Johan and Tore Hägglund  (2004) 
\"Revisiting the Ziegler–Nichols step response method for PID control.\"
Journal of process control 14.6 (2004): 635-650.
</p>
</html>"));
end PIDIntegralTime;
