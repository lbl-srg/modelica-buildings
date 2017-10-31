within Buildings.Controls.OBC.CDL.Continuous.Sources;
block Pulse "Generate pulse signal of type Real"
  parameter Real amplitude=1 "Amplitude of pulse";
  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit = "1") = 0.5 "Width of pulse in fraction of period";
  parameter Modelica.SIunits.Time period(final min=Constants.small)
   "Time for one period";
  parameter Integer nperiod=-1
    "Number of periods (< 0 means infinite number of periods)";
  parameter Real offset=0 "Offset of output signals";
  parameter Modelica.SIunits.Time startTime=0
    "Output = offset for time < startTime";
  Interfaces.RealOutput y
    "Connector of Pulse output signal" annotation (Placement(
        transformation(extent={{100,-10},{120,10}})));

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
  y = offset + (if (time < startTime or nperiod == 0 or (nperiod > 0 and
    count >= nperiod)) then 0 else if time < T_start + T_width then amplitude
     else 0);
  annotation (
    defaultComponentName="pul",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{-40,44},{0,44},{0,-70},{40,-70},{40,
              44},{79,44}}),
        Text(
          extent={{-147,-152},{153,-112}},
          lineColor={0,0,0},
          textString="period=%period"),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),
    Documentation(info="<html>
<p>
The Real output y is a pulse signal:
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Sources/Pulse.png\"
     alt=\"Pulse.png\" />
</p>
</html>"));
end Pulse;
