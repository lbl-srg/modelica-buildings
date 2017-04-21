within Buildings.Experimental.OpenBuildingControl.CDL.Sources;
block DutyCycle "Generate output cyclic on and off"

  Interfaces.RealInput u(
  final min = 0,
  final max = 1,
  final unit = "1") "Fraction of the cycle time the output should be on"
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
  Modelica.SIunits.Time T_width = period*u "Amount of ON time";
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
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
The block generates an output <code>y</code> that cycles on and off according to the specified length of time for the cycle
and the value of the input <code>u</code>, which indicates the fraction of the cycle time the output should be ON.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/CDL/Sources/DutyCycle.png\"
     alt=\"DutyCycle.png\" />
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
