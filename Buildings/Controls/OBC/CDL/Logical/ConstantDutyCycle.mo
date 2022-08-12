within Buildings.Controls.OBC.CDL.Logical;
block ConstantDutyCycle
  "Produce output that cycles on and off according to the specified pulse width and period"
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
  Interfaces.BooleanInput go
    "True: cycle the output; False: the output remains true"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  discrete Real t0(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Time instant when output begins cycling";
  Real t_sta(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "Begin time instant of one period";
  Real t_end(
    final quantity="Time",
    final unit="s",
    fixed=false)
    "End time instant of one period";

initial equation
  pre(t0)=time;

equation
  when go then
    t0 = time;
  end when;

  if go then
    t_sta = Buildings.Utilities.Math.Functions.round(
      x=integer((time-t0)/period)*period, n=6)+t0;
    t_end = t_sta + width*period;

    if (time>=t_sta) and (time<t_end) then
      y = true;
    else
      y = false;
    end if;
  else
    t_sta = time;
    t_end = time;
    y = true;
  end if;

annotation (
    defaultComponentName="conDutCyc",
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
          points={{-80,66},{-80,-92}},
          color={255,0,255}),
        Line(
          points={{-90,-80},{72,-80}},
          color={255,0,255}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
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
          extent={{-46,-12},{-14,-30}},
          textColor={135,135,135},
          textString="%period"),
        Polygon(
          points={{0,-30},{-8,-28},{-8,-32},{0,-30}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-60,-30},{0,-30}},
          color={135,135,135}),
        Polygon(
          points={{-60,-30},{-52,-28},{-52,-32},{-60,-30}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(points={{-80,0},{-60,0},{-60,40},{60,40}}, color={255,0,0}),
        Line(points={{-80,-40},{-60,-40}}, color={0,0,0}),
        Line(points={{-60,-40},{-30,-40},{-30,-80}}, color={0,0,0}),
        Line(points={{0,-40},{30,-40},{30,-80}}, color={0,0,0}),
        Line(points={{0,-40},{0,-80}}, color={0,0,0}),
        Polygon(
          points={{-60,-60},{-52,-58},{-52,-62},{-60,-60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Line(
          points={{-60,-60},{-30,-60}},
          color={135,135,135}),
        Polygon(
          points={{-30,-60},{-38,-58},{-38,-62},{-30,-60}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-58,-44},{-34,-58}},
          textColor={135,135,135},
          textString="%width"),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
    Documentation(
      info="<html>
<p>
Block that produces an output that cycles on and off according to the specified
length of time for the cycle, and the specified percentage of the time that the
output should be on. It cycles the output when the <code>go</code> input is on;
if the <code>go</code> input is off, the output remains on.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/ConstantDutyCycle.png\"
     alt=\"ConstantDutyCycle.png\" />
</p>
</html>",
revisions="<html>
<ul>
<li>
August 11, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConstantDutyCycle;
