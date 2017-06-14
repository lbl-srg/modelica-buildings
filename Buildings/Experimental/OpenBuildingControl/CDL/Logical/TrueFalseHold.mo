within Buildings.Experimental.OpenBuildingControl.CDL.Logical;
block TrueFalseHold "Block that holds an output signal for a specified duration"

  parameter Modelica.SIunits.Time holdDuration
    "Time duration during which the output cannot change";

  Interfaces.BooleanInput u "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-122,-10},{-102,10}})));

  Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  Timer timer1 "Timer for false output"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Timer timer2 "Timer for true output"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.StateGraph.InitialStepWithSignal initialStep
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.StateGraph.TransitionWithSignal transitionToTrue
    "Transition to true"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Not notU "Negation of input"
    annotation (Placement(transformation(extent={{20,-118},{40,-98}})));
  Modelica.StateGraph.StepWithSignal outputTrue
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.StateGraph.TransitionWithSignal transitionToFalse
    "Transition to false"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  GreaterEqualThreshold greEquThr2(final threshold=holdDuration)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  And and2 "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{68,-110},{88,-90}})));
  GreaterEqualThreshold greEquThr1(final threshold=holdDuration)
    "Output true when timer elapsed the required time"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));
  And and1 "Check for input and elapsed timer"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));

equation
  connect(u, notU.u) annotation (Line(points={{-120,0},{-88,0},{-88,-108},{18,-108}},
        color={255,0,255}));
  connect(transitionToTrue.outPort, outputTrue.inPort[1])
    annotation (Line(points={{-18.5,30},{-1,30}}, color={0,0,0}));
  connect(outputTrue.outPort[1], transitionToFalse.inPort)
    annotation (Line(points={{20.5,30},{36,30}}, color={0,0,0}));
  connect(outputTrue.active, y)
    annotation (Line(points={{10,19},{10,0},{110,0}}, color={255,0,255}));
  connect(initialStep.outPort[1], transitionToTrue.inPort)
    annotation (Line(points={{-39.5,30},{-24,30}}, color={0,0,0}));
  connect(transitionToFalse.outPort, initialStep.inPort[1]) annotation (Line(
        points={{41.5,30},{60,30},{60,50},{-70,50},{-70,30},{-61,30}}, color={0,
          0,0}));
  connect(outputTrue.active, timer2.u)
    annotation (Line(points={{10,19},{10,-60},{18,-60}}, color={255,0,255}));
  connect(timer2.y, greEquThr2.u)
    annotation (Line(points={{41,-60},{48,-60}}, color={0,0,127}));
  connect(greEquThr2.y, and2.u1) annotation (Line(points={{71,-60},{80,-60},{80,
          -76},{56,-76},{56,-100},{66,-100}}, color={255,0,255}));
  connect(notU.y, and2.u2)
    annotation (Line(points={{41,-108},{66,-108}}, color={255,0,255}));
  connect(and2.y, transitionToFalse.condition) annotation (Line(points={{89,-100},
          {94,-100},{94,-20},{40,-20},{40,18}}, color={255,0,255}));
  connect(timer1.y, greEquThr1.u)
    annotation (Line(points={{-59,-30},{-52,-30}}, color={0,0,127}));
  connect(initialStep.active, timer1.u) annotation (Line(points={{-50,19},{-50,12},
          {-86,12},{-86,-30},{-82,-30}}, color={255,0,255}));
  connect(u, and1.u2) annotation (Line(points={{-120,0},{-88,0},{-88,-78},{-32,-78}},
        color={255,0,255}));
  connect(greEquThr1.y, and1.u1) annotation (Line(points={{-29,-30},{-20,-30},{-20,
          -50},{-44,-50},{-44,-70},{-32,-70},{-32,-70}}, color={255,0,255}));
  connect(and1.y, transitionToTrue.condition) annotation (Line(points={{-9,-70},
          {-4,-70},{-4,-10},{-20,-10},{-20,18}}, color={255,0,255}));
  annotation (Icon(graphics={    Rectangle(
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
          extent={{-90,-62},{96,-90}},
          lineColor={0,0,255},
          textString="%holdDuration")}),
        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-120},{100,100}})),
Documentation(info="<html>
<p>
Block that holds a <code>true</code> or <code>false</code> signal constant for at least a defined time period.
</p>
<p>
Whenever the input <code>u</code> switches, the output <code>y</code>
switches and remains at that value for at least <code>holdDuration</code>
seconds, where <code>holdDuration</code> is a parameter.
After <code>holdDuration</code> elapsed, the output will be
<code>y = u</code>.
If this change required changing the value of <code>y</code>,
then <code>y</code> will remain at that value for at least <code>holdDuration</code>.
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
and the current state has been active for at least <code>holdDuration</code> seconds.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/MinimumOnOffTimeImplementation.png\"
alt=\"Input and output of the block\"/>
</p>

<p>
Simulation results of a typical example with <code>holdDuration = 1000</code> seconds.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Logical/Composite/MinimumOnOffTime.png\"
alt=\"Input and output of the block\"/>
</p>

</html>", revisions="<html>
<ul>
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
