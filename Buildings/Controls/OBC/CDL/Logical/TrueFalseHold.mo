within Buildings.Controls.OBC.CDL.Logical;
block TrueFalseHold
  "Block that holds an output signal for at least a specified duration"
  parameter Real trueHoldDuration(
    final quantity="Time",
    final unit="s")
    "true hold duration"
    annotation (Evaluate=true);
  parameter Real falseHoldDuration(
    final quantity="Time",
    final unit="s")=trueHoldDuration
    "false hold duration"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Boolean output signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDel1(
    delayTime=falseHoldDuration)
    if falseHoldDuration > 0
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDel2(
    delayTime=trueHoldDuration)
    if trueHoldDuration > 0
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of state graph"
    annotation (Placement(transformation(extent={{110,100},{130,120}})));
  Modelica.StateGraph.StepWithSignal outputFalse(
    nIn=if trueHoldDuration > 0 then 2 else 1,
    nOut=1)
    if falseHoldDuration > 0
    "State for which the block outputs false"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
  Modelica.StateGraph.TransitionWithSignal toTrue
    if falseHoldDuration > 0 and trueHoldDuration > 0
    "Transition to true"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not notU
    "Negation of input"
    annotation (Placement(transformation(extent={{-150,-90},{-130,-70}})));
  Modelica.StateGraph.StepWithSignal outputTrue(
    nIn=if falseHoldDuration > 0 then 2 else 1,
    nOut=1)
    if trueHoldDuration > 0
    "State with true output signal"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Modelica.StateGraph.TransitionWithSignal toFalse
    if trueHoldDuration > 0 and falseHoldDuration > 0
    "Transition to false"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    if trueHoldDuration > 0
    "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    if falseHoldDuration > 0
    "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Modelica.StateGraph.InitialStep initialStep(
    nOut=if trueHoldDuration > 0 and falseHoldDuration > 0 then 2 else 1,
    nIn=if trueHoldDuration > 0 and not(falseHoldDuration > 0) or not(trueHoldDuration > 0)
      and falseHoldDuration > 0 then 1 else 0)
    if trueHoldDuration > 0 or falseHoldDuration > 0
    "Initial state"
    annotation (Placement(transformation(extent={{-150,10},{-130,30}})));
  Modelica.StateGraph.TransitionWithSignal InitToTrue
    if trueHoldDuration > 0
    "Transition to true"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  Modelica.StateGraph.TransitionWithSignal InitToFalse
    if falseHoldDuration > 0 and trueHoldDuration > 0
    "Transition to false – Case where both true and false hold durations are not zero"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not zerTruHolNotZerFalHol
    if not(trueHoldDuration > 0) and falseHoldDuration > 0
    "Case where true hold duration is zero and false hold duration is not zero"
    annotation (Placement(transformation(extent={{110,50},{130,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal notZerTruHol
    if trueHoldDuration > 0
    "Case where true hold duration is not zero"
    annotation (Placement(transformation(extent={{110,-70},{130,-50}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal zerTruHolZerFalHol
    if not(trueHoldDuration > 0) and not(falseHoldDuration > 0)
    "Case where both true and false hold durations are zero"
    annotation (Placement(transformation(extent={{110,-10},{130,10}})));
  Modelica.StateGraph.TransitionWithSignal falseToInit
    if falseHoldDuration > 0 and not(trueHoldDuration > 0)
    "Transition to initial step"
    annotation (Placement(transformation(extent={{50,90},{70,110}})));
  Modelica.StateGraph.TransitionWithSignal trueToInit
    if trueHoldDuration > 0 and not(falseHoldDuration > 0)
    "Transition to initial step"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Modelica.StateGraph.TransitionWithSignal InitToFalse1
    if falseHoldDuration > 0 and not(trueHoldDuration > 0)
    "Transition to false – Case where only false hold duration is not zero"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
equation
  connect(outputTrue.outPort[1], toFalse.inPort)
    annotation (Line(points={{-9.5,-40},{40,-40},{40,-20},{56,-20}},color={0,0,0}));
  connect(outputFalse.outPort[1], toTrue.inPort)
    annotation (Line(points={{-29.5,80},{4,80},{4,80},{36,80}},color={0,0,0}));
  connect(outputTrue.active, onDel2.u)
    annotation (Line(points={{-20,-51},{-20,-80},{-12,-80}},color={255,0,255}));
  connect(notU.y, and2.u2)
    annotation (Line(points={{-128,-80},{-100,-80},{-100,-100},{20,-100},{20,-88},{28,-88}},
      color={255,0,255}));
  connect(and2.y, toFalse.condition)
    annotation (Line(points={{52,-80},{60,-80},{60,-32}},color={255,0,255}));
  connect(outputFalse.active, onDel1.u)
    annotation (Line(points={{-40,69},{-40,40},{-32,40}},color={255,0,255}));
  connect(u, and1.u2)
    annotation (Line(points={{-200,0},{0,0},{0,32},{8,32}},color={255,0,255}));
  connect(and1.y, toTrue.condition)
    annotation (Line(points={{32,40},{40,40},{40,68}},color={255,0,255}));
  connect(u, InitToTrue.condition)
    annotation (Line(points={{-200,0},{-170,0},{-170,-60},{-60,-60},{-60,-52}},
      color={255,0,255}));
  connect(InitToTrue.outPort, outputTrue.inPort[1])
    annotation (Line(points={{-58.5,-40},{-31,-40}},color={0,0,0}));
  connect(InitToFalse.outPort, outputFalse.inPort[1])
    annotation (Line(points={{-78.5,80},{-51,80}},color={0,0,0}));
  connect(notU.u, u)
    annotation (Line(points={{-152,-80},{-170,-80},{-170,0},{-200,0}},color={255,0,255}));
  connect(notU.y, InitToFalse.condition)
    annotation (Line(points={{-128,-80},{-100,-80},{-100,40},{-80,40},{-80,68}},
      color={255,0,255}));
  connect(onDel1.y, and1.u1)
    annotation (Line(points={{-8,40},{8,40}},color={255,0,255}));
  connect(onDel2.y, and2.u1)
    annotation (Line(points={{12,-80},{28,-80}},color={255,0,255}));
  connect(outputTrue.active, notZerTruHol.u[1])
    annotation (Line(points={{-20,-51},{-20,-60},{108,-60}},color={255,0,255}));
  connect(notZerTruHol.y[1], y)
    annotation (Line(points={{132,-60},{140,-60},{140,0},{180,0}},color={255,0,255}));
  connect(outputFalse.active, zerTruHolNotZerFalHol.u)
    annotation (Line(points={{-40,69},{-40,60},{108,60}},color={255,0,255}));
  connect(u, zerTruHolZerFalHol.u[1])
    annotation (Line(points={{-200,0},{108,0}},color={255,0,255}));
  connect(zerTruHolZerFalHol.y[1], y)
    annotation (Line(points={{132,0},{180,0}},color={255,0,255}));
  connect(initialStep.outPort[1], InitToTrue.inPort)
    annotation (Line(points={{-129.5,20},{-120,20},{-120,-40},{-64,-40}},color={0,0,0}));
  connect(toTrue.outPort, outputTrue.inPort[2])
    annotation (Line(points={{41.5,80},{50,80},{50,10},{-40,10},{-40,-40},{-31,-40}},
      color={0,0,0}));
  connect(toFalse.outPort, outputFalse.inPort[2])
    annotation (Line(points={{61.5,-20},{80,-20},{80,20},{-60,20},{-60,80},{-51,80}},
      color={0,0,0}));
  connect(and2.y, trueToInit.condition)
    annotation (Line(points={{52,-80},{80,-80},{80,-52}},color={255,0,255}));
  connect(outputTrue.outPort[1], trueToInit.inPort)
    annotation (Line(points={{-9.5,-40},{34.25,-40},{34.25,-40},{76,-40}},color={0,0,0}));
  connect(trueToInit.outPort, initialStep.inPort[1])
    annotation (Line(points={{81.5,-40},{100,-40},{100,-110},{-160,-110},{-160,20},{-151,20}},
      color={0,0,0}));
  connect(outputFalse.outPort[1], falseToInit.inPort)
    annotation (Line(points={{-29.5,80},{19.25,80},{19.25,100},{56,100}},color={0,0,0}));
  connect(and1.y, falseToInit.condition)
    annotation (Line(points={{32,40},{60,40},{60,88}},color={255,0,255}));
  connect(zerTruHolNotZerFalHol.y, y)
    annotation (Line(points={{132,60},{140,60},{140,0},{180,0}},color={255,0,255}));
  connect(falseToInit.outPort, initialStep.inPort[1])
    annotation (Line(points={{61.5,100},{80,100},{80,120},{-160,120},{-160,20},{-151,20}},
      color={0,0,0}));
  connect(initialStep.outPort[2], InitToFalse.inPort)
    annotation (Line(points={{-129.5,20},{-120,20},{-120,80},{-84,80}},color={0,0,0}));
  connect(initialStep.outPort[1], InitToFalse1.inPort)
    annotation (Line(points={{-129.5,20},{-120,20},{-120,60},{-104,60}},color={0,0,0}));
  connect(notU.y, InitToFalse1.condition)
    annotation (Line(points={{-128,-80},{-100,-80},{-100,48}},color={255,0,255}));
  connect(InitToFalse1.outPort, outputFalse.inPort[1])
    annotation (Line(points={{-98.5,60},{-74,60},{-74,80},{-51,80}},color={0,0,0}));
  annotation (
    defaultComponentName="truFalHol",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),
        Line(
          points={{-84,10},{-50,10},{-50,54},{-18,54},{-18,10},{-18,10}},
          color={255,0,255}),
        Line(
          points={{-78,-46},{-48,-46},{-48,-2},{-24,-2},{-24,-46},{-24,-46}}),
        Line(
          points={{-24,-46},{6,-46},{6,-2},{44,-2},{44,-46},{74,-46}}),
        Line(
          points={{-18,10},{14,10},{14,54},{46,54},{46,10},{66,10}},
          color={255,0,255}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-88,-62},{92,-90}},
          textColor={0,0,255},
          textString="%falseHoldDuration"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},if y then{0,255,0}else{235,235,235}),
          fillColor=DynamicSelect({235,235,235},if y then{0,255,0}else{235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},if u then{0,255,0}else{235,235,235}),
          fillColor=DynamicSelect({235,235,235},if u then{0,255,0}else{235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,96},{96,68}},
          textColor={0,0,255},
          textString="%trueHoldDuration")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-120},{160,140}})),
    Documentation(
      info="<html>
<p>
Block that holds a <code>true</code> or <code>false</code> signal for at least a defined time period.
</p>
<p>
Whenever the input <code>u</code> switches to true (resp. false), 
the output <code>y</code> switches and remains true for at least 
the duration specified by the parameter <code>trueHoldDuration</code> 
(resp. <code>falseHoldDuration</code>).
After this duration has elapsed, the output will be <code>y = u</code>.
</p>
<p>
This block could for example be used to disable an economizer,
and not re-enable it for <i>10</i>&nbsp;min, and vice versa.
</p>
<p>
The image below shows the implementation with a state graph in which
each transition is only triggered when the input has the corresponding value,
and the current state has been active for at least the specified duration.
Note that certain components are conditional and used only if 
the parameters <code>trueHoldDuration</code> or <code>falseHoldDuration</code>
equal zero.
This is the case of the components on the far right of the diagram and 
the feedback to the initial step, which enhance event handling during simulations 
with zero hold duration.
While these components do not fundamentally alter the logic described above, 
they help prevent unexpected results when this block is used in conjunction 
with other blocks based on synchronous language elements.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueFalseHoldImplementation.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
Simulation results of a typical example with <code>trueHoldDuration = falseHoldDuration = 1000</code>&nbsp;s.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueFalseHold.png\"
alt=\"Input and output of the block\"/>
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 5, 2024, by Antoine Gautier:<br/>
Refactored with direct pass-through if the duration is zero and corrected the documentation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3787\">issue 3787</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
September 18, 2017, by Michael Wetter:<br/>
Improved event handling.
</li>
<li>
July 14, 2017, by Michael Wetter:<br/>
Corrected model to set output equal to input during initialization.
</li>
<li>
June 13, 2017, by Michael Wetter:<br/>
Reimplemented model using a state graph to avoid having to test for equality within tolerance,
and to correct a bug.
This implementation is also easier to understand.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/789\">issue 789</a>.
</li>
<li>
May 24, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end TrueFalseHold;
