within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
package SetPoints

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains chilled water plant reset control sequences.
The implementation is based on section 5.2.5.2. in ASHRAE RP-1711 Advanced Sequences
of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (draft version on March 23, 2020).
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
          radius=25.0),
      Text(
        extent={{-100,100},{100,-100}},
        textColor={0,0,0},
        textString="S")}));
end SetPoints;
