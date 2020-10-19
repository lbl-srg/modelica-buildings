within Buildings.Controls.OBC.CDL.Integers.Sources;
block Pulse "Generate pulse signal of type Integer"
  parameter Integer amplitude=1 "Amplitude of pulse";
  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit = "1") = 0.5 "Width of pulse in fraction of period";
  parameter Modelica.SIunits.Time period(final min=Constants.small)
   "Time for one period";
  parameter Modelica.SIunits.Time delay=0
    "Delay time for output";
  parameter Integer offset=0 "Offset of output signals";
  Interfaces.IntegerOutput y "Connector of Pulse output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  parameter Modelica.SIunits.Time t1(fixed=false)
    "First end of amplitude";
  parameter Integer y0 = offset + amplitude "Value when pulse is on";
initial equation
  t0 = Buildings.Utilities.Math.Functions.round(
         x = integer(time+delay/period)*period,
         n = 6);
  t1 = t0 + width*period;
  y = if time >= t0 and time < t1 then y0 else offset;

equation
  when sample(t0, period) then
    y = y0;
  elsewhen sample(t1, period) then
    y = offset;
  end when;

  annotation (
    defaultComponentName="intPul",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                           Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={244,125,35}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={244,125,35},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={255,170,85}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={244,125,35},
          fillColor={244,125,35},
          fillPattern=FillPattern.Solid),
        Line(points={{79,-70},{39,-70},{39,44},{-1,44},{-1,-70},{-41,-70},{-41,44},
              {-80,44}},    color={0,0,0}),
        Text(
          extent={{-147,-152},{153,-112}},
          lineColor={0,0,0},
          textString="period=%period"),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3))),
        Line(points={{-132,-18}}, color={28,108,200})}),
    Documentation(info="<html>
<p>
Block that outputs a pulse signal as shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Integers/Sources/Pulse.png\"
     alt=\"Pulse.png\" />
     </p>
<p>
The pulse signal is generated an infinite number of times, and aligned with time <code>time=delay</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 19, 2020, by Michael Wetter:<br/>
Refactored implementation, avoided state events.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
</li>
<li> 
September 8, 2020, by Milica Grahovac:<br/>
First implementation, based on the implementation of <code>Real</code> pulse.
</li>
</ul>
</html>"));
end Pulse;
