within Buildings.Electrical.Icons;
partial model RefAngleConversion
  "Icon that represents if the angle symble should be displayed or not"
  annotation (Icon(graphics={
        Line(visible = ground_2 == true,
          points={{80,-40},{120,-40}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(visible = ground_2 == true,
          points={{80,-40},{106,-14}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(visible = ground_2 == true,
          points={{102,-16},{114,-24},{118,-42}},
          color={0,120,120},
          smooth=Smooth.Bezier),
        Line(visible = ground_1 == true,
          points={{-102,-16},{-114,-24},{-118,-42}},
          color={0,120,120},
          smooth=Smooth.Bezier),
        Line(visible = ground_1 == true,
          points={{-80,-40},{-106,-14}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(visible = ground_1 == true,
          points={{-80,-40},{-120,-40}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5)}), Documentation(info="<html>
<p>
This is the icon that conditionally draws the angle symbol for a
conversion model (e.g., a transformer).
</p>
</html>", revisions="<html>
<ul>
<li>
October 3, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end RefAngleConversion;
