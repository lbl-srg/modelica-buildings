within Buildings.Controls.OBC.CDL.Discrete;
block TriggeredMax
  "Output the maximum, absolute value of a continuous signal at trigger instants"

  Interfaces.RealInput u "Connector with a Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Connector with a Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Interfaces.BooleanInput trigger "Connector for trigger"
    annotation (Placement(
        transformation(
        origin={0,-118},
        extent={{-20,-20},{20,20}},
        rotation=90)));

initial equation
  y = u;

equation
  when trigger then
     y = max(pre(y), abs(u));
  end when;


  annotation (
    defaultComponentName="triMax",
    Icon(
      coordinateSystem(preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={                     Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={223,211,169},
        lineThickness=5.0,
        borderPattern=BorderPattern.Raised,
        fillPattern=FillPattern.Solid), Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{25.0,-10.0},{45.0,10.0}}),
      Line(points={{-100.0,0.0},{-45.0,0.0}},
        color={0,0,127}),
      Line(points={{45.0,0.0},{100.0,0.0}},
        color={0,0,127}),
      Line(points={{0.0,-100.0},{0.0,-26.0}},
        color={255,0,255}),
      Line(points={{-35.0,0.0},{28.0,-48.0}},
        color={0,0,127}),
      Text(extent={{-86.0,24.0},{82.0,82.0}},
        textString="max"),
      Ellipse(lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        extent={{-45.0,-10.0},{-25.0,10.0}})}),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{
            100,100}}), graphics={
        Ellipse(
          extent={{-25,-10},{-45,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{45,-10},{25,10}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,0},{-45,0}}, color={0,0,255}),
        Line(points={{45,0},{100,0}}, color={0,0,255}),
        Line(points={{-35,0},{28,-48}}, color={0,0,255}),
        Line(points={{0,-100},{0,-26}}, color={255,0,255})}),
    Documentation(info="<html>
<p>
Block that outputs the input signal whenever the trigger input
signal is rising (i.e., trigger changes to
<code>true</code>). The maximum, absolute value of the input signal
at the sampling point is provided as the output signal.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2017, by Michael Wetter:<br/>
Removed parameter <code>startTime</code> and <code>sampleTime</code>
as these are not needed for this block, and introduced parameter
<code>y_start=0</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/938\">issue 938</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end TriggeredMax;
