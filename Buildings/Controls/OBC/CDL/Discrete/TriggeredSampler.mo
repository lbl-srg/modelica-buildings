within Buildings.Controls.OBC.CDL.Discrete;
block TriggeredSampler
  "Triggered sampling of continuous signals"
  parameter Real y_start=0
    "Initial value of output signal";
  Interfaces.RealInput u
    "Connector with a Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanInput trigger
    "Signal that triggers the sampler"
    annotation (Placement(transformation(origin={0,-120},extent={{-20,-20},{20,20}},rotation=90)));
  Interfaces.RealOutput y
    "Connector with a Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  y=y_start;

equation
  when trigger then
    y=u;
  end when;
  annotation (
    defaultComponentName="triSam",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={223,211,169},
          lineThickness=5.0,
          borderPattern=BorderPattern.Raised,
          fillPattern=FillPattern.Solid),
        Ellipse(
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{25.0,-10.0},{45.0,10.0}}),
        Line(
          points={{-100.0,0.0},{-45.0,0.0}},
          color={0,0,127}),
        Line(
          points={{45.0,0.0},{100.0,0.0}},
          color={0,0,127}),
        Line(
          points={{0.0,-100.0},{0.0,-26.0}},
          color={255,0,255}),
        Line(
          points={{-35.0,0.0},{28.0,-48.0}},
          color={0,0,127}),
        Ellipse(
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-45.0,-10.0},{-25.0,10.0}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Samples the continuous input signal whenever the trigger input
signal is rising (i.e., trigger changes from <code>false</code> to
<code>true</code>) and provides the sampled input signal as output.
Before the first sampling, the output signal is equal to
the initial value defined via parameter <code>y_start</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
May 18, 2017, by Michael Wetter:<br/>
Corrected documentation.
</li>
<li>
May 17, 2017, by Milica Grahovac:<br/>
First revision, based on the implementation of the
Modelica Standard Library.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end TriggeredSampler;
