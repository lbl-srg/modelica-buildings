within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.FirstOrderTimedelayed;
block Gain "Identifies the gain of a first order time delayed model"
  parameter Real yHig(min=0) = 1
    "Higher value for the output";
  parameter Real yLow(min=0) = 0.5
    "Lower value for the output";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector for the response signal of a relay controller"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOn
    "Connector for a signal of the length for the On period"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
    iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput tOff
    "Connector for a signal of the length for the Off period"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
    iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput k
    "Connector for a output signal of the gain"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant highRealyOuput(k=yHig)
    "Higher value for the output"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowRealyOuput(k=yLow)
    "Lower value for the output"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul2 "product of tOn and yHig"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    "product of tOff and yLow"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add Iu
    "the integral of the relay output"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset Iy
    "the integral of the process output"
    annotation (Placement(transformation(extent={{-42,70},{-22,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant referenceRelayOutpit(k=0)
    "reference value of the relay control output"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide divIyIu "calculates the gain"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noReset(k=false)
    "disable the reset of Iy"
    annotation (Placement(transformation(extent={{28,40},{8,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Connector for trigger signal"
    annotation (Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-120}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={0,-120})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler sampIu(y_start=1)
    "sampling Iu when the tuning period ends"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
equation
  connect(mul2.y, Iu.u1) annotation (Line(points={{-18,20},{0,20},{0,-24},{8,-24}},
                color={0,0,127}));
  connect(mul1.y, Iu.u2) annotation (Line(points={{-18,-50},{0,-50},{0,-36},{8,-36}},
                    color={0,0,127}));
  connect(Iy.u, u) annotation (Line(points={{-44,80},{-120,80}},
        color={0,0,127}));
  connect(referenceRelayOutpit.y, Iy.y_reset_in) annotation (Line(points={{-58,60},
          {-52,60},{-52,72},{-44,72}}, color={0,0,127}));
  connect(divIyIu.u1, Iy.y) annotation (Line(points={{58,6},{40,6},{40,80},{-20,
          80}}, color={0,0,127}));
  connect(divIyIu.y, k) annotation (Line(points={{82,0},{110,0}}, color={0,0,127}));
  connect(noReset.y, Iy.trigger) annotation (Line(points={{6,50},{-32,50},{-32,68}}, color={255,0,255}));
  connect(mul1.u2, tOff) annotation (Line(points={{-42,-56},{-80,-56},{-80,-80},
          {-120,-80}}, color={0,0,127}));
  connect(mul1.u1, lowRealyOuput.y) annotation (Line(points={{-42,-44},{-52,-44},
          {-52,-30},{-58,-30}}, color={0,0,127}));
  connect(highRealyOuput.y, mul2.u1) annotation (Line(points={{-58,30},{-52,30},
          {-52,26},{-42,26}}, color={0,0,127}));
  connect(mul2.u2, tOn) annotation (Line(points={{-42,14},{-52,14},{-52,0},{-120,0}}, color={0,0,127}));
  connect(sampIu.u, Iu.y) annotation (Line(points={{38,-30},{32,-30}}, color={0,0,127}));
  connect(sampIu.y, divIyIu.u2) annotation (Line(points={{62,-30},{70,-30},{70,-14},
          {40,-14},{40,-6},{58,-6}}, color={0,0,127}));
  connect(sampIu.trigger, trigger) annotation (Line(points={{50,-42},{50,-80},{0,
          -80},{0,-120}}, color={255,0,255}));
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
<p>This block calculates the gain of a first-order time-delayed model, <i>k</i>, by</p>
<p>k = I<sub>y</sub>/I<sub>u</sub></p>
<p>where <i>I<sub>y</i></sub> and <i>I<sub>u</i></sub> are the integral of the process output and the integral of the relay output, respectively.</p>
<p><i>I<sub>y</i></sub> is calculated by </p>
<p>I<sub>y</sub> = &int; u(t) dt;</p>
<p>where <i>u</i> is the process output.</p>
<p><i>I<sub>u</i></sub> is calculated by </p>
<p>I<sub>u</sub> = t<sub>on</sub>  y<sub>hig</sub> + t<sub>off</sub>  y<sub>low</sub>;</p>
<p>where <i>y<sub>hig</sub></i> and <i>y<sub>low</sub></i> are the higher value and the lower value of the relay control output, respectively.</p>
<p><i>t<sub>on</sub></i> and <i>t<sub>off</sub></i> are the length of the On period and the Off period, respectively.</p>
<h4>References</h4>
<p>
Josefin Berner (2017).
\"Automatic Controller Tuning using Relay-based Model Identification.\"
Department of Automatic Control, Lund Institute of Technology, Lund University.
</p>
</html>"));
end Gain;
