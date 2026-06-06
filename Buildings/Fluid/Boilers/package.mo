within Buildings.Fluid;
package Boilers "Package with boiler models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
This package contains components models for boilers.
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{0,0},{-20,-40},{20,-40},{0,0}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}));
end Boilers;
