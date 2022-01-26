within Buildings.Obsolete.Controls.OBC.CDL.Conversions;
block IsHoliday
  "Block that outputs true if the input is a holiday"
  Buildings.Obsolete.Controls.OBC.CDL.Interfaces.DayTypeInput u
    "Connector of DayType input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u == Buildings.Obsolete.Controls.OBC.CDL.Types.Day.Holiday;
  annotation (
    defaultComponentName="isHol",
    obsolete = "Obsolete model that will be removed in future releases",
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if the input signal is
of type holiday.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 13, 2022, by Michael Wetter:<br/>
Moved to <code>Obsolete</code> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2839\">issue 2839</a>.
</li>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-82,46},{82,-44}},
          textColor={0,127,0},
          textString="isHoliday"),
        Text(
          extent={{-140,148},{160,108}},
          textString="%name",
          textColor={0,0,255})}));
end IsHoliday;
