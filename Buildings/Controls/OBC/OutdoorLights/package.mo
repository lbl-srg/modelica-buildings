within Buildings.Controls.OBC;
package OutdoorLights
  "Package with models for outdoor lighting controls"
  extends Modelica.Icons.Package;
  annotation (
    Documentation(
      info="<html>
<p>
This package contains outdoor lighting controllers.
</p>
</html>"),
    Icon(
      graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          extent={{0,70},{2,-96}},
          lineColor={28,108,200},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-8,46},{10,46}},
          color={0,0,0}),
        Line(
          points={{-16,70},{18,70}},
          color={0,0,0}),
        Rectangle(
          extent={{-14,-96},{18,-98}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-8,72},{10,70}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{0,80},{2,72}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-14,70},{-12,70},{-4,46},{-6,46},{-14,70}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{16,70},{14,70},{6,46},{8,46},{16,70}},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-122,100},{78,-102}},
          lineColor={0,0,0},
          pattern=LinePattern.None),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end OutdoorLights;
