within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses;
block TimeConstantDelay
  "Calculate the time constant and the time delay of a first order time delayed model"
  parameter Real yHig(min=1E-6) = 1
    "Higher value for the output (assuming the reference output is 0)";
  parameter Real yLow(min=1E-6) = 0.5
    "Lower value for the output (assuming the reference output is 0)";
  parameter Real deaBan(min=0) = 0.5
    "Deadband for holding the output value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the On period"
    annotation (Placement(transformation(extent={{-140,56},{-100,96}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput k
    "Gain"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rat
    "Ratio between the time constant and the time delay"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Abs absk
    "Absoulte value of the gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Exp exp
    "Exponential value of the ratio between time constant and the time delay"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yHigSig(k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yLowSig(k=yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant relDeaBan(k=deaBan)
    "Dead band of the relay controller"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Sum of the inputs"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Sum of the higher value for the output and the lower value for the output"
    annotation (Placement(transformation(extent={{34,0},{54,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Quotient of dead band divided by the absolute value of the gain"
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div2
    "Blocks that calculates input 1 by input 2"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide div3
    "Blocks that calculates the time constant"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1 "Product of the two inputs"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2
    "Blocks that calculates time delay"
    annotation (Placement(transformation(extent={{0,74},{20,94}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Blocks that calculates the difference of the two inputs"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Blocks that calculates the difference of the two inputs"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Log log
    "Natural logarithm of the input"
    annotation (Placement(transformation(extent={{-20,-100},{-40,-80}})));

equation
  connect(absk.u, k)
    annotation (Line(points={{-82,0},{-120,0}}, color={0,0,127}));
  connect(rat, exp.u)
    annotation (Line(points={{-120,-50},{-82,-50}}, color={0,0,127}));
  connect(relDeaBan.y, div1.u1) annotation (Line(points={{22,40},{28,40},{28,0},
          {-4,0},{-4,-14},{-2,-14}}, color={0,0,127}));
  connect(sub2.u1, div1.y) annotation (Line(points={{28,-34},{26,-34},{26,-20},{
          22,-20}}, color={0,0,127}));
  connect(sub2.u2, yLowSig.y) annotation (Line(points={{28,-46},{-12,-46},{-12,40},
          {-18,40}}, color={0,0,127}));
  connect(yHigSig.y, add2.u1) annotation (Line(points={{-58,40},{-52,40},{-52,16},
          {32,16}}, color={0,0,127}));
  connect(add2.u2, yLowSig.y) annotation (Line(points={{32,4},{-12,4},{-12,40},{
          -18,40}}, color={0,0,127}));
  connect(add2.y, mul1.u2) annotation (Line(points={{56,10},{72,10},{72,24},{54,
          24},{54,34},{58,34}}, color={0,0,127}));
  connect(exp.y, mul1.u1) annotation (Line(points={{-58,-50},{-8,-50},{-8,60},{
          52,60},{52,46},{58,46}}, color={0,0,127}));
  connect(sub2.y, add1.u2) annotation (Line(points={{52,-40},{54,-40},{54,-36},{
          58,-36}}, color={0,0,127}));
  connect(add1.u1, mul1.y) annotation (Line(points={{58,-24},{52,-24},{52,-6},{86,
          -6},{86,40},{82,40}}, color={0,0,127}));
  connect(sub1.y, div2.u2) annotation (Line(points={{42,-70},{48,-70},{48,-76},
          {58,-76}}, color={0,0,127}));
  connect(div2.u1, add1.y) annotation (Line(points={{58,-64},{54,-64},{54,-48},
          {84,-48},{84,-30},{82,-30}},color={0,0,127}));
  connect(tOn, div3.u1) annotation (Line(points={{-120,76},{-42,76}},
          color={0,0,127}));
  connect(div3.u2, log.y) annotation (Line(points={{-42,64},{-46,64},{-46,-90},{
          -42,-90}},  color={0,0,127}));
  connect(div3.y, T) annotation (Line(points={{-18,70},{120,70}},
        color={0,0,127}));
  connect(mul2.u2, T) annotation (Line(points={{-2,78},{-10,78},{-10,70},{120,
          70}}, color={0,0,127}));
  connect(mul2.u1, exp.u) annotation (Line(points={{-2,90},{-90,90},{-90,-50},{-82,
          -50}}, color={0,0,127}));
  connect(mul2.y, L) annotation (Line(points={{22,84},{92,84},{92,-60},{120,-60}},
        color={0,0,127}));
  connect(sub1.u2, div1.y) annotation (Line(points={{18,-76},{10,-76},{10,-34},
          {26,-34},{26,-20},{22,-20}},color={0,0,127}));
  connect(log.u, div2.y) annotation (Line(points={{-18,-90},{86,-90},{86,-70},{
          82,-70}}, color={0,0,127}));
  connect(absk.y, div1.u2) annotation (Line(points={{-58,0},{-20,0},{-20,-26},{
          -2,-26}},  color={0,0,127}));
  connect(yHigSig.y, sub1.u1) annotation (Line(points={{-58,40},{-52,40},{-52,
          -64},{18,-64}}, color={0,0,127}));
  annotation (
        defaultComponentName = "timConDel",
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
<p>
This block calculates the time constant and the time delay of a first-order time delayed model.
</p>
<h4>Main equations</h4>
<p>
The time constant, <code>T</code>, is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
T = t<sub>on</sub>/(ln((&delta;/|k|-y<sub>hig</sub>+exp(&tau;/(1 - &tau;))(y<sub>hig</sub> + y<sub>low</sub>))/(y<sub>hig</sub>-&delta;/|k|))),
</p>
<p>
where <code>y<sub>hig</sub></code> and <code>y<sub>low</sub></code> are the higher value
and the lower value of the relay control output, respectively.
<code>t<sub>on</sub></code> is the length of the On period.
<code>&delta;</code> is the dead band of a relay controller.
<code>k</code> is the gain of the first-order time delayed model.
<code>&tau;</code> is the normalized time delay.
</p>
<p>
The time delay, <code>L</code>, is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
L = T &tau;/(1 - &tau;),
</p>
<h4>References</h4>
<p>
Josefin Berner (2015).
\"Automatic Tuning of PID Controllers based on Asymmetric Relay Feedback.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.
</p>
</html>"));
end TimeConstantDelay;
