within Buildings.Controls.OBC.CDL.Logical.Sources;
block SampleTrigger
  "Generate sample trigger signal"
  parameter Real period(
    final quantity="Time",
    final unit="s",
    final min=Constants.small)
    "Sample period";
  parameter Real shift(
    final quantity="Time",
    final unit="s")=0
    "Shift time for output";
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "First sample time instant";

initial equation
  t0=Buildings.Utilities.Math.Functions.round(
    x=integer((time)/period)*period+mod(shift,period),
    n=6);

equation
  y=sample(
    t0,
    period);
  annotation (
    defaultComponentName="samTri",
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
        Line(
          points={{-60,-70},{-60,70}}),
        Line(
          points={{-20,-70},{-20,70}}),
        Line(
          points={{20,-70},{20,70}}),
        Line(
          points={{60,-70},{60,70}}),
        Text(
          extent={{-150,-140},{150,-110}},
          textColor={0,0,0},
          textString="%period"),
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
          textString="%name")}),
    Documentation(
      info="<html>
<p>
The Boolean output <code>y</code> is a trigger signal that is only <code>true</code>
at sample times (defined by parameter <code>period</code>) and is otherwise
<code>false</code>.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Sources/SampleTrigger.png\"
     alt=\"SampleTrigger.png\" />
</p>
<p>
The trigger signal is generated an infinite number of times, and aligned with <code>time=delay</code>.
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
Refactored implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
</li>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end SampleTrigger;
