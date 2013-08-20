within Districts.Electrical.DC.Interfaces;
partial model OnePort_p
  "Component with a two pin DC connector ('positive'): i[1] + i[2] = 0 "
  extends Districts.Electrical.DC.Interfaces.TwoPinComponent_p;
  Modelica.SIunits.Current i "Current flowing from pin p to pin n";
equation
  0 = sum(term.i);
  i = term.PhaseSystem.systemCurrent(term.i);
  annotation (
    Documentation(info="<html>
<p>Superclass of elements which have <b>two</b> electrical pins: the positive pin connector <i>p</i>, and the negative pin connector <i>n</i>. It is assumed that the current flowing into pin p is identical to the current flowing out of pin n. This current is provided explicitly as current i.</p>
</html>",
 revisions="<html>
<ul>
<li><i> 1998   </i>
       by Christoph Clauss<br/> initially implemented<br/>
       </li>
</ul>
</html>"),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Line(points={{-94,20},{-69,20}},  color={160,160,164}),
        Polygon(
          points={{-79,23},{-69,20},{-79,17},{-79,23}},
          lineColor={160,160,164},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Line(points={{-69,-34},{-94,-34}},
                                        color={160,160,164}),
        Line(points={{-113,14},{-103,14}},
                                         color={160,160,164}),
        Line(points={{-108,9},{-108,19}}, color={160,160,164}),
        Text(
          extent={{-84,23},{-64,43}},
          lineColor={160,160,164},
          textString="i"),
        Polygon(
          points={{-85,-31},{-95,-34},{-85,-37},{-85,-31}},
          lineColor={160,160,164},
          fillColor={160,160,164},
          fillPattern=FillPattern.Solid),
        Line(points={{-113,-12},{-103,-12}},
                                       color={160,160,164}),
        Text(
          extent={{-94,-9},{-74,-29}},
          lineColor={160,160,164},
          textString="i")}),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics));
end OnePort_p;
