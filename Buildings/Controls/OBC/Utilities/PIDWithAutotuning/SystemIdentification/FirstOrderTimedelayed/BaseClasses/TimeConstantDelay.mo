within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.BaseClasses;
block TimeConstantDelay
  "Calculate the time constant and the time delay of a first order time delayed model"
  parameter Real yHig(min=1E-6)
    "Higher value for the output (assuming the reference output is 0)";
  parameter Real yLow(min=1E-6)
    "Lower value for the output (assuming the reference output is 0)";
  parameter Real deaBan(min=1E-6)
    "Deadband for holding the output value";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Length for the on period"
    annotation (Placement(transformation(extent={{-220,100},{-180,140}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput k
    "Gain"
    annotation (Placement(transformation(extent={{-220,-10},{-180,30}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput rat
    "Ratio between the time constant and the time delay"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput T(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time constant"
    annotation (Placement(transformation(extent={{180,90},{220,130}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput L(
    final quantity="Time",
    final unit="s",
    min=100*Buildings.Controls.OBC.CDL.Constants.eps)
    "Time delay"
    annotation (Placement(transformation(extent={{180,-10},{220,30}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput triFai
    "True when an error occurs in the autotuning process"
    annotation (Placement(transformation(extent={{180,-150},{220,-110}}),
    iconTransformation(extent={{100,-100},{140,-60}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Abs absk
    "Absoulte value of the gain"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Exp exp
    "Exponential value of the ratio between time constant and the time delay"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yHigSig(
    final k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yLowSig(
    final k=yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant relDeaBan(
    final k=deaBan)
    "Dead band of the relay controller"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Add add1
    "Sum of the inputs"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    "Sum of the higher value for the output and the lower value for the output"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    "Quotient of deadband divided by the absolute value of the gain"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div2
    "Blocks that calculates input 1 by input 2"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div3
    "Blocks that calculates the time constant"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul1 "Product of the two inputs"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul2
    "Blocks that calculates time delay"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub1
    "Blocks that calculates the difference of the two inputs"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub2
    "Blocks that calculates the difference of the two inputs"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Log log
    "Natural logarithm of the input"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre1(final h=1e-6)
    "Check if the input is less than 0"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Avoid a negative input for the log function"
    annotation (Placement(transformation(extent={{-82,-100},{-62,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "True when an negative input is given for the log function"
    annotation (Placement(transformation(extent={{102,-140},{122,-120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(final k=1e-6)
    "Constant"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=-1)
    "Opposite of the input"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
equation
  connect(absk.u, k)
    annotation (Line(points={{-162,10},{-200,10}},
                                                color={0,0,127}));
  connect(rat, exp.u)
    annotation (Line(points={{-200,-60},{-162,-60}},color={0,0,127}));
  connect(relDeaBan.y, div1.u1) annotation (Line(points={{-78,10},{-40,10},{-40,
          -4},{-22,-4}},
                      color={0,0,127}));
  connect(sub2.u1, div1.y) annotation (Line(points={{38,-24},{10,-24},{10,-10},{
          2,-10}},  color={0,0,127}));
  connect(sub2.u2, yLowSig.y) annotation (Line(points={{38,-36},{-70,-36},{-70,70},
          {-78,70}}, color={0,0,127}));
  connect(yHigSig.y, add2.u1) annotation (Line(points={{-138,70},{-130,70},{-130,
          46},{-62,46}}, color={0,0,127}));
  connect(add2.u2, yLowSig.y) annotation (Line(points={{-62,34},{-70,34},{-70,70},
          {-78,70}},color={0,0,127}));
  connect(add2.y, mul1.u2) annotation (Line(points={{-38,40},{0,40},{0,54},{38,54}},
          color={0,0,127}));
  connect(exp.y, mul1.u1) annotation (Line(points={{-138,-60},{-30,-60},{-30,66},
          {38,66}}, color={0,0,127}));
  connect(sub2.y, add1.u2) annotation (Line(points={{62,-30},{70,-30},{70,-16},{
          78,-16}}, color={0,0,127}));
  connect(add1.u1, mul1.y) annotation (Line(points={{78,-4},{70,-4},{70,60},{62,
          60}}, color={0,0,127}));
  connect(sub1.y, div2.u2) annotation (Line(points={{62,-80},{80,-80},{80,-76},{
          118,-76}}, color={0,0,127}));
  connect(div2.u1, add1.y) annotation (Line(points={{118,-64},{110,-64},{110,-10},
          {102,-10}}, color={0,0,127}));
  connect(tOn, div3.u1) annotation (Line(points={{-200,120},{-140,120},{-140,116},
          {38,116}}, color={0,0,127}));
  connect(div3.y, T) annotation (Line(points={{62,110},{200,110}},
        color={0,0,127}));
  connect(mul2.u2, T) annotation (Line(points={{98,124},{80,124},{80,110},{200,110}},
          color={0,0,127}));
  connect(mul2.u1, exp.u) annotation (Line(points={{98,136},{-170,136},{-170,-60},
          {-162,-60}}, color={0,0,127}));
  connect(mul2.y, L) annotation (Line(points={{122,130},{130,130},{130,10},{200,
          10}},  color={0,0,127}));
  connect(sub1.u2, div1.y) annotation (Line(points={{38,-86},{10,-86},{10,-10},{
          2,-10}}, color={0,0,127}));
  connect(absk.y, div1.u2) annotation (Line(points={{-138,10},{-110,10},{-110,-16},
          {-22,-16}},color={0,0,127}));
  connect(yHigSig.y, sub1.u1) annotation (Line(points={{-138,70},{-130,70},{-130,
          -74},{38,-74}}, color={0,0,127}));
  connect(log.y, div3.u2) annotation (Line(points={{-18,-90},{20,-90},{20,104},{
          38,104}}, color={0,0,127}));
  connect(div2.y, max1.u1) annotation (Line(points={{142,-70},{150,-70},{150,-50},
          {-90,-50},{-90,-84},{-84,-84}},      color={0,0,127}));
  connect(log.u, max1.y)
    annotation (Line(points={{-42,-90},{-60,-90}},   color={0,0,127}));
  connect(gre1.u2, div2.y) annotation (Line(points={{38,-138},{-90,-138},{-90,-50},
          {150,-50},{150,-70},{142,-70}},      color={0,0,127}));
  connect(con.y, max1.u2) annotation (Line(points={{-138,-110},{-120,-110},{-120,
          -96},{-84,-96}},   color={0,0,127}));
  connect(gre1.y, edg.u)
    annotation (Line(points={{62,-130},{100,-130}}, color={255,0,255}));
  connect(edg.y, triFai)
    annotation (Line(points={{124,-130},{200,-130}}, color={255,0,255}));
  connect(gre1.u1, gai.y) annotation (Line(points={{38,-130},{20,-130},{20,-120},
          {2,-120}},    color={0,0,127}));
  connect(gai.u, con.y) annotation (Line(points={{-22,-120},{-120,-120},{-120,-110},
          {-138,-110}}, color={0,0,127}));
  annotation (
        defaultComponentName = "timConDel",
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255})}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,
            -160},{180,160}})),
    Documentation(revisions="<html>
<ul>
<li>
March 8, 2024, by Michael Wetter:<br/>
Changed deadband to be consistent within the package.
</li>
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
where <i>y<sub>hig</sub></i> and <i>y<sub>low</sub></i> are constants related to
an asymmetric relay output.
<code>t<sub>on</sub></code> is the length of the on period of the same asymmetric relay output.
<code>&delta;</code> is the dead band of the same asymmetric relay output.
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
