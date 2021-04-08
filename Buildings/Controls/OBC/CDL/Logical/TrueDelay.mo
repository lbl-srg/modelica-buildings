within Buildings.Controls.OBC.CDL.Logical;
block TrueDelay
  "Delay a rising edge of the input, but do not delay a falling edge."
  parameter Real delayTime(
    final quantity="Time",
    final unit="s")
    "Delay time";
  parameter Boolean delayOnInit=false
    "Set to true to delay initial true input";
  Interfaces.BooleanInput u
    "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real t_past(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Time before simulation started";
  Real t_next(
    final quantity="Time",
    final unit="s")
    "Next event time";

initial equation
  t_past=time-1000;
  pre(u)=false;
  pre(t_next)=time-1000;

equation
  when initial() then
    t_next=
      if not delayOnInit then
        t_past
      else
        time+delayTime;
    y=
      if not(delayOnInit and delayTime > 0) then
        u
      else
        false;
  elsewhen u then
    t_next=time+delayTime;
    y=
      if delayTime > 0 then
        false
      else
        true;
  elsewhen not u then
    t_next=t_past;
    y=false;
  elsewhen time >= pre(t_next) then
    t_next=t_past;
    y=u;
  end when;
  annotation (
    defaultComponentName="truDel",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-250,-120},{250,-150}},
          lineColor={0,0,0},
          textString="%delayTime"),
        Line(
          points={{-80,-66},{-60,-66},{-60,-22},{38,-22},{38,-66},{66,-66}}),
        Line(
          points={{-80,32},{-4,32},{-4,76},{38,76},{38,32},{66,32}},
          color={255,0,255}),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Block that delays a signal when it becomes <code>true</code>.
</p>
<p>
A rising edge of the Boolean input <code>u</code> gives a delayed output.
A falling edge of the input is immediately given to the output. If
<code>delayOnInit = true</code>, then a <code>true</code> input signal
at the start time is also delayed, otherwise the input signal is
produced immediately at the output.
</p>
<p>
Simulation results of a typical example with a delay time of <i>0.1</i> second
is shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueDelay1.png\"
     alt=\"OnDelay1.png\" />
<br/>
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/TrueDelay2.png\"
     alt=\"OnDelay2.png\" />
</p>

</html>",
      revisions="<html>
<ul>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.SIunits</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
February 11, 2019, by Milica Grahovac:<br/>
Added boolean input to enable delay of an initial true input.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end TrueDelay;
