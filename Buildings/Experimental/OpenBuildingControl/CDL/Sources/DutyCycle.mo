within Buildings.Experimental.OpenBuildingControl.CDL.Sources;
block DutyCycle "Generate output cyclic on and off"

  Interfaces.RealInput u "Percentage of the cycle time the output should be on: [0, 100]"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  parameter Boolean cycleOn = true
    "= false, if don't want to have the cycle ON.";

  parameter Modelica.SIunits.Time period(min=Constants.small) = 1.0 "Time for one cycle";

  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Modelica.SIunits.Time startTime=0
    "Output = false for time < startTime";
  parameter Integer nperiod=-1
    "Number of cycles (< 0 means infinite number of periods)";

protected
  Modelica.SIunits.Time T_width = period*u/100 "Amount of ON time";
  Modelica.SIunits.Time T_start "Start time of current cycle";
  Integer count "Cycle count";
initial algorithm
  count := integer((time - startTime)/period);
  T_start := startTime + count*period;

equation
  when integer((time - startTime)/period) > pre(count) then
    count = pre(count) + 1;
    T_start = time;
  end when;
  y = if cycleOn then
         (if (time < startTime or nperiod == 0 or (nperiod > 0 and count >= nperiod))
         then false
         else if time < T_start + (period-T_width) then false
         else true)
      else false;
  annotation (
    defaultComponentName="dutCyc",
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
          extent={{-154,144},{146,104}},
          lineColor={0,0,255},
          textString="%name")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-72,90},{-77,68},{-67,68},{-72,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-72,68},{-72,-8}},  color={95,95,95}),
        Line(points={{-82,0},{72,0}},     color={95,95,95}),
        Polygon(
          points={{82,0},{60,5},{60,-5},{82,0}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,-4},{-38,-13}},
          lineColor={0,0,0},
          textString="startTime"),
        Text(
          extent={{-74,96},{-41,79}},
          lineColor={0,0,0},
          textString="y"),
        Text(
          extent={{0,-4},{21,-14}},
          lineColor={0,0,0},
          textString="time"),
        Line(points={{34,62},{34,44}}, color={95,95,95}),
        Line(points={{-10,33},{30,33}}, color={95,95,95}),
        Text(
          extent={{-41,67},{1,58}},
          lineColor={0,0,0},
          textString="one cycle period"),
        Text(
          extent={{-5,30},{32,21}},
          lineColor={0,0,0},
          textString="width"),
        Polygon(
          points={{-12,33},{-3,35},{-3,31},{-12,33}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,33},{26,35},{26,31},{34,33}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-72,0},{-12,0}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-12,0},{-12,44}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-12,44},{34,44}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{34,44},{34,0}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{34,55},{-72,55}}, color={95,95,95}),
        Polygon(
          points={{-72,55},{-63,57},{-63,53},{-72,55}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{34,55},{26,57},{26,53},{34,55}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-12,44},{-72,44}},
          color={95,95,95},
          pattern=LinePattern.Dash),
        Text(
          extent={{-94,50},{-73,40}},
          lineColor={0,0,0},
          textString="true")}),
    Documentation(info="<html>
<p>
The block generates an output <code>y</code> that cycles on and off according to the specified length of time for the cycle
and the value of the input <code>u</code>, which indicates the percentage of the cycle time the output should be ON.
</p>

</html>", revisions="<html>
<ul>
<li>
March 30, 2017, Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end DutyCycle;
