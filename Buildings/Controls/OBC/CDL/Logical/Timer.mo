within Buildings.Controls.OBC.CDL.Logical;
block Timer
  "Timer measuring the time from the time instant where the Boolean input became true"

  parameter Boolean accumulate = false
    "Set to true when need to find accumulated time which can be reset by another boolean input";

  Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanInput reset if accumulate
    "Connector of Boolean for resetting output to zero"
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Modelica.SIunits.Time entryTime "Time instant when u became true";
  discrete Real yAcc "Accumulated time up to last change to true";
  Interfaces.BooleanInput u0_internal(final start=false, final fixed=true) "Internal connector";

initial equation
  pre(entryTime) = 0;
  yAcc = 0;
equation
  connect(reset, u0_internal);
  if not accumulate then
    u0_internal = false;
  end if;

  when u and (not edge(u0_internal)) then
    entryTime = time;
  elsewhen u0_internal then
    entryTime = time;
  end when;

  when u0_internal then
    yAcc = 0;
  elsewhen (not u) then
    yAcc = pre(y);
  end when;

  if not accumulate then
    y = if u then time - entryTime else 0.0;
  else
    y = if u then yAcc + (time - entryTime) else yAcc;
  end if;

annotation (
    defaultComponentName="tim",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
      Line(points={{-66,-60},{82,-60}},
        color={192,192,192}),
      Line(points={{-58,68},{-58,-80}},
        color={192,192,192}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{90,-60},{68,-52},{68,-68},{90,-60}}),
      Polygon(lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid,
        points={{-58,90},{-66,68},{-50,68},{-58,90}}),
      Line(points={{-56,-60},{-38,-60},{-38,-16},{40,-16},{40,-60},{68,-60}},
        color={255,0,255}),
      Line(points={{-58,0},{-40,0},{40,90},{40,0},{68,0}},
        color={0,0,127}),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0} else {235,
              235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,-58},{88,-98}},
          lineColor={217,67,180},
          textString="accumulate: %accumulate")}),
    Documentation(info="<html>
<p>
Block that represents a timer.
</p>
<p>
When the Boolean input <code>u</code> becomes true, the timer is 
started and the output <code>y</code> is the time from the time instant where
<code>u</code> became true. 
</p>
<ul>
<li>
If parameter <code>accumulate</code> is false, once the input <code>u</code> becomes false, 
the timer is stopped and the output is reset to zero. 
</li>
<li>
If parameter <code>accumulate</code> is true, once the input <code>u</code> becomes false,
the timer will not fully stopped but hold the accumulated true input time. The
accumulated time can be reset to zero when the input <code>reset</code> becomes true.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 23, 2018, by Jianjun Hu:<br/>
Added conditional boolean input for cumulative time measuring. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1221\">issue 1221</a>
</li>
<li>
July 18, 2018, by Jianjun Hu:<br/>
Update implementation to output accumulated true input time.  This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1212\">issue 1212</a>
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Timer;
