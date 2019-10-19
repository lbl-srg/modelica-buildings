within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
package EquipmentRotation "Equipment rotation sequences to maintain even wear"

annotation (
preferredView="info", Documentation(info="<html>
<p>
This package contains waterside economizer (WSE) control sequences.
The implementation is based on section 5.2.3. in ASHRAE RP-1711, Draft 4.
</p>
</html>"),
Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Ellipse(
          origin={-26.6667,38.6207},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.3333,-81.3793},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={-26.6667,-81.3793},
          lineColor={128,128,128},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
        Ellipse(
          origin={93.333,38.6207},
          lineColor={128,128,128},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          extent={{-53.3333,1.37927},{-13.3329,41.3792}}),
      Line(points={{-40,60},{0,60},{0,-60},{40,-60}}, color={128,128,128}),
      Line(points={{-40,-60},{0,-60},{0,60},{40,60}}, color={128,128,128}),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end EquipmentRotation;
