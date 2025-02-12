within Buildings.Controls.OBC.ASHRAE.PrimarySystem;
package ChillerPlant "Chiller plant control sequences"

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains control sequences for a chiller plant comprising a single
chiller or multiple chillers, chilled and condenser water pumps, cooling towers
and an optional water side economizer.
</p>
<p>
The control sequences are implemented based on ASHRAE Guideline36-2021.
</p>
</html>"),
  Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end ChillerPlant;
