within Buildings.Fluid.ZoneEquipment;
package BaseClasses "Baseclasses used for zone equipment system models"

annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Ellipse(
          extent={{-30,-30},{30,30}},
          lineColor={128,128,128},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
  This package contains baseclasses used for constructing the zone equipment system 
  models as well as their associated controllers.
    </html>"));
end BaseClasses;
