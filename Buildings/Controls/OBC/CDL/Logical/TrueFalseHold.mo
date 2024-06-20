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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
protected
  /* The following parameter is required solely as a warkaround for a bug in OCT [Modelon - 1263].
  Both Dymola and OMC can handle the initial equation pre(u)=u, which complies with MLS. */
  parameter Boolean pre_u_start=false
    "Value of pre(u) at initial time";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  discrete Real entryTimeTrue(
    final quantity="Time",
    final unit="s")
    "Time instant when true hold started";
  discrete Real entryTimeFalse(
    final quantity="Time",
    final unit="s")
    "Time instant when false hold started";
initial equation
  /* To ensure that no true hold is active at the start of the simulation
  if u is initially false, we set pre(entryTimeTrue) to -Modelica.Constants.inf.
  This guarantees that the condition time >= pre(entryTimeTrue) + trueHoldDuration
  is met at the start of the simulation.
  Similarly, we set pre(entryTimeFalse) to -Modelica.Constants.inf if u is true. */
  pre(entryTimeTrue)=if u then time else -Modelica.Constants.inf;
  pre(entryTimeFalse)=if u then -Modelica.Constants.inf else time;
  pre(u)=pre_u_start;
  pre(y)=u;
equation
  when {change(u),
        time >= pre(entryTimeFalse) + falseHoldDuration and
        time >= pre(entryTimeTrue) + trueHoldDuration} then
    y=if time >= pre(entryTimeFalse) + falseHoldDuration and
         time >= pre(entryTimeTrue) + trueHoldDuration then u
      else pre(y);
    entryTimeTrue=if change(y) and y then time else pre(entryTimeTrue);
    entryTimeFalse=if change(y) and not y then time else pre(entryTimeFalse);
  end when;
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
          lineColor=DynamicSelect({235,235,235},if y then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillColor=DynamicSelect({235,235,235},if y then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},if u then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillColor=DynamicSelect({235,235,235},if u then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-90,96},{96,68}},
          textColor={0,0,255},
          textString="%trueHoldDuration")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
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
June 13, 2024, by Antoine Gautier:<br/>
Refactored with synchronous language elements.<br/>
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
