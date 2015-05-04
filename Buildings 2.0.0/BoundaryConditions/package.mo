within Buildings;
package BoundaryConditions "Package with models for boundary conditions"
  extends Modelica.Icons.Package;


annotation (preferredView="info",
Documentation(info="<html>
This package contains models to compute boundary conditions such as weather data.
For models that set boundary conditions for fluid flow systems,
see
<a href=\"modelica://Buildings.Fluid.Sources\">
Buildings.Fluid.Sources</a>.
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
        extent={{-76,80},{6,-2}},
        lineColor={255,255,255},
        lineThickness=1,
        fillPattern=FillPattern.Sphere,
        fillColor={255,255,255}),
      Line(
        points={{32,-24},{76,-82}},
        color={95, 95, 95},
        smooth=Smooth.None),
      Line(
        points={{4,-24},{48,-82}},
        color={95, 95, 95},
        smooth=Smooth.None),
      Line(
        points={{-26,-24},{18,-82}},
        color={95, 95, 95},
        smooth=Smooth.None),
      Line(
        points={{-56,-24},{-12,-82}},
        color={95, 95, 95},
        smooth=Smooth.None),
      Polygon(
        points={{64,6},{50,-2},{40,-18},{70,-24},{78,-52},{26,-52},{-6,-54},{
            -72,-52},{-72,-22},{-52,-10},{-42,10},{-78,34},{-44,52},{40,56},{76,
            40},{64,6}},
        lineColor={150,150,150},
        lineThickness=0.1,
        fillPattern=FillPattern.Sphere,
        smooth=Smooth.Bezier,
        fillColor={150,150,150})}));
end BoundaryConditions;
