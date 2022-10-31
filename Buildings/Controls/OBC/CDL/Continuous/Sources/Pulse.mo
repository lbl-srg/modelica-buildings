within Buildings.Controls.OBC.CDL.Continuous.Sources;
block Pulse
  "Generate pulse signal of type Real"
  parameter Real amplitude=1
    "Amplitude of pulse";
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
  parameter Real offset=0
    "Offset of output signals";
  Interfaces.RealOutput y
    "Connector of Pulse output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Logical.Sources.Pulse booPul(
    final width=width,
    final period=period,
    final shift=shift)
    "Boolean pulse"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Conversions.BooleanToReal booToRea(
    final realTrue=offset+amplitude,
    final realFalse=offset)
    "Boolean to real conversion"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(booPul.y,booToRea.u)
    annotation (Line(points={{-18,0},{18,0}},color={255,0,255}));
  connect(y,booToRea.y)
    annotation (Line(points={{120,0},{42,0}},color={0,0,127}));
  annotation (
    defaultComponentName="pul",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,68},{-80,-80}},
          color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,-70},{82,-70}},
          color={192,192,192}),
        Text(
          extent={{-147,-152},{153,-112}},
          textColor={0,0,0},
          textString="period=%period"),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3))),
        Polygon(
          points={{-80,52},{-68,56},{-68,48},{-80,52}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-80,52},{-4,52}},
          color={135,135,135}),
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
          textString="%shift"),
        Line(
          points={{79,-70},{40,-70},{40,44},{-1,44},{-1,-70},{-41,-70},{-41,44},{-80,44}}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Block that outputs a pulse signal as shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Sources/Pulse.png\"
     alt=\"Pulse.png\" />
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
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 16, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Pulse;
