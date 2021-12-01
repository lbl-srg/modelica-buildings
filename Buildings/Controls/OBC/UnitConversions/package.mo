within Buildings.Controls.OBC;
package UnitConversions "Package with blocks for unit conversion"

annotation (
Documentation(
info="<html>
<p>
Package with blocks for unit conversions.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 29, 2021, by Michael Wetter:<br/>
Regenerated files with <code>Text</code> annotation using now the <code>textColor</code> attribute
rather than the deprecated <code>lineColor</code> attribute.
</li>
<li>
August 1, 2018, by Milica Grahovac:<br/>
Generated with <code>Buildings/Resources/src/Controls/OBC/UnitConversions/unit_converters.py</code>.<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
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
        Polygon(
        points={{92,-42},{32,-22},{32,-62},{92,-42}},
        lineColor={191,0,0},
        fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
        Line(points={{-88,-42},{32,-42}},
            color={191,0,0}),
        Text(
          extent={{-72,78},{72,6}},
          textColor={0,0,0},
        textString="SI")}));
end UnitConversions;
