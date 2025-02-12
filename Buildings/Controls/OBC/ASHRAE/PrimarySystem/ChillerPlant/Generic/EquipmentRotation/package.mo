within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic;
package EquipmentRotation "Equipment rotation sequences to maintain even wear"

annotation (
preferredView="info", Documentation(info="<html>
<p>
This package contains equipment staging and rotation sequences implemented based on
ASHRAE Guideline36-2021, section 5.1.15. The control intent of these sequences is,
where the device configuration allows for it, 
to have the devices be lead/lag or lead/standby rotated to maintain even wear.
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
