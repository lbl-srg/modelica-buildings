within Buildings.Controls.OBC.CDL.Logical;
block TrueHold
  "Block that holds a true signal for at least a requested duration"
  parameter Real duration(
    final quantity="Time",
    final unit="s")
    "Time duration of the true output signal hold"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
protected
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    if duration > 0
    "Root of state graph"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.StateGraph.InitialStep initialStep(
    nIn=1,
    nOut=1)
    if duration > 0
    "Initial step"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Modelica.StateGraph.StepWithSignal outputTrue(
    nIn=1,
    nOut=1)
    if duration > 0
    "Holds the output at true"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.StateGraph.TransitionWithSignal toOutputTrue
    if duration > 0
    "Transition that activates sending a true output signal"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Modelica.StateGraph.Transition toInitial(
    final enableTimer=duration > 0,
    final waitTime=duration)
    if duration > 0
    "Transition that activates the initial state"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanExtractSignal pas
    if not(duration > 0)
    "Pass through directly if hold duration is zero"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
equation
  connect(initialStep.outPort[1], toOutputTrue.inPort)
    annotation (Line(points={{-59.5,60},{-44,60}},color={0,0,0}));
  connect(outputTrue.active, y)
    annotation (Line(points={{0,49},{0,0},{120,0}},color={255,0,255}));
  connect(toOutputTrue.condition, u)
    annotation (Line(points={{-40,48},{-40,0},{-120,0}},color={255,0,255}));
  connect(toInitial.outPort, initialStep.inPort[1])
    annotation (Line(points={{31.5,60},{54,60},{54,86},{-90,86},{-90,60},{-81,60}},
      color={0,0,0}));
  connect(toOutputTrue.outPort, outputTrue.inPort[1])
    annotation (Line(points={{-38.5,60},{-11,60}},color={0,0,0}));
  connect(outputTrue.outPort[1], toInitial.inPort)
    annotation (Line(points={{10.5,60},{26,60}},color={0,0,0}));
  connect(u, pas.u[1])
    annotation (Line(points={{-120,0},{-80,0},{-80,-40},{-12,-40}},color={255,0,255}));
  connect(pas.y[1], y)
    annotation (Line(points={{12,-40},{80,-40},{80,0},{120,0}},color={255,0,255}));
  annotation (
    defaultComponentName="truHol",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{-72,18},{-48,18},{-48,62},{52,62},{52,18},{80,18}},
          color={255,0,255}),
        Line(
          points={{-68,-46},{-48,-46},{-48,-2},{22,-2},{22,-46},{78,-46}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-90,-62},{96,-90}},
          textColor={0,0,255},
          textString="%duration"),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},if y then{0,255,0}else{235,235,235}),
          fillColor=DynamicSelect({235,235,235},if y then{0,255,0}else{235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},if u then{0,255,0}else{235,235,235}),
          fillColor=DynamicSelect({235,235,235},if u then{0,255,0}else{235,235,235}),
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Block that holds a <code>true</code> input signal for at least a defined time period.
</p>
<p>
At initialization, the output <code>y</code> is equal to the input <code>u</code>.
If the input <code>u</code> becomes <code>true</code>, or is <code>true</code>
during intialization, a timer starts
and the Boolean output <code>y</code> stays <code>true</code> for the time
period provided by the parameter <code>duration</code>.
When this time is elapsed, the input is checked again. If
it is <code>true</code>, then the timer is restarted and the output remains
<code>true</code> for another <code>duration</code> seconds.
If the input <code>u</code> is <code>false</code> after
<code>holdTime</code> seconds, then the ouput is switched to <code>false</code>,
until the input becomes <code>true</code> again.
</p>
<p>
The figure below shows the state chart of the implementation. Note that the
transitions are done in zero time.
If the parameter <code>duration</code> is equal to zero, the state chart is
not used and the output <code>y</code> is equal to the input <code>u</code>.
This enhances event handling during simulations with zero hold duration
and helps prevent unexpected results when this block is used in conjunction
with other blocks based on synchronous language elements.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueHoldImplementation.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
The figure below shows an example with a hold time of <i>3600</i> seconds
and a pulse width period <i>9000</i> seconds that starts at <i>t=200</i> seconds.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueHold.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
The figure below shows an example with a hold time of <i>60</i> seconds
and a pulse width period <i>3600</i> seconds that starts at <i>t=0</i> seconds.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueHold1.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
The next two figures show the same experiment, except that the input <code>u</code>
has been negated. The figure below has again a hold time of <i>3600</i> seconds
and a pulse width period <i>9000</i> seconds that starts at <i>t=200</i> seconds.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueHold2.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
The figure below has again a hold time of <i>60</i> seconds
and a pulse width period <i>3600</i> seconds that starts at <i>t=0</i> seconds.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueHold3.png\"
alt=\"Input and output of the block\"/>
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 5, 2024, by Antoine Gautier:<br/>
Refactored with direct pass-through if the duration is zero.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3787\">issue 3787</a>.
</li>
<li>
March 27, 2024, by Michael Wetter:<br/>
Renamed block from <code>TrueHoldWithReset</code> to <code>TrueHold</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3689\">issue 3689</a>.
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
June 13, 2017, by Michael Wetter:<br/>
Reimplemented model using a state graph to avoid having to test for equality within tolerance.
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
end TrueHold;
