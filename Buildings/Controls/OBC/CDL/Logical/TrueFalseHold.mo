within Buildings.Controls.OBC.CDL.Logical;
block TrueFalseHold "Block that holds an output signal for at least a specified duration"

  parameter Modelica.SIunits.Time trueHoldDuration
    "true hold duration";

  parameter Modelica.SIunits.Time falseHoldDuration = trueHoldDuration
    "false hold duration";

  Interfaces.BooleanInput u "Boolean input signal"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDel1(
    delayTime=falseHoldDuration)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay onDel2(
    delayTime=trueHoldDuration)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of state graph"
    annotation (Placement(transformation(extent={{-160,100},{-140,120}})));
  Modelica.StateGraph.StepWithSignal        outputFalse(nIn=2)
    "State for which the block outputs false"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.StateGraph.TransitionWithSignal toTrue "Transition to true"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
  CDL.Logical.Not notU "Negation of input"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));
  Modelica.StateGraph.StepWithSignal outputTrue(nIn=2)
    "State with true output signal"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.StateGraph.TransitionWithSignal toFalse "Transition to false"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  CDL.Logical.And and2 "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  CDL.Logical.And and1 "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));

  Modelica.StateGraph.InitialStep initialStep(nIn=0, nOut=2) "Initial state"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Modelica.StateGraph.TransitionWithSignal toTrue1 "Transition to true"
    annotation (Placement(transformation(extent={{-70,102},{-50,122}})));
  Modelica.StateGraph.TransitionWithSignal toFalse1 "Transition to false"
    annotation (Placement(transformation(extent={{-90,80},{-70,100}})));
equation
  connect(outputTrue.outPort[1], toFalse.inPort)
    annotation (Line(points={{20.5,20},{28,20},{36,20}}, color={0,0,0}));
  connect(outputTrue.active, y)
    annotation (Line(points={{10,9},{10,0},{180,0}},  color={255,0,255}));
  connect(outputFalse.outPort[1], toTrue.inPort)
    annotation (Line(points={{-39.5,20},{-32,20},{-24,20}}, color={0,0,0}));
  connect(toFalse.outPort, outputFalse.inPort[1]) annotation (Line(points={{41.5,20},
          {60,20},{60,40},{-70,40},{-70,20.5},{-61,20.5}},     color={0,0,0}));
  connect(outputTrue.active,onDel2. u)
    annotation (Line(points={{10,9},{10,0},{10,-60},{18,-60}},
                                                         color={255,0,255}));
  connect(notU.y, and2.u2)
    annotation (Line(points={{-118,70},{140,70},{140,-80},{48,-80},{48,-68},{58,
          -68}},                                   color={255,0,255}));
  connect(and2.y, toFalse.condition) annotation (Line(points={{82,-60},{100,-60},
          {100,-20},{40,-20},{40,8}},color={255,0,255}));
  connect(outputFalse.active,onDel1. u) annotation (Line(points={{-50,9},{-50,0},
          {-140,0},{-140,-30},{-102,-30}},
                                         color={255,0,255}));
  connect(u, and1.u2) annotation (Line(points={{-200,0},{-160,0},{-160,-50},{
          -60,-50},{-60,-38},{-52,-38},{-52,-38}},
        color={255,0,255}));
  connect(and1.y, toTrue.condition) annotation (Line(points={{-28,-30},{-20,-30},
          {-20,8}},                   color={255,0,255}));
  connect(u, toTrue1.condition) annotation (Line(points={{-200,0},{-160,0},{-160,
          52},{-60,52},{-60,100}},
                              color={255,0,255}));
  connect(toTrue1.outPort, outputTrue.inPort[1]) annotation (Line(points={{-58.5,
          112},{-10,112},{-10,20.5},{-1,20.5}},
                                              color={0,0,0}));
  connect(toTrue.outPort, outputTrue.inPort[2])
    annotation (Line(points={{-18.5,20},{-1,20},{-1,19.5}}, color={0,0,0}));
  connect(toFalse1.outPort, outputFalse.inPort[2]) annotation (Line(points={{-78.5,
          90},{-72,90},{-72,44},{-72,20},{-61,20},{-61,19.5}},          color={0,
          0,0}));
  connect(initialStep.outPort[1], toTrue1.inPort) annotation (Line(points={{-99.5,
          110.25},{-90,110.25},{-90,110},{-90,112},{-64,112}},
                                           color={0,0,0}));
  connect(initialStep.outPort[2], toFalse1.inPort) annotation (Line(points={{-99.5,
          109.75},{-94,109.75},{-94,110},{-90,110},{-90,90},{-84,90}},
                                                   color={0,0,0}));
  connect(notU.u, u) annotation (Line(points={{-142,70},{-160,70},{-160,0},{-200,
          0}},
        color={255,0,255}));
  connect(notU.y, toFalse1.condition)
    annotation (Line(points={{-118,70},{-80,70},{-80,78}},color={255,0,255}));
  connect(onDel1.y, and1.u1)
    annotation (Line(points={{-78,-30},{-52,-30}}, color={255,0,255}));
  connect(onDel2.y, and2.u1)
    annotation (Line(points={{42,-60},{42,-60},{58,-60}}, color={255,0,255}));
  annotation (defaultComponentName="truFalHol",
          Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised,
          lineColor={0,0,0}),
          Line(points={{-84,10},{-50,10},{-50,54},{-18,54},{-18,10},{-18,10}},
              color={255,0,255}),
          Line(points={{-78,-46},{-48,-46},{-48,-2},{-24,-2},{-24,-46},{-24,-46}}),
          Line(points={{-24,-46},{6,-46},{6,-2},{44,-2},{44,-46},{74,-46}}),
          Line(points={{-18,10},{14,10},{14,54},{46,54},{46,10},{66,10}},
              color={255,0,255}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-88,-62},{92,-90}},
          lineColor={0,0,255},
          textString="%falseHoldDuration"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,96},{96,68}},
          lineColor={0,0,255},
          textString="%trueHoldDuration")}),
        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-180,-120},{160,140}})),
Documentation(info="<html>
<p>
Block that holds a <code>true</code> or <code>false</code> signal for at least a defined time period.
</p>
<p>
Whenever the input <code>u</code> switches, the output <code>y</code>
switches and remains at that value for at least <code>duration</code>
seconds, where <code>duration</code> is a parameter.
After <code>duration</code> elapsed, the output will be
<code>y = u</code>.
If this change required changing the value of <code>y</code>,
then <code>y</code> will remain at that value for at least <code>duration</code>.
Otherwise, <code>y</code> will change immediately whenever <code>u</code>
changes.
</p>
<p>
This block could for example be used to disable an economizer,
and not re-enable it for <i>10</i> minutes, and vice versa.
</p>
<p>
The image below shows the implementation with a state graph in which
each transition is only triggered when the input has the corresponding value,
and the current state has been active for at least <code>duration</code> seconds.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueFalseHoldImplementation.png\"
alt=\"Input and output of the block\"/>
</p>

<p>
Simulation results of a typical example with <code>duration = 1000</code> seconds.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueFalseHold.png\"
alt=\"Input and output of the block\"/>
</p>
</html>",
revisions="<html>
<ul>
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
