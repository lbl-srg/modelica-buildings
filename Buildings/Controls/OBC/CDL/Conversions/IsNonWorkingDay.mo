within Buildings.Controls.OBC.CDL.Conversions;
block IsNonWorkingDay
  "Block that outputs true if the input is a non-working day"

  Interfaces.DayTypeInput u "Connector of DayType input signal"
    annotation ( Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = u == Buildings.Controls.OBC.CDL.Types.Day.NonWorkingDay;

annotation (
defaultComponentName="isNonWorDay",
Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the input signal is
of type non-working day.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-82,46},{82,-44}},
          lineColor={0,127,0},
          textString="isNonWorkingDay"),
        Text(
          extent={{-140,148},{160,108}},
          textString="%name",
          lineColor={0,0,255})}));
end IsNonWorkingDay;
