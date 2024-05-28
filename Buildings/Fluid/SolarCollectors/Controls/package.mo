within Buildings.Fluid.SolarCollectors;
package Controls "Package for solar thermal collector controllers"
  extends Modelica.Icons.Package;

  annotation(Documentation(info = "<html>
  <p>
    This package contains a controller for solar thermal collectors.
  </p>
  </html>"),
    Icon(graphics={
      Polygon(origin = {40, -35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-10, 0}, {5, 5}, {5, -5}, {-10, 0}}),
      Line(origin = {-51.25, 0}, points = {{21.25, -35}, {-13.75, -35}, {-13.75, 35}, {6.25, 35}}),
      Rectangle(origin = {0, 35.1488}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}),
      Rectangle(origin = {0, -34.8512}, fillColor = {255, 255, 255}, extent = {{-30, -20.1488}, {30, 20.1488}}),
      Polygon(origin = {-40, 35}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{10, 0}, {-5, 5}, {-5, -5}, {10, 0}}),
      Line(origin = {51.25, 0}, points = {{-21.25, 35}, {13.75, 35}, {13.75, -35}, {-6.25, -35}})}));
end Controls;
