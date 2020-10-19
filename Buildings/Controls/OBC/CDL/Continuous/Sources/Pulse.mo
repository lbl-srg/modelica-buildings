within Buildings.Controls.OBC.CDL.Continuous.Sources;
block Pulse "Generate pulse signal of type Real"
  parameter Real amplitude=1 "Amplitude of pulse";
  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit = "1") = 0.5 "Width of pulse in fraction of period";
  parameter Modelica.SIunits.Time period(final min=Constants.small)
   "Time for one period";
  parameter Real offset=0 "Offset of output signals";

  Interfaces.RealOutput y "Connector of Pulse output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Modelica.SIunits.Time t0(fixed=false)
    "First sample time instant";
  parameter Modelica.SIunits.Time t1(fixed=false)
    "First end of amplitude";
  parameter Real y0 = offset + amplitude "Value when pulse is on";
initial equation
  t0 = Buildings.Utilities.Math.Functions.round(
         x = integer(time/period)*period,
         n = 6);
  t1 = t0 + width*period;
  y = if time >= t0 and time < t1 then y0 else offset;

equation
  when {sample(t0, period)} then
    y = y0;
  elsewhen sample(t1, period) then
    y = offset;
  end when;

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
        Line(points={{-80,44},{-40,44},{-40,-70},{0,-70},{0,44},{40,44},{40,-70},
              {68,-70}}),
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
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}),
    Documentation(info="<html>
<p>
Block that outputs a pulse signal as shown below.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/Sources/Pulse.png\"
     alt=\"Pulse.png\" />
     </p>
<p>
The pulse signal is generated an infinite number of times.
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
