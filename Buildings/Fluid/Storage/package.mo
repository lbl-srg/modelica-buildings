within Buildings.Fluid;
package Storage "Package with thermal energy storage models"
  extends Modelica.Icons.Package;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains thermal energy storage models.
</p>
</html>"),
    Icon(graphics={
        Ellipse(
          extent={{-60,20},{60,-20}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=180,
          origin={0,-60},
          rotation=360),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          rotation=180),
        Ellipse(
          extent={{-20,60},{20,-60}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={0,60},
          rotation=90),
        Rectangle(
          extent={{-59,-50},{59,-60}},
          lineColor={255,255,255},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Storage;
