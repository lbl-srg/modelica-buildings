within Buildings.Controls.OBC.CDL.Logical;
block HysteresisWithHold
  "Hysteresis block that optionally allows to specify a hold time"

  parameter Real uLow "if y=true and u<=uLow, switch to y=false";
  parameter Real uHigh "if y=false and u>=uHigh, switch to y=true";

  parameter Modelica.SIunits.Time trueHoldDuration
    "true hold duration";

  parameter Modelica.SIunits.Time falseHoldDuration = trueHoldDuration
    "false hold duration";

  Controls.OBC.CDL.Interfaces.RealInput u "Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Controls.OBC.CDL.Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{220,-10},{240,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of state graph"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.StateGraph.InitialStep initialStep(
    nOut=2,
    nIn=0)
    "Initial state"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.StateGraph.TransitionWithSignal toTrue1 "Transition to true"
    annotation (Placement(transformation(extent={{10,80},{30,100}})));
  Modelica.StateGraph.TransitionWithSignal toFalse1 "Transition to false"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Not not1 "Negation of input"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Hysteresis hysteresis(
    final uLow=uLow,
    final uHigh=uHigh)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.StateGraph.StepWithSignal outputTrue(nIn=2)
    "State with true output signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Modelica.StateGraph.StepWithSignal outputFalse(nIn=2)
    "State for which the block outputs false"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.StateGraph.TransitionWithSignal toTrue "Transition to true"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.StateGraph.TransitionWithSignal toFalse "Transition to false"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Timer timer "Timer for false output"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  GreaterEqualThreshold greEquThr(final threshold=falseHoldDuration)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  And and1 "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Timer timer1  "Timer for true output"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  GreaterEqualThreshold greEquThr1(final threshold=trueHoldDuration)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
  And and2 "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{160,-60},{180,-40}})));

initial equation
  assert(uLow < uHigh, "Require uLow < uHigh. Check parameter values.");

equation
  connect(initialStep.outPort[1], toTrue1.inPort)
    annotation (Line(points={{-19.5,90.25},{-2,90},{16,90}},  color={0,0,0}));
  connect(initialStep.outPort[2], toFalse1.inPort) annotation (Line(points={{-19.5,
          89.75},{-12,89.75},{-12,70},{-4,70}},  color={0,0,0}));
  connect(u, hysteresis.u)
    annotation (Line(points={{-120,0},{-82,0}}, color={0,0,127}));
  connect(hysteresis.y, not1.u) annotation (Line(points={{-59,0},{-50,0},{-50,50},
          {-42,50}}, color={255,0,255}));
  connect(not1.y, toFalse1.condition)
    annotation (Line(points={{-19,50},{0,50},{0,58}}, color={255,0,255}));
  connect(hysteresis.y, toTrue1.condition) annotation (Line(points={{-59,0},{-50,
          0},{-50,32},{20,32},{20,78}}, color={255,0,255}));
  connect(toFalse1.outPort, outputFalse.inPort[1]) annotation (Line(points={{1.5,
          70},{10,70},{10,0.5},{19,0.5}}, color={0,0,0}));
  connect(outputFalse.outPort[1], toTrue.inPort)
    annotation (Line(points={{40.5,0},{48.25,0},{56,0}}, color={0,0,0}));
  connect(toTrue.outPort, outputTrue.inPort[1]) annotation (Line(points={{61.5,0},
          {70,0},{70,0.5},{79,0.5}}, color={0,0,0}));
  connect(outputTrue.outPort[1], toFalse.inPort)
    annotation (Line(points={{100.5,0},{116,0}}, color={0,0,0}));
  connect(toTrue1.outPort, outputTrue.inPort[2]) annotation (Line(points={{21.5,
          90},{46,90},{70,90},{70,-0.5},{79,-0.5}}, color={0,0,0}));
  connect(toFalse.outPort, outputFalse.inPort[2]) annotation (Line(points={{121.5,
          0},{140,0},{140,20},{12,20},{12,-0.5},{19,-0.5}}, color={0,0,0}));
  connect(timer.y, greEquThr.u)
    annotation (Line(points={{-39,-50},{-22,-50}}, color={0,0,127}));
  connect(greEquThr.y, and1.u1)
    annotation (Line(points={{1,-50},{18,-50}}, color={255,0,255}));
  connect(hysteresis.y, and1.u2) annotation (Line(points={{-59,0},{-50,0},{-50,-16},
          {-80,-16},{-80,-80},{10,-80},{10,-58},{18,-58}}, color={255,0,255}));
  connect(outputFalse.active, timer.u) annotation (Line(points={{30,-11},{30,-20},
          {-76,-20},{-76,-50},{-62,-50}}, color={255,0,255}));
  connect(and1.y, toTrue.condition) annotation (Line(points={{41,-50},{50,-50},{
          60,-50},{60,-12}}, color={255,0,255}));
  connect(outputTrue.active, timer1.u) annotation (Line(points={{90,-11},{90,-11},
          {90,-20},{64,-20},{64,-50},{78,-50}}, color={255,0,255}));
  connect(timer1.y, greEquThr1.u)
    annotation (Line(points={{101,-50},{118,-50}}, color={0,0,127}));
  connect(greEquThr1.y, and2.u1)
    annotation (Line(points={{141,-50},{158,-50}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-19,50},{-19,50},{200,50},{
          200,-80},{150,-80},{150,-58},{158,-58}}, color={255,0,255}));
  connect(and2.y, toFalse.condition) annotation (Line(points={{181,-50},{190,-50},
          {190,-24},{120,-24},{120,-12}}, color={255,0,255}));
  connect(outputTrue.active, y) annotation (Line(points={{90,-11},{90,-20},{180,
          -20},{180,0},{230,0}},      color={255,0,255}));
  annotation (defaultComponentName="hysWitHol",
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{220,120}})),
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-66,-40},{62,-82}},
          lineColor={0,0,0},
          textString="%uLow     %uHigh"),
          Polygon(
            points={{-22,8},{-10,2},{-22,-4},{-22,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Line(points={{-48,2},{-16,2}}),
          Line(points={{-10,34},{-10,-36}}),
          Line(points={{-18,2},{18,2}}),
          Polygon(
            points={{12,8},{24,2},{12,-4},{12,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(extent={{24,18},{62,-16}}, lineColor={0,0,0}),
          Rectangle(extent={{-86,18},{-48,-16}}, lineColor={0,0,0}),
        Text(
          extent={{-140,148},{160,108}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}),
Documentation(info="<html>
<p>
Model for a hysteresis block that optionally allows to specify a hold time.
During the hold time, the output is not allowed to switch.
</p>
<p>
When the input <code>u</code> becomes greater than <code>uHigh</code>, the
output <code>y</code> becomes <code>true</code> and remains <code>true</code>
for at least <code>trueHoldDuration</code> seconds, after which time it is allowed
to switch immediately.
</p>
<p>
When the input <code>u</code> becomes less than <code>uLow</code>, the output
<code>y</code> becomes <code>false</code> and remains <code>false</code> for
at least <code>falseHoldDuration</code> seconds, after which time it is allowed
to switch immediately.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/HysteresisWithHold.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
This model for example could be used to disable an economizer, and not re-enable
it for <i>10</i> minutes, and vice versa. Using hysteresis can avoid the
distraction from the input noise.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HysteresisWithHold;
