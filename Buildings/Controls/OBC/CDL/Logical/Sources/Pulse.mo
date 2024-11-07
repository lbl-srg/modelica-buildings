within Buildings.Controls.OBC.CDL.Logical.Sources;
block Pulse
  "Generate pulse signal of type Boolean"
  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit="1")=0.5
    "Width of pulse in fraction of period";
  parameter Real period(
    final quantity="Time",
    final unit="s",
    final min=Constants.small)
    "Time for one period";
  parameter Real shift(
    final quantity="Time",
    final unit="s")=0
    "Shift time for output";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Output with pulse value"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First sample time instant";
  parameter Real t1(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First end of amplitude";

initial algorithm
  t0 := Buildings.Utilities.Math.Functions.round(
    x=integer((time)/period)*period+mod(shift,period),
    n=6);
  t1 := t0+width*period;
  // Make sure t0 and t1 are within time + period.
  if time+period < t1 then
    t0 := t0-period;
    t1 := t1-period;
  end if;
  // Make sure time is between t0 and t1, or t1 and t0
  // Now, t0 < t1
  if time >= t1 then
    t0 := t0+period;
  elseif time < t0 then
    t1 := t1-period;
  end if;
  // Assert that t0 <= t < t1 or t1 <= t < t0
  if
    (t0 < t1) then
    assert(
      t0 <= time and time < t1,
      getInstanceName()+": Implementation error in initial time calculation: t0 = "+String(t0)+", t1 = "+String(t1)+",  period = "+String(period)+", time = "+String(time));
    y := time >= t0 and time < t1;
  else
    assert(
      t1 <= time and time < t0,
      getInstanceName()+": Implementation error in initial time calculation: t0 = "+String(t0)+", t1 = "+String(t1)+",  period = "+String(period)+", time = "+String(time));
    y := not
            (time >= t1 and time < t0);
  end if;

equation
  when sample(
    t0,
    period) then
    y=true;
  elsewhen sample(
    t1,
    period) then
    y=false;
  end when;
  annotation (
    defaultComponentName="booPul",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-150,-140},{150,-110}},
          textColor={0,0,0},
          textString="%period"),
        Line(
          points={{79,-70},{40,-70},{40,44},{-1,44},{-1,-70},{-41,-70},{-41,44},{-80,44}}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,88}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,66},{-80,-82}},
          color={255,0,255}),
        Line(
          points={{-90,-70},{72,-70}},
          color={255,0,255}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={255,0,255},
          fillColor={255,0,255},
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
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-66,80},{-8,56}},
          textColor={135,135,135},
          textString="%period"),
        Polygon(
          points={{-2,52},{-14,56},{-14,48},{-2,52}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-80,52},{-4,52}},
          color={135,135,135}),
        Polygon(
          points={{-80,52},{-68,56},{-68,48},{-80,52}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{40,34},{72,34}},
          color={135,135,135}),
        Polygon(
          points={{74,34},{62,38},{62,30},{74,34}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{38,64},{96,40}},
          textColor={135,135,135},
          textString="%shift")}),
    Documentation(
      info="<html>
<p>
Block that outputs a pulse signal as shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Sources/Pulse.png\"
     alt=\"BooleanPulse.png\" />
</p>
<p>
The pulse signal is generated an infinite number of times, and aligned with <code>time=shift</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 03, 2020, by Milica Grahovac:<br/>
Renamed <code>delay</code> parameter to <code>shift</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2282\">issue 2282</a>.
</li>
<li>
November 12, 2020, by Michael Wetter:<br/>
Reformulated to remove dependency to <code>Modelica.Units.SI</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2243\">issue 2243</a>.
</li>
<li>
October 19, 2020, by Michael Wetter:<br/>
Refactored implementation, avoided state events.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
</li>
<li>
September 8, 2020, by Milica Grahovac:<br/>
Enabled specification of number of periods as a parameter.
</li>
<li>
September 1, 2020, by Milica Grahovac:<br/>
Revised initial equation section to ensure expected simulation results when <code>startTime</code> is before simulation start time.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2110\">#2110</a>.
</li>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Pulse;
