within Buildings.Templates.Plants.Controls.Utilities;
block TimerWithReset
  "Timer measuring the time from the time instant where the Boolean input became true"
  parameter Real t(
    final quantity="Time",
    final unit="s")=0
    "Threshold time for comparison";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Input that switches timer on if true, and off if false"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput reset
    "Reset signal"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(
    final quantity="Time",
    final unit="s")
    "Elapsed time"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput passed
    "True if the elapsed time is greater than threshold"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-100},{140,-60}})));
protected
  discrete Real entryTime(
    final quantity="Time",
    final unit="s")
    "Time instant when u became true";
initial equation
  entryTime = time;
  passed = t <= 0;
equation
  when {u, reset} then
    entryTime = time;
    passed = u and t <= 0;
  elsewhen u and time >= pre(entryTime) + t then
    entryTime = pre(entryTime);
    passed = true;
  elsewhen not u then
    entryTime = pre(entryTime);
    passed = false;
  end when;
  y = if u then time - entryTime else 0.0;
  annotation (
    __cdl(
      extensionBlock=true),
    defaultComponentName="tim",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(
          points={{-66,-60},{82,-60}},
          color={192,192,192}),
        Line(
          points={{-58,68},{-58,-80}},
          color={192,192,192}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{90,-60},{68,-52},{68,-68},{90,-60}}),
        Polygon(
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid,
          points={{-58,90},{-66,68},{-50,68},{-58,90}}),
        Line(
          points={{-56,-60},{-38,-60},{-38,-16},{40,-16},{40,-60},{68,-60}},
          color={255,0,255}),
        Line(
          points={{-58,0},{-40,0},{40,58},{40,0},{68,0}},
          color={0,0,127}),
        Text(
          extent={{-150,150},{150,110}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-64,62},{62,92}},
          textColor={0,0,0},
          textString="t=%t"),
        Ellipse(
          extent={{-83,7},{-69,-7}},
          lineColor=DynamicSelect({235,235,235},if u then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillColor=DynamicSelect({235,235,235},if u then
                                                         {0,255,0} else
                                                                      {235,235,235}),
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,-73},{85,-87}},
          lineColor=DynamicSelect({235,235,235},if passed then
                                                              {0,255,0} else
                                                                           {235,235,235}),
          fillColor=DynamicSelect({235,235,235},if passed then
                                                              {0,255,0} else
                                                                           {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
October 21, 2024, by Antoine Gautier:<br/>
Refactored to ensure <code>passed=u</code> if <code>t=0</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3952\">#3952</a>.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This block is similar to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Timer\">
Buildings.Controls.OBC.CDL.Logical.Timer</a>,
but introduces an additional Boolean input signal <code>reset</code>,
which resets the timer.
When <code>reset</code> becomes true:
<code>y=0</code> and <code>passed=false</code>.
</p>
</html>"));
end TimerWithReset;
