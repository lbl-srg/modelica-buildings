within Buildings.Controls.OBC.CDL;
package Routing "Package with blocks that combine and extract signals"
  annotation (
    Documentation(
      info="<html>
<p>
This package contains blocks to combine and extract signals.
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
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Line(
          points={{-90,0},{4,0}},
          color={95,95,95}),
        Line(
          points={{88,65},{48,65},{-8,0}},
          color={95,95,95}),
        Line(
          points={{-8,0},{93,0}},
          color={95,95,95}),
        Line(
          points={{87,-65},{48,-65},{-8,0}},
          color={95,95,95})}));
end Routing;
