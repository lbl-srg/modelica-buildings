within Buildings.Fluid;
package Humidifiers "Package with humidifier models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
Package with humidifiers.
</p>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-72,70},{70,-72}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,-52},{34,54}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,48},{34,32},{34,32},{8,18},{8,24},{24,32},{24,32},{8,42},{
            8,48}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{8,0},{34,-16},{34,-16},{8,-30},{8,-24},{24,-16},{24,-16},{8,
            -6},{8,0}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Humidifiers;
