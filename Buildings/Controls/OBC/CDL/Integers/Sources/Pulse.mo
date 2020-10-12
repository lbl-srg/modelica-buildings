within Buildings.Controls.OBC.CDL.Integers.Sources;
block Pulse "Generate pulse signal of type Integer"
  parameter Integer amplitude=1 "Amplitude of pulse";
  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit = "1") = 0.5 "Width of pulse in fraction of period";
  parameter Modelica.SIunits.Time period(final min=Constants.small)
   "Time for one period";
  parameter Integer nPeriod=-1
    "Number of periods (< 0 means infinite number of periods)";
  parameter Integer offset=0 "Offset of output signals";
  parameter Modelica.SIunits.Time startTime=0
    "Output = offset for time < startTime";
  Interfaces.IntegerOutput y "Connector of Pulse output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  Modelica.SIunits.Time T_width=period*width "Pulse duration time";
  Modelica.SIunits.Time T_start "Start time of current period";
  Integer count "Period count";
initial equation
  count = integer((time - startTime)/period);
  T_start = startTime + count*period;
equation
  when integer((time - startTime)/period) > pre(count) then
    count = pre(count) + 1;
    T_start = time;
  end when;
  y = offset + (if (time < startTime or nPeriod == 0 or (nPeriod > 0 and
    count >= nPeriod)) then 0 else if time < T_start + T_width then amplitude
     else 0);
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
        Line(points={{-80,-70},{-40,-70},{-40,44},{0,44},{0,-70},{40,-70},{40,
              44},{79,44}}, color={0,0,0}),
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
This block generates an Integer pulse signal as shown below.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Integers/Sources/Pulse.png\"
     alt=\"Pulse.png\" />
</p>
<p>
The pulse output signal is generated <code>nPeriod</code> amount of times or infinitely if <code>nPeriod</code> is set to a negative number.
</p>
</html>", revisions="<html>
<ul>
<li>, 
September 8, 2020, by Milica Grahovac:<br/>
First implementation, based on the implementation of <code>Real</code> pulse.
</li>
</ul>
</html>"));
end Pulse;
