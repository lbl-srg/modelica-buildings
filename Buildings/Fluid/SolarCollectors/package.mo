within Buildings.Fluid;

package SolarCollectors "Package with models for solar collectors"
  extends Modelica.Icons.Package;

  annotation(
    Documentation(info = "<html>
  This package contains models which can be used to simulate solar thermal
  systems and examples describing their use.
  </html>"),
    Icon(
      graphics = {
        Polygon(origin = {14, -34}, fillColor = {136, 138, 133}, pattern = LinePattern.None, fillPattern = FillPattern.Solid,
          points = {{-70, -20}, {-32, -48}, {74, 28}, {30, 48}, {-70, -20}}),
        Ellipse(origin = {-59, 59}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-19, 19}, {19, -19}}),
        Line(origin = {-20.0398, 44.6215}, points = {{-16, 8}, {26, -4}}),
        Line(origin = {-48.3585, 20.4861}, points = {{-6, 16}, {0, -18}}),
        Line(origin = {-35.6812, 25.8008}, points = {{-6, 16}, {14, -12}})}));
end SolarCollectors;